<html>
	<head>
		<title>Serwis Biblioteczny - Dodaj ksiazke</title>
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

			$library = $_POST['LIBRARY'];
			$book = $_POST['BOOK'];
			$author = $_POST['AUTHOR'];
			if ($library == "c") {
				$library = NULL;
			}
			if ($book == "") {
				$book = NULL;
			}
			if ($author == "") {
				$author = NULL;
			}


			if (is_null($library) || is_NULL($book) || is_null($author)) {
				echo "<p style=\"color:red\">Wprowadzono niepoprawne dane</p>";
				exit;
			}

			$query = oci_parse($connection, "select id_biblioteki as id from biblioteka where nazwa = :library_");
			oci_bind_by_name($query, ":library_", $library);
			oci_execute($query);
			$row = oci_fetch_array($query, OCI_BOTH);
			$library_id = $row['ID'];


			$query = oci_parse($connection, "select * from ksiazka where autor = :author_ and tytul = :book_ and id_biblioteki = :library_id_");
			oci_bind_by_name($query, ":author_", $author);
			oci_bind_by_name($query, ":book_", $book);
			oci_bind_by_name($query, ":library_id_", $library_id);
			oci_execute($query);
		
			if (!oci_fetch_array($query, OCI_BOTH)) {
				echo "<p style=\"color:red\">Wprowadzono niepoprawne dane</p>";
				exit;
			}


			$delete = oci_parse($connection, "delete from ksiazka where autor = :author_ and tytul = :book_ and id_biblioteki = :library_id_");
			oci_bind_by_name($delete, ":author_", $author);
			oci_bind_by_name($delete, ":book_", $book);
			oci_bind_by_name($delete, ":library_id_", $library_id);

			oci_execute($delete);
			oci_commit($connection);

			$err = oci_error();
			if ($err) {
				echo "Wystapil blad:<br>";
				var_dump(err);
			} else {
				echo "Pomyslnie usunieto ksiazke ze zbioru!";
			}
		?>
	</body>
</html>
