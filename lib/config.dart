class Config {
  static const String baseUrl =
      'https://a3e9-2001-448a-3010-a982-8-d6f9-9213-1d2d.ngrok-free.app/api';

  static const String katalogPeminjaman = '$baseUrl/katalog/peminjaman-barang';
  static const String peminjamanBarang = '$baseUrl/peminjaman';

  static String getKatalogPeminjamanBarang(String namaBarang) {
    return '$katalogPeminjaman/$namaBarang';
  }

  static String getPeminjamanEndpoint(String barangId, String stockId) {
    return '$peminjamanBarang/$barangId/$stockId';
  }
}
