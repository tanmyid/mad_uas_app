<?php
header("access-control-allow-origin: *");
//buat koneksi
$koneksi = new mysqli("localhost", "root", "", "mad_uas_db_kopi");
//perintah tambah / ubah mahasiswa
if ($_GET['aksi'] == 'simpan_mahasiswa') {
    $jenis_kopi = $_POST['jenis_kopi'];
    $nama_kopi = $_POST['nama_kopi'];
    $harga_kopi = $_POST['harga_kopi'];
    if ($_GET['operasi'] == 'tambah') {
        $query_tambah_mahasiswa = mysqli_query($koneksi, "INSERT into kopi SET jenis_kopi = '$jenis_kopi', nama_kopi = '$nama_kopi', harga_kopi = '$harga_kopi'
");
        if ($query_tambah_mahasiswa) {
            echo json_encode(['status_operasi' => 'Berhasil']);
        } else {
            echo json_encode(['status_operasi' => 'Gagal']);
        }
    }
    if ($_GET['operasi'] == 'ubah') {
        $id_kopi = $_POST['id_kopi'];
        $query_ubah_mahasiswa = mysqli_query($koneksi, "UPDATE kopi set
jenis_kopi = '$jenis_kopi',
nama_kopi = '$nama_kopi',
harga_kopi = '$harga_kopi'
WHERE id_kopi='$id_kopi'");
        if ($query_ubah_mahasiswa) {
            echo json_encode(['status_operasi' => 'Berhasil']);
        } else {
            echo json_encode(['status_operasi' => 'Gagal']);
        }
    }
}
//perintah tambah / ubah dosen
if ($_GET['aksi'] == 'simpan_dosen') {
    $nidn_dosen = $_POST['nama_kasir'];
    $nama_dosen = $_POST['jabatan'];
    if ($_GET['operasi'] == 'tambah') {
        $query_tambah_dosen = mysqli_query($koneksi, "INSERT into kasir set
nama_kasir = '$nidn_dosen',
jabatan = '$nama_dosen'
");
        if ($query_tambah_dosen) {
            echo json_encode(['status_operasi' => 'Berhasil']);
        } else {
            echo json_encode(['status_operasi' => 'Gagal']);
        }
    }
    if ($_GET['operasi'] == 'ubah') {
        $id_dosen = $_POST['id_kasir'];
        $query_ubah_dosen = mysqli_query($koneksi, "UPDATE kasir set
nama_kasir = '$nidn_dosen',
jabatan = '$nama_dosen'
WHERE id_kasir='$id_dosen'");
        if ($query_ubah_dosen) {
            echo json_encode(['status_operasi' => 'Berhasil']);
        } else {
            echo json_encode(['status_operasi' => 'Gagal']);
        }
    }
}
//perintah tambah jadwal kuliah
if ($_GET['aksi'] == 'simpan_jadwalkuliah') {
    $jumlah_jual = $_POST['jumlah_jual'];
    $tgl_penjualan = date('Y-m-d');
    $id_kopi = $_POST['id_kopi'];
    $id_kasir = $_POST['id_kasir'];
    $pecah_id_kopi = explode('-', $id_kopi);
    $pecah_id_kasir = explode('-', $id_kasir);
    if ($_GET['operasi'] == 'tambah') {
        $query_tambah_jadwalkuliah = mysqli_query($koneksi, "INSERT INTO transaksi SET tgl_penjualan = '$tgl_penjualan', id_kopi = '$pecah_id_kopi[0]', id_kasir = '$pecah_id_kasir[0]', jumlah_jual='$jumlah_jual'");
        if ($query_tambah_jadwalkuliah) {
            echo json_encode(['status_operasi' => 'Berhasil']);
        } else {
            echo json_encode(['status_operasi' => 'Gagal']);
        }
    }
}
//nim : (nim kamu)
//nama : (nama kamu)