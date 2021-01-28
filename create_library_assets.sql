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
	imie varchar2(20) not null,
	nazwisko varchar2(20) not null
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


-- ============================== MIASTO ==============================

insert into miasto values (10, 'Warszawa');
insert into miasto values (11, 'Poznan');
insert into miasto values (12, 'Krakow');
insert into miasto values (13, 'Gdansk');
insert into miasto values (14, 'Bialystok');


-- ============================== BIBLIOTEKA ==============================

insert into biblioteka values (100, 'Biblioteka Kubusia Puchatka', 10);
insert into biblioteka values (101, 'Biblioteka Kangurka', 10);
insert into biblioteka values (102, 'Biblioteka Prosiaczka', 10);
insert into biblioteka values (103, 'Biblioteka Tygryska', 10);
insert into biblioteka values (104, 'Biblioteka Klapouchego', 10);

insert into biblioteka values (200, 'Biblioteka Koziolka Matolka', 11);
insert into biblioteka values (201, 'Biblioteka Piotrusia Pana', 11);
insert into biblioteka values (202, 'Biblioteka Dzwoneczka', 11);
insert into biblioteka values (203, 'Biblioteka Muminkow', 11);
insert into biblioteka values (204, 'Biblioteka Ani z Zielonego Wzgorza', 11);

insert into biblioteka values (300, 'Biblioteka Misia Uszatka', 12);
insert into biblioteka values (301, 'Biblioteka Mikolajka', 12);
insert into biblioteka values (302, 'Biblioteka Brzydzkie Kaczatko', 12);
insert into biblioteka values (303, 'Biblioteka Calineczka', 12);
insert into biblioteka values (304, 'Biblioteka Krolowa Sniegu', 12);

insert into biblioteka values (400, 'Biblioteka Maly Ksiaze', 13);
insert into biblioteka values (401, 'Biblioteka Polnocna', 13);
insert into biblioteka values (402, 'Biblioteka Wschodnia', 13);
insert into biblioteka values (403, 'Biblioteka Poludniowa', 13);
insert into biblioteka values (404, 'Biblioteka Zachodnia', 13);

insert into biblioteka values (500, 'Biblioteka Aleksandryjska', 14);
insert into biblioteka values (501, 'Biblioteka Kazimierza Wielkiego', 14);
insert into biblioteka values (502, 'Biblioteka Jagielly', 14);
insert into biblioteka values (503, 'Biblioteka Stefana Batorego', 14);
insert into biblioteka values (504, 'Biblioteka Zygmunta Wazy', 14);


-- ============================== KSIAZKA ==============================


insert into ksiazka values (1000, 'Margaret Wise Brown', ' Dobranoc, księżycu', 4, 1, 103);

insert into ksiazka values (1001, 'Jan Brzechwa', ' Wiersze i bajki', 2, 1, 100);

insert into ksiazka values (1002, 'Danuta Gellnerowa', ' Cukrowe miasteczko', 3, 1, 104);

insert into ksiazka values (1003, 'Czesław Janczarski', ' Miś Uszatek', 4, 1, 202);

insert into ksiazka values (1004, 'Czesław Janczarski', ' Gdzie mieszka bajeczka', 4, 1, 404);

insert into ksiazka values (1005, 'Czesław Janczarski', ' O smoku Wawelskim', 5, 1, 300);

insert into ksiazka values (1006, 'Astrid Lindgren', ' Lotta z ulicy Awanturników', 3, 1, 504);

insert into ksiazka values (1007, 'Sam Mc Bratney', ' Nawet nie wiesz, jak bardzo Cię kocham', 4, 1, 204);

insert into ksiazka values (1008, 'Beata Ostrowicka', ' Lulaki, Pan Czekoladka i przedszkole', 5, 1, 201);

insert into ksiazka values (1009, 'Beata Ostrowicka', ' Ale ja tak chcę!', 4, 1, 502);

insert into ksiazka values (1010, 'Joanna Papuzińska', ' Śpiące wierszyki', 4, 1, 101);

insert into ksiazka values (1011, 'Eliza Piotrowska', ' Bajka o drzewie', 4, 1, 504);

