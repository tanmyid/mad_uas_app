import 'dart:async';
import 'package:animated_snack_bar/animated_snack_bar.dart';
import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:mad_uas_app/hal-pengguna/hal_layout.dart';
import 'package:mad_uas_app/hal_daftar_akun.dart';
import 'package:mad_uas_app/hal_utama.dart';

class HalMasuk extends StatefulWidget {
  const HalMasuk({super.key});
  @override
  State<HalMasuk> createState() => _HalMasukState();
}

class _HalMasukState extends State<HalMasuk> {
  final _formKey = GlobalKey<FormState>();
//mendefinisikan field/kolom inputan
  var username = TextEditingController();
  var password = TextEditingController();
  Future prosesLogin() async {
    try {
      return await http.post(
        Uri.parse(
            "http://localhost/mad_uas_app_api/autentifikasi.php?aksi=login"),
        body: {
          "username": username.text,
          "password": password.text,
        },
      ).then((value) {
//membuat variabel data untuk menyimpan data yang diambil dari database
        var data = jsonDecode(value.body);
//menampilkan pesan setelah menambahkan data ke database, kamu dapat menambah pesan ataunotifikasi di sini
        print(data["status_operasi"]);
        if (data["status_operasi"] == 'Berhasil') {
          AnimatedSnackBar.material(
            'Masuk berhasil.',
            type: AnimatedSnackBarType.success,
            duration: const Duration(seconds: 1),
          ).show(context);
          GetStorage.init();
          final box = GetStorage();
          final simpan_username_pengguna = data["username"];
          final simpan_password_pengguna = data["password"];
          final simpan_hakakses_pengguna = data["hak_akses"];
          box.write('simpan_username_pengguna', simpan_username_pengguna);
          box.write('simpan_password_pengguna', simpan_password_pengguna);
          box.write('simpan_hakakses_pengguna', simpan_hakakses_pengguna);
          Timer(const Duration(seconds: 2), () {
            Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                    builder: (context) => HalLayout(halamanindex: 0)));
          });
        } else {
          AnimatedSnackBar.material(
            'Masuk gagal.',
            type: AnimatedSnackBarType.warning,
            duration: const Duration(seconds: 1),
          ).show(context);
        }
      });
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
            onPressed: () {
              Navigator.pushReplacement(context,
                  MaterialPageRoute(builder: (context) => const HalUtama()));
            },
            icon: const Icon(
              Icons.arrow_back_ios,
              size: 20,
              color: Colors.black,
            )),
      ),
      body: SizedBox(
        height: MediaQuery.of(context).size.height,
        width: double.infinity,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Column(
              children: [
                const Text(
                  "Login",
                  style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
                ),
                const SizedBox(
                  height: 15,
                ),
                Text(
                  "Masukkan Username & Password",
                  style: TextStyle(fontSize: 15, color: Colors.grey[700]),
                )
              ],
            ),
            Container(
              height: MediaQuery.of(context).size.height / 2.5,
              decoration: const BoxDecoration(
                  image: DecorationImage(
                      image: AssetImage("assets/image-form/img-homepage.png"))),
            ),
            Column(
              children: [
                Form(
                  key: _formKey,
                  child: Container(
                    padding: const EdgeInsets.all(40.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 5),
                        TextFormField(
                          controller: username,
                          decoration: InputDecoration(
                              label: const Text('Username'),
                              hintText: "Tulis username ...",
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(50),
                              ),
                              fillColor: Colors.white,
                              filled: true),
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Username is Required!';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 10),
                        TextFormField(
                          controller: password,
                          decoration: InputDecoration(
                              label: const Text('Password'),
                              hintText: 'Tulis password ...',
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(50),
                              ),
                              fillColor: Colors.white,
                              filled: true),
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Password is Required!';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 15),
                        Container(
                          padding: const EdgeInsets.all(1),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(50),
                              border: const Border(
                                bottom: BorderSide(color: Colors.black),
                                top: BorderSide(color: Colors.black),
                                left: BorderSide(color: Colors.black),
                                right: BorderSide(color: Colors.black),
                              )),
                          child: MaterialButton(
                            minWidth: double.infinity,
                            height: 60,
                            color: Colors.brown,
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(50)),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: const [
                                Text(
                                  "M a s u k",
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 18,
                                      color: Colors.white),
                                ),
                                SizedBox(
                                  width: 10,
                                ),
                                Icon(
                                  Icons.login_rounded,
                                  color: Colors.white,
                                ),
                              ],
                            ),
                            onPressed: () {
//validasi
                              if (_formKey.currentState!.validate()) {
//menjalankan fungsi untuk kirim data ke database
                                prosesLogin();
                              }
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text("Belum memiliki akun ? "),
                GestureDetector(
                  onTap: () {
                    Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const HalDaftarAkun()));
                  },
                  child: const Text(
                    "Daftar Akun.",
                    style: TextStyle(
                        fontWeight: FontWeight.bold, color: Colors.blue),
                  ),
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}
