# Otvoreno_Racunarstvo_Labs
Laboratorijske vježbe za predmet Otvoreno računarstvo

Tema laboratorijske vježbe - azijski recepti
Baza podataka sadrži 14 azijskih recepata koji se sastoje od razno raznih sastojaka (ukupno njih 84) i koji potječu iz različitih regija Azije. 

## Metapodaci

| Metapodatak | Vrijednost |
|---|---|
| Naziv skupa | Azijski recepti |
| Autor | Patrik Krčma |
| Verzija | 1.0 |
| Licencija | CC0 (Creative Commons Zero) 1.0  https://creativecommons.org/publicdomain/zero/1.0/|
| Jezik podataka | hrvatski (uz engleske izvorne nazive jela) |

## Atributi

Svako jelo određuje idućih 10 atributa:

| Atribut | Tip | Opis |
|---|---|---|
| id | cijeli broj | Jedinstveni identifikator recepta |
| ime | tekst | Izvorni (engleski/međunarodni) naziv jela |
| hrvatski_naziv | tekst | Naziv jela na hrvatskom |
| regija | tekst | Regija Azije |
| zemlja_porijekla | tekst | Zemlja podrijetla; ( stavljeno „Regionalno jelo“ kad podrijetlo jela uzima više zemalja) |
| ljutina | tekst | blago / blago ljuto / ljuto / jako ljuto |
| vegetarijanski | tekst | da / ne |
| veganski | tekst | da / ne |
| sadrzi_gluten | tekst | da / ne |
| vrijeme_pripreme_min | cijeli broj | Okvirno vrijeme pripreme u minutama |
| tip_jela | tekst | predjelo / glavno jelo / desert |
| sastojak | tekst | sastojak recepta; podaci recepta se ponavljaju za svaki sastojak |
| sastojci | polje tekstova | (JSON) popis sastojaka recepta |