insert into ksiazka values (1012, 'Eliza Piotrowska', ' Bajka o słońcu', 2, 1, 402);

insert into ksiazka values (1013, 'Renata Piątkowska', ' Opowiadania z piaskownicy', 2, 1, 301);

insert into ksiazka values (1014, 'Małgorzata Strzałkowska', ' Zielony, żółty, rudy, brązowy', 4, 1, 304);

insert into ksiazka values (1015, 'Julian Tuwim', ' Wiersze dla dzieci', 4, 1, 103);

insert into ksiazka values (1016, 'Kim Fupz Aakeson', ' Esben i duch Dziadka', 3, 2, 103);

insert into ksiazka values (1017, 'Hans Christian Andersen', ' Baśnie', 2, 2, 104);

insert into ksiazka values (1018, 'Wiera Badalska', ' Ballada o kapryśnej królewnie', 5, 2, 302);

insert into ksiazka values (1019, 'Ivona Březinová', ' Cukierek dla dziadka Tadka', 4, 2, 403);

insert into ksiazka values (1020, 'Jan Brzechwa', ' Pan Drops i jego trupa', 2, 2, 100);

insert into ksiazka values (1021, 'Wanda Chotomska', ' Wiersze', 5, 2, 501);

insert into ksiazka values (1022, 'Wanda Chotomska', ' Pięciopsiaczki', 3, 2, 204);

insert into ksiazka values (1023, 'Carlo Collodi', ' Pinokio', 4, 2, 300);

insert into ksiazka values (1024, 'VaclavĆtvrtek', ' Bajki z mchu i paproci', 5, 2, 301);

insert into ksiazka values (1025, 'VaclavĆtvrtek', ' O gajowym Chrobotku', 2, 2, 501);

insert into ksiazka values (1026, 'VaclavĆtvrtek', ' Podróże furmana Szejtroczka', 3, 2, 402);

insert into ksiazka values (1027, 'Iwona Czarkowska', ' Biuro zagubionych zabawek', 5, 2, 200);

insert into ksiazka values (1028, 'Barbara Gawryluk', ' Dżok, legenda o psiej wierności', 3, 2, 101);

insert into ksiazka values (1029, 'Eva Janikovszky', ' Gdybym był dorosły', 4, 2, 304);

insert into ksiazka values (1030, 'Czesław Janczarski', ' Jak Wojtek został strażakiem', 5, 2, 202);

insert into ksiazka values (1031, 'Grzegorz Janusz', ' Misiostwo świata', 2, 2, 401);

insert into ksiazka values (1032, 'Hanna Januszewska', ' O Pleciudze', 3, 2, 100);

insert into ksiazka values (1033, 'Kęstutis Kasparavičius', ' Mała zima', 2, 2, 200);

insert into ksiazka values (1034, 'Maria Krueger', ' Apolejka i jej osiołek', 3, 2, 303);

insert into ksiazka values (1035, 'Lucyna Krzemieniecka', ' O Jasiu Kapeluszniku', 4, 2, 301);

insert into ksiazka values (1036, 'Tadeusz Kubiak', ' Wiersze na dzień dobry', 3, 2, 304);

insert into ksiazka values (1037, 'Åsa Lind', ' Piaskowy Wilk', 5, 2, 104);

insert into ksiazka values (1038, 'Astrid Lindgren', ' Pippi Pończoszanka', 3, 2, 304);

insert into ksiazka values (1039, 'Astrid Lindgren', ' Emil ze Smalandii', 2, 2, 203);

insert into ksiazka values (1040, 'Beata Majchrzak', ' Opowieść o błękitnym psie, czyli o rzeczach trudnych dla dzieci', 2, 2, 503);

insert into ksiazka values (1041, 'Kornel Makuszyński', ' Przygody Koziołka Matołka', 5, 2, 300);

insert into ksiazka values (1042, 'Patric Mc Donnell', ' TEK. Nowoczesny jaskiniowiec', 5, 2, 300);

insert into ksiazka values (1043, 'Małgorzata Musierowicz', ' Znajomi z zerówki', 3, 2, 301);

insert into ksiazka values (1044, 'Alan A. Milne', ' Kubuś Puchatek, Chatka Puchatka', 3, 2, 200);

