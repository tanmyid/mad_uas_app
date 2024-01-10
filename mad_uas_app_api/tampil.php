<?php
header("access-control-allow-origin: *");
//buat koneksi
$koneksi = new mysqli("localhost", "root", "", "mad_uas_db_kopi");
//perintah tampil data mahasiswa
if ($_GET['aksi'] == 'tampil_mahasiswa') {
    if ($_GET['operasi'] == 'semua_data') {
        $query_tampil_mahasiswa = mysqli_query($koneksi, "SELECT * from kopi");
        $data_mahasiswa = mysqli_fetch_all($query_tampil_mahasiswa, MYSQLI_ASSOC);
    }
    if ($_GET['operasi'] == 'detail_data') {
        $id_mahasiswa = $_GET['id_kopi'];
        $query_tampil_mahasiswa = mysqli_query($koneksi, "SELECT * from kopi WHERE id_kopi=" . $id_mahasiswa);
        $data_mahasiswa = mysqli_fetch_array($query_tampil_mahasiswa, MYSQLI_ASSOC);
    }
    echo json_encode($data_mahasiswa);
}
//perintah tampil data dosen
if ($_GET['aksi'] == 'tampil_dosen') {
    if ($_GET['operasi'] == 'semua_data') {
        $query_tampil_dosen = mysqli_query($koneksi, "SELECT * from kasir");
        $data_dosen = mysqli_fetch_all($query_tampil_dosen, MYSQLI_ASSOC);
    }
    if ($_GET['operasi'] == 'detail_data') {
        $id_dosen = $_GET['id_kasir'];
        $query_tampil_dosen = mysqli_query($koneksi, "SELECT * from kasir=" . $id_dosen);
        $data_dosen = mysqli_fetch_array($query_tampil_dosen, MYSQLI_ASSOC);
    }
    echo json_encode($data_dosen);
}
//perintah tampil data jadwal kuliah
if ($_GET['aksi'] == 'tampil_jadwalkuliah') {
    $query_tampil_jadwalkuliah = mysqli_query($koneksi, "SELECT * from transaksi, kopi, kasir WHERE transaksi.id_kopi = kopi.id_kopi and
transaksi.id_kasir = kasir.id_kasir ORDER BY id_transaksi DESC");
    $data_jadwalkuliah = mysqli_fetch_all($query_tampil_jadwalkuliah, MYSQLI_ASSOC);
    echo json_encode($data_jadwalkuliah);
}
//nim : (nim kamu)
//nama : (nama kamu)