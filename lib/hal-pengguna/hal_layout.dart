// ignore_for_file: non_constant_identifier_names, prefer_typing_uninitialized_variables, unnecessary_brace_in_string_interps, unused_element, must_be_immutable, unused_local_variable
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:mad_uas_app/hal-pengguna/hal_konten.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:animated_snack_bar/animated_snack_bar.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:intl/intl.dart';
import 'package:mad_uas_app/hal_utama.dart';

class HalLayout extends StatefulWidget {
  HalLayout({super.key, required this.halamanindex});
  int halamanindex;
  @override
  State<HalLayout> createState() => _HalLayoutState();
}

class _HalLayoutState extends State<HalLayout> {
//membuat variabel untuk session
  var session_username;
  var session_password;
  var session_hakakses;
  @override
  void initState() {
    super.initState();
    ambilDataMahasiswa();
    ambilDataDosen();
//perintah untuk menjalankan fungsi ambil data session dari storage
    GetStorage.init();
    final box = GetStorage();
    setState(() {
      session_username = box.read('simpan_username_pengguna');
      session_password = box.read('simpan_password_pengguna');
      session_hakakses = box.read('simpan_hakakses_pengguna');
    });
  }

  final halaman = [
    const HalBerandaPengguna(),
    const HalJadwalKuliah(),
    const HalRekapMahasiswa(),
    const HalRekapDosen(),
  ];
  List menu_aplikasi = [
    'Beranda',
    'Transaksi',
    'Daftar Kopi',
    'Daftar Kasir',
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
        title: Text(
          menu_aplikasi[widget.halamanindex],
          style: const TextStyle(
              color: Colors.black, fontWeight: FontWeight.bold, fontSize: 20),
        ),
        leading: TextButton.icon(
          onPressed: () {
            formKonfirmasiKeluar(context);
          },
          icon: const Icon(
            Icons.arrow_back_ios,
            size: 20,
            color: Colors.black,
          ),
          label: const Text(
            'Keluar',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
        leadingWidth: 100,
      ),
      bottomNavigationBar: BottomNavigationBar(
          backgroundColor: Colors.brown,
          type: BottomNavigationBarType.shifting,
          fixedColor: Colors.black, //memberi warna jika menu di pilih
          iconSize: 30,
          currentIndex: widget.halamanindex,
          landscapeLayout: BottomNavigationBarLandscapeLayout.spread,
          onTap: (value) {
            widget.halamanindex = value;
            setState(() {});
          },
          items: const [
            BottomNavigationBarItem(
                backgroundColor: Colors.brown,
                icon: Icon(Icons.home),
                label: 'Beranda'),
            BottomNavigationBarItem(
                backgroundColor: Colors.brown,
                icon: Icon(Icons.table_rows_rounded),
                label: 'Transaksi '),
            BottomNavigationBarItem(
                backgroundColor: Colors.brown,
                icon: Icon(Icons.people_alt_rounded),
                label: 'Daftar Kopi'),
            BottomNavigationBarItem(
                backgroundColor: Colors.brown,
                icon: Icon(Icons.people_alt_rounded),
                label: 'Daftar Kasir'),
          ]),
      body: IndexedStack(
        index: widget.halamanindex,
        children: halaman,
      ),
      floatingActionButton: SpeedDial(
        animatedIcon: AnimatedIcons.menu_close,
        animatedIconTheme: const IconThemeData(size: 22.0),
        closeManually: false,
        curve: Curves.bounceIn,
        overlayColor: Colors.black,
        overlayOpacity: 0.5,
        backgroundColor: Colors.purple,
        foregroundColor: Colors.white,
        elevation: 8.0,
        shape: const CircleBorder(),
        children: [
          SpeedDialChild(
              child: const Icon(Icons.people_alt_rounded),
              backgroundColor: Colors.white,
              label: 'Entri Kopi',
              labelStyle: const TextStyle(fontSize: 12.0),
              onTap: () => formEntriMahasiswa(context)),
          SpeedDialChild(
              child: const Icon(Icons.people_alt_rounded),
              backgroundColor: Colors.white,
              label: 'Entri Kasir',
              labelStyle: const TextStyle(fontSize: 12.0),
              onTap: () => formEntriDosen(context)),
          SpeedDialChild(
            child: const Icon(Icons.content_paste_search_rounded),
            backgroundColor: Colors.white,
            label: 'Entri Transaksi',
            labelStyle: const TextStyle(fontSize: 12.0),
            onTap: () => formEntriJadwalKuliah(context),
          ),
          SpeedDialChild(
            child: const Icon(Icons.refresh_rounded),
            backgroundColor: Colors.white,
            label: 'Refresh Halaman',
            labelStyle: const TextStyle(fontSize: 12.0),
            onTap: () => Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                    builder: (context) => HalLayout(halamanindex: 0))),
          ),
        ],
      ),
    );
  }