insert into ksiazka values (1045, 'Łukasz Olszacki', ' Bajka o tym, jak błędny rycerz nie uratował królewny, a smok przeszedł na wegetarianizm', 5, 2, 500);

insert into ksiazka values (1046, 'Renata Piątkowska', ' Na wszystko jest sposób', 3, 2, 501);

insert into ksiazka values (1047, 'Renata Piątkowska', ' Nie ma nudnych dni', 3, 2, 101);

insert into ksiazka values (1048, 'Gianni Rodari', ' Bajki przez telefon(w tym Historyjki o Alicji, która zawsze wpadała w kłopot)', 3, 2, 404);

insert into ksiazka values (1049, 'Zofia Rogoszówna', ' Dzieci Pana Majstra', 2, 2, 102);

insert into ksiazka values (1050, 'Małgorzata Strzałkowska', ' Leśne Głupki', 5, 2, 104);

insert into ksiazka values (1051, 'Małgorzata Strzałkowska', ' Wiersze do poduchy, Wyliczanki z pustej szklanki', 5, 2, 404);

insert into ksiazka values (1052, 'Anna Świrszczyńska', ' Dziwny tygrys', 4, 2, 404);

insert into ksiazka values (1053, 'Anna Świrszczyńska', ' O chciwym Achmedzie', 5, 2, 302);

insert into ksiazka values (1054, 'Julian Tuwim', ' Pan Maluśkiewicz i wieloryb', 4, 2, 304);

insert into ksiazka values (1055, 'Emilia Waśniowska', ' Kiedy słychać ptaki', 4, 2, 104);

insert into ksiazka values (1056, 'Danuta Wawiłow', ' Wiersze', 2, 2, 500);

insert into ksiazka values (1057, 'Max Velthuijs', ' Żabka i obcy', 4, 2, 204);

insert into ksiazka values (1058, 'Katarzyna Ziemnicka', ' Wielka wyprawa pirat Nata', 4, 2, 503);

insert into ksiazka values (1059, 'Heather Amery', ' Mity greckie dla najmłodszych', 2, 3, 504);

insert into ksiazka values (1060, 'Ludwig Bemelmans', ' Madeline w Paryżu', 3, 3, 501);

insert into ksiazka values (1061, 'Marcin Brykczyński', ' Ni pies, ni wydra', 5, 3, 301);

insert into ksiazka values (1062, 'Marcin Brykczyński', ' 8 podziękowań, Czarno na białym', 4, 3, 500);

insert into ksiazka values (1063, 'Marcin Brykczyński', ' Skąd się biorą dzieci', 5, 3, 501);

insert into ksiazka values (1064, 'Marcin Brykczyński', ' Czary', 4, 3, 502);

insert into ksiazka values (1065, 'Jan Brzechwa', ' Pchła Szachrajka', 5, 3, 102);

insert into ksiazka values (1066, 'Jan Brzechwa', ' Szelmostwa Lisa Witalisa', 3, 3, 500);

insert into ksiazka values (1067, 'Jan Brzechwa', ' Baśń o korsarzu Palemonie', 5, 3, 304);

insert into ksiazka values (1068, 'Sebastian Cichocki', ' S.Z.T.U.K.A. Szalenie zajmując twory utalentowanych i krnąbrnych artystów', 2, 3, 300);

insert into ksiazka values (1069, 'Wanda Chotomska', ' Wanda Chotomska dzieciom', 4, 3, 302);

insert into ksiazka values (1070, 'Maurice Druon', ' Magiczny świat Tistu ', 3, 3, 200);

insert into ksiazka values (1071, 'Jerzy Ficowski', ' Gałązka z drzewa słońca', 3, 3, 100);

insert into ksiazka values (1072, 'Jerzy Ficowski', ' Syrenka', 2, 3, 400);

insert into ksiazka values (1073, 'Jerzy Ficowski', ' Tęcza na niedzielę (i inne wiersze)', 5, 3, 304);

insert into ksiazka values (1074, 'Dorota Gellner', ' Krawcowe', 2, 3, 103);

insert into ksiazka values (1075, 'Dorota Gellner', ' Zając', 5, 3, 403);

