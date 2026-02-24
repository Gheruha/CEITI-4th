-- Crearea sinonimului

-- CALL sys.create_synonym_db('ThinkSpace', 'info_think_space');
USE ThinkSpace;

SHOW TABLES;

DESC angajati;

DESC departamente;

DESC functii;
DESC taskuri;
desc proiecte;

-- Vederea & sinonimul 1: afisarea numelui angajatilor si departamentelor din care fac parte
DROP VIEW IF EXISTS view_departamente_angajati;
CREATE VIEW view_departamente_angajati AS
SELECT
  a.nume,
  a.prenume,
  d.nume_departament
FROM
  angajati a
  JOIN functii f ON a.id_functie = f.id_functie
  JOIN departamente d ON f.id_departament = d.id_departament;

-- Afisarea salariului fiecarui angajat pe baza proiectelor
DROP VIEW IF EXISTS view_salariu_angajati;
CREATE VIEW view_salariu_angajati AS
-- To see their salary as putea sa folosesc taskuri si proiecte
