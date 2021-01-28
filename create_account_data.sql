drop table uzytkownicy;

create table uzytkownicy(
	login varchar2(20) not null,
	haslo varchar2(20) not null,
	imie varchar2(30) not null,
	nazwisko varchar2(30) not null,
	czy_admin number(1) not null
);

create or replace trigger validate_user_remove
before delete
on uzytkownicy
declare
	liczba_adminow int;
begin
	select count(czy_admin) into liczba_adminow from uzytkownicy;

	if liczba_adminow = 1 and :OLD.czy_admin = 1 then
		raise_application_error(-20000, "Proba usuniecia ostatniego administratora.");
	end if; 
end;
/

insert into uzytkownicy values ("kubus", "puchatek", "Jakub", "Puchalski", 1);