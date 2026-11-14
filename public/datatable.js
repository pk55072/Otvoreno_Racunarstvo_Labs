const form = document.getElementById('filter-form');
const qInput = document.getElementById('q');
const attrSelect = document.getElementById('attr');
const statusEl = document.getElementById('status');
const tbody = document.querySelector('#data-table tbody');
const FIELDS = ['id','ime','hrvatski_naziv','regija','zemlja_porijekla','ljutina',
  'vegetarijanski','veganski','sadrzi_gluten','vrijeme_pripreme_min','tip_jela'];

let requestCounter = 0; 
let timer;

function currentParams() {
  const params = new URLSearchParams();
  const q = qInput.value.trim();
  if (q) {                                  
    params.set('q', q);
    if (attrSelect.value) params.set('attr', attrSelect.value);
  }
  return params;
}

function render(rows) {
  tbody.replaceChildren();                  
  for (const r of rows) {
    const tr = document.createElement('tr');
    for (const f of FIELDS) {
      const td = document.createElement('td');
      td.textContent = r[f];
      tr.appendChild(td);
    }
    const td = document.createElement('td');
    td.textContent = r.sastojci.join(', ');
    tr.appendChild(td);
    tbody.appendChild(tr);
  }
}

async function load() {
  const params = currentParams();
  const qs = params.toString();

  document.getElementById('dl-csv').href = '/api/export?format=csv' + (qs ? '&' + qs : '');
  document.getElementById('dl-json').href = '/api/export?format=json' + (qs ? '&' + qs : '');

  const myRequest = ++requestCounter;
  statusEl.textContent = 'Učitavanje…';
  try {
    const res = await fetch('/api/recepti' + (qs ? '?' + qs : ''));
    const body = await res.json();
    if (myRequest !== requestCounter) return;
    if (!res.ok) throw new Error(body.message);
    render(body.response);
    statusEl.textContent = `Prikazano zapisa: ${body.response.length}`;
  } catch (err) {
    if (myRequest !== requestCounter) return;
    render([]);
    statusEl.textContent = err.message;
  }
}

form.addEventListener('submit', (e) => { e.preventDefault(); load(); });
qInput.addEventListener('input', () => { clearTimeout(timer); timer = setTimeout(load, 250); });
attrSelect.addEventListener('change', load);
load();                                   