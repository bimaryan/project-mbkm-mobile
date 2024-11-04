import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:project_mbkm/config.dart';
import 'package:project_mbkm/routes.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'bottom_nav_bar.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key, required String token});

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  bool _isLoading = true;
  String? _errorMessage;
  Map<String, dynamic>? _mahasiswa;

  @override
  void initState() {
    super.initState();
    _fetchData();
  }

  Future<void> _fetchData() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('auth_token');

      if (token == null) {
        setState(() {
          _errorMessage = 'User is not authenticated.';
          _isLoading = false;
        });
        return;
      }

      final url = Uri.parse('${Config.baseUrl}/profile/');
      final response = await http.get(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        setState(() {
          _mahasiswa = data['mahasiswa'];
          _isLoading = false;
        });
      } else {
        setState(() {
          _errorMessage = 'Failed to fetch data: ${response.statusCode}';
          _isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        _errorMessage = 'An error occurred. Please try again.';
        _isLoading = false;
      });
    }
  }

  Future<void> _updateProfile(String? name, String? email, String? telepon,
      String? jenisKelamin) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('auth_token');
    final url = Uri.parse(
        '${Config.baseUrl}/profile/edit-profile/${_mahasiswa?['id']}');
    final response = await http.put(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode({
        'nama': name,
        'email': email,
        'telepon': telepon,
        'kelas_id': _mahasiswa?['kelas_id'], // Include the class ID
        'jenis_kelamin': jenisKelamin,
        // Add other fields if necessary
      }),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      setState(() {
        _mahasiswa = data['mahasiswa'];
        _errorMessage = null;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(data['message'])),
      );
    } else {
      setState(() {
        _errorMessage = 'Failed to update profile: ${response.statusCode}';
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to update profile')),
      );
    }
  }

  Future<void> _resetPassword(String? password, String? confirmPassword) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('auth_token');

    if (token == null || _mahasiswa == null) {
      setState(() {
        _errorMessage = 'User is not authenticated or profile data is missing.';
      });
      return;
    }

    final url = Uri.parse(
        '${Config.baseUrl}/profile/ubah-kata-sandi/${_mahasiswa!['id']}');
    final response = await http.put(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode({
        'password': password,
        'konfirmasi_password': confirmPassword,
      }),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(data['message'])),
      );
    } else {
      final error = jsonDecode(response.body)['error'];
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(error ?? 'Failed to reset password')),
      );
    }
  }

  Future<void> _logout() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('auth_token');
    final url = Uri.parse('${Config.baseUrl}/logout');

    final response = await http.get(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      prefs.remove('auth_token'); // Clear auth token
      Navigator.of(context)
          .pushReplacementNamed(Routes.login); // Navigate to login
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Logout berhasil')),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to logout')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Image.asset(
              'assets/images/polindra.png',
              width: 30,
              height: 30,
            ),
            const SizedBox(width: 8),
            const Text(
              'SILK',
              style: TextStyle(color: Colors.white),
            ),
          ],
        ),
        backgroundColor: const Color(0xFF0E9F6E),
        automaticallyImplyLeading: false,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _errorMessage != null
              ? Center(child: Text(_errorMessage!))
              : Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Profile Card
                      Card(
                        elevation: 2,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            children: [
                              // Profile Image
                              CircleAvatar(
                                radius: 40,
                                backgroundColor: Colors.grey[200],
                                backgroundImage: _mahasiswa?['foto'] != null
                                    ? NetworkImage(_mahasiswa!['foto'])
                                    : null,
                                child: _mahasiswa?['foto'] == null
                                    ? const Icon(
                                        Icons.person,
                                        size: 40,
                                        color: Colors.grey,
                                      )
                                    : null,
                              ),
                              const SizedBox(height: 16),
                              // Profile Information
                              Row(
                                children: [
                                  const Icon(Icons.person,
                                      color: Colors.blueAccent),
                                  const SizedBox(width: 10),
                                  Text(
                                    _mahasiswa?['nama'] ?? '',
                                    style: const TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 10),
                              Row(
                                children: [
                                  const Icon(Icons.email, color: Colors.green),
                                  const SizedBox(width: 10),
                                  Text(
                                    _mahasiswa?['email'] ?? '',
                                    style: const TextStyle(fontSize: 16),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 10),
                              Row(
                                children: [
                                  const Icon(Icons.school,
                                      color: Colors.orange),
                                  const SizedBox(width: 10),
                                  Text(
                                    '${_mahasiswa?['nim'] ?? ''}',
                                    style: const TextStyle(fontSize: 16),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 20),
                              // Edit Button
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  ElevatedButton.icon(
                                    onPressed: () {
                                      _showEditProfileModal(context);
                                    },
                                    icon: const Icon(Icons.edit),
                                    label: const Text('Edit Profile'),
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: const Color(0xFF0E9F6E),
                                      foregroundColor: Colors.white,
                                    ),
                                  ),
                                  ElevatedButton.icon(
                                    onPressed: () {
                                      _showResetPasswordModal(context);
                                    },
                                    icon: const Icon(Icons.lock_reset),
                                    label: const Text('Reset Password'),
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: const Color(0xFF0E9F6E),
                                      foregroundColor: Colors.white,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),
                      // Logout Button
                      ElevatedButton.icon(
                        onPressed: _logout,
                        icon: const Icon(Icons.logout),
                        label: const Text('Logout'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red,
                          foregroundColor: Colors.white,
                          minimumSize: const Size(double.infinity, 48),
                        ),
                      ),
                    ],
                  ),
                ),
      bottomNavigationBar: BottomNavBar(
        currentIndex: Routes.routeToIndex[Routes.profile]!,
        onTap: (index) {
          setState(() {});
        },
      ),
    );
  }

  void _showResetPasswordModal(BuildContext context) {
    final formKey = GlobalKey<FormState>();
    String? newPassword;
    String? confirmPassword;

    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Form(
              key: formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextFormField(
                    obscureText: true,
                    decoration:
                        const InputDecoration(labelText: 'New Password'),
                    validator: (value) => value == null || value.isEmpty
                        ? 'New password is required'
                        : null,
                    onChanged: (value) => newPassword = value,
                  ),
                  TextFormField(
                    obscureText: true,
                    decoration:
                        const InputDecoration(labelText: 'Confirm Password'),
                    validator: (value) =>
                        value != newPassword ? 'Passwords do not match' : null,
                    onChanged: (value) => confirmPassword = value,
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () async {
                      if (formKey.currentState!.validate()) {
                        await _resetPassword(newPassword, confirmPassword);
                        Navigator.of(context).pop();
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF0E9F6E),
                      foregroundColor: Colors.white,
                    ),
                    child: Text('Reset Password'),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  void _showEditProfileModal(BuildContext context) {
    final formKey = GlobalKey<FormState>();
    String? name = _mahasiswa?['nama'];
    String? email = _mahasiswa?['email'];
    String? telepon = _mahasiswa?['telepon'];
    String? jenisKelamin = _mahasiswa?['jenis_kelamin'];

    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Form(
              key: formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextFormField(
                    initialValue: name,
                    decoration: const InputDecoration(labelText: 'Nama'),
                    validator: (value) => value == null || value.isEmpty
                        ? 'Nama harus diisi'
                        : null,
                    onChanged: (value) => name = value,
                  ),
                  TextFormField(
                    initialValue: email,
                    decoration: const InputDecoration(labelText: 'Email'),
                    validator: (value) => value == null || value.isEmpty
                        ? 'Email harus diisi'
                        : null,
                    onChanged: (value) => email = value,
                  ),
                  TextFormField(
                    initialValue: telepon,
                    decoration:
                        const InputDecoration(labelText: 'Telepon (optional)'),
                    onChanged: (value) => telepon = value,
                  ),
                  DropdownButtonFormField<String>(
                    value: jenisKelamin,
                    items: const [
                      DropdownMenuItem(
                          value: "Laki-laki", child: Text("Laki-laki")),
                      DropdownMenuItem(
                          value: "Perempuan", child: Text("Perempuan")),
                    ],
                    onChanged: (value) => jenisKelamin = value,
                    decoration: const InputDecoration(
                        labelText: 'Jenis Kelamin (optional)'),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () async {
                      if (formKey.currentState!.validate()) {
                        await _updateProfile(
                            name, email, telepon, jenisKelamin);
                        Navigator.of(context).pop(); // Close the dialog
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF0E9F6E),
                      foregroundColor: Colors.white,
                    ),
                    child: Text('Simpan'),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
