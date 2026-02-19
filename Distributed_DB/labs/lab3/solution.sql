use ThinkSpace;

show tables;

-- FRAGMENTARE VERTICALA
-- Fragmentare verticala pentru tabelul angajati
DROP TABLE IF EXISTS angajati_data_nasterii;

CREATE TABLE angajati_data_nasterii AS
SELECT
  nume,
  prenume,
  data_nasterii
FROM
  angajati;

INSERT INTO
  angajati_data_nasterii (nume, prenume, data_nasterii)
SELECT
  nume,
  prenume,
  data_nasterii
FROM
  angajati;

DESC angajati_data_nasterii;
-- Fragmentare verticala pentru tabelul taskuri
DROP TABLE IF EXISTS taskuri_nr_ore;

CREATE TABLE taskuri_nr_ore AS
SELECT
  id_task,
  nr_ore
FROM
  taskuri;

INSERT INTO
  taskuri_nr_ore (id_task, nr_ore)
SELECT
  id_task,
  nr_ore
FROM
  taskuri;

DESC taskuri_nr_ore;
-- FRAGMENTARE VERTICALA


-- FRAGMENTARE ORIZONTALA
-- Fragmentare orizontala pentru tabelul angajati 
ALTER TABLE angajati_data_nasterii
PARTITION BY
  RANGE COLUMNS (data_nasterii) (
    PARTITION p0
    VALUES
      LESS THAN ('1990-01-01'),
      PARTITION p1
    VALUES
      LESS THAN ('2000-01-01'),
      PARTITION p2
    VALUES
      LESS THAN (MAXVALUE)
  );
SELECT * FROM angajati_data_nasterii PARTITION(p0);
DROP TABLE angajati_data_nasterii;

-- Fragmentare orizontala pentru tabelul taskuri 
ALTER TABLE taskuri_nr_ore
PARTITION BY
  RANGE COLUMNS (nr_ore) (
    PARTITION p0
    VALUES
      LESS THAN (10),
      PARTITION p1
    VALUES
      LESS THAN (20),
      PARTITION p2
    VALUES
      LESS THAN (MAXVALUE)
  );

SELECT * FROM taskuri_nr_ore PARTITION(p0);
DROP TABLE taskuri_nr_ore;
-- FRAGMENTARE ORIZONTALA


-- FRAGMENTARE HIBRIDA
DROP TABLE IF EXISTS angajati_v1_before_2000;

DROP TABLE IF EXISTS angajati_v1_2000_plus;

CREATE TABLE angajati_v1_before_2000 AS
SELECT
  id_angajat,
  nume,
  prenume,
  data_nasterii
FROM
  angajati
WHERE
  data_nasterii IS NOT NULL
  AND data_nasterii < '2000-01-01';

CREATE TABLE angajati_v1_2000_plus AS
SELECT
  id_angajat,
  nume,
  prenume,
  data_nasterii
FROM
  angajati
WHERE
  data_nasterii IS NULL
  OR data_nasterii >= '2000-01-01';


DROP TABLE IF EXISTS taskuri_v2_lt_20;
DROP TABLE IF EXISTS taskuri_v2_ge_20;
CREATE TABLE taskuri_v2_lt_20 AS
SELECT
  id_task,
  id_proiect,
  nr_ore,
  plata_ora
FROM
  taskuri
WHERE
  nr_ore IS NOT NULL
  AND nr_ore < 20;

CREATE TABLE taskuri_v2_ge_20 AS
SELECT
  id_task,
  id_proiect,
  nr_ore,
  plata_ora
FROM
  taskuri
WHERE
  nr_ore IS NULL
  OR nr_ore >= 20;
-- FRAGMENTARE HIBRIDA


