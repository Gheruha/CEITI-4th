-- Crearea sinonimului
USE ThinkSpace;

-- Vederea 1: afisarea numelui angajatilor si departamentelor din care fac parte
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

-- Vederea 2: Afisarea salariului fiecarui angajat pe baza proiectelor
DROP VIEW IF EXISTS view_salariu_angajati;

CREATE VIEW view_salariu_angajati AS
SELECT
  a.id_angajat,
  a.nume,
  a.prenume,
  SUM(t.nr_ore * t.plata_ora) AS salariu_total
FROM
  angajati a
  JOIN taskuri t ON a.id_angajat = t.id_angajat
GROUP BY
  a.id_angajat,
  a.nume,
  a.prenume;

-- Vederea 3: Salariul minim, maxim, mediu si numarul de angajati per departament
DROP VIEW IF EXISTS view_statistici_departamente;

CREATE VIEW view_statistici_departamente AS
SELECT
  d.id_departament,
  d.nume_departament,
  AVG(IFNULL (emp.salariu_total, 0)) AS salariu_mediu,
  MIN(IFNULL (emp.salariu_total, 0)) AS salariu_minim,
  MAX(IFNULL (emp.salariu_total, 0)) AS salariu_maxim,
  COUNT(a.id_angajat) AS numar_angajati
FROM
  departamente d
  JOIN functii f ON d.id_departament = f.id_departament
  JOIN angajati a ON f.id_functie = a.id_functie
  LEFT JOIN (
    SELECT
      id_angajat,
      SUM(nr_ore * plata_ora) AS salariu_total
    FROM
      taskuri
    GROUP BY
      id_angajat
  ) emp ON a.id_angajat = emp.id_angajat
GROUP BY
  d.id_departament,
  d.nume_departament;

-- Crearea sinonimului
-- CALL sys.create_synonym_db('ThinkSpace', 'info_think_space');
-- Afisarea informatiei cu ajutorul sinonimelor
-- Afisare informatiei folosind sinonimul(info_think_space) si vederea(view_departamente_angajati)
SELECT
  *
FROM
  Informatii_think_space.view_departamente_angajati;

-- Afisare informatiei folosind sinonimul(info_think_space) si vederea view_salariu_angajati)
SELECT
  *
FROM
  Informatii_think_space.view_salariu_angajati;

-- Afisare informatiei folosind sinonimul(info_think_space) si vederea(view_statistici_angajati)
SELECT * FROM Informatii_think_space.view_statistici_departamente;
