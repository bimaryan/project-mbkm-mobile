class Config {
  // Base URL for API
  static const String baseUrl =
      'http://192.168.1.8:8000/api';

  // Endpoints
  static const String katalogPeminjaman = '$baseUrl/katalog/peminjaman-barang';
  static const String peminjamanBarang = '$baseUrl/peminjaman';

  static String getKatalogPeminjamanBarang(String namaBarang) {
    return '$katalogPeminjaman/$namaBarang';
  }

  static String getPeminjamanEndpoint(String barangId, String stockId) {
    return '$peminjamanBarang/$barangId/$stockId';
  }
}
