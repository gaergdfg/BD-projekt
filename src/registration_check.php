<html>
	<head>
		<title>Serwis Biblioteczny - Rejestracja</title>
	</head>
	<body>
		<?php
			session_start();
			$connection = oci_connect("pp418377", "Mimuw-sql123", "labora.mimuw.edu.pl/LABS");
			if (!connection) {
				echo "oci_connect failed\n";
				$err = oci_error();
				echo $err['message'];
			}

			$login = $_POST['LOGIN'];
			$password = $_POST['PASSWORD'];
			$name = $_POST['IMIE'];
			$surname = $_POST['NAZWISKO'];

			$query = oci_parse($connection, "select * from uzytkownicy where login = '".$login."'");
			oci_execute($query, OCI_NO_AUTO_COMMIT);

			if (oci_fetch_array($query, OCI_BOTH)) {
				// przekazac informacje, ze juz ktos ma taki login
				echo "fail\n";
				header("Location: registration.php");
			} else {
				$insert = oci_parse($connection, "insert into uzytkownicy values ('".$login."', '".$password."', '".$name."', '".$surname."', 0)");
				oci_execute($insert, OCI_NO_AUTO_COMMIT);
				oci_commit($connection);
				echo "success\n";
				header("Location: main_menu.php");
			}
		?>
	</body>
</html>
