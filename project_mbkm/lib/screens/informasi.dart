// informasi.dart
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
            padding: const EdgeInsets.all(8.0),
            child: Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              elevation: 5,
              child: ListTile(
                leading: ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: Container(
                    width: 60,
                    height: 60,
                    color: Colors.grey.shade300,
                    child: const Center(child: Text('Gambar')),
                  ),
                ),
                title: Text('Peminjaman ${index + 1}'),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Kelas: ${kelasList[index]}'),
                    const SizedBox(height: 4),
                    Text('Dosen: ${dosenList[index]}'),
                  ],
                ),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => InformasiPeminjamanScreen(
                        kelas: kelasList[index],
                        jurusan: jurusanList[index],
                        matakuliah: matakuliahList[index],
                        peralatan: peralatanList[index],
                        jumlahPeralatan: jumlahPeralatanList[index],
                        ruangLab: ruangLabList[index],
                        dosenPengampu: dosenList[index],
                      ),
                    ),
                  );
                },
              ),
            ),
          );
        },
      ),
    );
  }
}
