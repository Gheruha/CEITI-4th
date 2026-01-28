use ThinkSpace;

-- Pentru a evita erorile la stergerea tabelelor.
set foreign_key_checks = 0;
drop table if exists taskuri;
drop table if exists angajati;
drop table if exists functii;
drop table if exists proiecte;
drop table if exists departamente;
set foreign_key_checks = 1;

-- Crearea tuturor tabelelor + cheile secundare.
create table departamente(
  id_departament int primary key,
  nume_departament varchar(64)
);

create table proiecte(
  id_proiect int primary key,
  denumire_proiect varchar(64),
  start_date date,
  end_date date,
  buget double(8,2),
  id_departament int,
  status enum('activ', 'neactiv', 'finalizat'),
  total_tasks int default 0,
  completed_tasks int default 0,
  
  foreign key (id_departament) references departamente(id_departament)
);

create table functii(
  id_functie int primary key,
  nume_functie varchar(64),
  salariu_baza double(8,2),
  id_departament int,
  foreign key (id_departament) references departamente(id_departament)
);

create table angajati(
  id_angajat int primary key,
  nume varchar(64),
  prenume varchar(64),
  data_nasterii date,
  sex enum('M', 'F'),
  salariu double(8,2),
  id_functie int,
  foreign key (id_functie) references functii(id_functie)
);

create table taskuri(
  id_task int primary key,
  descriere varchar(10000),
  data_inceperii date,
  data_incheierii date,
  status enum('activ', 'neactiv', 'finalizat'),
  nr_ore smallint,
  plata_ora double(8,2),
  id_angajat int,
  id_proiect int,
  foreign key (id_angajat) references angajati(id_angajat),
  foreign key (id_proiect) references proiecte(id_proiect)
);


/* Am creat o procedura ce va fi chemata de trigere (la tabelul taskuri)
   Procedura se ocupa de schimbarea valorii status in tabelul proiecte. 
   Daca toate task-urile de la un anumit proiect sunt egale cu finalizat, atunci 
   status-ul proiectului va fi setat ca finalizat.
*/
delimiter $$
drop procedure if exists check_proiect_status $$
create procedure check_proiect_status(p_id_proiect int)
begin
    declare v_total int;
    declare v_done int;

    select total_tasks, completed_tasks 
    into v_total, v_done
    from proiecte 
    where id_proiect = p_id_proiect;

    if v_total > 0 and v_total = v_done then
        update proiecte set status = 'finalizat' where id_proiect = p_id_proiect;
    else
        update proiecte set status = 'activ' where id_proiect = p_id_proiect;
    end if;
end $$


drop trigger if exists trg_task_insert $$
create trigger trg_task_insert
after insert on taskuri
for each row
begin
    update proiecte 
    set total_tasks = total_tasks + 1,
        completed_tasks = completed_tasks + (CASE WHEN NEW.status = 'finalizat' THEN 1 ELSE 0 END)
    where id_proiect = NEW.id_proiect;

    call check_proiect_status(NEW.id_proiect);
end $$

drop trigger if exists trg_task_update $$
create trigger trg_task_update
after update on taskuri
for each row
begin
    if OLD.status != NEW.status then
        update proiecte 
        set completed_tasks = completed_tasks + 
            (CASE 
                WHEN NEW.status = 'finalizat' THEN 1  
                WHEN OLD.status = 'finalizat' THEN -1 
                ELSE 0 
             END)
        where id_proiect = NEW.id_proiect;
        
        call check_proiect_status(NEW.id_proiect);
    end if;
end $$

drop trigger if exists trg_task_delete $$
create trigger trg_task_delete
after delete on taskuri
for each row
begin
    update proiecte 
    set total_tasks = total_tasks - 1,
        completed_tasks = completed_tasks - (CASE WHEN OLD.status = 'finalizat' THEN 1 ELSE 0 END)
    where id_proiect = OLD.id_proiect;

    call check_proiect_status(OLD.id_proiect);
end $$

delimiter ;

-- Afisare tabele create.
desc functii;
desc angajati;
desc departamente;
desc proiecte;
desc taskuri;

