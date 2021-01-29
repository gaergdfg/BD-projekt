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

		<form action="idk.php">
			<label for="city">Wybierz miasto: </label>
			<select name="CITY" id="city">
			<?php
				echo "<option value='c'>&nbsp;</option>";
				foreach ($cities as $city) {
					echo "<option value=".$city.">".$city."</option>";
				}	
			?>
			</select>

			<label for="library">Wybierz biblioteke: </label>
			<select name="LIBRARY" id="library">
			<?php
				echo "<option value='c'>&nbsp;</option>";
				foreach ($libraries as $library) {
					echo "<option value=".$library.">".$library."</option>";
				}
			?>
			</select>

			<input type="SUBMIT" value="Wyszukaj">
		</form>

		<script>
			var assignment = <?php echo json_encode($assignment); ?>;
			$("#city").change(function() {
				var $this = this;
				$("#library").children().each(function() {
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