insert into ksiazka values (1076, 'Kamil Giżycki', ' Wielkie czyny szympansa Bajbuna Mądrego', 2, 3, 404);

insert into ksiazka values (1077, 'Frances Hodgson Burnett', ' Mała księżniczka', 4, 3, 300);

insert into ksiazka values (1078, 'P.P.Jerszow', ' Konik Garbusek', 5, 3, 503);

insert into ksiazka values (1079, 'Roksana Jędrzejewska', ' Wróbel', 5, 3, 304);

insert into ksiazka values (1080, 'Grzegorz Kasdepke', ' Detektyw Pozytywka', 5, 3, 400);

insert into ksiazka values (1081, 'Erich Kästner', ' 35 maja', 4, 3, 403);

insert into ksiazka values (1082, 'Ludwik Jerzy Kern', ' Wiersze dla dzieci', 3, 3, 402);

insert into ksiazka values (1083, 'Ludwik Jerzy Kern', ' Ludwik Jerzy Kern dzieciom', 4, 3, 103);

insert into ksiazka values (1084, 'Ludwik Jerzy Kern', ' Ferdynand Wspaniały', 5, 3, 300);

insert into ksiazka values (1085, 'Astrid Lindgren', ' Dzieci z Bullerbyn', 3, 3, 502);

insert into ksiazka values (1086, 'Astrid Lindgren', ' Mio, mój Mio', 5, 3, 402);

insert into ksiazka values (1087, 'Edith Nesbit', ' Pięcioro dzieci i coś', 3, 3, 102);

insert into ksiazka values (1088, 'Edith Nesbit', ' Historia Amuletu', 4, 3, 404);

insert into ksiazka values (1089, 'Edith Nesbit', ' Feniks i dywan', 4, 3, 404);

insert into ksiazka values (1090, 'Roman Pisarski', ' Wyrwidąb i Waligóra', 2, 3, 500);

insert into ksiazka values (1091, 'Otfried Preussler', ' Malutka czarownica', 5, 3, 502);

insert into ksiazka values (1092, 'Gianni Rodari', ' Interesy Pana Kota', 5, 3, 100);

insert into ksiazka values (1093, 'Gianni Rodari', ' Opowieśćo Cebulku', 3, 3, 401);

insert into ksiazka values (1094, 'Gianni Rodari', ' Gelsomino w kraju Kłamczuchów', 5, 3, 203);

insert into ksiazka values (1095, 'Michael Roher', ' Wędrowne ptaki', 4, 3, 500);

insert into ksiazka values (1096, 'Michał Rusinek', ' Wierszyki domowe', 3, 3, 104);

insert into ksiazka values (1097, 'Michał Rusinek', ' Wierszyki rodzinne', 3, 3, 401);

insert into ksiazka values (1098, 'Igor Sikirycki', ' Jak drwal królem został', 4, 3, 200);

insert into ksiazka values (1099, 'Barbara Tylicka', ' Generał Ciupinek', 2, 3, 302);

insert into ksiazka values (1100, 'Anne Cath. Westly', ' 8+2 i ciężarówka', 4, 3, 301);

insert into ksiazka values (1101, 'Anne Cath. Westly', ' 8+2 i domek w lesie', 4, 3, 401);

insert into ksiazka values (1102, 'E.B. White', ' Pajęczyna Charlotty', 4, 3, 404);

insert into ksiazka values (1103, 'Magdalena Wiśniewska', ' Mały Saj i wielka przygoda', 3, 3, 201);

insert into ksiazka values (1104, 'Piotr Wojciechowski', ' Z kufra Pana Pompuła', 2, 3, 301);

insert into ksiazka values (1105, 'Piotr Wojciechowski', '  Bajki żółtego psa', 3, 3, 304);

insert into ksiazka values (1106, 'Praca zbiorowa', ' Śpiewająca Lipka. Baśnie Słowian Zachodnich', 5, 3, 403);

insert into ksiazka values (1107, 'Edmund de Amicis', ' Serce', 4, 4, 202);

insert into ksiazka values (1108, 'Zbigniew Batko', ' Z powrotem, czyli fatalne skutki niewłaściwych lektur', 2, 4, 202);

