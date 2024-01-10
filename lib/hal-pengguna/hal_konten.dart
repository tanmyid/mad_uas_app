// ignore_for_file: use_build_context_synchronously, non_constant_identifier_names, prefer_typing_uninitialized_variables, duplicate_ignore, avoid_print, unused_local_variable, unused_element
import 'package:animated_snack_bar/animated_snack_bar.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:intl/intl.dart';
import 'package:timeline_tile/timeline_tile.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'hal_layout.dart';

//--------------------------- AREA KONTEN BERANDA ------------------------------
class HalBerandaPengguna extends StatefulWidget {
  const HalBerandaPengguna({super.key});
  @override
  State<HalBerandaPengguna> createState() => _HalBerandaPenggunaState();
}

class _HalBerandaPenggunaState extends State<HalBerandaPengguna> {
//membuat variabel session
  var session_username;
  var session_password;
  var session_hakakses;
//membuat variabel array untuk menampung data dari tabel mahasiswa
  List data_mahasiswa = [];
//membuat variabel array untuk menampung data dari tabel dosen
  List data_dosen = [];
//membuat variabel array untuk menampung data dari tabel jadwal kuliah
  List data_jadwalkuliah = [];
  @override
  void initState() {
    super.initState();
//perintah untuk menjalankan fungsi ambil data session dari storage
    GetStorage.init();
    final box = GetStorage();
    setState(() {
      session_username = box.read('simpan_username_pengguna');
      session_password = box.read('simpan_password_pengguna');
      session_hakakses = box.read('simpan_hakakses_pengguna');
    });
    ambilData();
  }

//membuat perintah untuk mengambil data mahasiswa dari database menggunakan RestFul API
  Future ambilData() async {
    try {
      final tampil_mahasiswa = await http.get(Uri.parse(
          "http://localhost/mad_uas_app_api/tampil.php?aksi=tampil_mahasiswa&operasi=semua_data"));
      final tampil_dosen = await http.get(Uri.parse(
          "http://localhost/mad_uas_app_api/tampil.php?aksi=tampil_dosen&operasi=semua_data"));
      final tampil_jadwalkuliah = await http.get(Uri.parse(
          "http://localhost/mad_uas_app_api/tampil.php?aksi=tampil_jadwalkuliah"));
      if (tampil_mahasiswa.statusCode == 200) {
        final ambil_data_mahasiswa = jsonDecode(tampil_mahasiswa.body);
        setState(() {
          data_mahasiswa = ambil_data_mahasiswa;
        });
      }
      if (tampil_dosen.statusCode == 200) {
        final ambil_data_dosen = jsonDecode(tampil_dosen.body);
        setState(() {
          data_dosen = ambil_data_dosen;
        });
      }
      if (tampil_jadwalkuliah.statusCode == 200) {
        final ambil_data_jadwalkuliah = jsonDecode(tampil_jadwalkuliah.body);
        setState(() {
          data_jadwalkuliah = ambil_data_jadwalkuliah;
        });
      }
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "Selamat Datang .. ",
                        style: TextStyle(
                            fontSize: 25, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Text(
                        "Halaman pengguna kamu.",
                        style: TextStyle(fontSize: 15, color: Colors.grey[900]),
                      )
                    ],
                  ),
                  Column(
                    children: [
                      Icon(
                        Icons.person_pin,
                        size: 75,
                        color: Colors.grey[900],
                      ),
                      Text('($session_username)')
                    ],
                  )
                ],
              ),
              const SizedBox(height: 25),
//menampilkan data mahasiswa
              const Text("List Kopi",
                  style: TextStyle(fontWeight: FontWeight.bold)),
              SizedBox(
                  height: 100,
                  child: ListView.builder(
                      itemCount: data_mahasiswa.length,
                      scrollDirection: Axis.horizontal,
                      itemBuilder: (BuildContext context, int index) {
                        return Container(
                          width: 90,
                          margin: const EdgeInsets.all(5),
                          child: CircleAvatar(
                            backgroundColor: Colors.brown,
                            radius: 100,
                            child: Center(
                              child: Text(
                                '${data_mahasiswa[index]['nama_kopi']}',
                                overflow: TextOverflow.fade,
                                maxLines: 1,
                                softWrap: false,
                                style: const TextStyle(color: Colors.white),
                              ),
                            ),
                          ),
                        );
                      })),
              const SizedBox(height: 15),
