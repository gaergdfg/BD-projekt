<html>
	<head>
		<title>Serwis Biblioteczny - Rejestracja</title>
	</head>
	<body>
		<?php
			session_start();
			$connection = oci_connect("pp418377", "Mimuw-sql123", "labora.mimuw.edu.pl/LABS");
			if (!$connection) {
				$err = oci_error();
				echo "oci_connect failed ", $err['message'];
			}

			$login = $_POST['LOGIN'];
			$password = $_POST['PASSWORD'];
			$name = $_POST['NAME'];
			$surname = $_POST['SURNAME'];

			$query = oci_parse($connection, "select * from uzytkownicy where login = :login_");
			oci_bind_by_name($query, ":login_", $login);

			oci_execute($query, OCI_NO_AUTO_COMMIT);
			
			$duplicate = false;
			while (oci_fetch_array($query, OCI_BOTH)) {
				$duplicate = true;
			}
			 
			if ($duplicate) {
				// TODO: przekazac informacje, ze juz ktos ma taki login
				header("Location: registration.php");
			} else {
				$query = oci_parse($connection, "insert into uzytkownicy values (:login_, :password_, :name_, :surname_, 0)");
				oci_bind_by_name($query, ":login_", $login);
				oci_bind_by_name($query, ":password_", $password);
				oci_bind_by_name($query, ":name_", $name);
				oci_bind_by_name($query, ":surname_", $surname);

				oci_execute($query, OCI_DEFAULT);
				oci_commit($connection);

				header("Location: main_menu.php");
			}
		?>
	</body>
</html>
