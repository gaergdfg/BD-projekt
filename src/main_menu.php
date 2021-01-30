<html>
	<head>
		<title>Serwis Biblioteczny - Strona Glowna</title>
		<meta http-equiv="content-type" content="text/html" charset="utf-8">
		<script src="https://ajax.googleapis.com/ajax/libs/jquery/2.0.2/jquery.min.js"></script>
	</head>

	<body>
		<h1>Serwis Biblioteczny</h1>

		<?php
			session_start();

			$connection = oci_connect("pp418377", "Mimuw-sql123", "labora.mimuw.edu.pl/LABS");
			if (!$connection) {
				$err = oci_error();
				echo "oci_connect() failed ", $err['message'];
			}

			$cities = [];
			$libraries = [];
			$assignment = [];

			$cities_query = oci_parse($connection, "select * from miasto");
			oci_execute($cities_query);
			while ($row = oci_fetch_array($cities_query, OCI_BOTH)) {
				$cities[] = $row['NAZWA'];
			}
			
			$libraries_query = oci_parse($connection, "select biblioteka.nazwa as library, miasto.nazwa as city from biblioteka, miasto where biblioteka.id_miasta = miasto.id_miasta");
			oci_execute($libraries_query);
			while ($row = oci_fetch_array($libraries_query, OCI_BOTH)) {
				$libraries[] = $row['LIBRARY'];
				$assignment[$row['LIBRARY']] = $row['CITY'];
			}
			$assignment["c"] = "";
		?>

		Zobacz wszystkie ksiazki dostepne w naszej ofercie!

		<form action="general_book.php" method="POST">
			<label for="city">Wybierz miasto: </label>
			<select name="CITY" id="city-general">
			<?php
				echo "<option value='c'>&nbsp;</option>";
				foreach ($cities as $city) {
					echo "<option value='".$city."'>".$city."</option>";
				}	
			?>
			</select>

			<label for="library">Wybierz biblioteke: </label>
			<select name="LIBRARY" id="library-general">
			<?php
				echo "<option value='c'>&nbsp;</option>";
				foreach ($libraries as $library) {
					echo "<option value='".$library."'>".$library."</option>";
				}
			?>
			</select>

			<input type="SUBMIT" value="Wyszukaj">
		</form>

		Sprawdz dostepnosc ksiazek w naszej ofercie!

		<form action="specific_book.php" method="POST">
			<label for="city">Wybierz miasto: </label>
			<select name="CITY" id="city-specific">
			<?php
				echo "<option value='c'>&nbsp;</option>";
				foreach ($cities as $city) {
					echo "<option value='".$city."'>".$city."</option>";
				}	
			?>
			</select>

			<label for="library">Wybierz biblioteke: </label>
			<select name="LIBRARY" id="library-specific">
			<?php
				echo "<option value='c'>&nbsp;</option>";
				foreach ($libraries as $library) {
					echo "<option value='".$library."'>".$library."</option>";
				}
			?>
			</select>

			<label>Wpisz tytul ksiazki: </label>
			<input type="TEXT" name="BOOK" value="">

			<input type="SUBMIT" value="Wyszukaj">
		</form>

		<form action="history.php" method="POST">
			<label>Twoja historia wypozyczen</label>
			<input type="SUBMIT" value="Zobacz">
		</form>

		<form action="recommendation.php" method="POST">
			<label>Sprawdz ksiazki rekomendowane dla Ciebie!</label>
			<input type="SUBMIT" value="Sprawdz">
		</form>

		<?php
			$login = $_SESSION['LOGIN'];

			$query = oci_parse($connection, "select czy_admin from czytelnik where login = :login_");
			oci_bind_by_name($query, ":login_", $login);
			oci_execute($query);

			$row = oci_fetch_array($query, OCI_BOTH);
			$is_admin = $row['CZY_ADMIN'];

			if ($is_admin) {
				echo "<br><br><br><br><p style=\"color:red\">Administracja:</p>";
			}
		?>

		<?php
			if ($is_admin) {
				echo "<br>";

				echo "Dodaj ksiazke do zbioru.<br>";

				echo "<form action=\"add_book.php\" method=\"POST\">";
				echo "<label for=\"library\">Wybierz biblioteke: </label>";
				echo "<select name=\"LIBRARY\" id=\"library-remove\">";
				echo "<option value='c'>&nbsp;</option>";
				foreach ($libraries as $library) {
					echo "<option value='".$library."'>".$library."</option>";
				}
				echo "</select><br>";

				echo "<label>Wpisz tytul ksiazki: </label>";
				echo "<input type=\"TEXT\" name=\"BOOK\" value=\"\"> ";

				echo "<label>Wpisz autora ksiazki: </label>";
				echo "<input type=\"TEXT\" name=\"AUTHOR\" value=\"\">";
				echo "<br>";

				echo "<label>Wprowadz liczba ksiazek: </label>";
				echo "<input type=\"NUMBER\" name=\"QUANTITY\" value=1 min=1> ";

				echo "<label>Wprowadz poziom czytelniczy: </label>";
				echo "<input type=\"NUMBER\" name=\"LEVEL\" value=1 min=1 max=8> ";
				echo "<br>";

				echo "<input type=\"SUBMIT\" value=\"Dodaj\">";
				echo "</form>";
				echo "<br>";
			}
		?>

		<?php
			if ($is_admin) {
				echo "<br>";

				echo "Usun ksiazke ze zbioru.<br>";

				echo "<form action=\"remove_book.php\" method=\"POST\">";
				echo "<label for=\"library\">Wybierz biblioteke: </label>";
				echo "<select name=\"LIBRARY\" id=\"library-remove\">";
				echo "<option value='c'>&nbsp;</option>";
				foreach ($libraries as $library) {
					echo "<option value='".$library."'>".$library."</option>";
				}
				echo "</select><br>";

				echo "<label>Wpisz tytul ksiazki: </label>";
				echo "<input type=\"TEXT\" name=\"BOOK\" value=\"\"> ";

				echo "<label>Wpisz autora ksiazki: </label>";
				echo "<input type=\"TEXT\" name=\"AUTHOR\" value=\"\">";
				echo "<br>";

				echo "<input type=\"SUBMIT\" value=\"Usun\">";
				echo "</form>";
			}
		?>

		<script>
			var assignment = <?php echo json_encode($assignment); ?>;
			$("#city-general").change(function() {
				var $this = this;
				$("#library-general").children().each(function() {
					$(this).attr("disabled", function() {
						if (this.text == 'c') {
							return false;
						}
						return assignment[this.text] != $this.value;
					});
				});
			});
		</script>

		<script>
			var assignment = <?php echo json_encode($assignment); ?>;
			$("#city-specific").change(function() {
				var $this = this;
				$("#library-specific").children().each(function() {
					$(this).attr("disabled", function() {
						if (this.text == 'c') {
							return false;
						}
						return assignment[this.text] != $this.value;
					});
				});
			});
		</script>
	</body>
</html>
