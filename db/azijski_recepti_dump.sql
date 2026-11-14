--
-- PostgreSQL database dump
--

\restrict 99phpOJM1zoIYFrZN9bJlzENGtETAufu3YMmwQ7GOvmTbfolAI0dfWJMbPIHDIG

-- Dumped from database version 18.6
-- Dumped by pg_dump version 18.6

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET transaction_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: recept; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.recept (
    id integer NOT NULL,
    ime character varying(100) NOT NULL,
    hrvatski_naziv character varying(100) NOT NULL,
    zemlja_id integer NOT NULL,
    ljutina character varying(15) NOT NULL,
    vegetarijanski boolean NOT NULL,
    veganski boolean NOT NULL,
    sadrzi_gluten boolean NOT NULL,
    vrijeme_pripreme_min integer NOT NULL,
    tip_jela character varying(15) NOT NULL
);


--
-- Name: recept_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.recept_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: recept_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.recept_id_seq OWNED BY public.recept.id;


--
-- Name: recept_sastojak; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.recept_sastojak (
    recept_id integer NOT NULL,
    sastojak_id integer NOT NULL
);


--
-- Name: sastojak; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.sastojak (
    id integer NOT NULL,
    naziv character varying(80) NOT NULL
);


--
-- Name: sastojak_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.sastojak_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: sastojak_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.sastojak_id_seq OWNED BY public.sastojak.id;


--
-- Name: zemlja; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.zemlja (
    id integer NOT NULL,
    naziv character varying(60) NOT NULL,
    regija character varying(60) NOT NULL
);


--
-- Name: v_recepti; Type: VIEW; Schema: public; Owner: -
--

CREATE VIEW public.v_recepti AS
 SELECT r.id,
    r.ime,
    r.hrvatski_naziv,
    z.regija,
    z.naziv AS zemlja_porijekla,
    r.ljutina,
        CASE
            WHEN r.vegetarijanski THEN 'da'::text
            ELSE 'ne'::text
        END AS vegetarijanski,
        CASE
            WHEN r.veganski THEN 'da'::text
            ELSE 'ne'::text
        END AS veganski,
        CASE
            WHEN r.sadrzi_gluten THEN 'da'::text
            ELSE 'ne'::text
        END AS sadrzi_gluten,
    r.vrijeme_pripreme_min,
    r.tip_jela
   FROM (public.recept r
     JOIN public.zemlja z ON ((z.id = r.zemlja_id)));


--
-- Name: zemlja_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.zemlja_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: zemlja_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.zemlja_id_seq OWNED BY public.zemlja.id;


--
-- Name: recept id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.recept ALTER COLUMN id SET DEFAULT nextval('public.recept_id_seq'::regclass);


--
-- Name: sastojak id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.sastojak ALTER COLUMN id SET DEFAULT nextval('public.sastojak_id_seq'::regclass);


--
-- Name: zemlja id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.zemlja ALTER COLUMN id SET DEFAULT nextval('public.zemlja_id_seq'::regclass);


--
-- Data for Name: recept; Type: TABLE DATA; Schema: public; Owner: -
--

