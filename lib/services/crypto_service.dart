import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/cryptocurrency.dart';

class CryptoService {
  static final endpoint = Uri.parse('https://api.coinlore.net/api/tickers/');
  final http.Client _client;

  CryptoService({http.Client? client}) : _client = client ?? http.Client();

  Future<List<Cryptocurrency>> fetchCoins() async {
    final response = await _client.get(endpoint).timeout(
      const Duration(seconds: 20),
    );
    if (response.statusCode != 200) {
      throw Exception('Server mengembalikan HTTP ${response.statusCode}.');
    }
    final decoded = jsonDecode(response.body);
    if (decoded is! Map<String, dynamic> || decoded['data'] is! List) {
      throw const FormatException('Format respons API tidak sesuai.');
    }
    final coins = (decoded['data'] as List).map((item) {
      if (item is! Map<String, dynamic>) {
        throw const FormatException('Format item API tidak sesuai.');
      }
      return Cryptocurrency.fromJson(item);
    }).toList();
    coins.sort((a, b) => a.rank.compareTo(b.rank));
    return coins;
  }

  void dispose() => _client.close();
}
