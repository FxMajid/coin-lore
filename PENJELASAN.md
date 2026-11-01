# Penjelasan Tugas 03 MSIM4401

## Identitas

Nama: ____________________
NIM: _____________________
Kelas: ___________________

## Tujuan

Membuat aplikasi Flutter yang mengambil data cryptocurrency dari API online
https://api.coinlore.net/api/tickers/ dan menampilkan rank, name, symbol,
dan price_usd. Tampilan mengikuti contoh soal berupa tombol Refresh dan daftar
kuning muda dengan tiga bagian: peringkat, nama/simbol, dan harga USD.

## Penjelasan file

| File | Fungsi |
| --- | --- |
| `pubspec.yaml` | Identitas proyek, batas versi Dart, dependency Flutter dan paket `http` untuk HTTP GET. |
| `lib/main.dart` | Titik masuk `main()`, menjalankan `CryptoApp`, mengatur tema dan halaman utama. |
| `lib/models/cryptocurrency.dart` | Model empat atribut dan factory `fromJson()` untuk validasi serta konversi JSON ke objek Dart. Field JSON `price_usd` dipetakan menjadi `priceUsd`. |
| `lib/services/crypto_service.dart` | Mengirim GET ke CoinLore, batas tunggu 20 detik, memeriksa status HTTP dan struktur JSON, serta mengurutkan koin berdasarkan rank. |
| `lib/screens/crypto_page.dart` | Memuat data di `initState`, mengatur state pemuatan/error/data, tombol Refresh, tarik untuk refresh, dan daftar `ListView.builder`. |
| `android/app/src/main/AndroidManifest.xml` | Konfigurasi aplikasi Android dan izin INTERNET pada manifest utama, termasuk untuk build release. |
| `test/crypto_service_test.dart` | Menguji endpoint/pemetaan/urutan data, presisi harga kecil, field hilang, HTTP gagal, dan struktur respons salah memakai respons tiruan. |
| `siapkan_proyek.py` | Membuat platform Android/iOS menggunakan Flutter SDK lalu menyalin source paket ke proyek baru. Ini alat persiapan, bukan kode runtime aplikasi. |

## Alur pengambilan data

1. `main()` memanggil `runApp()` untuk menampilkan `CryptoApp`.
2. Halaman `CryptoPage` dibuat. `initState()` memanggil `_loadCoins()`.
3. `_loadCoins()` mengaktifkan indikator pemuatan dan memanggil `fetchCoins()`.
4. Service mengirim HTTP GET ke endpoint API. `await` menunggu respons secara asinkron.
5. Jika HTTP 200, `jsonDecode()` mengubah JSON menjadi struktur data Dart.
6. Array pada key `data` dipetakan menjadi daftar objek `Cryptocurrency`.
7. Setelah halaman dipastikan masih aktif dengan `mounted`, `setState()` menyimpan
   hasil agar Flutter memperbarui tampilan.
8. `ListView.builder` membuat baris sesuai jumlah data. `Row` dan `Expanded`
   membagi lebar layar untuk rank, nama/simbol, dan harga USD.
9. Tombol Refresh menjalankan proses yang sama untuk memperbarui daftar.

Contoh pemetaan (ilustrasi, bukan harga saat ini):

```json
{"rank":1,"name":"Bitcoin","symbol":"BTC","price_usd":"27604.54"}
```

Pada layar ditampilkan Rank 1, Bitcoin, BTC, dan USD 27604.54. Harga disimpan
sebagai teks mengikuti respons API untuk mempertahankan angka desimal aslinya.

## Penanganan kondisi khusus

`try/catch/finally` memastikan indikator pemuatan berhenti setelah request selesai,
baik berhasil maupun gagal. Timeout dan format JSON salah memiliki pesan khusus.
Kesalahan lainnya menampilkan pesan untuk memeriksa koneksi. Data lama tetap
terlihat jika refresh gagal. `mounted` mencegah pembaruan state setelah halaman
ditutup. HTTP client ditutup melalui `dispose()`.

## Langkah demonstrasi dan screenshot

1. Siapkan proyek mengikuti README dan jalankan pada emulator/HP Android.
2. Tunjukkan tombol Refresh dan daftar cryptocurrency setelah data berhasil dimuat.
3. Jelaskan posisi rank, name, symbol, dan price_usd pada satu baris.
4. Tekan Refresh untuk menunjukkan pengambilan ulang dari API.
5. Gulir daftar untuk menunjukkan item lain.
6. Putuskan internet lalu tekan Refresh untuk mengamati pesan gagal; sambungkan
   kembali internet dan tekan Refresh untuk memulihkan pemuatan.
7. Ambil screenshot hasil nyata dan tambahkan ke laporan. Harga dapat sama saat
   refresh jika data API belum berubah.

## Batasan dan validasi

Aplikasi menampilkan halaman pertama dari endpoint sesuai alamat soal, maksimal
100 koin per request. Memuat semua koin membutuhkan pagination yang belum
ditambahkan pada implementasi ini. Tidak ada data harga contoh yang digunakan
oleh aplikasi; data contoh hanya ada dalam pengujian dan penjelasan.

Flutter SDK tidak tersedia saat penyusunan paket ini. Analisis Dart, lima test,
build APK, dan tampilan perangkat belum diverifikasi dengan Flutter. Jalankan
`flutter analyze`, `flutter test`, dan `flutter run` sesuai README sebelum
mengumpulkan tugas, lalu lengkapi laporan dengan hasil pengujian Anda.

## Referensi

- Tugas_03.pdf, Tugas Praktikum MSIM4401, Tugas 03.
- Flutter: https://docs.flutter.dev/cookbook/networking/fetch-data
- CoinLore: https://www.coinlore.com/cryptocurrency-data-api