INSERT INTO public.recept VALUES (1, 'Egg Fried Rice', 'pržena riža', 1, 'blago', false, false, true, 20, 'glavno jelo');
INSERT INTO public.recept VALUES (2, 'Peking Duck', 'pekinška patka', 1, 'blago', false, false, true, 180, 'glavno jelo');
INSERT INTO public.recept VALUES (3, 'Gonbao Chicken', 'piletina gonbao', 1, 'ljuto', false, false, true, 35, 'glavno jelo');
INSERT INTO public.recept VALUES (4, 'Chicken Chow Mein', 'pileći chow mein', 1, 'blago', false, false, true, 30, 'glavno jelo');
INSERT INTO public.recept VALUES (5, 'Mochi', 'moči (mochi)', 2, 'blago', true, true, false, 45, 'desert');
INSERT INTO public.recept VALUES (6, 'Tonkotsu Ramen', 'tonkotsu ramen', 2, 'blago', false, false, true, 480, 'glavno jelo');
INSERT INTO public.recept VALUES (7, 'Nasi Goreng', 'indonezijska pržena riža', 3, 'ljuto', false, false, true, 30, 'glavno jelo');
INSERT INTO public.recept VALUES (8, 'Pad Thai', 'pad thai', 4, 'blago ljuto', false, false, false, 30, 'glavno jelo');
INSERT INTO public.recept VALUES (9, 'Kheer', 'kheer (indijski rižin puding)', 5, 'blago', true, false, false, 60, 'desert');
INSERT INTO public.recept VALUES (10, 'Butter Chicken', 'piletina u maslacu (butter chicken)', 5, 'blago ljuto', false, false, false, 90, 'glavno jelo');
INSERT INTO public.recept VALUES (11, 'Baklava', 'baklava', 6, 'blago', true, false, true, 150, 'desert');
INSERT INTO public.recept VALUES (12, 'Shawarma', 'šavarma', 6, 'blago', false, false, true, 300, 'glavno jelo');
INSERT INTO public.recept VALUES (13, 'Hummus', 'humus', 6, 'blago', true, true, false, 15, 'predjelo');
INSERT INTO public.recept VALUES (14, 'Biryani', 'biryani', 7, 'blago ljuto', false, false, false, 120, 'glavno jelo');


--
-- Data for Name: recept_sastojak; Type: TABLE DATA; Schema: public; Owner: -
--

