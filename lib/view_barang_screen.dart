import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:project_mbkm/routes.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'bottom_nav_bar.dart';

class ViewScreen extends StatefulWidget {
  final String namaBarang;

  const ViewScreen(
      {super.key, required String token, required this.namaBarang});

  @override
  _ViewScreenState createState() => _ViewScreenState();
}

class _ViewScreenState extends State<ViewScreen> {
  bool _isLoading = true;
  String? _errorMessage;
  Map<String, dynamic>? _barangData;

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

      final url = Uri.parse(
          'https://a32a-180-241-240-182.ngrok-free.app/api/katalog/peminjaman-barang/${widget.namaBarang}');
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
          _barangData = data['view'];
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
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _errorMessage != null
              ? Center(child: Text(_errorMessage!))
              : _barangData == null
                  ? const Center(child: Text('No data available'))
                  : SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Product Image
                          if (_barangData!['foto'] != null)
                            Image.network(
                              _barangData!['foto'],
                              height: 250,
                              width: double.infinity,
                              fit: BoxFit.cover,
                            ),
                          const SizedBox(height: 10),

                          Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 16.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  _barangData!['nama_barang'] ?? 'Unknown',
                                  style: const TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),

                          // Barang Details
                          Container(
                            color: Colors.white,
                            padding: const EdgeInsets.all(16.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                    'Kategori: ${_barangData!['kategori']?['kategori'] ?? 'Unknown'}'),
                                Text(
                                    'Satuan: ${_barangData!['satuan']?['satuan'] ?? 'Unknown'}'),
                                Text(
                                    'Kondisi: ${_barangData!['kondisi']?['kondisi'] ?? 'Unknown'}'),
                                Text(
                                    'Stock: ${_barangData!['stock']?['stock'] ?? 'Unknown'}'),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
      bottomNavigationBar: BottomNavBar(
        currentIndex: Routes.routeToIndex[Routes.katalog]!,
        onTap: (index) {
          setState(() {
            // Handle bottom navigation tap
          });
        },
      ),
    );
  }
}
