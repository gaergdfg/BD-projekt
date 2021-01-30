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
			$quantity = $_POST['QUANTITY'];
			$level = $_POST['LEVEL'];
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
			} else {
				$query = oci_parse($connection, "select max(id_ksiazki) as id from ksiazka");
				oci_execute($query);
				$row = oci_fetch_array($query, OCI_BOTH);
				var_dump($row);
				$new_book_id = $row['ID'] + 1;

				$query = oci_parse($connection, "select id_biblioteki as id from biblioteka where nazwa = :library_");
				oci_bind_by_name($query, ":library_", $library);
				oci_execute($query);
				$row = oci_fetch_array($query, OCI_BOTH);
				$library_id = $row['ID'];

				echo $new_book_id, ' ',  $author, ' ', $book, ' ', $quantity, ' ', $level, ' ', $library_id, "<br>";

				$insert = oci_parse($connection, "insert into ksiazka values (:new_book_id_, :author_, :book_, :quantity_, :level_, :library_id_)");
				oci_bind_by_name($insert, ":new_book_id_", $new_book_id);
				oci_bind_by_name($insert, ":author_", $author);
				oci_bind_by_name($insert, ":book_", $book);
				oci_bind_by_name($insert, ":quantity_", $quantity);
				oci_bind_by_name($insert, ":level_", $level);
				oci_bind_by_name($insert, ":library_id_", $library_id);

				oci_execute($insert);
				oci_commit($connection);

				$err = oci_error();
				var_dump($err);
				if ($err) {
					echo "Wystapil blad:<br>";
					var_dump(err);
				} else {
					echo "Pomyslnie dodano nowa ksiazke do zbioru!";
				}
			}
		?>
	</body>
</html>
