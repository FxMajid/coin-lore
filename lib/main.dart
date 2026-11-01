import 'package:flutter/material.dart';
import 'screens/crypto_page.dart';

void main() => runApp(const CryptoApp());

class CryptoApp extends StatelessWidget {
  const CryptoApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Data Cryptocurrency',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF0055DD)),
        useMaterial3: true,
        scaffoldBackgroundColor: Colors.white,
      ),
      home: const CryptoPage(),
    );
  }
}
