// informasi_peminjaman.dart
import 'package:flutter/material.dart';

class InformasiPeminjamanScreen extends StatelessWidget {
  final String kelas;
  final String jurusan;
  final String matakuliah;
  final String peralatan;
  final String jumlahPeralatan;
  final String ruangLab;
  final String dosenPengampu;

  const InformasiPeminjamanScreen({
    Key? key,
    required this.kelas,
    required this.jurusan,
    required this.matakuliah,
    required this.peralatan,
    required this.jumlahPeralatan,
    required this.ruangLab,
    required this.dosenPengampu,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Informasi Peminjaman'),
        backgroundColor: Colors.teal,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          elevation: 5,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Detail Peminjaman',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.teal,
                  ),
                ),
                const SizedBox(height: 20),
                _buildDetailRow('Kelas:', kelas),
                _buildDetailRow('Jurusan/Prodi:', jurusan),
                _buildDetailRow('Matakuliah:', matakuliah),
                _buildDetailRow('Peralatan yang dibutuhkan:', peralatan),
                _buildDetailRow('Jumlah Peralatan:', jumlahPeralatan),
                _buildDetailRow('Ruang Lab:', ruangLab),
                _buildDetailRow('Dosen Pengampu:', dosenPengampu),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.teal),
                  child: const Text('Kembali'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          Text(value),
        ],
      ),
    );
  }
}
