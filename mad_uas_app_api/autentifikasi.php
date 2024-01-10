<?php
header("access-control-allow-origin: *");
//buat koneksi
$koneksi = new mysqli("localhost", "root", "", "mad_uas_db_kopi");
if ($_GET['aksi'] == 'login') {
    //variabel data
    $username = $_POST['username'];
    $password = $_POST['password'];
    //perintah cari data
    $query_tampil_user = mysqli_query($koneksi, "SELECT * from user where username = '$username' and password = '$password' ");
    $data_user = mysqli_fetch_array($query_tampil_user, MYSQLI_ASSOC);
    if (!empty($data_user['username'])) {
        echo json_encode([
            'status_operasi' => 'Berhasil',
            'username' => $data_user['username'],
            'password' => $data_user['password'],
            'hak_akses' => $data_user['hak_akses']
        ]);
    } else {
        echo json_encode(['status_operasi' => 'Gagal']);
    }
}
if ($_GET['aksi'] == 'perikasi_login') {
    //variabel data
    $username = $_POST['username'];
    $password = $_POST['password'];
    //perintah cari data
    $query_tampil_user = mysqli_query($koneksi, "SELECT * from user where username = '$username' and password = '$password' ");
    $data_user = mysqli_fetch_array($query_tampil_user, MYSQLI_ASSOC);
    if (!empty($data_user['username'])) {
        echo json_encode(['status_operasi' => 'Berhasil', 'hak_akses' => $data_user['hak_akses']]);
    } else {
        echo json_encode(['status_operasi' => 'Gagal']);
    }
}
//perintah tambah user
if ($_GET['aksi'] == 'daftar_akun') {
    //variabel data
    $username = $_POST['username'];
    $password = $_POST['password'];
    $password_konfirmasi = $_POST['password_konfirmasi'];
    $hak_akses = 'Bukan Admin';
    //cek username sudah ada apa belum di database
    $query_cek_username = mysqli_query($koneksi, "SELECT * from user where username = '$username' ");
    $data_user = mysqli_fetch_array($query_cek_username, MYSQLI_ASSOC);
    //jika data username belum ada di database, sistem melakukan proses tambah data baru
    if (empty($data_user['username']) and $password == $password_konfirmasi) {
        //perintah insert
        $query_tambah_user = mysqli_query($koneksi, "INSERT into user set
username = '$username',
password = '$password',
hak_akses = '$hak_akses'
");
        echo json_encode(['status_operasi' => 'Berhasil']);
    } else {
        echo json_encode(['status_operasi' => 'Gagal']);
    }
}
