<!DOCTYPE html>
<html>
<head>

<meta charset="UTF-8">
<title>база данных</title>
</head>
<body>


<?php
$conn = mysqli_connect("95.131.149.21", "mtkp_tip_3107", "807443", "mtkp_tip_3107");
$Email = mysqli_real_escape_string($conn, $_POST["Email"]);
$PASS = mysqli_real_escape_string($conn, $_POST["Password"]);
$id_klienta=rand(1,100);

if ($resulth = mysqli_query($conn, "SELECT Email FROM regist WHERE Email='" . $Email . "'")) {
while( $row = mysqli_fetch_assoc($resulth) ){
// Проверяет есть ли id
if ($row['Email']) {
// если id есть, то он сравнивает пароли функцией password_verify
echo "вы пидорасина ебучая";
$new_url = 'профиль.php';
header('Location: '.$new_url);

}
}
}

mysqli_query($conn, "INSERT INTO `regist` (`id_klienta`, `Email`, `PASS`) VALUES ('$id_klienta', '$Email', '$PASS')");



$result = $conn->query("SELECT Email,PASS,id_klienta FROM regist WHERE id_klienta=$id_klienta");
echo "<table><tr><th>Email</th><th>PASS</th></tr>";
foreach($result as $row){
echo "<tr>";
echo "<td>" . $row["Email"] . "</td>";
echo "<td>" . $row["PASS"] . "</td>";

echo "</tr>";
}
echo "</table>";



mysqli_close($conn);

?>

</body>
</html>