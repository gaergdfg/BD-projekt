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
	tytul varchar2(50) not null,
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

insert into ksiazka values ('Margaret Wise Brown', 'Dobranoc, księżycu', 4, 1, 200);
insert into ksiazka values ('Jan Brzechwa', 'Wiersze i bajki', 3, 1, 303);
insert into ksiazka values ('Danuta Gellnerowa', 'Cukrowe miasteczko', 5, 1, 401);
insert into ksiazka values ('Czesław Janczarski', 'Miś Uszatek', 4, 1, 403);
insert into ksiazka values ('Czesław Janczarski', 'Gdzie mieszka bajeczka', 2, 1, 101);
insert into ksiazka values ('Czesław Janczarski', 'O smoku Wawelskim', 5, 1, 404);
insert into ksiazka values ('Astrid Lindgren', 'Lotta z ulicy Awanturników', 2, 1, 200);
insert into ksiazka values ('Sam Mc Bratney', 'Nawet nie wiesz, jak bardzo Cię kocham', 3, 1, 203);
insert into ksiazka values ('Beata Ostrowicka', 'Lulaki, Pan Czekoladka i przedszkole', 4, 1, 304);
insert into ksiazka values ('Beata Ostrowicka', 'Ale ja tak chcę!', 4, 1, 204);
insert into ksiazka values ('Joanna Papuzińska', 'Śpiące wierszyki', 4, 1, 102);
insert into ksiazka values ('Eliza Piotrowska', 'Bajka o drzewie', 2, 1, 202);
insert into ksiazka values ('Eliza Piotrowska', 'Bajka o słońcu', 5, 1, 204);
insert into ksiazka values ('Renata Piątkowska', 'Opowiadania z piaskownicy', 2, 1, 402);
insert into ksiazka values ('Małgorzata Strzałkowska', 'Zielony, żółty, rudy, brązowy', 4, 1, 503);
insert into ksiazka values ('Julian Tuwim', 'Wiersze dla dzieci', 4, 1, 401);