//------------------------------ AREA FORM ENTRI -----------------------------
//membuat validasi form entri saat input data
  final _formKey = GlobalKey<FormState>();
//--------------------------- FORM Entri Kopi ---------------------------
  Future formEntriMahasiswa(BuildContext context) {
//mendefinisikan field/kolom inputan mahasiswa
    var jenis_kopi = TextEditingController();
    var nama_kopi = TextEditingController();
    var harga_kopi = TextEditingController();
//perintah untuk menyimpan data mahasiswa
    Future simpanMahasiswa() async {
      try {
        return await http.post(
          Uri.parse(
              "http://localhost/mad_uas_app_api/simpan.php?aksi=simpan_mahasiswa&operasi=tambah"),
          body: {
            "jenis_kopi": jenis_kopi.text,
            "nama_kopi": nama_kopi.text,
            "harga_kopi": harga_kopi.text,
          },
        ).then((value) {
//menampilkan pesan setelah menambahkan data ke database, kamu dapat menambah pesan atau notifikasi lain di sini
          var data = jsonDecode(value.body);
          print(data["status_operasi"]);
          if (data["status_operasi"] == 'Berhasil') {
            Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                    builder: (context) => HalLayout(halamanindex: 2)));
            AnimatedSnackBar.material(
              'Operasi berhasil.',
              type: AnimatedSnackBarType.success,
              duration: const Duration(seconds: 1),
            ).show(context);
          } else {
            AnimatedSnackBar.material(
              'Operasi gagal.',
              type: AnimatedSnackBarType.warning,
              duration: const Duration(seconds: 1),
            ).show(context);
          }
        });
      } catch (e) {
        print(e);
      }
    }

