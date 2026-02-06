-- Crearea unui utilizator ce se va putea conecta printr-o parola
drop user if exists 'user1'@'localhost';
create user 'user1'@'localhost' identified by 'user1';
-- Pentru a se autentifica user1 trebuie sa scrie urmatoare comanda in 
-- consola -> mysql -u user1 -p si sa introduca parola corecta

-- Grant de privilegii pentru user1
grant select, insert, update on ThinkSpace.* to 'user1'@'localhost';

-- Revocarea privilegiilor pentru user1
revoke insert on ThinkSpace.* from 'user1'@'localhost';

-- Verificarea privilegiilor user1
show grants for 'user1'@'localhost';


-- Chestii ce nu trebuiesc in fisierul pe drive.
use thinkspace;
show tables;
desc functii;

-- Constrangerile de integritate pentru tabelul angajati
alter table angajati
add constraint chk_salariu_angajati 
check (salariu >= 500 and salariu <= 100000);

alter table angajati 
drop check chk_salariu_angajati;


alter table angajati
add constraint chk_varsta_angajati
check (data_nasterii > '2006-01-01');

alter table angajati 
drop constraint chk_varsta_angajati;


-- Constrangerile de integritate pentru tabelul functii
alter table functii
add constraint chk_salariu_baza
check (salariu_baza >= 500 and salariu_baza <= 100000);

alter table functii 
drop check chk_salariu_baza;


-- Constrangerile de integritate pentru tabelul proiecte
alter table proiecte
add constraint chk_buget 
check (buget >= 1000 and buget <= 1000000);

alter table proiecte
drop check chk_buget;


-- Constraint pentru a fi siguri ca taskurile completate nu pot fi mai multe decat totalul lor
alter table proiecte 
add constraint chk_completed_total_tasks
check (total_tasks <= completed_tasks);

alter table proiecte 
drop check chk_completed_total_tasks;