insert into ksiazka values ('Kim Fupz Aakeson', 'Esben i duch Dziadka', 4, 2, 504);
insert into ksiazka values ('Hans Christian Andersen', 'Baśnie', 4, 2, 104);
insert into ksiazka values ('Wiera Badalska', 'Ballada o kapryśnej królewnie', 2, 2, 304);
insert into ksiazka values ('Ivona Březinová', 'Cukierek dla dziadka Tadka', 5, 2, 502);
insert into ksiazka values ('Jan Brzechwa', 'Pan Drops i jego trupa', 5, 2, 400);
insert into ksiazka values ('Wanda Chotomska', 'Wiersze', 3, 2, 201);
insert into ksiazka values ('Wanda Chotomska', 'Pięciopsiaczki', 5, 2, 303);
insert into ksiazka values ('Carlo Collodi', 'Pinokio', 3, 2, 400);
insert into ksiazka values ('VaclavĆtvrtek', 'Bajki z mchu i paproci', 4, 2, 501);
insert into ksiazka values ('VaclavĆtvrtek', 'O gajowym Chrobotku', 3, 2, 400);
insert into ksiazka values ('VaclavĆtvrtek', 'Podróże furmana Szejtroczka', 2, 2, 400);
insert into ksiazka values ('Iwona Czarkowska', 'Biuro zagubionych zabawek', 3, 2, 203);
insert into ksiazka values ('Barbara Gawryluk', 'Dżok, legenda o psiej wierności', 4, 2, 502);
insert into ksiazka values ('Eva Janikovszky', 'Gdybym był dorosły', 5, 2, 100);
insert into ksiazka values ('Czesław Janczarski', 'Jak Wojtek został strażakiem', 4, 2, 404);
insert into ksiazka values ('Grzegorz Janusz', 'Misiostwo świata', 3, 2, 401);
insert into ksiazka values ('Hanna Januszewska', 'O Pleciudze', 2, 2, 203);
insert into ksiazka values ('Kęstutis Kasparavičius', 'Mała zima', 2, 2, 304);
insert into ksiazka values ('Maria Krueger', 'Apolejka i jej osiołek', 3, 2, 300);
insert into ksiazka values ('Lucyna Krzemieniecka', 'O Jasiu Kapeluszniku', 5, 2, 404);
insert into ksiazka values ('Tadeusz Kubiak', 'Wiersze na dzień dobry', 2, 2, 504);
insert into ksiazka values ('Åsa Lind', 'Piaskowy Wilk', 5, 2, 302);
insert into ksiazka values ('Astrid Lindgren', 'Pippi Pończoszanka', 3, 2, 403);
insert into ksiazka values ('Astrid Lindgren', 'Emil ze Smalandii', 3, 2, 301);
insert into ksiazka values ('Beata Majchrzak', 'Opowieść o błękitnym psie, czyli o rzeczach trudnych dla dzieci', 3, 2, 101);
insert into ksiazka values ('Kornel Makuszyński', 'Przygody Koziołka Matołka', 4, 2, 304);
insert into ksiazka values ('Patric Mc Donnell', 'TEK. Nowoczesny jaskiniowiec', 5, 2, 304);
insert into ksiazka values ('Małgorzata Musierowicz', 'Znajomi z zerówki', 5, 2, 501);
insert into ksiazka values ('Alan A. Milne', 'Kubuś Puchatek, Chatka Puchatka', 4, 2, 203);
insert into ksiazka values ('Łukasz Olszacki', 'Bajka o tym, jak błędny rycerz nie uratował królewny, a smok przeszedł na wegetarianizm', 4, 2, 300);
insert into ksiazka values ('Renata Piątkowska', 'Na wszystko jest sposób', 5, 2, 104);
insert into ksiazka values ('Renata Piątkowska', 'Nie ma nudnych dni', 2, 2, 200);
insert into ksiazka values ('Gianni Rodari', 'Bajki przez telefon(w tym Historyjki o Alicji, która zawsze wpadała w kłopot)', 5, 2, 403);
insert into ksiazka values ('Zofia Rogoszówna', 'Dzieci Pana Majstra', 5, 2, 201);
insert into ksiazka values ('Małgorzata Strzałkowska', 'Leśne Głupki', 3, 2, 202);
insert into ksiazka values ('Małgorzata Strzałkowska', 'Wiersze do poduchy, Wyliczanki z pustej szklanki', 4, 2, 501);
insert into ksiazka values ('Anna Świrszczyńska', 'Dziwny tygrys', 4, 2, 303);
insert into ksiazka values ('Anna Świrszczyńska', 'O chciwym Achmedzie', 5, 2, 502);
insert into ksiazka values ('Julian Tuwim', 'Pan Maluśkiewicz i wieloryb', 3, 2, 201);
insert into ksiazka values ('Emilia Waśniowska', 'Kiedy słychać ptaki', 5, 2, 404);
insert into ksiazka values ('Danuta Wawiłow', 'Wiersze', 2, 2, 400);
insert into ksiazka values ('Max Velthuijs', 'Żabka i obcy', 5, 2, 401);
insert into ksiazka values ('Katarzyna Ziemnicka', 'Wielka wyprawa pirat Nata', 4, 2, 203);

