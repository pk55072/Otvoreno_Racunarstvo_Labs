const express = require('express');
const path = require('path');
const { Pool } = require('pg');

const ROOT = path.join(__dirname, '..'); 
const PORT = 3000;

const pool = new Pool();

const app = express();


const send = (res, code, status, message, response = null) =>
  res.status(code).json({ status, message, response });

class HttpError extends Error {
  constructor(code, message) { super(message); this.code = code; }
}

const BASE_SQL = `
  SELECT r.id, r.ime, r.hrvatski_naziv, z.regija, z.naziv AS zemlja_porijekla, r.ljutina,
         CASE WHEN r.vegetarijanski THEN 'da' ELSE 'ne' END AS vegetarijanski,
         CASE WHEN r.veganski       THEN 'da' ELSE 'ne' END AS veganski,
         CASE WHEN r.sadrzi_gluten  THEN 'da' ELSE 'ne' END AS sadrzi_gluten,
         r.vrijeme_pripreme_min, r.tip_jela,
         COALESCE(array_agg(s.naziv ORDER BY s.naziv) FILTER (WHERE s.id IS NOT NULL),
                  ARRAY[]::varchar[]) AS sastojci
  FROM recept r
  JOIN zemlja z ON z.id = r.zemlja_id
  LEFT JOIN recept_sastojak rs ON rs.recept_id = r.id
  LEFT JOIN sastojak s ON s.id = rs.sastojak_id
  GROUP BY r.id, z.id`;

const SEARCHABLE = {
  ime: 't.ime',
  hrvatski_naziv: 't.hrvatski_naziv',
  regija: 't.regija',
  zemlja_porijekla: 't.zemlja_porijekla',
  ljutina: 't.ljutina',
  vegetarijanski: 't.vegetarijanski',
  veganski: 't.veganski',
  sadrzi_gluten: 't.sadrzi_gluten',
  vrijeme_pripreme_min: 't.vrijeme_pripreme_min::text',
  tip_jela: 't.tip_jela',
  sastojci: "array_to_string(t.sastojci, ', ')",
};

async function queryRecipes(q, attr) {
  if (attr && !Object.hasOwn(SEARCHABLE, attr)) {
    throw new HttpError(400, `Unknown attribute "${attr}"`);
  }
  let sql = `SELECT * FROM (${BASE_SQL}) t`;
  const params = [];
  if (q) {
    params.push('%' + q.replace(/[\\%_]/g, '\\$&') + '%');
    const exprs = attr ? [SEARCHABLE[attr]] : Object.values(SEARCHABLE);
    sql += ' WHERE ' + exprs.map((e) => `${e} ILIKE $1`).join(' OR ');
  }
  sql += ' ORDER BY t.id';
  return (await pool.query(sql, params)).rows;
}

const CSV_HEADER = ['id','ime','hrvatski_naziv','regija','zemlja_porijekla','ljutina',
  'vegetarijanski','veganski','sadrzi_gluten','vrijeme_pripreme_min','tip_jela','sastojak'];

const csvCell = (v) => {
  const s = String(v ?? '');
  return /[",\r\n]/.test(s) ? '"' + s.replace(/"/g, '""') + '"' : s;
};

function toCsv(rows) {
  const lines = [CSV_HEADER.join(',')];
  for (const r of rows) {
    const parent = CSV_HEADER.slice(0, -1).map((k) => csvCell(r[k]));
    for (const s of r.sastojci.length ? r.sastojci : ['']) {
      lines.push([...parent, csvCell(s)].join(','));
    }
  }
  return lines.join('\n') + '\n';
}

const wrap = (fn) => (req, res, next) => fn(req, res, next).catch(next);
const readFilter = (req) => ({
  q: String(req.query.q ?? '').trim(),
  attr: String(req.query.attr ?? '').trim(),
});


app.use(express.static(path.join(ROOT, 'public')));
for (const f of ['azijski_recepti.csv', 'azijski_recepti.json', 'schema.json']) {
  app.get('/' + f, (req, res) => res.sendFile(path.join(ROOT, f)));
}

app.get('/api/recepti', wrap(async (req, res) => {
  const { q, attr } = readFilter(req);
  const rows = await queryRecipes(q, attr);
  send(res, 200, 'OK', `Fetched ${rows.length} recipes`, rows);
}));

app.get('/api/export', wrap(async (req, res) => {
  const { q, attr } = readFilter(req);
  const format = req.query.format;
  if (format !== 'csv' && format !== 'json') {
    throw new HttpError(400, 'Parameter "format" must be "csv" or "json"');
  }
  const rows = await queryRecipes(q, attr);
  if (format === 'csv') {
    res.set({
      'Content-Type': 'text/csv; charset=utf-8',
      'Content-Disposition': 'attachment; filename="azijski_recepti_filtrirano.csv"',
    }).send(toCsv(rows));
  } else {
    res.set({
      'Content-Type': 'application/json; charset=utf-8',
      'Content-Disposition': 'attachment; filename="azijski_recepti_filtrirano.json"',
    }).send(JSON.stringify(rows, null, 2));
  }
}));


app.use((req, res) => send(res, 404, 'Not Found', 'Does not exist'));

app.use((err, req, res, next) => {
  if (err instanceof HttpError) return send(res, err.code, 'Error', err.message);
  console.error(err);
  send(res, 500, 'Internal Server Error');
});

app.listen(PORT, async () => {
  console.log(`Server: http://localhost:${PORT}`);
  try {
    const r = await pool.query('SELECT count(*) AS n FROM recept');
    console.log(`Database OK, recipes: ${r.rows[0].n}`);
  } catch (e) {
    console.error('Database connection FAILED:', e.message);
  }
});