insert into ksiazka values (1109, 'Paweł Beręsewicz', ' Czy wojna jest dla dziewczyn?', 4, 4, 403);

insert into ksiazka values (1110, 'Paweł Beręsewicz', ' Jak zakochałem Kaśkę Kwiatek', 3, 4, 400);

insert into ksiazka values (1111, 'Paweł Beręsewicz', ' Noskawery', 4, 4, 501);

insert into ksiazka values (1112, 'Paul Berna', ' Rycerze złotego runa', 2, 4, 304);

insert into ksiazka values (1113, 'Marcin Brykczyński', ' W każdym z nas są drzwi do nieba', 5, 4, 402);

insert into ksiazka values (1114, 'Marcin Brykczyński', ' Jak się nie bać ortografii', 5, 4, 202);

insert into ksiazka values (1115, 'Marcin Brykczyński', ' Z deszczu pod rynnę', 5, 4, 200);

insert into ksiazka values (1116, 'Marcin Brykczyński', ' Frances Hodgson Burnett', 3, 4, 100);

insert into ksiazka values (1117, 'Andrew Clements', ' Fryndel', 5, 4, 402);

insert into ksiazka values (1118, 'Iwona Chmielewska', ' Pamiętnik Blumki', 2, 4, 200);

insert into ksiazka values (1119, 'Roald Dahl', ' Matylda', 4, 4, 204);

insert into ksiazka values (1120, 'Joanna Fabicka', ' Rutka', 5, 4, 103);

insert into ksiazka values (1121, 'Anna Kamieńska', ' Książka nad książkami', 5, 4, 400);

insert into ksiazka values (1122, 'Emilia Kiereś', ' Brat', 5, 4, 502);

insert into ksiazka values (1123, 'Rudyard Kipling', ' Księga dżungli', 5, 4, 201);

insert into ksiazka values (1124, 'Eric Knight', ' Lassie, wróć!', 4, 4, 101);

insert into ksiazka values (1125, 'Jan Izydor Korzeniowski', ' Chłopcy z zielonych stawów', 5, 4, 403);

insert into ksiazka values (1126, 'Lena Ledoff i Przemysław Dąbrowski', ' My, Psy, czyli czapka admirała Yamamoto', 5, 4, 503);

insert into ksiazka values (1127, 'Astrid Lindgren', ' Bracia Lwie Serce', 5, 4, 204);

insert into ksiazka values (1128, 'Astrid Lindgren', ' Rasmus i włóczęga', 5, 4, 102);

insert into ksiazka values (1129, 'Clive Staples Lewis', ' Opowieści z Narnii', 5, 4, 200);

insert into ksiazka values (1130, 'Olga Masiuk', ' Lenka, Fryderyk i podróże', 2, 4, 504);

insert into ksiazka values (1131, 'Olga Masiuk', ' Tydzień Konstancji', 3, 4, 504);

insert into ksiazka values (1132, 'Anna Onichimowska', ' Dzień czekolady', 3, 4, 100);

insert into ksiazka values (1133, 'Ida Pierelotkin', ' Ala Betka', 3, 4, 401);

insert into ksiazka values (1134, 'Renata Piątkowska', ' Wszystkie moje mamy', 4, 4, 100);

insert into ksiazka values (1135, 'Renata Piątkowska', ' Hebanowe serce', 2, 4, 102);

insert into ksiazka values (1136, 'Gianni Rodari', ' Był sobie dwa razy baron Lamberto', 4, 4, 403);

insert into ksiazka values (1137, 'Katarzyna Ryrych', ' Łopianowe pole', 5, 4, 403);

insert into ksiazka values (1138, 'Katarzyna Ryrych', ' Koniec świata nr 13', 3, 4, 503);

insert into ksiazka values (1139, 'Annie M.G.Schmidt', ' Minu ', 2, 4, 404);

insert into ksiazka values (1140, 'Barbara Stenka', ' Masło przygodowe', 4, 4, 204);

insert into ksiazka values (1141, 'Małgorzata Strzałkowska', ' Zbzikowane wierszyki łamiące języki, Pejzaż z gżegżółką', 2, 4, 203);

