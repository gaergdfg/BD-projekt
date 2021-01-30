<html>
	<head>
		<title>Serwis Biblioteczny - Szukaj</title>
		<meta http-equiv="content-type" content="text/html" charset="utf-8">
		<script src="https://ajax.googleapis.com/ajax/libs/jquery/2.0.2/jquery.min.js"></script>
	</head>

	<body>
		<a href="main_menu.php">Powrot do strony glownej</a>
		
		<h1>Serwis Biblioteczny</h1>

		<?php
			session_start();

			$connection = oci_connect("pp418377", "Mimuw-sql123", "labora.mimuw.edu.pl/LABS");
			if (!$connection) {
				$err = oci_error();
				echo "oci_connect() failed ", $err['message'];
			}

			$city = $_POST['CITY'];
			$library = $_POST['LIBRARY'];
			$book = $_POST['BOOK'];
			if ($city == "c") {
				$city = NULL;
			}
			if ($library == "c") {
				$library = NULL;
			}
			if ($book == "") {
				$book = NULL;
			}

			$query = NULL;
			if (is_null($book)) {
				if (is_null($city) && is_null($library)) {
					$query = oci_parse($connection, "select miasto.nazwa as miasto, biblioteka.nazwa as biblioteka, ksiazka.tytul as tytul, ksiazka.autor as autor, ksiazka.przedzial as przedzial from miasto, biblioteka, ksiazka where miasto.id_miasta = biblioteka.id_miasta and biblioteka.id_biblioteki = ksiazka.id_biblioteki and ksiazka.liczba > 0");
				} else if (!is_null($city) && is_null($library)) {
					$query = oci_parse($connection, "select miasto.nazwa as miasto, biblioteka.nazwa as biblioteka, ksiazka.tytul as tytul, ksiazka.autor as autor, ksiazka.przedzial as przedzial from miasto, biblioteka, ksiazka where miasto.id_miasta = biblioteka.id_miasta and biblioteka.id_biblioteki = ksiazka.id_biblioteki and miasto.nazwa = :city_ and ksiazka.liczba > 0");
					oci_bind_by_name($query, ":city_", $city);
				} else if (is_null($city) && !is_null($library)) {
					$query = oci_parse($connection, "select miasto.nazwa as miasto, biblioteka.nazwa as biblioteka, ksiazka.tytul as tytul, ksiazka.autor as autor, ksiazka.przedzial as przedzial from miasto, biblioteka, ksiazka where miasto.id_miasta = biblioteka.id_miasta and biblioteka.id_biblioteki = ksiazka.id_biblioteki and biblioteka.nazwa = :library_ and ksiazka.liczba > 0");
					oci_bind_by_name($query, ":library_", $library);
				} else {
					$query = oci_parse($connection, "select miasto.nazwa as miasto, biblioteka.nazwa as biblioteka, ksiazka.tytul as tytul, ksiazka.autor as autor, ksiazka.przedzial as przedzial from miasto, biblioteka, ksiazka where miasto.id_miasta = biblioteka.id_miasta and biblioteka.id_biblioteki = ksiazka.id_biblioteki and miasto.nazwa = :city_ and biblioteka.nazwa = :library_ and ksiazka.liczba > 0");
					oci_bind_by_name($query, ":city_", $city);
					oci_bind_by_name($query, ":library_", $library);
				}
			} else {
				$query = oci_parse($connection, "select miasto.nazwa as miasto, biblioteka.nazwa as biblioteka, ksiazka.tytul as tytul, ksiazka.autor as autor, ksiazka.przedzial as przedzial from miasto, biblioteka, ksiazka where miasto.id_miasta = biblioteka.id_miasta and biblioteka.id_biblioteki = ksiazka.id_biblioteki and ksiazka.tytul = :book_ and ksiazka.liczba > 0");
				oci_bind_by_name($query, ":book_", $book);
			}
			oci_execute($query);

			if (is_null($query)) {
				echo "Wprowadzono niepoprawne dane.";
			} else {
				echo "Ksiazki aktualnie dostepne:", "<br><br>";
				echo "<ul>";
				while ($row = oci_fetch_array($query, OCI_BOTH)) {
					echo "<li>", "Miasto: ", $row['MIASTO'], "<br>Biblioteka: ", $row['BIBLIOTEKA'], "<br>Tytul: ", $row['TYTUL'], "<br>Autor: ", $row['AUTOR'], "<br>Poziom czytelniczy: ", $row['PRZEDZIAL'], "</li>";
				}
				echo "</ul>";
			}
		?>
	</body>
</html>
