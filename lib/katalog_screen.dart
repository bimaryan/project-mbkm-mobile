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
  String _selectedCategory = 'Semua';
  int _currentPage = 1;
  bool _hasMoreData = true;

  @override
  void initState() {
    super.initState();
    _fetchData();
  }

  Future<void> _fetchData() async {
    if (!_hasMoreData) return;

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
          'https://e6c7-182-0-248-96.ngrok-free.app/api/home?kategori=$_selectedCategory');
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

  void _nextPage() {
    if (_hasMoreData) {
      setState(() {
        _currentPage++; // Increase the page number
      });
      _fetchData(); // Fetch data for the next page
    }
  }

  void _prevPage() {
    if (_currentPage > 1) {
      setState(() {
        _currentPage--; // Decrease the page number
      });
      _fetchData(); // Fetch data for the previous page
    }
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
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.all(16.0),
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
              ],
            ),
          ),
          // Displaying fetched data
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
                            return Card(
                              margin: const EdgeInsets.symmetric(vertical: 8.0),
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
                            );
                          },
                        ),
            ),
          ),

          // Page navigation and current page indicator
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ElevatedButton(
                  onPressed: _prevPage,
                  child: const Text('Prev'),
                ),
                Text(
                  'Page $_currentPage',
                  style: const TextStyle(fontSize: 16),
                ),
                ElevatedButton(
                  onPressed: _nextPage,
                  child: const Text('Next'),
                ),
              ],
            ),
          ),
        ],
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

  Widget _buildCategoryButton(String category) {
    return GestureDetector(
      onTap: () => _filterBarangs(category),
      child: Column(
        children: [
          Text(
            category,
            style: TextStyle(
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
