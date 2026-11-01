/// Empat atribut yang diminta dalam soal.
class Cryptocurrency {
  final int rank;
  final String name;
  final String symbol;
  // Simpan teks asli agar harga sangat kecil tidak dibulatkan menjadi 0.00.
  final String priceUsd;

  const Cryptocurrency({
    required this.rank,
    required this.name,
    required this.symbol,
    required this.priceUsd,
  });

  factory Cryptocurrency.fromJson(Map<String, dynamic> json) {
    final rank = int.tryParse(json['rank'].toString());
    final name = json['name'];
    final symbol = json['symbol'];
    final price = json['price_usd']?.toString();
    final numericPrice = price == null ? null : double.tryParse(price);
    if (rank == null || rank < 1 || name is! String || name.isEmpty ||
        symbol is! String || symbol.isEmpty || numericPrice == null ||
        !numericPrice.isFinite || numericPrice < 0) {
      throw const FormatException('Data cryptocurrency tidak valid.');
    }
    return Cryptocurrency(
      rank: rank,
      name: name,
      symbol: symbol,
      priceUsd: price!,
    );
  }
}