insert into ksiazka values ('Heather Amery', 'Mity greckie dla najmłodszych', 5, 3, 403);
insert into ksiazka values ('Ludwig Bemelmans', 'Madeline w Paryżu', 4, 3, 102);
insert into ksiazka values ('Marcin Brykczyński', 'Ni pies, ni wydra', 3, 3, 104);
insert into ksiazka values ('Marcin Brykczyński', '8 podziękowań, Czarno na białym', 3, 3, 501);
insert into ksiazka values ('Marcin Brykczyński', 'Skąd się biorą dzieci', 3, 3, 301);
insert into ksiazka values ('Marcin Brykczyński', 'Czary', 3, 3, 303);
insert into ksiazka values ('Jan Brzechwa', 'Pchła Szachrajka', 5, 3, 501);
insert into ksiazka values ('Jan Brzechwa', 'Szelmostwa Lisa Witalisa', 3, 3, 501);
insert into ksiazka values ('Jan Brzechwa', 'Baśń o korsarzu Palemonie', 3, 3, 401);
insert into ksiazka values ('Sebastian Cichocki', 'S.Z.T.U.K.A. Szalenie zajmując twory utalentowanych i krnąbrnych artystów', 4, 3, 403);
insert into ksiazka values ('Wanda Chotomska', 'Wanda Chotomska dzieciom', 2, 3, 504);
insert into ksiazka values ('Maurice Druon', 'Magiczny świat Tistu ', 2, 3, 504);
insert into ksiazka values ('Jerzy Ficowski', 'Gałązka z drzewa słońca', 4, 3, 100);
insert into ksiazka values ('Jerzy Ficowski', 'Syrenka', 3, 3, 301);
insert into ksiazka values ('Jerzy Ficowski', 'Tęcza na niedzielę (i inne wiersze)', 4, 3, 202);
insert into ksiazka values ('Dorota Gellner', 'Krawcowe', 3, 3, 200);
insert into ksiazka values ('Dorota Gellner', 'Zając', 2, 3, 404);
insert into ksiazka values ('Kamil Giżycki', 'Wielkie czyny szympansa Bajbuna Mądrego', 3, 3, 104);
insert into ksiazka values ('Frances Hodgson Burnett', 'Mała księżniczka', 2, 3, 500);
insert into ksiazka values ('P.P.Jerszow', 'Konik Garbusek', 2, 3, 401);
insert into ksiazka values ('Roksana Jędrzejewska', 'Wróbel', 4, 3, 104);
insert into ksiazka values ('Grzegorz Kasdepke', 'Detektyw Pozytywka', 3, 3, 402);
insert into ksiazka values ('Erich Kästner', '35 maja', 3, 3, 501);
insert into ksiazka values ('Ludwik Jerzy Kern', 'Wiersze dla dzieci', 4, 3, 303);
insert into ksiazka values ('Ludwik Jerzy Kern', 'Ludwik Jerzy Kern dzieciom', 4, 3, 501);
insert into ksiazka values ('Ludwik Jerzy Kern', 'Ferdynand Wspaniały', 4, 3, 401);
insert into ksiazka values ('Astrid Lindgren', 'Dzieci z Bullerbyn', 3, 3, 501);
insert into ksiazka values ('Astrid Lindgren', 'Mio, mój Mio', 3, 3, 400);
insert into ksiazka values ('Edith Nesbit', 'Pięcioro dzieci i coś', 2, 3, 402);
insert into ksiazka values ('Edith Nesbit', 'Historia Amuletu', 3, 3, 100);
insert into ksiazka values ('Edith Nesbit', 'Feniks i dywan', 5, 3, 401);
insert into ksiazka values ('Roman Pisarski', 'Wyrwidąb i Waligóra', 2, 3, 303);
insert into ksiazka values ('Otfried Preussler', 'Malutka czarownica', 4, 3, 203);
insert into ksiazka values ('Gianni Rodari', 'Interesy Pana Kota', 4, 3, 500);
insert into ksiazka values ('Gianni Rodari', 'Opowieśćo Cebulku', 4, 3, 401);
insert into ksiazka values ('Gianni Rodari', 'Gelsomino w kraju Kłamczuchów', 4, 3, 500);
insert into ksiazka values ('Michael Roher', 'Wędrowne ptaki', 3, 3, 504);
insert into ksiazka values ('Michał Rusinek', 'Wierszyki domowe', 4, 3, 200);
insert into ksiazka values ('Michał Rusinek', 'Wierszyki rodzinne', 4, 3, 303);
insert into ksiazka values ('Igor Sikirycki', 'Jak drwal królem został', 2, 3, 500);
insert into ksiazka values ('Barbara Tylicka', 'Generał Ciupinek', 5, 3, 500);
insert into ksiazka values ('Anne Cath. Westly', '8+2 i ciężarówka', 4, 3, 404);
insert into ksiazka values ('Anne Cath. Westly', '8+2 i domek w lesie', 3, 3, 102);
insert into ksiazka values ('E.B. White', 'Pajęczyna Charlotty', 3, 3, 300);
insert into ksiazka values ('Magdalena Wiśniewska', 'Mały Saj i wielka przygoda', 3, 3, 404);
insert into ksiazka values ('Piotr Wojciechowski', 'Z kufra Pana Pompuła', 2, 3, 304);
insert into ksiazka values ('Piotr Wojciechowski', ' Bajki żółtego psa', 3, 3, 204);
insert into ksiazka values ('Praca zbiorowa', 'Śpiewająca Lipka. Baśnie Słowian Zachodnich', 5, 3, 201);

