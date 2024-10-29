import 'package:flutter/material.dart';
import 'edit_profil.dart'; // Import the edit_profil.dart file

class ProfilScreen extends StatelessWidget {
  const ProfilScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
        backgroundColor: Colors.teal, // Set AppBar color to teal
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const CircleAvatar(
              radius: 50,
              backgroundColor: Colors.grey,
              child: Icon(Icons.person, size: 50, color: Colors.white),
            ),
            const SizedBox(height: 20),
            const Text(
              'NAMA MAHASISWA',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            const Text(
              '2205000',
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 5),
            const Text(
              'Politeknik Negeri Indramayu',
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 30),
            ElevatedButton(
              onPressed: () {
                // Navigate to the edit profile screen
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const EditProfilScreen()),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green, // Button color
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
              child: const Padding(
                padding: EdgeInsets.symmetric(horizontal: 40, vertical: 10),
                child: Text(
                  'Edit Profile',
                  style: TextStyle(fontSize: 16),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