insert into ksiazka values (1142, 'Mark Twain', ' Przygody Tomka Sawyera', 4, 4, 400);

insert into ksiazka values (1143, 'Mark Twain', ' Przygody Hucka, Królewicz i żebrak', 5, 4, 103);

insert into ksiazka values (1144, 'Adam Wajrak', ' Wielka księga prawdziwych tropicieli', 3, 4, 303);

insert into ksiazka values (1145, 'Emilia Waśniowska', ' Pamiątki Babuni', 4, 4, 403);

insert into ksiazka values (1146, 'Łukasz Wierzbicki', ' Afryka Kazika,Dziadeki Niedźwiadek, Machiną przez Chiny', 5, 4, 104);

insert into ksiazka values (1147, 'Rafał Witek', ' Klub latających ciotek', 4, 4, 100);

insert into ksiazka values (1148, 'Piotr Wojciechowski', ' Poniedziałek, którego nie było', 4, 4, 503);

insert into ksiazka values (1149, 'Wiktor Woroszylski', ' Cyryl, gdzie jesteś?', 4, 4, 200);

insert into ksiazka values (1150, 'Paweł Beręsewicz', ' A niech to czykolada', 4, 5, 102);

insert into ksiazka values (1151, 'Monika Błądek', ' Szary ', 2, 5, 303);

insert into ksiazka values (1152, 'Charles Dickens', ' Oliver Twist', 2, 5, 104);

insert into ksiazka values (1153, 'Charles Dickens', ' Opowieść wigilijna', 2, 5, 500);

insert into ksiazka values (1154, 'Michael Ende', ' Momo', 5, 5, 401);

insert into ksiazka values (1155, 'Antoine de Saint', ' Exupery', 5, 5, 104);

insert into ksiazka values (1156, 'Andrzej Grabowski', ' Wojna na pięknym brzegu', 3, 5, 403);

insert into ksiazka values (1157, 'Ewa Grętkiewicz', ' Dostaliśmy po dziecku', 2, 5, 201);

insert into ksiazka values (1158, 'Joanna Jagiełło', ' Zielone martensy ', 3, 5, 400);

insert into ksiazka values (1159, 'Torill Thorstad Hauger', ' Sigurd, syn Wikinga', 4, 5, 103);

insert into ksiazka values (1160, 'Astrid Lindgren', ' Ronja, córka zbójnika', 4, 5, 503);

insert into ksiazka values (1161, 'Katarzyna Majgier', ' Niedokończony eliksir nieśmiertelności ', 5, 5, 202);

insert into ksiazka values (1162, 'Witold Makowiecki', ' Diossos', 5, 5, 100);

insert into ksiazka values (1163, 'Witold Makowiecki', ' Przygody Meliklesa Greka', 2, 5, 404);

insert into ksiazka values (1164, 'Ferenc Molnar', ' Chłopcy z Placu Broni', 5, 5, 402);

insert into ksiazka values (1165, 'Jerzy Niemczuk', ' Opowieść pod strasznym tytułem', 2, 5, 200);

insert into ksiazka values (1166, 'Zuzanna Orlińska ', ' Ani słowa o Zosi', 3, 5, 501);

insert into ksiazka values (1167, 'Ferdynand Ossendowski', ' Słoń Birara', 4, 5, 102);

insert into ksiazka values (1168, 'Magda Papuzińska', ' Wszystko jest możliwe', 3, 5, 402);

insert into ksiazka values (1169, 'Katherine Paterson', ' Most do Terabithii', 4, 5, 404);

insert into ksiazka values (1170, 'Renata Piątkowska', ' Która to Malala?', 3, 5, 502);

insert into ksiazka values (1171, 'Michel Piquemal', ' Bajki filozoficzne', 3, 5, 204);

insert into ksiazka values (1172, 'Katarzyna Pranić', ' Ela', 5, 5, 500);

insert into ksiazka values (1173, 'Katarzyna Ryrych ', ' O Stephenie Hawkingu, czarnej dziurze i myszach podpodłogowych', 4, 5, 302);

insert into ksiazka values (1174, 'Eric Emmanuel Schmitt', ' Oskar i pani Róża', 2, 5, 302);

