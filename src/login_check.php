<html>
	<head>
		<title>Serwis Biblioteczny - Logowanie</title>
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

			$query = oci_parse($connection, "select * from czytelnik where login = '".$login."'");
			oci_bind_by_name($query, ":_login", $login);
			oci_execute($query, OCI_NO_AUTO_COMMIT);

			$success = false;

			while (($row = oci_fetch_array($query, OCI_BOTH))) {
				if ($row['LOGIN'] == $login && $row['HASLO'] == $password) {
					$success = true;
					break;
				}
			}

			if ($success) {
				$_SESSION['LOGIN'] = $login;
				header("Location: main_menu.php");
			} else {
				$_SESSION['WRONG_CREDENTIALS'] = true;
				header("Location: index.php");
			}
		?>
	</body>
</html>
