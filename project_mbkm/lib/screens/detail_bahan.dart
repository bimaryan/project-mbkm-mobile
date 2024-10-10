import 'package:flutter/material.dart';

class DetailBahanScreen extends StatelessWidget {
  final String namaBahan;
  final String deskripsiBahan;

  const DetailBahanScreen({
    Key? key,
    required this.namaBahan,
    required this.deskripsiBahan,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(namaBahan),
        backgroundColor: Colors.teal,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Gambar bahan
            Container(
              height: 200,
              decoration: BoxDecoration(
                color: Colors.grey.shade300,
                borderRadius: BorderRadius.circular(15),
              ),
              child: const Center(child: Text('GAMBAR BAHAN')),
            ),
            const SizedBox(height: 20),
            const Text(
              'Detail Bahan',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Text(
              deskripsiBahan,
              style: const TextStyle(fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }
}