insert into ksiazka values (1175, 'Eric Emmanuel Schmitt', ' Dziecko Noego', 3, 5, 102);

insert into ksiazka values (1176, 'Lemony Snicket', ' Seria niefortunnych zdarzeń', 4, 5, 201);

insert into ksiazka values (1177, 'Jerry Spinelli', ' Kraksa', 2, 5, 201);

insert into ksiazka values (1178, 'Marcin Szczygielski', ' Czarny młyn, Arka czasu', 5, 5, 104);

insert into ksiazka values (1179, 'J.R.R. Tolkien', ' Hobbit', 3, 5, 403);

insert into ksiazka values (1180, 'Emilia Waśniowska', ' Oswajam strach', 2, 5, 304);

insert into ksiazka values (1181, 'Jean Webster', ' Tajemniczy opiekun', 2, 5, 400);

insert into ksiazka values (1182, 'Jean Webster', ' Kochany Wrogu', 4, 5, 104);

insert into ksiazka values (1183, 'Łukasz Wierzbicki', ' Drzewo', 4, 5, 102);

insert into ksiazka values (1184, 'Maciej Wojtyszko', ' Bromba i inni', 3, 5, 302);

insert into ksiazka values (1185, 'Juliusz Verne', ' Tajemnicza wyspa', 5, 5, 503);

insert into ksiazka values (1186, 'Antologia pod red. Grzegorza Leszczyńskiego', ' Po schodach wierszy', 4, 6, 200);

insert into ksiazka values (1187, 'Paulo Coehlo', ' Alchemik', 5, 6, 500);

insert into ksiazka values (1188, 'Ursula K. le Guin', ' Czarnoksiężnik z Archipelagu', 2, 6, 400);

insert into ksiazka values (1189, 'Géza Hegedüs', ' Żeglarz z Miletu', 3, 6, 100);

insert into ksiazka values (1190, 'Barbara Kosmowska', ' Pozłacana rybka #', 5, 6, 203);

insert into ksiazka values (1191, 'Barbara Kosmowska', ' Sezon na zielone kasztany', 4, 6, 204);

insert into ksiazka values (1192, 'Ula Kowalczuk', ' Koń jaki jest każdy widzi, czyli alfabetyczny zbiór 300 konizmów', 3, 6, 403);

insert into ksiazka values (1193, 'Leena Krohn', ' Pelikan. Opowieść z miasta', 4, 6, 400);

insert into ksiazka values (1194, 'Maciej Kuczyński', ' Gwiazdy suchego stepu', 5, 6, 202);

insert into ksiazka values (1195, 'Harper Lee', ' Zabić drozda', 4, 6, 304);

insert into ksiazka values (1196, 'Jurij Olesza', ' Trzech grubasów ', 5, 6, 203);

insert into ksiazka values (1197, 'Joanna Rudniańska', ' Kotka Brygidy', 3, 6, 200);

insert into ksiazka values (1198, 'Katarzyna Ryrych', ' Wyspa mojej siostry', 2, 6, 504);

insert into ksiazka values (1199, 'Marcin Szczygielski', ' Teatr Niewidzialnych Dzieci ', 3, 6, 101);

insert into ksiazka values (1200, 'Dorota Terakowska', ' Córka czarownic', 5, 6, 200);

insert into ksiazka values (1201, 'Anika Thor', ' Prawda czy wyzwanie', 2, 6, 202);

insert into ksiazka values (1202, 'J.R.R. Tolkien', ' Władca pierścieni', 5, 6, 303);

insert into ksiazka values (1203, 'José Mauro de Vasconcelos', ' Moje drzewko pomarańczowe ', 3, 6, 402);

insert into ksiazka values (1204, 'Beata Wróblewska', ' Jabłko Apolejki', 3, 6, 302);

insert into ksiazka values (1205, 'Pierre Boulle', ' Most na rzece Kwai', 3, 7, 400);

insert into ksiazka values (1206, 'Dave Cousins', ' 15 dni bez głowy', 5, 7, 103);

insert into ksiazka values (1207, 'Anna Frank', ' Dziennik', 3, 7, 400);

insert into ksiazka values (1208, 'Francis Scott Fitzgerald', ' Wielki Gatsby', 2, 7, 104);

