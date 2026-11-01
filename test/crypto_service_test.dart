import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:tugas03_crypto/models/cryptocurrency.dart';
import 'package:tugas03_crypto/services/crypto_service.dart';

void main() {
  test('Mengambil data dari endpoint dan mengurutkan berdasarkan rank', () async {
    final client = MockClient((request) async {
      expect(request.url.toString(), 'https://api.coinlore.net/api/tickers/');
      return http.Response('{"data":['
        '{"rank":2,"name":"Ethereum","symbol":"ETH","price_usd":"1720.54"},'
        '{"rank":1,"name":"Bitcoin","symbol":"BTC","price_usd":"27604.54"}'
        ']}', 200);
    });
    final service = CryptoService(client: client);
    addTearDown(service.dispose);
    final coins = await service.fetchCoins();
    expect(coins.first.rank, 1);
    expect(coins.first.name, 'Bitcoin');
    expect(coins.first.symbol, 'BTC');
    expect(coins.first.priceUsd, '27604.54');
    expect(coins.length, 2);
  });

  test('Harga koin kecil tetap memiliki presisi asli', () {
    final coin = Cryptocurrency.fromJson({
      'rank': '10', 'name': 'Contoh', 'symbol': 'TEST',
      'price_usd': '0.00000012',
    });
    expect(coin.priceUsd, '0.00000012');
  });

  test('Menolak field wajib yang hilang', () {
    expect(() => Cryptocurrency.fromJson({'rank': 1}), throwsFormatException);
  });

  test('Respons HTTP gagal menghasilkan exception', () async {
    final service = CryptoService(client: MockClient((_) async => http.Response('', 503)));
    addTearDown(service.dispose);
    await expectLater(service.fetchCoins(), throwsException);
  });

  test('Respons dengan struktur salah ditolak', () async {
    final service = CryptoService(client: MockClient((_) async => http.Response('{"data":{}}', 200)));
    addTearDown(service.dispose);
    await expectLater(service.fetchCoins(), throwsFormatException);
  });
}
