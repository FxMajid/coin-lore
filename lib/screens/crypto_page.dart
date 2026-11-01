import 'dart:async';
import 'package:flutter/material.dart';
import '../models/cryptocurrency.dart';
import '../services/crypto_service.dart';

class CryptoPage extends StatefulWidget {
  const CryptoPage({super.key});

  @override
  State<CryptoPage> createState() => _CryptoPageState();
}

class _CryptoPageState extends State<CryptoPage> {
  final _service = CryptoService();
  List<Cryptocurrency> _coins = [];
  bool _loading = false;
  String? _error;

  @override
  void initState() {
    super.initState();
    _loadCoins();
  }

  Future<void> _loadCoins() async {
    if (_loading) return;
    setState(() {
      _loading = true;
      _error = null;
    });
    try {
      final coins = await _service.fetchCoins();
      if (!mounted) return;
      setState(() => _coins = coins);
    } on TimeoutException {
      if (!mounted) return;
      setState(() => _error = 'Waktu koneksi habis. Silakan coba lagi.');
    } on FormatException {
      if (!mounted) return;
      setState(() => _error = 'Format data API tidak dapat dibaca.');
    } catch (_) {
      if (!mounted) return;
      setState(() => _error = 'Gagal memuat data. Periksa internet, lalu tekan Refresh.');
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  void dispose() {
    _service.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 600),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(12),
                  child: ElevatedButton(
                    onPressed: _loading ? null : _loadCoins,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF0055DD),
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5),
                      ),
                    ),
                    child: Text(_loading ? 'Memuat...' : 'Refresh'),
                  ),
                ),
                if (_loading) const LinearProgressIndicator(),
                if (_error != null)
                  Padding(
                    padding: const EdgeInsets.all(12),
                    child: Text(_error!, style: const TextStyle(color: Colors.red)),
                  ),
                if (_error != null && _coins.isNotEmpty)
                  const Padding(
                    padding: EdgeInsets.only(bottom: 8),
                    child: Text('Menampilkan data terakhir yang berhasil dimuat.'),
                  ),
                Expanded(child: _buildList()),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildList() {
    if (_coins.isEmpty) {
      return Center(
        child: Text(_loading ? 'Mengambil data CoinLore...' :
          (_error == null ? 'Belum ada data cryptocurrency.' : 'Tekan Refresh untuk mencoba lagi.')),
      );
    }
    return RefreshIndicator(
      onRefresh: _loadCoins,
      child: ListView.builder(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.symmetric(horizontal: 8),
        itemCount: _coins.length,
        itemBuilder: (context, index) => _CoinRow(coin: _coins[index]),
      ),
    );
  }
}

class _CoinRow extends StatelessWidget {
  final Cryptocurrency coin;
  const _CoinRow({required this.coin});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
      decoration: const BoxDecoration(
        color: Color(0xFFFFF2CC),
        border: Border(bottom: BorderSide(color: Color(0xFFD6B656))),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(flex: 2, child: _field('Rank', coin.rank.toString())),
          const SizedBox(width: 8),
          Expanded(flex: 4, child: _field(coin.name, coin.symbol)),
          const SizedBox(width: 8),
          Expanded(flex: 5, child: _field('USD', coin.priceUsd)),
        ],
      ),
    );
  }

  Widget _field(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontSize: 12)),
        const SizedBox(height: 3),
        Text(value, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w500)),
      ],
    );
  }
}
