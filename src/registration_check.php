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

			$query = oci_parse($connection, "select * from czytelnik where login = :login_");
			oci_bind_by_name($query, ":login_", $login);

			oci_execute($query, OCI_NO_AUTO_COMMIT);
			
			$duplicate = false;
			while (oci_fetch_array($query, OCI_BOTH)) {
				$duplicate = true;
			}
			 
			if ($duplicate) {
				$_SESSION['LOGIN_TAKEN'] = true;

				header("Location: registration.php");
			} else {
				$query = oci_parse($connection, "select MAX(id_czytelnika) as id from czytelnik");
				oci_execute($query);

				$row = oci_fetch_array($query, OCI_BOTH);
				$next_id = $row['ID'] + 1;

				$query = oci_parse($connection, "insert into czytelnik values (:next_id_, :name_, :surname_, :login_, :password_, 0)");
				oci_bind_by_name($query, ":next_id_", $next_id);
				oci_bind_by_name($query, ":name_", $name);
				oci_bind_by_name($query, ":surname_", $surname);
				oci_bind_by_name($query, ":login_", $login);
				oci_bind_by_name($query, ":password_", $password);

				oci_execute($query, OCI_DEFAULT);

				oci_commit($connection);

				header("Location: main_menu.php");
			}
		?>
	</body>
</html>
