import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:project_mbkm/routes.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'bottom_nav_bar.dart'; // Import the bottom nav bar

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key, required String token});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<dynamic> _barangs = [];
  bool _isLoading = true;
  String? _errorMessage;
  String _selectedCategory = 'Semua'; // Default category

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
      final token =
          prefs.getString('auth_token'); // Retrieve the token from storage

      if (token == null) {
        setState(() {
          _errorMessage = 'User is not authenticated.';
          _isLoading = false;
        });
        return;
      }

      final url = Uri.parse(
          'https://86ea-103-148-130-53.ngrok-free.app/api/home?kategori=$_selectedCategory'); // Include selected category in the URL
      final response = await http.get(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token', // Send the token in the header
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
    });
    _fetchData(); // Fetch data again with the new category
  }

  void _onBottomNavTapped(int index) {
    setState(() {
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('SILK',
            style: TextStyle(color: Colors.white)), // White text
        backgroundColor: const Color(0xFF0E9F6E), // Green background color
      ),
      body: Column(
        children: [
          // Category filter buttons
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: () => _filterBarangs('Semua'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _selectedCategory == 'Semua'
                        ? const Color.fromARGB(255, 14, 159, 110)
                        : Colors.white,
                    foregroundColor: _selectedCategory == 'Semua'
                        ? Colors.white // White text for selected button
                        : Colors.black, // Black text for unselected button
                  ),
                  child: Text('Semua'),
                ),
                const SizedBox(width: 10),
                ElevatedButton(
                  onPressed: () => _filterBarangs('Alat'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _selectedCategory == 'Alat'
                        ? const Color.fromARGB(255, 14, 159, 110)
                        : Colors.white,
                    foregroundColor: _selectedCategory == 'Alat'
                        ? Colors.white // White text for selected button
                        : Colors.black, // Black text for unselected button
                  ),
                  child: Text('Alat'),
                ),
                const SizedBox(width: 10),
                ElevatedButton(
                  onPressed: () => _filterBarangs('Bahan'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _selectedCategory == 'Bahan'
                        ? const Color.fromARGB(255, 14, 159, 110)
                        : Colors.white,
                    foregroundColor: _selectedCategory == 'Bahan'
                        ? Colors.white // White text for selected button
                        : Colors.black, // Black text for unselected button
                  ),
                  child: Text('Bahan'),
                ),
              ],
            ),
          ),
          // Displaying fetched data
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: _isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : _errorMessage != null
                      ? Center(child: Text(_errorMessage!))
                      : ListView.builder(
                          itemCount: _barangs.length,
                          itemBuilder: (context, index) {
                            final barang = _barangs[index];
                            return Card(
                              margin: const EdgeInsets.symmetric(vertical: 8.0),
                              child: ListTile(
                                leading: Image.network(
                                  barang['foto'] ?? '',
                                  width: 50,
                                  height: 50,
                                  fit: BoxFit.cover,
                                ),
                                title: Text(barang['nama_barang']),
                                subtitle: Text(
                                    'Stok: ${barang['stok']}\nKategori: ${barang['kategori']}'),
                              ),
                            );
                          },
                        ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomNavBar(
        currentIndex: Routes.routeToIndex[Routes.home]!,
        onTap: (index) {
          setState(() {
          });
        },
      ),
    );
  }
}