insert into ksiazka values ('Edmund de Amicis', 'Serce', 4, 4, 500);
insert into ksiazka values ('Zbigniew Batko', 'Z powrotem, czyli fatalne skutki niewłaściwych lektur', 3, 4, 403);
insert into ksiazka values ('Paweł Beręsewicz', 'Czy wojna jest dla dziewczyn?', 2, 4, 103);
insert into ksiazka values ('Paweł Beręsewicz', 'Jak zakochałem Kaśkę Kwiatek', 2, 4, 104);
insert into ksiazka values ('Paweł Beręsewicz', 'Noskawery', 2, 4, 101);
insert into ksiazka values ('Paul Berna', 'Rycerze złotego runa', 3, 4, 201);
insert into ksiazka values ('Marcin Brykczyński', 'W każdym z nas są drzwi do nieba', 5, 4, 501);
insert into ksiazka values ('Marcin Brykczyński', 'Jak się nie bać ortografii', 3, 4, 202);
insert into ksiazka values ('Marcin Brykczyński', 'Z deszczu pod rynnę', 2, 4, 501);
insert into ksiazka values ('Marcin Brykczyński', 'Frances Hodgson Burnett', 5, 4, 204);
insert into ksiazka values ('Andrew Clements', 'Fryndel', 4, 4, 300);
insert into ksiazka values ('Iwona Chmielewska', 'Pamiętnik Blumki', 4, 4, 203);
insert into ksiazka values ('Roald Dahl', 'Matylda', 3, 4, 301);
insert into ksiazka values ('Joanna Fabicka', 'Rutka', 5, 4, 301);
insert into ksiazka values ('Anna Kamieńska', 'Książka nad książkami', 2, 4, 200);
insert into ksiazka values ('Emilia Kiereś', 'Brat', 5, 4, 402);
insert into ksiazka values ('Rudyard Kipling', 'Księga dżungli', 5, 4, 504);
insert into ksiazka values ('Eric Knight', 'Lassie, wróć!', 5, 4, 404);
insert into ksiazka values ('Jan Izydor Korzeniowski', 'Chłopcy z zielonych stawów', 5, 4, 101);
insert into ksiazka values ('Lena Ledoff i Przemysław Dąbrowski', 'My, Psy, czyli czapka admirała Yamamoto', 5, 4, 204);
insert into ksiazka values ('Astrid Lindgren', 'Bracia Lwie Serce', 3, 4, 401);
insert into ksiazka values ('Astrid Lindgren', 'Rasmus i włóczęga', 5, 4, 403);
insert into ksiazka values ('Clive Staples Lewis', 'Opowieści z Narnii', 4, 4, 204);
insert into ksiazka values ('Olga Masiuk', 'Lenka, Fryderyk i podróże', 2, 4, 204);
insert into ksiazka values ('Olga Masiuk', 'Tydzień Konstancji', 4, 4, 504);
insert into ksiazka values ('Anna Onichimowska', 'Dzień czekolady', 3, 4, 100);
insert into ksiazka values ('Ida Pierelotkin', 'Ala Betka', 4, 4, 304);
insert into ksiazka values ('Renata Piątkowska', 'Wszystkie moje mamy', 3, 4, 403);
insert into ksiazka values ('Renata Piątkowska', 'Hebanowe serce', 2, 4, 403);
insert into ksiazka values ('Gianni Rodari', 'Był sobie dwa razy baron Lamberto', 4, 4, 502);
insert into ksiazka values ('Katarzyna Ryrych', 'Łopianowe pole', 4, 4, 301);
insert into ksiazka values ('Katarzyna Ryrych', 'Koniec świata nr 13', 3, 4, 200);
insert into ksiazka values ('Annie M.G.Schmidt', 'Minu ', 4, 4, 401);
insert into ksiazka values ('Barbara Stenka', 'Masło przygodowe', 3, 4, 202);
insert into ksiazka values ('Małgorzata Strzałkowska', 'Zbzikowane wierszyki łamiące języki, Pejzaż z gżegżółką', 5, 4, 402);
insert into ksiazka values ('Mark Twain', 'Przygody Tomka Sawyera', 3, 4, 304);
insert into ksiazka values ('Mark Twain', 'Przygody Hucka, Królewicz i żebrak', 4, 4, 501);
insert into ksiazka values ('Adam Wajrak', 'Wielka księga prawdziwych tropicieli', 5, 4, 500);
insert into ksiazka values ('Emilia Waśniowska', 'Pamiątki Babuni', 5, 4, 101);
insert into ksiazka values ('Łukasz Wierzbicki', 'Afryka Kazika,Dziadeki Niedźwiadek, Machiną przez Chiny', 3, 4, 102);
insert into ksiazka values ('Rafał Witek', 'Klub latających ciotek', 4, 4, 504);
insert into ksiazka values ('Piotr Wojciechowski', 'Poniedziałek, którego nie było', 4, 4, 203);
insert into ksiazka values ('Wiktor Woroszylski', 'Cyryl, gdzie jesteś?', 3, 4, 301);

