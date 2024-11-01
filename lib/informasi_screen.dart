import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:project_mbkm/routes.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'bottom_nav_bar.dart';
import 'package:intl/intl.dart';

class InformasScreen extends StatefulWidget {
  const InformasScreen({super.key, required String token});

  @override
  _InformasiScreenState createState() => _InformasiScreenState();
}

class _InformasiScreenState extends State<InformasScreen> {
  bool _isLoading = true;
  String? _errorMessage;
  List<dynamic> _peminjamanData = [];
  int _currentPage = 1;
  bool _hasMoreData = true;

  @override
  void initState() {
    super.initState();
    _fetchData(_currentPage);
  }

  Future<void> _fetchData(int page) async {
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
          'https://a32a-180-241-240-182.ngrok-free.app/api/informasi?page=$page');
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
          _peminjamanData.addAll(data['peminjaman']['data']);
          _isLoading = false;
          _hasMoreData = data['peminjaman']['next_page_url'] != null;
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

  void _loadMore() {
    if (_hasMoreData && !_isLoading) {
      setState(() {
        _currentPage++;
      });
      _fetchData(_currentPage);
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
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Center(
          child: _isLoading && _peminjamanData.isEmpty
              ? const CircularProgressIndicator()
              : _errorMessage != null
                  ? Center(child: Text(_errorMessage!))
                  : Column(
                      children: [
                        Expanded(
                          child: ListView.builder(
                            itemCount: _peminjamanData.length + 1,
                            itemBuilder: (context, index) {
                              if (index == _peminjamanData.length) {
                                return _hasMoreData
                                    ? Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Center(
                                          child: TextButton(
                                            onPressed: _loadMore,
                                            child: const Text(
                                              'Load More',
                                              style: TextStyle(
                                                  color: Color(0xFF0E9F6E)),
                                            ),
                                          ),
                                        ),
                                      )
                                    : const SizedBox();
                              }

                              final peminjaman = _peminjamanData[index];
                              return Card(
                                margin:
                                    const EdgeInsets.symmetric(vertical: 8.0),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                elevation: 4,
                                child: Padding(
                                  padding: const EdgeInsets.all(16.0),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        '${peminjaman['mahasiswa']['nama']}',
                                        style: const TextStyle(
                                            fontSize: 20,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      const SizedBox(height: 8),
                                      if (peminjaman['barang']['foto'] != null)
                                        Image.network(
                                          peminjaman['barang']['foto'],
                                          height: 100,
                                          width: double.infinity,
                                          fit: BoxFit.cover,
                                        ),
                                      const SizedBox(height: 8),
                                      Text(
                                        '${peminjaman['barang']['nama_barang']}',
                                        style: const TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      const SizedBox(height: 8),
                                      Text(
                                        'Tanggal Pinjam: ${DateTime.fromMillisecondsSinceEpoch(peminjaman['waktu_pinjam_unix'] * 1000).toLocal().toString().split(" ")[0]}',
                                        style: const TextStyle(fontSize: 14),
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        'Waktu Pinjam: ${DateFormat.Hm().format(DateTime.fromMillisecondsSinceEpoch(peminjaman['waktu_pinjam_unix'] * 1000).toLocal())}',
                                        style:
                                            const TextStyle(color: Colors.grey),
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        'Waktu Kembali: ${DateFormat.Hm().format(DateTime.fromMillisecondsSinceEpoch(peminjaman['waktu_kembali_unix'] * 1000).toLocal())}',
                                        style:
                                            const TextStyle(color: Colors.grey),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                      ],
                    ),
        ),
      ),
      bottomNavigationBar: BottomNavBar(
        currentIndex: Routes.routeToIndex[Routes.informasi]!,
        onTap: (index) {
          setState(() {});
        },
      ),
    );
  }
}
