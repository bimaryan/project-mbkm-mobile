// ignore_for_file: file_names, duplicate_ignore, library_private_types_in_public_api

import 'package:flutter/material.dart';
import 'package:project_mbkm/main.dart';
import 'detail_bahan.dart';
import 'detail_alat.dart';
import 'detail_ruangan.dart';
import 'peminjaman.dart';
import 'informasi.dart';
import 'profil.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  _DashboardScreenState createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  int _selectedTabIndex = 0;
  int _bottomSelectedTabIndex = 0;
  final Map<String, int> itemQuantities = {};

  // Daftar item untuk setiap kategori
  final Map<String, List<Map<String, String>>> categories = {
    'Alat & Bahan': [
      {
        "name": "Perban",
        "stock": "Stok: 5",
        "image": 'assets/perban_image.jpg',
        "description": "Deskripsi Perban"
      },
      {
        "name": "Tensimeter",
        "stock": "Stok: 5",
        "image": 'assets/tensimeter_image.jpg',
        "description": "Deskripsi Tensimeter"
      },
      {
        "name": "Ruangan A",
        "stock": "Available",
        "image": 'assets/room_image_a.jpg',
        "description": "Deskripsi Ruangan A"
      },
    ],
    'Alat': [
      {
        "name": "Alat Bedah Minor",
        "stock": "Stok: 5",
        "image": 'assets/bedah_minor_image.jpg',
        "description": "Deskripsi Alat Bedah Minor"
      },
      {
        "name": "Stetoskop",
        "stock": "Stok: 5",
        "image": 'assets/stetoskop_image.jpg',
        "description": "Deskripsi Stetoskop"
      },
    ],
    'Bahan': [
      {
        "name": "Betadine",
        "stock": "Stok: 5",
        "image": 'assets/betadine_image.jpg',
        "description": "Deskripsi Betadine"
      },
      {
        "name": "Kapas Steril",
        "stock": "Stok: 5",
        "image": 'assets/kapas_steril_image.jpg',
        "description": "Deskripsi Kapas Steril"
      },
    ],
    'Lain-lain': [
      {
        "name": "Ruangan A",
        "stock": "Available",
        "image": 'assets/room_image_a.jpg',
        "description": "Deskripsi Ruangan A"
      },
      {
        "name": "Ruangan B",
        "stock": "Available",
        "image": 'assets/room_image_b.jpg',
        "description": "Deskripsi Ruangan B"
      },
    ]
  };

  @override
  void initState() {
    super.initState();
    // Inisialisasi jumlah untuk setiap item
    for (var category in categories.values) {
      for (var item in category) {
        itemQuantities[item['name']!] = 0; // Pastikan ini adalah integer
      }
    }
  }

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
          // Bagian profil
          Container(
            padding: const EdgeInsets.all(16.0),
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/background_image.jpg'),
                fit: BoxFit.cover,
              ),
            ),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 40,
                  backgroundColor: Colors.grey.shade200,
                  backgroundImage: const AssetImage(
                      'assets/profile_background.jpg'), // Gambar profil
                ),
                const SizedBox(width: 16),
                const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Gustian Prayoga Januar',
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                    Text(
                      '2205042', // Contoh user ID
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.black54,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          // Bagian Tab untuk kategori
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 10.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildTabItem('Alat & Bahan', 0),
                _buildTabItem('Alat', 1),
                _buildTabItem('Bahan', 2),
                _buildTabItem('Lain-lain', 3),
              ],
            ),
          ),

          // Daftar item yang akan ditampilkan
          Expanded(
            child: ListView.builder(
              itemCount: categories[getCurrentCategory()]?.length ?? 0,
              itemBuilder: (context, index) {
                final item = categories[getCurrentCategory()]![index];
                return _buildListItem(
                  context,
                  item['name']!,
                  item['stock']!,
                  item['image']!,
                  item['description']!,
                );
              },
            ),
          ),
        ],
      ),

      // Bottom navigation bar
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _bottomSelectedTabIndex,
        onTap: (index) {
          if (index == 1) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const PeminjamanScreen(),
              ),
            );
          } else if (index == 2) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const InformasiScreen(),
              ),
            );
          } else if (index == 3) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const ProfilScreen(),
              ),
            );
          }
          setState(() {
            _bottomSelectedTabIndex = index;
          });
        },
        items: const [
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
        showUnselectedLabels: true,
        type: BottomNavigationBarType.fixed,
      ),
    );
  }

  // Fungsi untuk membangun setiap tab
  Widget _buildTabItem(String label, int index) {
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedTabIndex = index;

          // Jika kategori 'Alat & Bahan' dipilih, reset ke index 0
          if (index == 0) {
            _bottomSelectedTabIndex = 0; // Kembali ke Alat & Bahan
          }
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 20.0),
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

  // Fungsi untuk membangun setiap item dalam list
  Widget _buildListItem(BuildContext context, String title, String stock,
      String imagePath, String description) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
      child: GestureDetector(
        onTap: () {
          final currentCategory = getCurrentCategory();

          // Navigasi ke detail item sesuai kategori
          if (currentCategory == 'Alat & Bahan') {
            if (categories['Alat']!.any((item) => item['name'] == title)) {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => DetailAlatScreen(
                    namaAlat: title,
                    deskripsiAlat: description,
                    imagePath: imagePath,
                  ),
                ),
              );
            } else if (categories['Bahan']!
                .any((item) => item['name'] == title)) {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => DetailBahanScreen(
                    namaBahan: title,
                    deskripsiBahan: description,
                    imagePath: imagePath,
                  ),
                ),
              );
            } else {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => DetailRuanganScreen(
                    namaRuangan: title,
                    deskripsiRuangan: description,
                    imagePath: imagePath,
                  ),
                ),
              );
            }
          } else if (currentCategory == 'Alat') {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => DetailAlatScreen(
                  namaAlat: title,
                  deskripsiAlat: description,
                  imagePath: imagePath,
                ),
              ),
            );
          } else if (currentCategory == 'Bahan') {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => DetailBahanScreen(
                  namaBahan: title,
                  deskripsiBahan: description,
                  imagePath: imagePath,
                ),
              ),
            );
          } else {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => DetailRuanganScreen(
                  namaRuangan: title,
                  deskripsiRuangan: description,
                  imagePath: imagePath,
                ),
              ),
            );
          }
        },
        child: Card(
          elevation: 3,
          margin: const EdgeInsets.symmetric(
              vertical: 8.0), // Menambahkan jarak antara item
          child: ListTile(
            leading: Image.asset(
              imagePath,
              width: 50,
              height: 50,
              fit: BoxFit.cover,
            ),
            title: Text(title),
            subtitle: Text(stock),
          ),
        ),
      ),
    );
  }

  // Fungsi untuk mendapatkan kategori saat ini
  String getCurrentCategory() {
    switch (_selectedTabIndex) {
      case 0:
        return 'Alat & Bahan';
      case 1:
        return 'Alat';
      case 2:
        return 'Bahan';
      case 3:
        return 'Lain-lain';
      default:
        return 'Alat & Bahan';
    }
  }
}