//menampilkan data dosen
              const Text(
                "Data Kasir",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              SizedBox(
                  height: 200,
                  child: ListView.builder(
                      itemCount: data_dosen.length,
                      scrollDirection: Axis.horizontal,
                      itemBuilder: (BuildContext context, int index) {
                        return Container(
                          width: 150,
                          decoration: BoxDecoration(
                              color: Colors.brown,
                              borderRadius: BorderRadius.circular(15)),
                          margin: const EdgeInsets.all(8),
                          child: Center(
                              child: Text(
                            '${data_dosen[index]['nama_kasir']}',
                            overflow: TextOverflow.fade,
                            maxLines: 1,
                            softWrap: false,
                            style: const TextStyle(color: Colors.white),
                          )),
                        );
                      })),
              const SizedBox(height: 15),
//menampilkan data jadwal kuliah
              const Text(
                "Riwayat Transaksi",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: data_jadwalkuliah.length,
                  itemBuilder: (BuildContext context, int index) {
                    return SizedBox(
                      height: 100,
                      child: TimelineTile(
                        beforeLineStyle: const LineStyle(color: Colors.grey),
                        indicatorStyle: IndicatorStyle(
                            width: 40,
                            color: Colors.brown,
                            iconStyle: IconStyle(
                                iconData: Icons.done, color: Colors.white)),
                        endChild: Container(
                          margin: const EdgeInsets.all(6),
                          padding: const EdgeInsets.all(6),
                          decoration: BoxDecoration(color: Colors.brown[500]),
                          height: 200,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                  '${data_jadwalkuliah[index]['tgl_penjualan']}',
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                      fontSize: 18)),
                              Text('${data_jadwalkuliah[index]['nama_kasir']}',
                                  style: const TextStyle(color: Colors.white)),
                              Text('${data_jadwalkuliah[index]['nama_kopi']}',
                                  style: const TextStyle(color: Colors.white)),
                              Text('${data_jadwalkuliah[index]['jumlah_jual']}',
                                  style: const TextStyle(color: Colors.white))
                            ],
                          ),
                        ),
                      ),
                    );
                  })
            ],
          ),
        ),
      ),
    );
  }
}

//------------------------ AREA KONTEN JADWAL KULIAH ---------------------------
class HalJadwalKuliah extends StatefulWidget {
  const HalJadwalKuliah({super.key});
  @override
  State<HalJadwalKuliah> createState() => _HalJadwalKuliahState();
}

class _HalJadwalKuliahState extends State<HalJadwalKuliah> {
  //membuat variabel array untuk menampung data dari tabel jadwal kuliah
  List data_jadwalkuliah = [];
  List filter_jadwalkuliah = [];
  final pencarian_data = TextEditingController();
//membuat perintah untuk mengambil data mahasiswa dari database menggunakan RestFul API
  Future ambilDataJadwalKuliah() async {
    try {
      final tampil_jadwalkuliah = await http.get(Uri.parse(
          "http://localhost/mad_uas_app_api/tampil.php?aksi=tampil_jadwalkuliah"));
      if (tampil_jadwalkuliah.statusCode == 200) {
        final ambil_data_jadwalkuliah = jsonDecode(tampil_jadwalkuliah.body);
        setState(() {
          data_jadwalkuliah = ambil_data_jadwalkuliah;
          filter_jadwalkuliah = ambil_data_jadwalkuliah;
        });
      }
    } catch (e) {
      print(e);
    }
  }

  @override
  void initState() {
    super.initState();
    ambilDataJadwalKuliah();
  }

  @override
  void dispose() {
    pencarian_data.dispose();
    super.dispose();
  }

