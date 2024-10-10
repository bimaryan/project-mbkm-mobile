// DashboardScreen.dart
// ignore_for_file: library_private_types_in_public_api, prefer_const_constructors, prefer_const_literals_to_create_immutables, file_names

import 'package:flutter/material.dart';
import 'detail_bahan.dart'; // Import halaman detail bahan
import '../main.dart'; // Pastikan untuk mengimpor main.dart
import 'peminjaman.dart'; // Import halaman peminjaman
import 'informasi.dart'; // Import halaman informasi

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  _DashboardScreenState createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  int _selectedTabIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text('Dashboard'),
        backgroundColor: Colors.teal,
        actions: [
          PopupMenuButton<String>(
            onSelected: (value) {
              if (value == 'logout') {
                Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(builder: (context) => const LoginScreen()),
                  (Route<dynamic> route) => false,
                );
              }
            },
            itemBuilder: (BuildContext context) {
              return [
                const PopupMenuItem<String>(
                  value: 'logout',
                  child: Text('Logout'),
                ),
              ];
            },
            icon: const Icon(Icons.more_vert),
          ),
        ],
      ),
      body: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(16.0),
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/background_image.jpg'),
                fit: BoxFit.cover,
              ),
            ),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 40,
                  backgroundImage: AssetImage('assets/profile_background.jpg'),
                  backgroundColor: Colors.grey.shade200,
                ),
                const SizedBox(width: 16),
                const Text(
                  'BIMA RYAN HITAM PEKAT',
                  style: TextStyle(
                    fontSize: 22,
                    color: Color.fromARGB(255, 0, 0, 0),
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 10.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildTabItem('Alat', 0),
                _buildTabItem('Bahan', 1),
                _buildTabItem('lain-lain', 2),
              ],
            ),
          ),
          Expanded(
            child: GridView.builder(
              padding: EdgeInsets.all(10),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
                childAspectRatio: 0.75,
              ),
              itemBuilder: (context, index) {
                List<String> bahanList = [
                  "Bahan A",
                  "Bahan B",
                  "Bahan C",
                  "Bahan D",
                ];

                List<String> deskripsiList = [
                  "Deskripsi Bahan A: Digunakan untuk ...",
                  "Deskripsi Bahan B: Kegunaan dalam ...",
                  "Deskripsi Bahan C: Bahan kimia untuk ...",
                  "Deskripsi Bahan D: Alat bantu untuk ...",
                ];

                return _buildGridItem(
                  context,
                  bahanList[index % bahanList.length],
                  deskripsiList[index % deskripsiList.length],
                );
              },
              itemCount: 6,
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedTabIndex,
        onTap: (index) {
          if (index == 1) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => PeminjamanScreen(),
              ),
            );
          } else if (index == 2) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => InformasiScreen(),
              ),
            );
          }
          setState(() {
            _selectedTabIndex = index;
          });
        },
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Bahan & Alat',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.assignment),
            label: 'Peminjaman',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.info),
            label: 'Informasi',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Akun',
          ),
        ],
        selectedItemColor: Colors.teal,
        unselectedItemColor: Colors.teal,
        selectedLabelStyle: TextStyle(color: Colors.teal),
        unselectedLabelStyle: TextStyle(color: Colors.teal),
        showUnselectedLabels: true,
        type: BottomNavigationBarType.fixed,
      ),
    );
  }

  Widget _buildTabItem(String label, int index) {
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedTabIndex = index;
        });
      },
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 20.0),
        decoration: BoxDecoration(
          color:
              _selectedTabIndex == index ? Colors.teal : Colors.grey.shade200,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: _selectedTabIndex == index ? Colors.white : Colors.teal,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  Widget _buildGridItem(
      BuildContext context, String namaBahan, String deskripsiBahan) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => DetailBahanScreen(
              namaBahan: namaBahan,
              deskripsiBahan: deskripsiBahan,
            ),
          ),
        );
      },
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        elevation: 5,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                height: 80,
                width: 80,
                color: Colors.grey.shade300,
                child: Center(child: Text('GAMBAR')),
              ),
              const SizedBox(height: 10),
              Text(
                namaBahan,
                style: TextStyle(fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 5),
              Text(
                'status',
                style: TextStyle(color: Colors.green),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
