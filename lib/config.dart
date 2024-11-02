class Config {
  static const String baseUrl =
      'https://c360-182-0-102-56.ngrok-free.app/api';

  static const String katalogPeminjaman = '$baseUrl/katalog/peminjaman-barang';
  static const String peminjamanBarang = '$baseUrl/peminjaman';

  static String getKatalogPeminjamanBarang(String namaBarang) {
    return '$katalogPeminjaman/$namaBarang';
  }

  static String getPeminjamanEndpoint(String barangId, String stockId) {
    return '$peminjamanBarang/$barangId/$stockId';
  }
}