insert into ksiazka values (1209, 'Ruben Gallego', ' Białe na czarnym', 2, 7, 202);

insert into ksiazka values (1210, 'Victor Hugo', ' Nędznicy', 5, 7, 504);

insert into ksiazka values (1211, 'Leszek Kołakowski', ' 13 bajek z królestwa Lailonii', 5, 7, 203);

insert into ksiazka values (1212, 'Alice Kuipers', ' Życie na drzwiach lodówki', 3, 7, 500);

insert into ksiazka values (1213, 'Yann Martel', ' Życie Pi', 4, 7, 303);

insert into ksiazka values (1214, 'Ewa Nowak', ' Bardzo biała wrona', 5, 7, 500);

insert into ksiazka values (1215, 'Anna Onichimowska', ' 10 stron świata', 2, 7, 201);

insert into ksiazka values (1216, 'Amos Oz', ' Jak uleczyć fanatyka', 5, 7, 500);

insert into ksiazka values (1217, 'Bolesław Prus', ' Faraon', 2, 7, 300);

insert into ksiazka values (1218, 'Nevil Shute', ' Ostatni brzeg', 4, 7, 401);

insert into ksiazka values (1219, 'Leonie Swann', ' Sprawiedliwość owiec;', 3, 7, 304);

insert into ksiazka values (1220, 'Jan Twardowski', ' Wiersze', 2, 7, 101);

insert into ksiazka values (1221, 'Władysław Bartoszewski', ' Warto być przyzwoitym', 5, 7, 103);

insert into ksiazka values (1222, 'Karen Blixen', ' Pożegnanie z Afryką', 4, 8, 203);

insert into ksiazka values (1223, 'Karen Blixen', ' Uczta Babette', 3, 8, 404);

insert into ksiazka values (1224, 'Guareschi', ' Don Camillo i jego trzódka', 3, 8, 102);

insert into ksiazka values (1225, 'Jerzy Ficowski', ' Lewe strony widoków', 5, 8, 300);

insert into ksiazka values (1226, 'Zbigniew Herbert', ' Martwa natura z wędzidłem', 5, 8, 101);

insert into ksiazka values (1227, 'Zbigniew Herbert', ' Barbarzyńca w ogrodzie', 3, 8, 102);

insert into ksiazka values (1228, 'Zbigniew Herbert', ' Pan Cogito', 5, 8, 300);

insert into ksiazka values (1229, 'Khaled Hosseini', ' Chłopiec z latawcem', 5, 8, 302);

insert into ksiazka values (1230, 'Khaled Hosseini', ' Tysiąc wspaniałych słońc', 2, 8, 201);

insert into ksiazka values (1231, 'Ryszard Kapuściński', ' Cesarz', 2, 8, 101);

insert into ksiazka values (1232, 'Ryszard Kapuściński', ' Imperium', 2, 8, 103);

insert into ksiazka values (1233, 'Mario Vargas Llosa', ' Rozmowa w katedrze', 5, 8, 401);

insert into ksiazka values (1234, 'Gemma Malley', ' Deklaracja', 5, 8, 402);

insert into ksiazka values (1235, 'Gabriel Garcia Marquez', ' Sto lat samotności', 5, 8, 400);

insert into ksiazka values (1236, 'George Orwell', ' Folwark Zwierzęcy', 4, 8, 101);

insert into ksiazka values (1237, 'George Orwell', ' Rok 1984', 5, 8, 501);

insert into ksiazka values (1238, 'Eliza Piotrowska', ' Obczyzno moja', 3, 8, 204);

insert into ksiazka values (1239, 'Peter Schweizer', ' Zwycięstwo. Jak upadł komunizm', 3, 8, 304);

insert into ksiazka values (1240, 'Isaac Bashevis Singer', ' Sztukmistrz z Lublina', 4, 8, 201);

insert into ksiazka values (1241, 'Mariusz Szczygieł', ' Gottland', 2, 8, 501);

insert into ksiazka values (1242, 'Wisława Szymborska', ' Wiersze', 3, 8, 201);

insert into ksiazka values (1243, 'Liao Yiwu', ' Prowadzący umarłych', 2, 8, 401);
