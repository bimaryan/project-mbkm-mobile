import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:project_mbkm/config.dart';
import 'package:project_mbkm/routes.dart';
import 'package:project_mbkm/view_barang_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'bottom_nav_bar.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key, required String token});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<dynamic> _barangs = [];
  bool _isLoading = true;
  String? _errorMessage;
  String _selectedCategory = 'Semua';

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

      // Build the URL without pagination
      final url =
          Uri.parse('${Config.baseUrl}/home?kategori=$_selectedCategory');
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
          _barangs = data['barangs'];
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

  void _filterBarangs(String category) {
    setState(() {
      _selectedCategory = category;
      _barangs.clear();
    });
    _fetchData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Image.asset(
              'assets/images/polindra.png', // Update with your logo's file path
              width: 30, // Adjust the width of the logo
              height: 30, // Adjust the height of the logo
            ),
            const SizedBox(width: 8), // Space between logo and title
            const Text(
              'SILK',
              style: TextStyle(color: Colors.white),
            ),
          ],
        ),
        backgroundColor: const Color(0xFF0E9F6E),
        automaticallyImplyLeading: false,
      ),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                elevation: 4, // Adjust elevation for shadow effect
                child: Padding(
                  padding: const EdgeInsets.all(
                      16.0), // Internal padding for card content
                  child: Image.asset(
                    'assets/images/gedungGSC.jpg', // Path to the image in assets
                    fit: BoxFit.cover, // Adjust fit as needed
                  ),
                ),
              ),
            ),
            const SizedBox(height: 5),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _buildCategoryButton('Semua'),
                  const SizedBox(width: 10),
                  _buildCategoryButton('Alat'),
                  const SizedBox(width: 10),
                  _buildCategoryButton('Bahan'),
                ],
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: _isLoading
                    ? const Center(child: CircularProgressIndicator())
                    : _errorMessage != null
                        ? Center(child: Text(_errorMessage!))
                        : ListView.builder(
                            itemCount: _barangs.length,
                            itemBuilder: (context, index) {
                              final barang = _barangs[index];
                              return InkWell(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => ViewScreen(
                                        token: 'token',
                                        namaBarang: barang['nama_barang'],
                                      ),
                                    ),
                                  );
                                },
                                child: Card(
                                  margin:
                                      const EdgeInsets.symmetric(vertical: 8.0),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  elevation: 4,
                                  child: Padding(
                                    padding: const EdgeInsets.all(12.0),
                                    child: Row(
                                      children: [
                                        Image.network(
                                          barang['foto'] ?? '',
                                          width: 60,
                                          height: 60,
                                          fit: BoxFit.cover,
                                        ),
                                        const SizedBox(width: 10),
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                barang['nama_barang'],
                                                style: const TextStyle(
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                              const SizedBox(height: 4),
                                              Text(
                                                'Stok: ${barang['stok']}',
                                                style: const TextStyle(
                                                  color: Colors.grey,
                                                ),
                                              ),
                                              Text(
                                                'Kategori: ${barang['kategori']}',
                                                style: const TextStyle(
                                                  color: Colors.grey,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavBar(
        currentIndex: Routes.routeToIndex[Routes.home]!,
        onTap: (index) {
          setState(() {});
        },
      ),
    );
  }

  Widget _buildCategoryButton(String category) {
    return GestureDetector(
      onTap: () => _filterBarangs(category),
      child: Column(
        children: [
          Text(
            category,
            style: TextStyle(
              fontSize: 18, // Increase font size
              color: _selectedCategory == category
                  ? const Color(0xFF0E9F6E)
                  : Colors.black,
              fontWeight: _selectedCategory == category
                  ? FontWeight.bold
                  : FontWeight.normal,
            ),
          ),
          const SizedBox(height: 4),
          Container(
            height: 2,
            width: 50,
            color: _selectedCategory == category
                ? const Color(0xFF0E9F6E)
                : Colors.transparent,
          ),
        ],
      ),
    );
  }
}
