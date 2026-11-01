# Tugas 03 MSIM4401 - Flutter Cryptocurrency

Paket source code untuk aplikasi mobile sesuai contoh soal: tombol Refresh biru,
daftar kuning muda, dan empat atribut rank, name, symbol, price_usd dari CoinLore.

## Persiapan

- Flutter stable dengan Dart >= 3.3 dan < 4.0, Android SDK, serta emulator/HP Android.
- Android Studio atau VS Code dengan plugin Flutter/Dart.
- Internet untuk mengunduh dependency dan mengambil data.
- Jalankan `flutter doctor` dan selesaikan masalah Android toolchain.
- iOS memerlukan macOS, Xcode, dan simulator/perangkat iOS.

Paket ini berisi source aplikasi dan konfigurasi manifest, bukan APK atau seluruh
berkas native hasil generator. Berkas Gradle, wrapper, ikon, dan project Xcode
dibuat oleh Flutter SDK di komputer Anda melalui salah satu cara berikut.

## Cara A: otomatis (jika Python tersedia)

Ekstrak ZIP, buka terminal pada folder `tugas03_flutter`, lalu jalankan:

```sh
python siapkan_proyek.py
cd ../tugas03_crypto
flutter analyze
flutter test
flutter run
```

Pada macOS/Linux perintah Python dapat berupa `python3`. Script membuat folder
baru `tugas03_crypto` di sebelah folder paket. Folder yang sudah ada tidak ditimpa.
Jika muncul beberapa perangkat, pilih emulator/HP Android atau jalankan
`flutter devices` dan `flutter run -d ID_PERANGKAT`.

## Cara B: manual (tanpa Python)

1. Di lokasi kerja pilihan Anda, jalankan:

```sh
flutter create --platforms=android,ios --project-name tugas03_crypto tugas03_crypto
```

2. Dari paket ini, salin folder `lib/`, folder `test/`, dan `pubspec.yaml` ke proyek
   baru. Ganti seluruh folder `lib` dan `test` bawaan agar contoh test counter
   Flutter tidak ikut dijalankan.
3. Ganti `android/app/src/main/AndroidManifest.xml` proyek baru dengan manifest
   yang disertakan pada lokasi yang sama dalam paket.
4. Masuk ke proyek baru dan jalankan:

```sh
cd tugas03_crypto
flutter pub get
flutter analyze
flutter test
flutter run
```

## Menghasilkan APK

Setelah berhasil dijalankan pada Android:

```sh
flutter build apk --release
```

Hasil di `build/app/outputs/flutter-apk/app-release.apk` dalam proyek yang dibuat.
Manifest utama sudah menyertakan permission INTERNET agar versi release bisa
mengakses API. Tidak perlu API key atau mengaktifkan cleartext HTTP karena HTTPS.

## Perilaku aplikasi

- Data dimuat saat halaman pertama kali dibuka.
- Tombol Refresh dan tarik daftar ke bawah mengambil ulang data.
- Tombol dinonaktifkan selama pemuatan untuk mencegah request bersamaan.
- Pesan ditampilkan ketika jaringan gagal, timeout, format tidak valid, atau data kosong.
- Bila refresh gagal, daftar sebelumnya dipertahankan dan diberi keterangan.
- Harga menggunakan string asli API agar harga sangat kecil tidak menjadi 0.00.
- Daftar dapat digulir. Endpoint tanpa parameter mengembalikan halaman pertama,
  maksimum 100 koin; aplikasi ini tidak memuat seluruh koin secara pagination.
- Urutan dan harga mengikuti respons API terbaru, sehingga dapat berbeda dari PDF.

## Berkas untuk tugas

`PENJELASAN.md` berisi penjelasan setiap file, alur program, dan langkah demonstrasi.
`SOURCE_CODE.txt` memuat source sebagai teks untuk memudahkan penyalinan ke laporan.
Tambahkan identitas mahasiswa dan screenshot aplikasi yang benar-benar Anda jalankan.

## Status pemeriksaan

Struktur paket, sintaks Python, dan XML manifest diperiksa saat penyusunan.
Flutter/Dart SDK tidak tersedia di lingkungan penyusunan, sehingga `flutter analyze`,
`flutter test`, build APK, dan pengujian tampilan pada perangkat BELUM dijalankan.
Lima test service/model disertakan untuk dijalankan setelah proyek disiapkan;
respons pada test adalah data contoh, sedangkan aplikasi memakai API online.

## Referensi

- Soal: Tugas_03.pdf, MSIM4401, Tugas 03.
- https://docs.flutter.dev/cookbook/networking/fetch-data
- https://www.coinlore.com/cryptocurrency-data-api
- https://api.coinlore.net/api/tickers/