INSERT INTO public.recept_sastojak VALUES (6, 1);
INSERT INTO public.recept_sastojak VALUES (4, 1);
INSERT INTO public.recept_sastojak VALUES (8, 2);
INSERT INTO public.recept_sastojak VALUES (9, 3);
INSERT INTO public.recept_sastojak VALUES (7, 3);
INSERT INTO public.recept_sastojak VALUES (3, 3);
INSERT INTO public.recept_sastojak VALUES (1, 3);
INSERT INTO public.recept_sastojak VALUES (14, 4);
INSERT INTO public.recept_sastojak VALUES (5, 5);
INSERT INTO public.recept_sastojak VALUES (11, 6);
INSERT INTO public.recept_sastojak VALUES (12, 7);
INSERT INTO public.recept_sastojak VALUES (4, 8);
INSERT INTO public.recept_sastojak VALUES (4, 9);
INSERT INTO public.recept_sastojak VALUES (8, 10);
INSERT INTO public.recept_sastojak VALUES (6, 10);
INSERT INTO public.recept_sastojak VALUES (4, 10);
INSERT INTO public.recept_sastojak VALUES (3, 10);
INSERT INTO public.recept_sastojak VALUES (2, 10);
INSERT INTO public.recept_sastojak VALUES (1, 10);
INSERT INTO public.recept_sastojak VALUES (14, 11);
INSERT INTO public.recept_sastojak VALUES (12, 11);
INSERT INTO public.recept_sastojak VALUES (14, 12);
INSERT INTO public.recept_sastojak VALUES (13, 12);
INSERT INTO public.recept_sastojak VALUES (12, 12);
INSERT INTO public.recept_sastojak VALUES (10, 12);
INSERT INTO public.recept_sastojak VALUES (8, 12);
INSERT INTO public.recept_sastojak VALUES (7, 12);
INSERT INTO public.recept_sastojak VALUES (6, 12);
INSERT INTO public.recept_sastojak VALUES (4, 12);
INSERT INTO public.recept_sastojak VALUES (3, 12);
INSERT INTO public.recept_sastojak VALUES (8, 13);
INSERT INTO public.recept_sastojak VALUES (7, 13);
INSERT INTO public.recept_sastojak VALUES (7, 14);
INSERT INTO public.recept_sastojak VALUES (8, 15);
INSERT INTO public.recept_sastojak VALUES (6, 15);
INSERT INTO public.recept_sastojak VALUES (7, 16);
INSERT INTO public.recept_sastojak VALUES (12, 17);
INSERT INTO public.recept_sastojak VALUES (10, 18);
INSERT INTO public.recept_sastojak VALUES (12, 19);
INSERT INTO public.recept_sastojak VALUES (13, 20);
INSERT INTO public.recept_sastojak VALUES (8, 21);
INSERT INTO public.recept_sastojak VALUES (5, 22);
INSERT INTO public.recept_sastojak VALUES (10, 23);
INSERT INTO public.recept_sastojak VALUES (7, 23);
INSERT INTO public.recept_sastojak VALUES (4, 23);
INSERT INTO public.recept_sastojak VALUES (3, 23);
INSERT INTO public.recept_sastojak VALUES (2, 24);
INSERT INTO public.recept_sastojak VALUES (6, 25);
INSERT INTO public.recept_sastojak VALUES (1, 26);
INSERT INTO public.recept_sastojak VALUES (8, 27);
INSERT INTO public.recept_sastojak VALUES (7, 27);
INSERT INTO public.recept_sastojak VALUES (1, 27);
INSERT INTO public.recept_sastojak VALUES (14, 28);
INSERT INTO public.recept_sastojak VALUES (12, 28);
INSERT INTO public.recept_sastojak VALUES (8, 29);
INSERT INTO public.recept_sastojak VALUES (7, 29);
INSERT INTO public.recept_sastojak VALUES (6, 29);
INSERT INTO public.recept_sastojak VALUES (1, 29);
INSERT INTO public.recept_sastojak VALUES (14, 30);
INSERT INTO public.recept_sastojak VALUES (12, 30);
INSERT INTO public.recept_sastojak VALUES (10, 30);
INSERT INTO public.recept_sastojak VALUES (11, 31);
INSERT INTO public.recept_sastojak VALUES (10, 31);
INSERT INTO public.recept_sastojak VALUES (10, 32);
INSERT INTO public.recept_sastojak VALUES (14, 33);
INSERT INTO public.recept_sastojak VALUES (9, 33);
INSERT INTO public.recept_sastojak VALUES (14, 34);
INSERT INTO public.recept_sastojak VALUES (6, 35);
INSERT INTO public.recept_sastojak VALUES (4, 35);
INSERT INTO public.recept_sastojak VALUES (3, 35);
INSERT INTO public.recept_sastojak VALUES (2, 35);
INSERT INTO public.recept_sastojak VALUES (1, 35);
INSERT INTO public.recept_sastojak VALUES (4, 36);
INSERT INTO public.recept_sastojak VALUES (2, 37);
INSERT INTO public.recept_sastojak VALUES (8, 38);
INSERT INTO public.recept_sastojak VALUES (7, 39);
INSERT INTO public.recept_sastojak VALUES (8, 40);
INSERT INTO public.recept_sastojak VALUES (7, 41);
INSERT INTO public.recept_sastojak VALUES (6, 42);
INSERT INTO public.recept_sastojak VALUES (13, 43);
INSERT INTO public.recept_sastojak VALUES (12, 44);
INSERT INTO public.recept_sastojak VALUES (14, 45);
INSERT INTO public.recept_sastojak VALUES (10, 45);
INSERT INTO public.recept_sastojak VALUES (3, 45);
INSERT INTO public.recept_sastojak VALUES (2, 45);
INSERT INTO public.recept_sastojak VALUES (3, 46);
INSERT INTO public.recept_sastojak VALUES (2, 46);
INSERT INTO public.recept_sastojak VALUES (10, 47);
INSERT INTO public.recept_sastojak VALUES (3, 47);
INSERT INTO public.recept_sastojak VALUES (7, 48);
INSERT INTO public.recept_sastojak VALUES (2, 49);
INSERT INTO public.recept_sastojak VALUES (2, 50);
INSERT INTO public.recept_sastojak VALUES (2, 51);
INSERT INTO public.recept_sastojak VALUES (2, 52);
INSERT INTO public.recept_sastojak VALUES (14, 53);
INSERT INTO public.recept_sastojak VALUES (2, 53);
INSERT INTO public.recept_sastojak VALUES (14, 54);
INSERT INTO public.recept_sastojak VALUES (12, 54);
INSERT INTO public.recept_sastojak VALUES (2, 54);
INSERT INTO public.recept_sastojak VALUES (14, 55);
INSERT INTO public.recept_sastojak VALUES (13, 55);
INSERT INTO public.recept_sastojak VALUES (10, 55);
INSERT INTO public.recept_sastojak VALUES (4, 55);
INSERT INTO public.recept_sastojak VALUES (1, 55);
INSERT INTO public.recept_sastojak VALUES (13, 56);
INSERT INTO public.recept_sastojak VALUES (12, 56);
INSERT INTO public.recept_sastojak VALUES (13, 57);
INSERT INTO public.recept_sastojak VALUES (12, 57);
INSERT INTO public.recept_sastojak VALUES (12, 58);
INSERT INTO public.recept_sastojak VALUES (10, 58);
INSERT INTO public.recept_sastojak VALUES (14, 59);
INSERT INTO public.recept_sastojak VALUES (12, 59);
INSERT INTO public.recept_sastojak VALUES (9, 59);
INSERT INTO public.recept_sastojak VALUES (14, 60);
INSERT INTO public.recept_sastojak VALUES (10, 60);
INSERT INTO public.recept_sastojak VALUES (14, 61);
INSERT INTO public.recept_sastojak VALUES (10, 62);
INSERT INTO public.recept_sastojak VALUES (14, 63);
INSERT INTO public.recept_sastojak VALUES (14, 64);
INSERT INTO public.recept_sastojak VALUES (14, 65);
INSERT INTO public.recept_sastojak VALUES (8, 66);
INSERT INTO public.recept_sastojak VALUES (7, 66);
INSERT INTO public.recept_sastojak VALUES (4, 66);
INSERT INTO public.recept_sastojak VALUES (3, 66);
INSERT INTO public.recept_sastojak VALUES (1, 66);
INSERT INTO public.recept_sastojak VALUES (6, 67);
INSERT INTO public.recept_sastojak VALUES (13, 68);
INSERT INTO public.recept_sastojak VALUES (12, 68);
INSERT INTO public.recept_sastojak VALUES (2, 69);
INSERT INTO public.recept_sastojak VALUES (3, 70);
INSERT INTO public.recept_sastojak VALUES (11, 71);
INSERT INTO public.recept_sastojak VALUES (10, 71);
INSERT INTO public.recept_sastojak VALUES (9, 71);
INSERT INTO public.recept_sastojak VALUES (5, 71);
INSERT INTO public.recept_sastojak VALUES (3, 71);
INSERT INTO public.recept_sastojak VALUES (11, 72);
INSERT INTO public.recept_sastojak VALUES (2, 72);
INSERT INTO public.recept_sastojak VALUES (8, 73);
INSERT INTO public.recept_sastojak VALUES (8, 74);
INSERT INTO public.recept_sastojak VALUES (2, 75);
INSERT INTO public.recept_sastojak VALUES (13, 76);
INSERT INTO public.recept_sastojak VALUES (12, 76);
INSERT INTO public.recept_sastojak VALUES (11, 76);
INSERT INTO public.recept_sastojak VALUES (9, 77);
INSERT INTO public.recept_sastojak VALUES (8, 78);
INSERT INTO public.recept_sastojak VALUES (3, 78);
INSERT INTO public.recept_sastojak VALUES (9, 79);
INSERT INTO public.recept_sastojak VALUES (11, 80);
INSERT INTO public.recept_sastojak VALUES (5, 81);
INSERT INTO public.recept_sastojak VALUES (4, 81);
INSERT INTO public.recept_sastojak VALUES (3, 81);
INSERT INTO public.recept_sastojak VALUES (11, 82);
INSERT INTO public.recept_sastojak VALUES (5, 82);
INSERT INTO public.recept_sastojak VALUES (4, 82);
INSERT INTO public.recept_sastojak VALUES (6, 83);
INSERT INTO public.recept_sastojak VALUES (6, 84);


