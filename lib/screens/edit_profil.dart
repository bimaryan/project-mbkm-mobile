// edit_profil.dart
// ignore_for_file: library_private_types_in_public_api

import 'package:flutter/material.dart';

class EditProfilScreen extends StatefulWidget {
  const EditProfilScreen({super.key});

  @override
  _EditProfilScreenState createState() => _EditProfilScreenState();
}

class _EditProfilScreenState extends State<EditProfilScreen> {
  final _namaController = TextEditingController();
  final _kelasController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _teleponController = TextEditingController();
  bool _isObscured = true;

  @override
  void initState() {
    super.initState();
    // Initialize controllers with default values (you can set them dynamically if needed)
    _namaController.text = "Nama Mahasiswa";
    _kelasController.text = "Kelas";
    _emailController.text = "emailmahasiswa@polindra.ac.id";
    _passwordController.text = "password";
    _teleponController.text = "08123456789";
  }

  @override
  void dispose() {
    _namaController.dispose();
    _kelasController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _teleponController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Edit Profile"),
        backgroundColor: Colors.white,
        elevation: 1,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Stack(
              children: [
                CircleAvatar(
                  radius: 60,
                  backgroundColor: Colors.grey.shade200,
                  child: const Icon(
                    Icons.person,
                    size: 60,
                    color: Colors.grey,
                  ),
                ),
                Positioned(
                  bottom: 0,
                  right: 10,
                  child: IconButton(
                    icon: const Icon(Icons.camera_alt, size: 30),
                    onPressed: () {
                      // Logic for editing profile image goes here
                    },
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            _buildTextField("Nama Lengkap", _namaController),
            const SizedBox(height: 10),
            _buildTextField("Kelas", _kelasController),
            const SizedBox(height: 10),
            _buildTextField("Email", _emailController),
            const SizedBox(height: 10),
            _buildPasswordField("Kata Sandi", _passwordController),
            const SizedBox(height: 10),
            _buildTextField("Nomor Telepon", _teleponController),
            const SizedBox(height: 30),
            ElevatedButton(
              onPressed: () {
                // Logic to save profile details
                _saveProfile();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.teal,
                padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 30),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
              ),
              child: const Text(
                "Simpan Profile",
                style: TextStyle(fontSize: 18),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // TextField builder for consistent styling
  Widget _buildTextField(String labelText, TextEditingController controller) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        labelText: labelText,
        labelStyle: const TextStyle(color: Colors.teal),
        enabledBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: Colors.teal),
          borderRadius: BorderRadius.circular(10.0),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: Colors.teal, width: 2.0),
          borderRadius: BorderRadius.circular(10.0),
        ),
      ),
    );
  }

  // Password TextField with toggle visibility
  Widget _buildPasswordField(
      String labelText, TextEditingController controller) {
    return TextField(
      controller: controller,
      obscureText: _isObscured,
      decoration: InputDecoration(
        labelText: labelText,
        labelStyle: const TextStyle(color: Colors.teal),
        enabledBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: Colors.teal),
          borderRadius: BorderRadius.circular(10.0),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: Colors.teal, width: 2.0),
          borderRadius: BorderRadius.circular(10.0),
        ),
        suffixIcon: IconButton(
          icon: Icon(
            _isObscured ? Icons.visibility_off : Icons.visibility,
            color: Colors.grey,
          ),
          onPressed: () {
            setState(() {
              _isObscured = !_isObscured;
            });
          },
        ),
      ),
    );
  }

  // Simulate save profile action
  void _saveProfile() {
    // Implement the logic to save the profile (e.g., to a database or API)
    // For now, just show a dialog with the entered details
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Profile Saved"),
          content: Text(
              "Nama: ${_namaController.text}\nKelas: ${_kelasController.text}\nEmail: ${_emailController.text}\nTelepon: ${_teleponController.text}"),
          actions: [
            TextButton(
              child: const Text("OK"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
