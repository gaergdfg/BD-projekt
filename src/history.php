<html>
	<head>
		<title>Serwis Biblioteczny - Historia</title>
		<meta http-equiv="content-type" content="text/html" charset="utf-8">
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

			$login = $_SESSION['LOGIN'];

			$query = oci_parse($connection, "select id_czytelnika from czytelnik where login = :login_");
			oci_bind_by_name($query, ":login_", $login);
			oci_execute($query);
			$row = oci_fetch_array($query, OCI_BOTH);
			$id = $row['ID_CZYTELNIKA'];

			$query = oci_parse($connection, "select ksiazka.tytul as tytul, ksiazka.autor as autor, ksiazka.przedzial as przedzial from historia_wypozyczen, ksiazka where historia_wypozyczen.id_czytelnika = :id_ and historia_wypozyczen.id_ksiazki = ksiazka.id_ksiazki");
			oci_bind_by_name($query, ":id_", $id);
			oci_execute($query);

			$is_empty = true;
			echo "Twoja historia wypozyczen:<br><br>";
			echo "<ul>";
			while ($row = oci_fetch_array($query, OCI_BOTH)) {
				$is_empty = false;
				echo "<li>", "Tytul: ", $row['TYTUL'], "<br>Autor: ", $row['AUTOR'], "<br>Poziom czytelniczy: ", $row['PRZEDZIAL'], "</li>";
			}
			echo "</ul>";

			if ($is_empty) {
				echo "<br><p>Wyglada na to, ze nie masz jeszcze wypozyczyles(as) jeszcze zadnej ksiazki.</p>";
			}
		?>
	</body>
</html>