--
-- Data for Name: sastojak; Type: TABLE DATA; Schema: public; Owner: -
--

INSERT INTO public.sastojak VALUES (1, 'Rezanci');
INSERT INTO public.sastojak VALUES (2, 'Rižini rezanci');
INSERT INTO public.sastojak VALUES (3, 'Riža');
INSERT INTO public.sastojak VALUES (4, 'Basmati riža');
INSERT INTO public.sastojak VALUES (5, 'Mochiko');
INSERT INTO public.sastojak VALUES (6, 'Filo tijesto');
INSERT INTO public.sastojak VALUES (7, 'Pita kruh');
INSERT INTO public.sastojak VALUES (8, 'Mrkva');
INSERT INTO public.sastojak VALUES (9, 'Kupus');
INSERT INTO public.sastojak VALUES (10, 'Mladi luk');
INSERT INTO public.sastojak VALUES (11, 'Luk');
INSERT INTO public.sastojak VALUES (12, 'Češnjak');
INSERT INTO public.sastojak VALUES (13, 'Ljutika');
INSERT INTO public.sastojak VALUES (14, 'Krastavac');
INSERT INTO public.sastojak VALUES (15, 'Klice graha');
INSERT INTO public.sastojak VALUES (16, 'Prženi luk');
INSERT INTO public.sastojak VALUES (17, 'Rajčica');
INSERT INTO public.sastojak VALUES (18, 'Pasirana rajčica');
INSERT INTO public.sastojak VALUES (19, 'Kiseli krastavci');
INSERT INTO public.sastojak VALUES (20, 'Slanutak');
INSERT INTO public.sastojak VALUES (21, 'Tofu');
INSERT INTO public.sastojak VALUES (22, 'Slatka pasta od crvenog graha');
INSERT INTO public.sastojak VALUES (23, 'Piletina');
INSERT INTO public.sastojak VALUES (24, 'Patka');
INSERT INTO public.sastojak VALUES (25, 'Svinjska potrbušina');
INSERT INTO public.sastojak VALUES (26, 'Šunka');
INSERT INTO public.sastojak VALUES (27, 'Kozice');
INSERT INTO public.sastojak VALUES (28, 'Janjetina');
INSERT INTO public.sastojak VALUES (29, 'Jaja');
INSERT INTO public.sastojak VALUES (30, 'Jogurt');
INSERT INTO public.sastojak VALUES (31, 'Maslac');
INSERT INTO public.sastojak VALUES (32, 'Vrhnje');
INSERT INTO public.sastojak VALUES (33, 'Mlijeko');
INSERT INTO public.sastojak VALUES (34, 'Ghee');
INSERT INTO public.sastojak VALUES (35, 'Soja umak');
INSERT INTO public.sastojak VALUES (36, 'Umak od kamenica');
INSERT INTO public.sastojak VALUES (37, 'Hoisin umak');
INSERT INTO public.sastojak VALUES (38, 'Riblji umak');
INSERT INTO public.sastojak VALUES (39, 'Kecap manis');
INSERT INTO public.sastojak VALUES (40, 'Tamarind pasta');
INSERT INTO public.sastojak VALUES (41, 'Pasta od kozica (terasi)');
INSERT INTO public.sastojak VALUES (42, 'Miso');
INSERT INTO public.sastojak VALUES (43, 'Tahini');
INSERT INTO public.sastojak VALUES (44, 'Tahini umak');
INSERT INTO public.sastojak VALUES (45, 'Đumbir');
INSERT INTO public.sastojak VALUES (46, 'Sečuanski papar');
INSERT INTO public.sastojak VALUES (47, 'Čili u prahu');
INSERT INTO public.sastojak VALUES (48, 'Čili');
INSERT INTO public.sastojak VALUES (49, 'Bijeli papar');
INSERT INTO public.sastojak VALUES (50, 'Muškatni oraščić');
INSERT INTO public.sastojak VALUES (51, 'Anis');
INSERT INTO public.sastojak VALUES (52, 'Sjemenke komorača');
INSERT INTO public.sastojak VALUES (53, 'Klinčić');
INSERT INTO public.sastojak VALUES (54, 'Cimet');
INSERT INTO public.sastojak VALUES (55, 'Sol');
INSERT INTO public.sastojak VALUES (56, 'Kumin');
INSERT INTO public.sastojak VALUES (57, 'Paprika u prahu');
INSERT INTO public.sastojak VALUES (58, 'Kurkuma');
INSERT INTO public.sastojak VALUES (59, 'Kardamom');
INSERT INTO public.sastojak VALUES (60, 'Garam masala');
INSERT INTO public.sastojak VALUES (61, 'Šafran');
INSERT INTO public.sastojak VALUES (62, 'Kasuri methi');
INSERT INTO public.sastojak VALUES (63, 'Lovorov list');
INSERT INTO public.sastojak VALUES (64, 'Menta');
INSERT INTO public.sastojak VALUES (65, 'Korijander');
INSERT INTO public.sastojak VALUES (66, 'Ulje');
INSERT INTO public.sastojak VALUES (67, 'Sezamovo ulje');
INSERT INTO public.sastojak VALUES (68, 'Maslinovo ulje');
INSERT INTO public.sastojak VALUES (69, 'Ocat');
INSERT INTO public.sastojak VALUES (70, 'Rižin ocat');
INSERT INTO public.sastojak VALUES (71, 'Šećer');
INSERT INTO public.sastojak VALUES (72, 'Med');
INSERT INTO public.sastojak VALUES (73, 'Palmin šećer');
INSERT INTO public.sastojak VALUES (74, 'Limeta');
INSERT INTO public.sastojak VALUES (75, 'Naranča');
INSERT INTO public.sastojak VALUES (76, 'Limunov sok');
INSERT INTO public.sastojak VALUES (77, 'Grožđice');
INSERT INTO public.sastojak VALUES (78, 'Kikiriki');
INSERT INTO public.sastojak VALUES (79, 'Bademi');
INSERT INTO public.sastojak VALUES (80, 'Orasi');
INSERT INTO public.sastojak VALUES (81, 'Kukuruzni škrob');
INSERT INTO public.sastojak VALUES (82, 'Voda');
INSERT INTO public.sastojak VALUES (83, 'Nori');
INSERT INTO public.sastojak VALUES (84, 'Svinjski temeljac');


