import 'package:flutter/material.dart';

class DetailAlatScreen extends StatelessWidget {
  final String namaAlat;
  final String deskripsiAlat;

  const DetailAlatScreen({
    Key? key,
    required this.namaAlat,
    required this.deskripsiAlat,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(namaAlat),
        backgroundColor: Colors.teal,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Gambar alat
            Container(
              height: 200,
              decoration: BoxDecoration(
                color: Colors.grey.shade300,
                borderRadius: BorderRadius.circular(15),
              ),
              child: const Center(child: Text('GAMBAR ALAT')),
            ),
            const SizedBox(height: 20),
            const Text(
              'Detail Alat',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Text(
              deskripsiAlat,
              style: const TextStyle(fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }
}
