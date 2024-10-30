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

      // Build the URL with pagination
      final url = Uri.parse(
          'https://e6c7-182-0-248-96.ngrok-free.app/api/home?kategori=$_selectedCategory&page=$_currentPage');
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
          // Add new items to _barangs
          _barangs.addAll(data['barangs']);
          _isLoading = false;
          // Update _hasMoreData if the fetched data size matches our limit (6)
          _hasMoreData = data['barangs'].length == 6;
          if (_hasMoreData) {
            _currentPage++; // Increment page if more data is available
          }
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
      _currentPage = 1;
      _barangs.clear();
      _hasMoreData = true;
    });
    _fetchData();
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
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: _isLoading && _barangs.isEmpty
                  ? const Center(child: CircularProgressIndicator())
                  : _errorMessage != null
                      ? Center(child: Text(_errorMessage!))
                      : Column(
                          children: [
                            Expanded(
                              child: ListView.builder(
                                itemCount: _barangs.length + 1,
                                itemBuilder: (context, index) {
                                  if (index == _barangs.length) {
                                    return _hasMoreData
                                        ? Center(
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      vertical: 8.0),
                                              child:
                                                  CircularProgressIndicator(),
                                            ),
                                          )
                                        : SizedBox.shrink();
                                  }
                                  final barang = _barangs[index];
                                  return Card(
                                    margin: const EdgeInsets.symmetric(
                                        vertical: 8.0),
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
                            if (_hasMoreData && !_isLoading) // Load more button
                              TextButton(
                                onPressed: _fetchData,
                                child: const Text('Load More'),
                              ),
                          ],
                        ),
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
              fontSize: 18,
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
