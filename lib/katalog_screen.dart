import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:project_mbkm/routes.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'bottom_nav_bar.dart';

class KatalogScreen extends StatefulWidget {
  const KatalogScreen({super.key, required String token});

  @override
  _KatalogScreenState createState() => _KatalogScreenState();
}

class _KatalogScreenState extends State<KatalogScreen> {
  final List<dynamic> _barangs = [];
  bool _isLoading = true;
  String? _errorMessage;
  String _selectedCategory = 'Semua'; // Default category
  int _currentPage = 1; // Current page for pagination
  bool _hasMoreData = true; // To track if more data is available

  @override
  void initState() {
    super.initState();
    _fetchData();
  }

  Future<void> _fetchData() async {
    if (!_hasMoreData) return; // Prevent fetching if no more data

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
          'https://86ea-103-148-130-53.ngrok-free.app/api/katalog?kategori=$_selectedCategory&page=$_currentPage');
      final response = await http.get(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token', // Send the token in the header
        },
      );

      print('Status code: ${response.statusCode}');
      print('Response body: ${response.body}');

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        setState(() {
          _barangs.addAll(data['barangs']);
          _isLoading = false;
          _hasMoreData =
              data['barangs'].length == 6; // Check if more data exists
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
      _currentPage = 1; // Reset to the first page
      _barangs.clear(); // Clear the existing data for fresh fetch
      _hasMoreData = true; // Reset pagination
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
        title: const Text('SILK', style: TextStyle(color: Colors.white)),
        backgroundColor: const Color(0xFF0E9F6E),
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
                        ? Colors.white
                        : Colors.black,
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
                        ? Colors.white
                        : Colors.black,
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
                        ? Colors.white
                        : Colors.black,
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
          if (_hasMoreData) // Show a loading indicator if there's more data to fetch
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: ElevatedButton(
                onPressed: () {
                  setState(() {
                    _currentPage++; // Increase the page number
                  });
                  _fetchData(); // Fetch data for the next page
                },
                child: const Text('Load More'),
              ),
            ),
        ],
      ),
      bottomNavigationBar: BottomNavBar(
        currentIndex: Routes.routeToIndex[Routes.katalog]!,
        onTap: (index) {
          setState(() {
          });
        },
      ),
    );
  }
}
