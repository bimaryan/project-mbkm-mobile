// ignore_for_file: unused_import, unused_local_variable

import 'package:flutter/material.dart';
import 'informasi_peminjaman.dart'; // Import informasi_peminjaman.dart

class InformasiScreen extends StatelessWidget {
  const InformasiScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Informasi'),
        backgroundColor: Colors.teal,
      ),
      body: ListView.builder(
        itemCount: 3, // Sesuaikan dengan jumlah item informasi
        itemBuilder: (context, index) {
          // Dummy data
          List<String> kelasList = ['Kelas 10', 'Kelas 11', 'Kelas 12'];
          List<String> jurusanList = ['IPA', 'IPS', 'Bahasa'];
          List<String> matakuliahList = [
            'Matematika',
            'Biologi',
            'Bahasa Inggris'
          ];
          List<String> peralatanList = ['Alat A', 'Alat B', 'Alat C'];
          List<String> jumlahPeralatanList = ['5', '10', '2'];
          List<String> ruangLabList = ['Lab 1', 'Lab 2', 'Lab 3'];
          List<String> dosenList = ['Bapak A', 'Ibu B', 'Bapak C'];

          return Padding(
            padding:
                const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
            child: Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              elevation: 5,
              child: Column(
                children: [
                  ListTile(
                    leading: ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: Container(
                        width: 60,
                        height: 60,
                        color: Colors.grey.shade300,
                        child: const Center(child: Text('Gambar')),
                      ),
                    ),
                    title: const Text('Perban'),
                    subtitle: const Text('1 barang'),
                    trailing: Chip(
                      label: const Text(
                        'Diproses',
                        style: TextStyle(color: Colors.white),
                      ),
                      backgroundColor: Colors.yellow.shade700,
                    ),
                  ),
                  const Divider(thickness: 1),
                  ExpansionTile(
                    title: const Text('Lihat Detail'),
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _buildDetailRow('NIM', '2205042'),
                            _buildDetailRow('Nama', 'Gustian Prayoga Januar'),
                            _buildDetailRow('Kelas', 'D4 RPL 3B'),
                            _buildDetailRow('Nama Dosen', 'Darish'),
                            _buildDetailRow('Mata Kuliah', 'Sistem Informasi'),
                            _buildDetailRow(
                                'Ruang Praktikum', 'Elektronik Dasar'),
                            _buildDetailRow('Waktu Peminjaman', '08.00 am'),
                            _buildDetailRow(
                                'Tanggal Peminjaman', '20 Oktober 2024'),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        },
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ElevatedButton(
          onPressed: () {
            // Aksi ketika tombol ditekan
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.teal,
            padding: const EdgeInsets.symmetric(vertical: 15),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
          child: const Text(
            'Ajukan Peminjaman',
            style: TextStyle(fontSize: 16),
          ),
        ),
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        children: [
          Text(
            '$label : ',
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          Text(value),
        ],
      ),
    );
  }
}
