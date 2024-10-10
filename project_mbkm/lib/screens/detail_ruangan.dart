import 'package:flutter/material.dart';

class DetailRuanganScreen extends StatelessWidget {
  final String namaRuangan;
  final String deskripsiRuangan;

  const DetailRuanganScreen({
    Key? key,
    required this.namaRuangan,
    required this.deskripsiRuangan,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(namaRuangan),
        backgroundColor: Colors.teal,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Gambar ruangan
            Container(
              height: 200,
              decoration: BoxDecoration(
                color: Colors.grey.shade300,
                borderRadius: BorderRadius.circular(15),
              ),
              child: const Center(child: Text('GAMBAR RUANGAN')),
            ),
            const SizedBox(height: 20),
            const Text(
              'Detail Ruangan',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Text(
              deskripsiRuangan,
              style: const TextStyle(fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }
}
