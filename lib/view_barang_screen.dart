import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'config.dart';

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

  // Form fields
  final TextEditingController _stockPinjamController = TextEditingController();
  final TextEditingController _tglPinjamController = TextEditingController();
  final TextEditingController _waktuPinjamController = TextEditingController();
  final TextEditingController _waktuKembaliController = TextEditingController();
  final TextEditingController _keteranganController = TextEditingController();

  String? _selectedRuangan;
  String? _selectedMatkul;
  String? _selectedDosen;

  List<Map<String, String>> ruanganOptions = [];
  List<Map<String, String>> matkulOptions = [];
  List<Map<String, String>> dosenOptions = [];

  @override
  void initState() {
    super.initState();
    _fetchData();
  }

  Future<void> _fetchData() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('auth_token');

      final response = await http.get(
        Uri.parse(Config.getKatalogPeminjamanBarang(widget.namaBarang)),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        _barangData = data['view'];

        // Populate dropdown options
        ruanganOptions = (data['ruangan'] as List)
            .map((e) => {
                  'id': e['id'].toString(),
                  'nama_ruangan': e['nama_ruangan'].toString()
                })
            .toList();
        matkulOptions = (data['matkul'] as List)
            .map((e) => {
                  'id': e['id'].toString(),
                  'mata_kuliah': e['mata_kuliah'].toString()
                })
            .toList();
        dosenOptions = (data['dosen'] as List)
            .map((e) => {
                  'id': e['id'].toString(),
                  'nama_dosen': e['nama_dosen'].toString()
                })
            .toList();
      } else {
        _errorMessage = json.decode(response.body)['error'] ?? 'Unknown error';
      }
    } catch (e) {
      _errorMessage = 'Error: $e';
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _submitBorrowing() async {
    if (_selectedRuangan == null ||
        _selectedMatkul == null ||
        _selectedDosen == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select all fields')),
      );
      return;
    }

    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString('auth_token');
      String? mahasiswaId = prefs.getString('mahasiswa_id');

      if (_barangData == null) {
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Barang data not available')));
        return;
      }

      // Ambil ID yang benar dari _barangData
      final String stockId = _barangData!['stock']['id'].toString();
      final String barangId = _barangData!['id'].toString();

      // Log URL untuk verifikasi
      final url = Config.getPeminjamanEndpoint(barangId, stockId);

      final response = await http.post(
        Uri.parse(url),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
        body: json.encode({
          'mahasiswa_id': mahasiswaId,
          'ruangan_id': _selectedRuangan,
          'matkul_id': _selectedMatkul,
          'dosen_id': _selectedDosen,
          'stock_pinjam': _stockPinjamController.text,
          'tgl_pinjam': _tglPinjamController.text,
          'waktu_pinjam': _waktuPinjamController.text,
          'waktu_kembali': _waktuKembaliController.text,
          'keterangan': _keteranganController.text,
        }),
      );

      final data = json.decode(response.body);
      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text(data['message'])));
        Navigator.pop(context);
      } else {
        _showErrorDialog(data['error'] ?? 'Unknown error');
      }
    } catch (e) {
      _showErrorDialog('Error: $e');
    }
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Error'),
          content: Text(message),
          actions: <Widget>[
            TextButton(
              child: const Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  Widget _buildDetailCard(String value) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        value,
        style: const TextStyle(fontSize: 12),
      ),
    );
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
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
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
                            const SizedBox(height: 16),

                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                  child: Row(
                                    children: [
                                      _buildDetailCard(_barangData!['kategori']
                                              ?['kategori'] ??
                                          'Unknown'),
                                      const SizedBox(width: 8),
                                      _buildDetailCard(_barangData!['satuan']
                                              ?['satuan'] ??
                                          'Unknown'),
                                      const SizedBox(width: 8),
                                      _buildDetailCard(_barangData!['kondisi']
                                              ?['kondisi'] ??
                                          'Unknown'),
                                      const SizedBox(width: 8),
                                      _buildDetailCard(_barangData!['stock']
                                              ?['stock'] ??
                                          'Unknown'),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 16),

                            // Product Name
                            Text(
                              _barangData!['nama_barang'] ?? 'Unknown',
                              style: const TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 16),

                            DropdownButtonFormField<String>(
                              value: _selectedRuangan,
                              decoration:
                                  const InputDecoration(labelText: 'Ruangan'),
                              items: ruanganOptions.map((option) {
                                return DropdownMenuItem<String>(
                                  value: option['id'],
                                  child: Text(option['nama_ruangan']!),
                                );
                              }).toList(),
                              onChanged: (value) {
                                setState(() {
                                  _selectedRuangan = value;
                                });
                              },
                            ),
                            DropdownButtonFormField<String>(
                              value: _selectedMatkul,
                              decoration: const InputDecoration(
                                  labelText: 'Mata Kuliah'),
                              items: matkulOptions.map((option) {
                                return DropdownMenuItem<String>(
                                  value: option['id'],
                                  child: Text(option['mata_kuliah']!),
                                );
                              }).toList(),
                              onChanged: (value) {
                                setState(() {
                                  _selectedMatkul = value;
                                });
                              },
                            ),
                            DropdownButtonFormField<String>(
                              value: _selectedDosen,
                              decoration:
                                  const InputDecoration(labelText: 'Dosen'),
                              items: dosenOptions.map((option) {
                                return DropdownMenuItem<String>(
                                  value: option['id'],
                                  child: Text(option['nama_dosen']!),
                                );
                              }).toList(),
                              onChanged: (value) {
                                setState(() {
                                  _selectedDosen = value;
                                });
                              },
                            ),

                            // Form Fields
                            TextField(
                              controller: _stockPinjamController,
                              decoration: const InputDecoration(
                                labelText: 'Stock Pinjam',
                              ),
                            ),
                            TextField(
                              controller: _tglPinjamController,
                              decoration: const InputDecoration(
                                  labelText: 'Tanggal Pinjam'),
                              readOnly: true,
                              onTap: () async {
                                DateTime? pickedDate = await showDatePicker(
                                  context: context,
                                  initialDate: DateTime.now(),
                                  firstDate: DateTime.now(),
                                  lastDate: DateTime(2100),
                                );
                                if (pickedDate != null) {
                                  setState(() {
                                    _tglPinjamController.text =
                                        "${pickedDate.toLocal()}".split(' ')[0];
                                  });
                                }
                              },
                            ),
                            TextField(
                              controller: _waktuPinjamController,
                              decoration: const InputDecoration(
                                  labelText: 'Waktu Pinjam'),
                              readOnly: true,
                              onTap: () async {
                                TimeOfDay? pickedTime = await showTimePicker(
                                  context: context,
                                  initialTime: TimeOfDay.now(),
                                );
                                if (pickedTime != null) {
                                  setState(() {
                                    _waktuPinjamController.text =
                                        pickedTime.format(context);
                                  });
                                }
                              },
                            ),
                            TextField(
                              controller: _waktuKembaliController,
                              decoration: const InputDecoration(
                                  labelText: 'Waktu Kembali'),
                              readOnly: true,
                              onTap: () async {
                                TimeOfDay? pickedTime = await showTimePicker(
                                  context: context,
                                  initialTime: TimeOfDay.now(),
                                );
                                if (pickedTime != null) {
                                  setState(() {
                                    _waktuKembaliController.text =
                                        pickedTime.format(context);
                                  });
                                }
                              },
                            ),
                            TextField(
                              controller: _keteranganController,
                              decoration: const InputDecoration(
                                labelText: 'Keterangan',
                              ),
                            ),

                            const SizedBox(height: 20),

                            ElevatedButton(
                              onPressed: _submitBorrowing,
                              child: const Text('Pinjam Barang'),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFF0E9F6E),
                                foregroundColor: Colors.white,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
    );
  }
}
