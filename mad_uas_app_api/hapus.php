<?php
header("access-control-allow-origin: *");
//buat koneksi
$koneksi = new mysqli("localhost", "root", "", "mad_uas_db_kopi");
//perintah hapus data mahasiswa
if ($_GET['aksi'] == 'hapus_mahasiswa') {
    $id_kopi = $_GET['id_kopi'];
    $query_hapus_mahasiswa = mysqli_query($koneksi, "DELETE from kopi where id_kopi='$id_kopi'");
    if ($query_hapus_mahasiswa) {
        echo json_encode(['status_operasi' => 'Berhasil']);
    } else {
        echo json_encode(['status_operasi' => 'Gagal']);
    }
}
//perintah hapus data dosen
if ($_GET['aksi'] == 'hapus_dosen') {
    $id_kasir = $_GET['id_kasir'];
    $query_hapus_dosen = mysqli_query($koneksi, "DELETE from kasir where id_kasir='$id_kasir'");
    if ($query_hapus_dosen) {
        echo json_encode(['status_operasi' => 'Berhasil']);
    } else {
        echo json_encode(['status_operasi' => 'Gagal']);
    }
}
//perintah hapus data jadwal kuliah
if ($_GET['aksi'] == 'hapus_jadwalkuliah') {
    $id_transaksi = $_GET['id_transaksi'];
    $query_hapus_jadwalkuliah = mysqli_query($koneksi, "DELETE FROM transaksi where id_transaksi='$id_transaksi'");
    if ($query_hapus_jadwalkuliah) {
        echo json_encode(['status_operasi' => 'Berhasil']);
    } else {
        echo json_encode(['status_operasi' => 'Gagal']);
    }
}
//nim : (nim kamu)
//nama : (nama kamu)