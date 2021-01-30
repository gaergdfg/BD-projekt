<html>
	<head>
		<title>Serwis Biblioteczny - Logowanie</title>
		<meta http-equiv="content-type" content="text/html" charset="utf-8">
	</head>

	<body>
		<h2>Logowanie</h2>

		<form action="login_check.php" method="POST">
			Login:
			<input type="TEXT" name="LOGIN" value="">
			<br><br>

			Haslo:
			<input type="PASSWORD" name="PASSWORD" value="">
			<br><br>

			<input type="SUBMIT" value="Zaloguj">
		</form>

		<?php

			session_start();

			if (isset($_SESSION['WRONG_CREDENTIALS'])) {
				echo "<p style=\"color:red\">Nie znaleziono uzytkownika o takiej kombinacji loginu i hasla.</p>";
				unset($_SESSION['WRONG_CREDENTIALS']);
			}

		?>

		<a href="registration.php">Nie masz konta? Zarejestruj sie!<a>
	</body>
</html>
