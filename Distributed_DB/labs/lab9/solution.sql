USE farmacie;

CREATE TABLE audit_activitate (
  id_audit INT AUTO_INCREMENT PRIMARY KEY,
  tabel_afectat VARCHAR(50) NOT NULL,
  actiune VARCHAR(20) NOT NULL,
  id_inregistrare INT NOT NULL,
  detalii TEXT,
  data_actiune TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Tabelul produse. Paritionare pe baza coloanei data_expirare, valori mai mici de 2026, 2027 si 2028.
CREATE TABLE produse (
  id_produs INT NOT NULL,
  denumire VARCHAR(100) NOT NULL,
  categorie VARCHAR(50) NOT NULL,
  pret DECIMAL(10,2) NOT NULL,
  stoc INT NOT NULL,
  producator VARCHAR(100) NOT NULL,
  data_expirare DATE NOT NULL,
  PRIMARY KEY (id_produs, data_expirare)
)
PARTITION BY RANGE COLUMNS(data_expirare) (
  PARTITION p2025 VALUES LESS THAN ('2026-01-01'),
  PARTITION p2026 VALUES LESS THAN ('2027-01-01'),
  PARTITION p2027 VALUES LESS THAN ('2028-01-01'),
  PARTITION pmax VALUES LESS THAN (MAXVALUE)
);

-- Tabelul servicii - Partitionare pe baza coloanei categorie. 
CREATE TABLE servicii (
  id_serviciu INT NOT NULL,
  denumire VARCHAR(100) NOT NULL,
  categorie VARCHAR(50) NOT NULL,
  pret DECIMAL(10,2) NOT NULL,
  durata_minute INT NOT NULL,
  disponibilitate VARCHAR(20) NOT NULL,
  PRIMARY KEY (id_serviciu, categorie)
)
PARTITION BY LIST COLUMNS(categorie) (
  PARTITION p_consult VALUES IN ('consultatie'),
  PARTITION p_teste VALUES IN ('testare'),
  PARTITION p_livrare VALUES IN ('livrare'),
  PARTITION p_altele VALUES IN ('vaccinare', 'monitorizare')
);

-- Inserarea datelor in tabelele produse si servicii.
INSERT INTO produse (id_produs, denumire, categorie, pret, stoc, producator, data_expirare) VALUES
(1, 'Paracetamol', 'analgezic', 25.50, 120, 'Terapia', '2025-11-20'),
(2, 'Ibuprofen', 'antiinflamator', 32.00, 90, 'Zentiva', '2026-03-15'),
(3, 'Vitamina C', 'supliment', 18.75, 200, 'Walmark', '2027-01-10'),
(4, 'Nurofen', 'antiinflamator', 40.00, 70, 'Reckitt', '2026-08-01'),
(5, 'Aspirina', 'analgezic', 22.30, 150, 'Bayer', '2025-09-05'),
(6, 'No-Spa', 'antispastic', 29.90, 85, 'Sanofi', '2027-06-18'),
(7, 'Fervex', 'raceala', 36.50, 60, 'UPSA', '2026-12-11'),
(8, 'Magneziu B6', 'supliment', 27.80, 110, 'Sanofi', '2025-07-30'),
(9, 'Smecta', 'digestiv', 21.40, 95, 'Ipsen', '2026-04-22'),
(10, 'Septolete', 'raceala', 19.90, 130, 'KRKA', '2027-09-09');

INSERT INTO servicii (id_serviciu, denumire, categorie, pret, durata_minute, disponibilitate) VALUES
(1, 'Consultatie farmacist', 'consultatie', 50.00, 20, 'disponibil'),
(2, 'Masurare tensiune', 'monitorizare', 15.00, 10, 'disponibil'),
(3, 'Test glicemie', 'testare', 25.00, 15, 'disponibil'),
(4, 'Livrare la domiciliu', 'livrare', 30.00, 60, 'disponibil'),
(5, 'Vaccinare antigripala', 'vaccinare', 120.00, 25, 'disponibil'),
(6, 'Consultatie nutritie', 'consultatie', 70.00, 30, 'disponibil'),
(7, 'Test colesterol', 'testare', 35.00, 20, 'disponibil'),
(8, 'Livrare urgenta', 'livrare', 50.00, 40, 'disponibil'),
(9, 'Vaccinare hepatita', 'vaccinare', 150.00, 30, 'disponibil'),
(10, 'Monitorizare puls', 'monitorizare', 10.00, 10, 'disponibil');

-- Crearea triggerului pentru update-ul produselor care va adauga valor in audit_activitate cu valorile anterioare si cele noi.
DELIMITER $$

CREATE TRIGGER trg_produse_update
BEFORE UPDATE ON produse
FOR EACH ROW
BEGIN
  INSERT INTO audit_activitate (tabel_afectat, actiune, id_inregistrare, detalii)
  VALUES (
    'produse',
    'update',
    OLD.id_produs,
    CONCAT(
      'vechi: ', OLD.denumire, ', pret=', OLD.pret, ', stoc=', OLD.stoc,
      ' | nou: ', NEW.denumire, ', pret=', NEW.pret, ', stoc=', NEW.stoc
    )
  );
END$$

-- Crearea triggerului pentru stergerea produselor care va adauga valori in audit_acitivitate si va arata ce produs a fost sters.
CREATE TRIGGER trg_produse_delete
BEFORE DELETE ON produse
FOR EACH ROW
BEGIN
  INSERT INTO audit_activitate (tabel_afectat, actiune, id_inregistrare, detalii)
  VALUES (
    'produse',
    'delete',
    OLD.id_produs,
    CONCAT(
      'sters: ', OLD.denumire, ', categorie=', OLD.categorie,
      ', pret=', OLD.pret, ', stoc=', OLD.stoc
    )
  );
END$$

-- Crearea triggerului servii_update ce va adauga noi date in tabelul audit_activitate
CREATE TRIGGER trg_servicii_update
BEFORE UPDATE ON servicii
FOR EACH ROW
BEGIN
  INSERT INTO audit_activitate (tabel_afectat, actiune, id_inregistrare, detalii)
  VALUES (
    'servicii',
    'update',
    OLD.id_serviciu,
    CONCAT(
      'vechi: ', OLD.denumire, ', pret=', OLD.pret, ', disponibilitate=', OLD.disponibilitate,
      ' | nou: ', NEW.denumire, ', pret=', NEW.pret, ', disponibilitate=', NEW.disponibilitate
    )
  );
END$$

-- Crearea triggerului servicii delete ce va afisa in tabelui audit_activitate ce serviciu a fost sters.
CREATE TRIGGER trg_servicii_delete
BEFORE DELETE ON servicii
FOR EACH ROW
BEGIN
  INSERT INTO audit_activitate (tabel_afectat, actiune, id_inregistrare, detalii)
  VALUES (
    'servicii',
    'delete',
    OLD.id_serviciu,
    CONCAT(
      'sters: ', OLD.denumire, ', categorie=', OLD.categorie,
      ', pret=', OLD.pret
    )
  );
END$$

DELIMITER ;

-- Declansarea triggerilor
UPDATE produse
SET pret = 27.50, stoc = 115
WHERE id_produs = 1 AND data_expirare = '2025-11-20';

UPDATE servicii
SET pret = 55.00, disponibilitate = 'ocupat'
WHERE id_serviciu = 1 AND categorie = 'consultatie';

DELETE FROM produse
WHERE id_produs = 5 AND data_expirare = '2025-09-05';

DELETE FROM servicii
WHERE id_serviciu = 8 AND categorie = 'livrare';

-- Afisarea datelor pe partitii
SELECT * FROM produse PARTITION (p2025);
SELECT * FROM produse PARTITION (p2026);
SELECT * FROM produse PARTITION (p2027);
SELECT * FROM servicii PARTITION (p_consult);
SELECT * FROM servicii PARTITION (p_teste);
SELECT * FROM servicii PARTITION (p_livrare);
SELECT * FROM servicii PARTITION (p_altele);
SELECT * FROM audit_activitate;