insert into ksiazka values ('Francesco d'Adamo', 'Iqbal', 3, 5, 302);
insert into ksiazka values ('Paweł Beręsewicz', 'A niech to czykolada', 5, 5, 101);
insert into ksiazka values ('Monika Błądek', 'Szary ', 2, 5, 301);
insert into ksiazka values ('Charles Dickens', 'Oliver Twist', 2, 5, 304);
insert into ksiazka values ('Charles Dickens', 'Opowieść wigilijna', 5, 5, 403);
insert into ksiazka values ('Michael Ende', 'Momo', 4, 5, 503);
insert into ksiazka values ('Antoine de Saint', 'Exupery', 5, 5, 204);
insert into ksiazka values ('Andrzej Grabowski', 'Wojna na pięknym brzegu', 5, 5, 400);
insert into ksiazka values ('Ewa Grętkiewicz', 'Dostaliśmy po dziecku', 2, 5, 103);
insert into ksiazka values ('Joanna Jagiełło', 'Zielone martensy ', 5, 5, 303);
insert into ksiazka values ('Torill Thorstad Hauger', 'Sigurd, syn Wikinga', 3, 5, 100);
insert into ksiazka values ('Astrid Lindgren', 'Ronja, córka zbójnika', 5, 5, 503);
insert into ksiazka values ('Katarzyna Majgier', 'Niedokończony eliksir nieśmiertelności ', 4, 5, 502);
insert into ksiazka values ('Witold Makowiecki', 'Diossos', 2, 5, 402);
insert into ksiazka values ('Witold Makowiecki', 'Przygody Meliklesa Greka', 5, 5, 404);
insert into ksiazka values ('Ferenc Molnar', 'Chłopcy z Placu Broni', 5, 5, 400);
insert into ksiazka values ('Jerzy Niemczuk', 'Opowieść pod strasznym tytułem', 2, 5, 103);
insert into ksiazka values ('Zuzanna Orlińska ', 'Ani słowa o Zosi', 5, 5, 204);
insert into ksiazka values ('Ferdynand Ossendowski', 'Słoń Birara', 2, 5, 400);
insert into ksiazka values ('Magda Papuzińska', 'Wszystko jest możliwe', 4, 5, 100);
insert into ksiazka values ('Katherine Paterson', 'Most do Terabithii', 3, 5, 303);
insert into ksiazka values ('Renata Piątkowska', 'Która to Malala?', 4, 5, 301);
insert into ksiazka values ('Michel Piquemal', 'Bajki filozoficzne', 4, 5, 100);
insert into ksiazka values ('Katarzyna Pranić', 'Ela', 4, 5, 104);
insert into ksiazka values ('Katarzyna Ryrych ', 'O Stephenie Hawkingu, czarnej dziurze i myszach podpodłogowych', 5, 5, 301);
insert into ksiazka values ('Eric Emmanuel Schmitt', 'Oskar i pani Róża', 4, 5, 102);
insert into ksiazka values ('Eric Emmanuel Schmitt', 'Dziecko Noego', 2, 5, 101);
insert into ksiazka values ('Lemony Snicket', 'Seria niefortunnych zdarzeń', 5, 5, 402);
insert into ksiazka values ('Jerry Spinelli', 'Kraksa', 3, 5, 404);
insert into ksiazka values ('Marcin Szczygielski', 'Czarny młyn, Arka czasu', 2, 5, 103);
insert into ksiazka values ('J.R.R. Tolkien', 'Hobbit', 5, 5, 403);
insert into ksiazka values ('Emilia Waśniowska', 'Oswajam strach', 2, 5, 303);
insert into ksiazka values ('Jean Webster', 'Tajemniczy opiekun', 3, 5, 300);
insert into ksiazka values ('Jean Webster', 'Kochany Wrogu', 3, 5, 501);
insert into ksiazka values ('Łukasz Wierzbicki', 'Drzewo', 4, 5, 201);
insert into ksiazka values ('Maciej Wojtyszko', 'Bromba i inni', 3, 5, 504);
insert into ksiazka values ('Juliusz Verne', 'Tajemnicza wyspa', 3, 5, 304);

insert into ksiazka values ('Antologia pod red. Grzegorza Leszczyńskiego', 'Po schodach wierszy', 5, 6, 100);
insert into ksiazka values ('Paulo Coehlo', 'Alchemik', 5, 6, 402);
insert into ksiazka values ('Arthur Conan Doyle', 'Pies Baskerville'ów', 2, 6, 401);
insert into ksiazka values ('Ursula K. le Guin', 'Czarnoksiężnik z Archipelagu', 2, 6, 503);
insert into ksiazka values ('Géza Hegedüs', 'Żeglarz z Miletu', 2, 6, 502);
insert into ksiazka values ('Barbara Kosmowska', 'Pozłacana rybka #', 4, 6, 401);
insert into ksiazka values ('Barbara Kosmowska', 'Sezon na zielone kasztany', 5, 6, 302);
insert into ksiazka values ('Ula Kowalczuk', 'Koń jaki jest każdy widzi, czyli alfabetyczny zbiór 300 konizmów', 5, 6, 302);
insert into ksiazka values ('Leena Krohn', 'Pelikan. Opowieść z miasta', 3, 6, 102);
insert into ksiazka values ('Maciej Kuczyński', 'Gwiazdy suchego stepu', 3, 6, 203);
insert into ksiazka values ('Harper Lee', 'Zabić drozda', 4, 6, 101);
insert into ksiazka values ('Jurij Olesza', 'Trzech grubasów ', 4, 6, 500);
insert into ksiazka values ('Joanna Rudniańska', 'Kotka Brygidy', 5, 6, 500);
insert into ksiazka values ('Katarzyna Ryrych', 'Wyspa mojej siostry', 5, 6, 400);
insert into ksiazka values ('Marcin Szczygielski', 'Teatr Niewidzialnych Dzieci ', 5, 6, 300);
insert into ksiazka values ('Dorota Terakowska', 'Córka czarownic', 2, 6, 203);
insert into ksiazka values ('Anika Thor', 'Prawda czy wyzwanie', 4, 6, 103);
insert into ksiazka values ('J.R.R. Tolkien', 'Władca pierścieni', 5, 6, 501);
insert into ksiazka values ('José Mauro de Vasconcelos', 'Moje drzewko pomarańczowe ', 5, 6, 404);
insert into ksiazka values ('Beata Wróblewska', 'Jabłko Apolejki', 5, 6, 102);

insert into ksiazka values ('Pierre Boulle', 'Most na rzece Kwai', 5, 7, 204);
insert into ksiazka values ('Dave Cousins', '15 dni bez głowy', 4, 7, 302);
insert into ksiazka values ('Anna Frank', 'Dziennik', 2, 7, 301);
insert into ksiazka values ('Francis Scott Fitzgerald', 'Wielki Gatsby', 4, 7, 301);
insert into ksiazka values ('Ruben Gallego', 'Białe na czarnym', 5, 7, 404);
insert into ksiazka values ('Victor Hugo', 'Nędznicy', 2, 7, 301);
insert into ksiazka values ('Leszek Kołakowski', '13 bajek z królestwa Lailonii', 4, 7, 502);
insert into ksiazka values ('Alice Kuipers', 'Życie na drzwiach lodówki', 5, 7, 300);
insert into ksiazka values ('Yann Martel', 'Życie Pi', 2, 7, 504);
insert into ksiazka values ('Ewa Nowak', 'Bardzo biała wrona', 4, 7, 502);
insert into ksiazka values ('Anna Onichimowska', '10 stron świata', 2, 7, 201);
insert into ksiazka values ('Amos Oz', 'Jak uleczyć fanatyka', 4, 7, 400);
insert into ksiazka values ('Bolesław Prus', 'Faraon', 4, 7, 301);
insert into ksiazka values ('Nevil Shute', 'Ostatni brzeg', 3, 7, 504);
insert into ksiazka values ('Leonie Swann', 'Sprawiedliwość owiec;', 4, 7, 503);
insert into ksiazka values ('Jan Twardowski', 'Wiersze', 5, 7, 301);
insert into ksiazka values ('Władysław Bartoszewski', 'Warto być przyzwoitym', 5, 7, 402);

insert into ksiazka values ('Karen Blixen', 'Pożegnanie z Afryką', 3, 8, 202);
insert into ksiazka values ('Karen Blixen', 'Uczta Babette', 3, 8, 404);
insert into ksiazka values ('Guareschi', 'Don Camillo i jego trzódka', 2, 8, 403);
insert into ksiazka values ('Jerzy Ficowski', 'Lewe strony widoków', 3, 8, 102);
insert into ksiazka values ('Zbigniew Herbert', 'Martwa natura z wędzidłem', 5, 8, 102);
insert into ksiazka values ('Zbigniew Herbert', 'Barbarzyńca w ogrodzie', 4, 8, 501);
insert into ksiazka values ('Zbigniew Herbert', 'Pan Cogito', 2, 8, 203);
insert into ksiazka values ('Khaled Hosseini', 'Chłopiec z latawcem', 5, 8, 103);
insert into ksiazka values ('Khaled Hosseini', 'Tysiąc wspaniałych słońc', 2, 8, 404);
insert into ksiazka values ('Ryszard Kapuściński', 'Cesarz', 3, 8, 201);
insert into ksiazka values ('Ryszard Kapuściński', 'Imperium', 5, 8, 203);
insert into ksiazka values ('Mario Vargas Llosa', 'Rozmowa w katedrze', 3, 8, 302);
insert into ksiazka values ('Gemma Malley', 'Deklaracja', 3, 8, 501);
insert into ksiazka values ('Gabriel Garcia Marquez', 'Sto lat samotności', 2, 8, 304);
insert into ksiazka values ('George Orwell', 'Folwark Zwierzęcy', 4, 8, 204);
insert into ksiazka values ('George Orwell', 'Rok 1984', 3, 8, 403);
insert into ksiazka values ('Eliza Piotrowska', 'Obczyzno moja', 4, 8, 100);
insert into ksiazka values ('Peter Schweizer', 'Zwycięstwo. Jak upadł komunizm', 2, 8, 204);
insert into ksiazka values ('Isaac Bashevis Singer', 'Sztukmistrz z Lublina', 5, 8, 201);
insert into ksiazka values ('Mariusz Szczygieł', 'Gottland', 5, 8, 400);
insert into ksiazka values ('Wisława Szymborska', 'Wiersze', 4, 8, 401);
insert into ksiazka values ('Liao Yiwu', 'Prowadzący umarłych', 3, 8, 104);
