drop table obecnie_wypozyczone cascade constraints;
drop table historia_wypozyczen cascade constraints;
drop table czytelnik cascade constraints;
drop table ksiazka cascade constraints;
drop table biblioteka cascade constraints;
drop table miasto cascade constraints;

create table miasto(
	id_miasta int not null primary key,
	nazwa varchar2(20) not null
);

create table biblioteka(
	id_biblioteki int not null primary key,
	nazwa varchar2(50) not null,
	id_miasta int references miasto(id_miasta)
);

create table ksiazka(
	id_ksiazki int not null primary key,
	autor varchar2(50) not null,
	tytul varchar2(100) not null,
	liczba number(2) not null,
	przedzial int not null,
	id_biblioteki int references biblioteka(id_biblioteki)
);

create table czytelnik(
	id_czytelnika int not null primary key,
	imie varchar2(50) not null,
	nazwisko varchar2(50) not null,
	login varchar2(50) not null,
	haslo varchar2(50) not null,
	czy_admin number(1) not null
);

create table historia_wypozyczen(
	id_czytelnika int not null references czytelnik,
	id_ksiazki int not null references ksiazka
);

create table obecnie_wypozyczone(
	id_czytelnika int not null references czytelnik,
	id_ksiazki int not null references ksiazka
);


-- ============================== UPDATE ==============================
create or replace trigger validate_ksiazka_update
before update
on ksiazka
for each row
begin
	if :NEW.liczba - :OLD.liczba <> 1 then
		raise_application_error(-20000, 'Proba wypozyczenia wiecej niz jednej ksiazki na raz');
	end if;
end;
/

create or replace trigger validate_historia_update
before update
on historia_wypozyczen
for each row
begin
	raise_application_error(-20000, 'Proba zmiany danych na temat wypozyczonych ksiazek');
end;
/

create or replace trigger validate_obecne_update
before update
on obecnie_wypozyczone
for each row
begin
	raise_application_error(-20000, 'Proba zmiany danych na temat obecnie wypozyczonych ksiazek');
end;
/


-- ============================== REMOVE ==============================
create or replace trigger validate_miasto_remove
before delete
on miasto
declare
begin
	raise_application_error(-20000, 'Proba usuniecia miasta z bazy danych');
end;
/

create or replace trigger validate_biblioteka_remove
before delete
on biblioteka
declare
begin
	raise_application_error(-20000, 'Proba usuniecia biblioteki z bazy danych');
end;
/

create or replace trigger validate_ksiazka_remove
before delete
on ksiazka
for each row
declare
	liczba_wypozyczonych number;
begin
	select count(*) into liczba_wypozyczonych from obecnie_wypozyczone where obecnie_wypozyczone.id_ksiazki = :OLD.id_ksiazki;

	if liczba_wypozyczonych <> 0 then
		raise_application_error(-20000, 'Proba usuniecia ksiazki, ktorej egzemplarze sa obecnie wypozyczone');
	end if;
end;
/