//FORM ENTRI
    return showModalBottomSheet(
        isScrollControlled: true,
        context: context,
        backgroundColor: Colors.white,
        barrierColor: Colors.black87.withOpacity(0.5),
        isDismissible: true,
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(top: Radius.circular(30))),
        builder: (context) => SizedBox(
              height: MediaQuery.of(context).size.height * 0.85,
              child: Form(
                key: _formKey,
                child: SingleChildScrollView(
                  child: Container(
                    padding: const EdgeInsets.all(40.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        AppBar(
                          title: const Text(
                            'Form Entri Kopi',
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.black87),
                          ),
                          centerTitle: true,
                          backgroundColor: Colors.white,
                          elevation: 0,
                          iconTheme: const IconThemeData(color: Colors.black87),
                        ),
                        const SizedBox(height: 5),
                        TextFormField(
                          controller: jenis_kopi,
                          decoration: const InputDecoration(
                              label: Text('Jenis Kopi'),
                              hintText: "Tulis Jenis Kopi ...",
                              fillColor: Colors.white,
                              filled: true),
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Jenis Kopi is Required!';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 10),
                        TextFormField(
                          controller: nama_kopi,
                          decoration: const InputDecoration(
                              label: Text('Nama'),
                              hintText: 'Tulis nama ...',
                              fillColor: Colors.white,
                              filled: true),
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Nama is Required!';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 10),
                        TextFormField(
                          controller: harga_kopi,
                          decoration: const InputDecoration(
                              label: Text('Harga'),
                              hintText: 'Tulis Harga ...',
                              fillColor: Colors.white,
                              filled: true),
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Harga is Required!';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 15),
                        Container(
                          padding: const EdgeInsets.all(1),
                          child: MaterialButton(
                            minWidth: double.infinity,
                            height: 60,
                            color: Colors.green,
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(50)),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: const [
                                Icon(
                                  Icons.save,
                                  color: Colors.white,
                                ),
                                SizedBox(
                                  width: 10,
                                ),
                                Text(
                                  "Simpan",
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 18,
                                      color: Colors.white),
                                ),
                              ],
                            ),
                            onPressed: () {
//validasi
                              if (_formKey.currentState!.validate()) {
//menjalankan fungsi untuk kirim data ke database
                                simpanMahasiswa();
                              }
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ));
  }

//---------------------------- FORM ENTRI DOSEN ------------------------------
  Future formEntriDosen(BuildContext context) {
//mendefinisikan field/kolom inputan dosen
    var nama_kasir = TextEditingController();
    var nama_dosen = TextEditingController();
//perintah untuk menyimpan data dosen
    Future simpanDosen() async {
      try {
        return await http.post(
          Uri.parse(
              "http://localhost/mad_uas_app_api/simpan.php?aksi=simpan_dosen&operasi=tambah"),
          body: {
            "nama_kasir": nama_kasir.text,
            "jabatan": nama_dosen.text,
          },
        ).then((value) {
//menampilkan pesan setelah menambahkan data ke database, kamu dapat menambah pesan atau notifikasi lain di sini
          var data = jsonDecode(value.body);
          print(data["status_operasi"]);
          if (data["status_operasi"] == 'Berhasil') {
            Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                    builder: (context) => HalLayout(halamanindex: 3)));
            AnimatedSnackBar.material(
              'Operasi berhasil.',
              type: AnimatedSnackBarType.success,
              duration: const Duration(seconds: 1),
            ).show(context);
          } else {
            AnimatedSnackBar.material(
              'Operasi gagal.',
              type: AnimatedSnackBarType.warning,
              duration: const Duration(seconds: 1),
            ).show(context);
          }
        });
      } catch (e) {
        print(e);
      }
    }

//FORM ENTRI
    return showModalBottomSheet(
        isScrollControlled: true,
        context: context,
        backgroundColor: Colors.white,
        barrierColor: Colors.black87.withOpacity(0.5),
        isDismissible: true,
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(top: Radius.circular(30))),
        builder: (context) => SizedBox(
              height: MediaQuery.of(context).size.height * 0.85,
              child: Form(
                key: _formKey,
                child: Container(
                  padding: const EdgeInsets.all(40.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      AppBar(
                        title: const Text(
                          'Form Entri Kasir',
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.black87),
                        ),
                        centerTitle: true,
                        backgroundColor: Colors.white,
                        elevation: 0,
                        iconTheme: const IconThemeData(color: Colors.black87),
                      ),
                      const SizedBox(height: 5),
                      TextFormField(
                        controller: nama_kasir,
                        decoration: const InputDecoration(
                            label: Text('Nama Kasir'),
                            hintText: "Tulis Nama Kasir ...",
                            fillColor: Colors.white,
                            filled: true),
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Nama Kasir is Required!';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 10),
                      TextFormField(
                        controller: nama_dosen,
                        decoration: const InputDecoration(
                            label: Text('Jabatan Kasir'),
                            hintText: 'Tulis Jabatan Kasir ...',
                            fillColor: Colors.white,
                            filled: true),
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Jabatan Kasir is Required!';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 15),
                      Container(
                        padding: const EdgeInsets.all(1),
                        child: MaterialButton(
                          minWidth: double.infinity,
                          height: 60,
                          color: Colors.green,
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(50)),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: const [
                              Icon(
                                Icons.save,
                                color: Colors.white,
                              ),
                              SizedBox(
                                width: 10,
                              ),
                              Text(
                                "Simpan",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 18,
                                    color: Colors.white),
                              ),
                            ],
                          ),
                          onPressed: () {
//validasi
                            if (_formKey.currentState!.validate()) {
//menjalankan fungsi untuk kirim data ke database
                              simpanDosen();
                            }
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ));
  }

//-------------------------- FORM ENTRI JADWAL KULIAH ------------------------
  List opsi_mahasiswa = [];
  List opsi_dosen = [];
//membuat perintah untuk mengambil data mahasiswa dari database menggunakan RestFul API
  Future ambilDataMahasiswa() async {
    final tampil_mahasiswa = await http.get(Uri.parse(
        "http://localhost/mad_uas_app_api/tampil.php?aksi=tampil_mahasiswa&operasi=semua_data"));
    if (tampil_mahasiswa.statusCode == 200) {
      final ambil_data_mahasiswa = jsonDecode(tampil_mahasiswa.body) as List;
      for (var data_mahasiswa in ambil_data_mahasiswa) {
        opsi_mahasiswa.add(
            '${data_mahasiswa['id_kopi']} - ${data_mahasiswa['jenis_kopi']} - ${data_mahasiswa['nama_kopi']}');
      }
      return opsi_mahasiswa;
    }
  }

//membuat perintah untuk mengambil data dosen dari database menggunakan RestFul API
  Future ambilDataDosen() async {
    final tampil_dosen = await http.get(Uri.parse(
        "http://localhost/mad_uas_app_api/tampil.php?aksi=tampil_dosen&operasi=semua_data"));
    if (tampil_dosen.statusCode == 200) {
      final ambil_data_dosen = jsonDecode(tampil_dosen.body) as List;
      for (var data_dosen in ambil_data_dosen) {
        opsi_dosen.add(
            '${data_dosen['id_kasir']} - ${data_dosen['nama_kasir']} - ${data_dosen['jabatan']}');
      }
      return opsi_mahasiswa;
    }
  } //FORM ENTRI

  Future formEntriJadwalKuliah(BuildContext context) {
//mendefinisikan field/kolom inputan dosen
    var id_kopi;
    var id_kasir;
    // var tgl_penjualan;
    var jumlah_jual = TextEditingController();
//perintah untuk menyimpan data dosen
    Future simpanJadwalKuliah() async {
      try {
        return await http.post(
          Uri.parse(
              "http://localhost/mad_uas_app_api/simpan.php?aksi=simpan_jadwalkuliah&operasi=tambah"),
          body: {
            // "tgl_penjualan": tgl_penjualan,
            "id_kopi": id_kopi,
            "id_kasir": id_kasir,
            "jumlah_jual": jumlah_jual.text,
          },
        ).then((value) {
//menampilkan pesan setelah menambahkan data ke database, kamu dapat menambah pesan atau notifikasi lain di sini
          var data = jsonDecode(value.body);
          print(data["status_operasi"]);
          if (data["status_operasi"] == 'Berhasil') {
            Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                    builder: (context) => HalLayout(halamanindex: 1)));
            AnimatedSnackBar.material(
              'Operasi berhasil.',
              type: AnimatedSnackBarType.success,
              duration: const Duration(seconds: 1),
            ).show(context);
          } else {
            AnimatedSnackBar.material(
              'Operasi gagal.',
              type: AnimatedSnackBarType.warning,
              duration: const Duration(seconds: 1),
            ).show(context);
          }
        });
      } catch (e) {
        print(e);
      }
    }

//FORM ENTRI
    return showModalBottomSheet(
        isScrollControlled: true,
        context: context,
        backgroundColor: Colors.white,
        barrierColor: Colors.black87.withOpacity(0.5),
        isDismissible: true,
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(top: Radius.circular(30))),
        builder: (context) => SizedBox(
              height: MediaQuery.of(context).size.height * 0.85,
              child: Form(
                key: _formKey,
                child: Container(
                  padding: const EdgeInsets.all(40.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      AppBar(
                        title: const Text(
                          'Form Entri Transaksi',
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.black87),
                        ),
                        centerTitle: true,
                        backgroundColor: Colors.white,
                        elevation: 0,
                        iconTheme: const IconThemeData(color: Colors.black87),
                      ),
                      const SizedBox(height: 10),
                      DropdownButtonFormField<String>(
                        value: id_kopi,
                        onChanged: (value) {
                          setState(() {
                            id_kopi = value;
                          });
                        },
                        items: opsi_mahasiswa.map((value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          );
                        }).toList(),
                        decoration: const InputDecoration(
                          label: Text('Nama Kopi',
                              style: TextStyle(fontWeight: FontWeight.bold)),
                          hintText: ' - Pilih Kopi -',
                          fillColor: Colors.white,
                          filled: true,
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Nama Kopi is Required!';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 10),
                      DropdownButtonFormField<String>(
                        isExpanded: true,
                        value: id_kasir,
                        onChanged: (value) {
                          setState(() {
                            id_kasir = value;
                          });
                        },
                        items: opsi_dosen.map((value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(
                              value,
                              overflow: TextOverflow.fade,
                              maxLines: 1,
                              softWrap: false,
                            ),
                          );
                        }).toList(),
                        decoration: const InputDecoration(
                          label: Text('Nama Kasir',
                              style: TextStyle(fontWeight: FontWeight.bold)),
                          hintText: ' - Pilih Kasir -',
                          fillColor: Colors.white,
                          filled: true,
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Kasir is Required!';
                          }
                          return null;
                        },
                      ),
                      TextFormField(
                        controller: jumlah_jual,
                        decoration: const InputDecoration(
                            label: Text('Jumlah'),
                            hintText: "Tulis Jumlah ...",
                            fillColor: Colors.white,
                            filled: true),
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Jumlah is Required!';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 15),
                      Container(
                        padding: const EdgeInsets.all(1),
                        child: MaterialButton(
                          minWidth: double.infinity,
                          height: 60,
                          color: Colors.green,
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(50)),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: const [
                              Icon(
                                Icons.save,
                                color: Colors.white,
                              ),
                              SizedBox(
                                width: 10,
                              ),
                              Text(
                                "Simpan",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 18,
                                    color: Colors.white),
                              ),
                            ],
                          ),
                          onPressed: () {
//validasi
                            if (_formKey.currentState!.validate()) {
//menjalankan fungsi untuk kirim data ke database
                              simpanJadwalKuliah();
                            }
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ));
  }

//-------------- FORM KONFIRMASI LOGOUT / KELUAR APLIKASI --------------------
  Future formKonfirmasiKeluar(BuildContext context) {
//perintah untuk menjalankan fungsi ambil data session dari storage
    Future prosesKeluar() async {
      GetStorage.init();
      final box = GetStorage();
      box.remove('simpan_username_pengguna');
      box.remove('simpan_password_pengguna');
      box.remove('simpan_hakakses_pengguna');
      AnimatedSnackBar.material(
        'Keluar berhasil',
        type: AnimatedSnackBarType.success,
        duration: const Duration(seconds: 1),
      ).show(context);
      Timer(const Duration(seconds: 2), () {
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => const HalUtama()));
      });
    }

    return showModalBottomSheet(
        isScrollControlled: true,
        context: context,
        backgroundColor: Colors.white,
        barrierColor: Colors.black87.withOpacity(0.5),
        isDismissible: true,
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(top: Radius.circular(30))),
        builder: (context) => SizedBox(
              height: MediaQuery.of(context).size.height * 0.85,
              child: Form(
                key: _formKey,
                child: Container(
                  padding: const EdgeInsets.all(40.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      AppBar(
                        title: const Text(
                          'Profil Akun',
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.black87),
                        ),
                        centerTitle: true,
                        backgroundColor: Colors.white,
                        elevation: 0,
                        iconTheme: const IconThemeData(color: Colors.black87),
                      ),
                      const SizedBox(height: 5),
                      Icon(
                        Icons.person_pin,
                        size: 200,
                        color: Colors.grey[900],
                      ),
                      const SizedBox(height: 20),
                      Text('Username : $session_username'),
                      const SizedBox(height: 20),
                      Text('Password : $session_password'),
                      const SizedBox(height: 20),
                      Text('Hak Akses : $session_hakakses'),
                      const SizedBox(height: 15),
                      Container(
                        padding: const EdgeInsets.all(1),
                        child: MaterialButton(
                          minWidth: double.infinity,
                          height: 60,
                          color: Colors.orange[900],
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(50)),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: const [
                              Icon(
                                Icons.logout_rounded,
                                color: Colors.white,
                              ),
                              SizedBox(
                                width: 10,
                              ),
                              Text(
                                "K e l u a r",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 18,
                                    color: Colors.white),
                              ),
                            ],
                          ),
                          onPressed: () {
//proses keluar atau logout
                            prosesKeluar();
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ));
  }
}
