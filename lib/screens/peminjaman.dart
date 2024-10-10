// ignore_for_file: library_private_types_in_public_api

import 'package:flutter/material.dart';

class PeminjamanScreen extends StatefulWidget {
  const PeminjamanScreen({Key? key}) : super(key: key);

  @override
  _PeminjamanScreenState createState() => _PeminjamanScreenState();
}

class _PeminjamanScreenState extends State<PeminjamanScreen> {
  bool _acceptTerms = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Peminjaman'),
        backgroundColor: Colors.teal,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Note : * data wajib di isi.',
                style:
                    TextStyle(color: Colors.red, fontStyle: FontStyle.italic),
              ),
              const SizedBox(height: 20),
              _buildTextField('Kelas', 'Masukan Kelas'),
              const SizedBox(height: 10),
              _buildTextField('Jurusan/Prodi', 'Masukan Jurusan atau Prodi'),
              const SizedBox(height: 10),
              _buildTextField('Matakuliah', 'Masukan Matakuliah'),
              const SizedBox(height: 10),
              _buildTextField('Peralatan yang dibutuhkan', 'Masukan Peralatan'),
              const SizedBox(height: 10),
              _buildTextField('Jumlah Peralatan', 'Masukan Jumlah Peralatan'),
              const SizedBox(height: 10),
              _buildTextField('Ruang Lab', 'Masukan keperluan peminjaman'),
              const SizedBox(height: 10),
              _buildTextField('Dosen Pengampu', 'Masukan Nama Dosen Pengampu'),
              const SizedBox(height: 20),
              Row(
                children: [
                  Checkbox(
                    value: _acceptTerms,
                    onChanged: (value) {
                      setState(() {
                        _acceptTerms = value!;
                      });
                    },
                  ),
                  const Text('Syarat dan Ketentuan peminjaman barang')
                ],
              ),
              const SizedBox(height: 20),
              Center(
                child: ElevatedButton(
                  onPressed: () {
                    if (_acceptTerms) {
                      // Logic ketika tombol selesai ditekan dan syarat dipenuhi
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Pengajuan peminjaman berhasil!'),
                        ),
                      );
                    } else {
                      // Logic ketika syarat belum dicentang
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Harap setujui syarat dan ketentuan.'),
                        ),
                      );
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.teal,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 40, vertical: 15),
                  ),
                  child: const Text('Kirim'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(String label, String hint) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '$label *',
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 5),
        TextField(
          decoration: InputDecoration(
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(20), // Rounded corners
            ),
            hintText: hint,
            contentPadding:
                const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
          ),
        ),
      ],
    );
  }
}
