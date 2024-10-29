// ignore_for_file: no_leading_underscores_for_local_identifiers, use_key_in_widget_constructors

import 'package:flutter/material.dart';

class DetailBahanScreen extends StatelessWidget {
  final String namaBahan;
  final String deskripsiBahan;
  final String imagePath;

  const DetailBahanScreen({
    required this.namaBahan,
    required this.deskripsiBahan,
    required this.imagePath,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(namaBahan),
        backgroundColor: Colors.teal, // Change the AppBar color to teal
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: Image.asset(imagePath, fit: BoxFit.cover),
                ),
              ),
              const SizedBox(height: 16),
              Text(
                namaBahan,
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                deskripsiBahan,
                style: const TextStyle(
                  fontSize: 16,
                  height: 1.5,
                ),
                textAlign: TextAlign.justify,
              ),
              const SizedBox(height: 20),
              _buildFormPeminjaman(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFormPeminjaman(BuildContext context) {
    bool _acceptTerms = false;
    return StatefulBuilder(builder: (context, setState) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Note : * data wajib di isi.',
            style: TextStyle(color: Colors.red, fontStyle: FontStyle.italic),
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
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Pengajuan peminjaman berhasil!'),
                    ),
                  );
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Harap setujui syarat dan ketentuan.'),
                    ),
                  );
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.teal,
                padding:
                    const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
              ),
              child: const Text('Kirim'),
            ),
          ),
        ],
      );
    });
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