--
-- Data for Name: zemlja; Type: TABLE DATA; Schema: public; Owner: -
--

INSERT INTO public.zemlja VALUES (1, 'Kina', 'Istočna Azija');
INSERT INTO public.zemlja VALUES (2, 'Japan', 'Istočna Azija');
INSERT INTO public.zemlja VALUES (3, 'Indonezija', 'Jugoistočna Azija');
INSERT INTO public.zemlja VALUES (4, 'Tajland', 'Jugoistočna Azija');
INSERT INTO public.zemlja VALUES (5, 'Indija', 'Južna Azija');
INSERT INTO public.zemlja VALUES (6, 'Regionalno jelo (Bliski istok)', 'Zapadna Azija');
INSERT INTO public.zemlja VALUES (7, 'Regionalno jelo (Južna Azija)', 'Južna Azija');


--
-- Name: recept_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.recept_id_seq', 14, true);


--
-- Name: sastojak_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.sastojak_id_seq', 84, true);


--
-- Name: zemlja_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.zemlja_id_seq', 7, true);


--
-- Name: recept recept_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.recept
    ADD CONSTRAINT recept_pkey PRIMARY KEY (id);


--
-- Name: recept_sastojak recept_sastojak_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.recept_sastojak
    ADD CONSTRAINT recept_sastojak_pkey PRIMARY KEY (recept_id, sastojak_id);


--
-- Name: sastojak sastojak_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.sastojak
    ADD CONSTRAINT sastojak_pkey PRIMARY KEY (id);


--
-- Name: zemlja zemlja_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.zemlja
    ADD CONSTRAINT zemlja_pkey PRIMARY KEY (id);


--
-- Name: recept_sastojak recept_sastojak_recept_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.recept_sastojak
    ADD CONSTRAINT recept_sastojak_recept_id_fkey FOREIGN KEY (recept_id) REFERENCES public.recept(id);


--
-- Name: recept_sastojak recept_sastojak_sastojak_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.recept_sastojak
    ADD CONSTRAINT recept_sastojak_sastojak_id_fkey FOREIGN KEY (sastojak_id) REFERENCES public.sastojak(id);


--
-- Name: recept recept_zemlja_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.recept
    ADD CONSTRAINT recept_zemlja_id_fkey FOREIGN KEY (zemlja_id) REFERENCES public.zemlja(id);


--
-- PostgreSQL database dump complete
--

\unrestrict 99phpOJM1zoIYFrZN9bJlzENGtETAufu3YMmwQ7GOvmTbfolAI0dfWJMbPIHDIG

