<html>
	<head>
		<title>Serwis Biblioteczny - Rejestracja</title>
		<meta http-equiv="content-type" content="text/html" charset="utf-8">
	</head>

	<body>
		<h2>Logowanie</h2>

		<form action="registration_check.php" method="POST">
			Login:
			<input type="TEXT" name="LOGIN" value="">
			<br><br>

			Haslo:
			<input type="PASSWORD" name="PASSWORD" value="">
			<br><br>

			Imie:
			<input type="TEXT" name="NAME" value="">
			<br><br>

			Nazwisko:
			<input type="TEXT" name="SURNAME" value="">
			<br><br>

			<input type="SUBMIT" value="Zarejestruj">
		</form>

		<?php

			session_start();

			if (isset($_SESSION['LOGIN_TAKEN'])) {
				echo "<p style=\"color:red\">Uzytkownik o takim login'ie juz istnieje, prosze wybierz inny.</p>";
				unset($_SESSION['LOGIN_TAKEN']);
			}

		?>
	</body>
</html>