  void _onSearchTextChanged(String text) {
    setState(() {
      filter_jadwalkuliah = text.isEmpty
          ? data_jadwalkuliah
          : data_jadwalkuliah
              .where((jadwal_kuliah) =>
                  jadwal_kuliah['tgl_penjualan']
                      .toLowerCase()
                      .contains(text.toLowerCase()) ||
                  jadwal_kuliah['jabatan']
                      .toLowerCase()
                      .contains(text.toLowerCase()))
              .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: TextField(
            controller: pencarian_data,
            decoration: InputDecoration(
              hintText: 'Pencarian data ...',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(25),
              ),
            ),
            onChanged: _onSearchTextChanged,
          ),
        ),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: DataTable(
              columns: const [
                DataColumn(
                  label: Text(
                    'No.',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  numeric: true,
                ),
                DataColumn(
                  label: Text(
                    'Tgl Transaksi',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
                DataColumn(
                  label: Text(
                    'Kopi',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
                DataColumn(
                  label: Text(
                    'Nama Kasir',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
                DataColumn(
                  label: Text(
                    'Jumlah Jual',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
                DataColumn(
                  label: Text(
                    'Opsi',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
              ],
              rows: List.generate(filter_jadwalkuliah.length, (index) {
                final jadwal_kuliah = filter_jadwalkuliah[index];
                return DataRow(
                  cells: [
                    DataCell(Text("${index + 1}. ")),
                    DataCell(Text('${jadwal_kuliah['tgl_penjualan']}')),
                    DataCell(Text(jadwal_kuliah['nama_kopi'])),
                    DataCell(Text(jadwal_kuliah['nama_kasir'])),
                    DataCell(Text(jadwal_kuliah['jumlah_jual'])),
                    DataCell(ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                      ),
                      child: const Text(
                        "Hapus",
                        style: TextStyle(color: Colors.white),
                      ),
                      onPressed: () {
                        AwesomeDialog(
                          context: context,
                          dialogType: DialogType.warning,
                          animType: AnimType.topSlide,
                          showCloseIcon: true,
                          title: "Hapus Data",
                          desc: "Kamu yakin ingin menghapus data ? ",
                          btnCancelText: "Kembali",
                          btnOkText: "Oke, Lanjutkan",
                          btnCancelOnPress: () {},
                          btnOkOnPress: () {
                            hapusDataJadwalKuliah(
                                jadwal_kuliah['id_transaksi']);
                          },
                        ).show();
                      },
                    )),
                  ],
                );
              }),
            ),
          ),
        ),
      ],
    );
  }

//membuat perintah untuk menghapus data mahasiswa dari database menggunakan RestFul API
  Future hapusDataJadwalKuliah(String id_transaksi) async {
    final hapus_jadwalkuliah = await http.get(Uri.parse(
        "http://localhost/mad_uas_app_api/hapus.php?aksi=hapus_jadwalkuliah&id_transaksi=$id_transaksi"));
    final status_hapus_jadwalkuliah = jsonDecode(hapus_jadwalkuliah.body);
    print(status_hapus_jadwalkuliah["status_operasi"]);
    if (status_hapus_jadwalkuliah["status_operasi"] == 'Berhasil') {
      AnimatedSnackBar.material(
        'Hapus berhasil.',
        type: AnimatedSnackBarType.success,
        duration: const Duration(seconds: 1),
      ).show(context);
      Navigator.pushReplacement(
          context,
          MaterialPageRoute(
              builder: (BuildContext context) => HalLayout(halamanindex: 1)));
      ;
    } else {
      AnimatedSnackBar.material(
        'Hapus gagal.',
        type: AnimatedSnackBarType.warning,
        duration: const Duration(seconds: 1),
      ).show(context);
    }
  }
}

//------------------------- AREA KONTEN REKAP MAHASISWA ------------------------
class HalRekapMahasiswa extends StatefulWidget {
  const HalRekapMahasiswa({super.key});
  @override
  State<HalRekapMahasiswa> createState() => _HalRekapMahasiswaState();
}

class _HalRekapMahasiswaState extends State<HalRekapMahasiswa> {
//membuat variabel array untuk menampung data dari tabel mahasiswa
  List data_mahasiswa = [];
//membuat perintah untuk mengambil data mahasiswa dari database menggunakan RestFul API
  Future ambilDataMahasiswa() async {
    final tampil_mahasiswa = await http.get(Uri.parse(
        "http://localhost/mad_uas_app_api/tampil.php?aksi=tampil_mahasiswa&operasi=semua_data"));
    if (tampil_mahasiswa.statusCode == 200) {
      final ambil_data_mahasiswa = jsonDecode(tampil_mahasiswa.body);
      setState(() {
        data_mahasiswa = ambil_data_mahasiswa;
      });
    }
  }

  @override
  void initState() {
    super.initState();
//perintah untuk menjalankan fungsi ambil data dari database
    ambilDataMahasiswa();
  }

//membuat perintah untuk menghapus data mahasiswa dari database menggunakan RestFul API
  Future hapusDataMahasiswa(id_kopi) async {
    final hapus_mahasiswa = await http.get(Uri.parse(
        "http://localhost/mad_uas_app_api/hapus.php?aksi=hapus_mahasiswa&id_kopi=$id_kopi"));
    final status_hapus_mahasiswa = jsonDecode(hapus_mahasiswa.body);
    print(status_hapus_mahasiswa["status_operasi"]);
    if (status_hapus_mahasiswa["status_operasi"] == 'Berhasil') {
      AnimatedSnackBar.material(
        'Hapus berhasil.',
        type: AnimatedSnackBarType.success,
        duration: const Duration(seconds: 1),
      ).show(context);
      Navigator.pushReplacement(
          context,
          MaterialPageRoute(
              builder: (BuildContext context) => HalLayout(halamanindex: 2)));
    } else {
      AnimatedSnackBar.material(
        'Hapus gagal.',
        type: AnimatedSnackBarType.warning,
        duration: const Duration(seconds: 1),
      ).show(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(18.0),
        child: ListView.builder(
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
          itemCount: data_mahasiswa.length,
          itemBuilder: (context, index) {
            return Slidable(
              key: const ValueKey(0),
              startActionPane: ActionPane(
                motion: const ScrollMotion(),
                dismissible: DismissiblePane(onDismissed: () {}),
                children: [
                  SlidableAction(
                    onPressed: (BuildContext context) {
                      var id_kopi = data_mahasiswa[index]['id_kopi'];
                      hapusDataMahasiswa(id_kopi);
                    },
                    backgroundColor: const Color(0xFFFE4A49),
                    foregroundColor: Colors.white,
                    icon: Icons.delete,
                    label: 'Hapus',
                  ),
                ],
              ),
              endActionPane: ActionPane(
                motion: const ScrollMotion(),
                children: [
                  SlidableAction(
                    flex: 2,
                    onPressed: (BuildContext context) {
                      formEntriMahasiswa(
                        data_mahasiswa[index]['id_kopi'],
                        data_mahasiswa[index]['jenis_kopi'],
                        data_mahasiswa[index]['nama_kopi'],
                        data_mahasiswa[index]['harga_kopi'],
                      );
                    },
                    backgroundColor: const Color(0xFF7BC043),
                    foregroundColor: Colors.white,
                    icon: Icons.edit,
                    label: 'Ubah',
                  ),
                ],
              ),
              child: ListTile(
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 16,
                ),
                onTap: () {},
                leading: Text("${index + 1}. "),
                title: Text(
                  '${data_mahasiswa[index]['nama_kopi']}',
                  style: const TextStyle(fontSize: 20),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

//FORM ENTRI MAHASISWA
//membuat validasi form entri saat input data
  final _formKey = GlobalKey<FormState>();
  Future formEntriMahasiswa(vid_kopi, vjenis_kopi, vnama_kopi, vharga_kopi) {
//mendefinisikan field/kolom inputan mahasiswa
    var jenis_kopi = TextEditingController();
    var nama_kopi = TextEditingController();
    var harga_kopi = TextEditingController();
//perintah untuk menampilkan data dosen yang akan di ubah
    setState(() {
      jenis_kopi = TextEditingController(text: vjenis_kopi);
      nama_kopi = TextEditingController(text: vnama_kopi);
      harga_kopi = TextEditingController(text: vharga_kopi);
    });
//perintah untuk menyimpan data mahasiswa
    Future simpanMahasiswa() async {
      try {
        return await http.post(
          Uri.parse(
              "http://localhost/mad_uas_app_api/simpan.php?aksi=simpan_mahasiswa&operasi=ubah"),
          body: {
            "id_kopi": vid_kopi,
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
                              label: Text('Nama Kopi'),
                              hintText: 'Tulis Nama Kopi ...',
                              fillColor: Colors.white,
                              filled: true),
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Nama Kopi is Required!';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 10),
                        TextFormField(
                          controller: harga_kopi,
                          decoration: const InputDecoration(
                              label: Text('Harga'),
                              hintText: 'Tulis Nama Kopi ...',
                              fillColor: Colors.white,
                              filled: true),
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Nama Kopi is Required!';
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
}

//------------------------- AREA KONTEN REKAP DOSEN ----------------------------
class HalRekapDosen extends StatefulWidget {
  const HalRekapDosen({super.key});
  @override
  State<HalRekapDosen> createState() => _HalRekapDosenState();
}

class _HalRekapDosenState extends State<HalRekapDosen> {
//membuat variabel untuk menampung data dari tabel dosen
  List data_dosen = [];
//membuat perintah untuk mengambil data dosen dari database menggunakan RestFul API
  Future ambilDataDosen() async {
    final tampil_dosen = await http.get(Uri.parse(
        "http://localhost/mad_uas_app_api/tampil.php?aksi=tampil_dosen&operasi=semua_data"));
    if (tampil_dosen.statusCode == 200) {
      final ambil_data_dosen = jsonDecode(tampil_dosen.body);
      setState(() {
        data_dosen = ambil_data_dosen;
      });
    }
  }

  @override
  void initState() {
    super.initState();
//perintah untuk menjalankan fungsi ambil data dari database
    ambilDataDosen();
  }

//membuat perintah untuk menghapus data mahasiswa dari database menggunakan RestFul API
  Future hapusDataDosen(id_kasir) async {
    final hapus_dosen = await http.get(Uri.parse(
        "http://localhost/mad_uas_app_api/hapus.php?aksi=hapus_dosen&id_kasir=$id_kasir"));
    final status_hapus_dosen = jsonDecode(hapus_dosen.body);
    print(status_hapus_dosen["status_operasi"]);
    if (status_hapus_dosen["status_operasi"] == 'Berhasil') {
      AnimatedSnackBar.material(
        'Hapus berhasil.',
        type: AnimatedSnackBarType.success,
        duration: const Duration(seconds: 1),
      ).show(context);
      Navigator.pushReplacement(
          context,
          MaterialPageRoute(
              builder: (BuildContext context) => HalLayout(halamanindex: 3)));
      ;
    } else {
      AnimatedSnackBar.material(
        'Hapus gagal.',
        type: AnimatedSnackBarType.warning,
        duration: const Duration(seconds: 1),
      ).show(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.all(18.0),
        child: ListView.builder(
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
          itemCount: data_dosen.length,
          itemBuilder: (context, index) {
            return Slidable(
              key: const ValueKey(0),
              startActionPane: ActionPane(
                motion: const ScrollMotion(),
                dismissible: DismissiblePane(onDismissed: () {}),
                children: [
                  SlidableAction(
                    onPressed: (BuildContext context) {
                      var id_kasir = data_dosen[index]['id_kasir'];
                      hapusDataDosen(id_kasir);
                    },
                    backgroundColor: const Color(0xFFFE4A49),
                    foregroundColor: Colors.white,
                    icon: Icons.delete,
                    label: 'Hapus',
                  ),
                ],
              ),
              endActionPane: ActionPane(
                motion: const ScrollMotion(),
                children: [
                  SlidableAction(
                    flex: 2,
                    onPressed: (BuildContext context) {
                      formEntriDosen(
                          data_dosen[index]['id_kasir'],
                          data_dosen[index]['nama_kasir'],
                          data_dosen[index]['jabatan']);
                    },
                    backgroundColor: const Color(0xFF7BC043),
                    foregroundColor: Colors.white,
                    icon: Icons.edit,
                    label: 'Ubah',
                  ),
                ],
              ),
              child: ListTile(
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 16,
                ),
                onTap: () {},
                leading: Text("${index + 1}. "),
                title: Text(
                  '${data_dosen[index]['nama_kasir']}',
                  style: const TextStyle(fontSize: 20),
                ),
                subtitle: Text(
                  '${data_dosen[index]['jabatan']}',
                  style: const TextStyle(fontSize: 14),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

//FORM ENTRI DOSEN
//membuat validasi form entri saat input data
  final _formKey = GlobalKey<FormState>();
  Future formEntriDosen(vid_kasir, vnama_kasir, vjabatan) {
//mendefinisikan field/kolom inputan dosen
    var nama_kasir = TextEditingController();
    var jabatan = TextEditingController();
//perintah untuk menampilkan data dosen yang akan di ubah
    setState(() {
      nama_kasir = TextEditingController(text: vnama_kasir);
      jabatan = TextEditingController(text: vjabatan);
    });
//perintah untuk menyimpan data dosen
    Future simpanDosen() async {
      try {
        return await http.post(
          Uri.parse(
              "http://localhost/mad_uas_app_api/simpan.php?aksi=simpan_dosen&operasi=ubah"),
          body: {
            "id_kasir": vid_kasir,
            "nama_kasir": nama_kasir.text,
            "jabatan": jabatan.text,
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
                            hintText: "Tulis nama kasir ...",
                            fillColor: Colors.white,
                            filled: true),
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Nama kasir is Required!';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 10),
                      TextFormField(
                        controller: jabatan,
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
}
