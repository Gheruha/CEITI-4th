USE thinkspace;

-- Sarcina 5, crearea tranzactiei.
START TRANSACTION;

UPDATE angajati
SET salariu = ROUND(salariu * 1.05, 2);

DELETE FROM taskuri
WHERE status = 'finalizat'
  AND data_incheierii IS NOT NULL
  AND data_incheierii < DATE_SUB(CURDATE(), INTERVAL 6 MONTH);

COMMIT;

DROP TRIGGER IF EXISTS trig_angajati_salariu;

DELIMITER $$

-- Sarcina 1. Interzicerea schimbarii salariului.  
CREATE TRIGGER trig_angajati_salariu
BEFORE UPDATE ON angajati
FOR EACH ROW
BEGIN
  IF NOT (NEW.salariu <=> OLD.salariu) THEN
    SIGNAL SQLSTATE '45000'
      SET MESSAGE_TEXT = 'salariu cannot be modified';
  END IF;
END$$

DELIMITER ;

-- Sarcina 2. Afisarea mesajelor la adaugarea noilor proiecte.
DROP TRIGGER IF EXISTS trig_proiecte_noi;

DELIMITER $$

CREATE TRIGGER trig_proiecte_noi
BEFORE INSERT ON proiecte
  FOR EACH ROW
    BEGIN
    IF (SELECT 1 FROM proiecte WHERE id_proiect = NEW.id_proiect) THEN
      SIGNAL SQLSTATE '45000'
      SET MESSAGE_TEXT = 'Eroare: id_proiect deja exista!';
    ELSE
      SIGNAL SQLSTATE '12345'
      SET MESSAGE_TEXT = 'A fost inregistrat un proiect nou.';
    END IF;
  
END$$

DELIMITER ;


-- Sarcina 3. Trigger ce nu permite adaugarea mai mult de 50 de angajati.
DROP TRIGGER IF EXISTS trig_numar_angajati;

DELIMITER $$

CREATE TRIGGER trig_numar_angajati
BEFORE INSERT ON angajati
FOR EACH ROW
  BEGIN 
  IF (SELECT COUNT(*) FROM angajati) >= 50 THEN 
    SIGNAL SQLSTATE '45000'
    SET MESSAGE_TEXT = 'Eroare: nu se pot introduce mai mult de 50 de angajati.';
  END IF;
END$$

DELIMITER ;

