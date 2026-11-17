# NusaKas

Aplikasi Flutter sederhana untuk mencatat pemasukan dan pengeluaran kas himpunan dengan tema ungu lilac.

## Fitur
- Ringkasan saldo, total pemasukan, dan total pengeluaran.
- Menambahkan transaksi pemasukan/pengeluaran.
- Validasi keterangan dan nominal.
- Menolak nominal nol/negatif dan pengeluaran melebihi saldo.
- Menghapus transaksi dengan menggeser item (Dismissible).
- Perhitungan dipisahkan pada `KasCalculator`.

## Struktur
- `lib/domain/`: model dan logika perhitungan.
- `lib/data/`: repository transaksi (penyimpanan sementara di memori).
- `lib/ui/`: halaman dan view model.
- `test/unit/`: unit test.
- `test/widget/`: widget test.
- `integration_test/`: integration test.

## Menjalankan aplikasi
```bash
flutter pub get
flutter run
```

## Menjalankan pengujian
```bash
flutter test
flutter test integration_test/app_test.dart
```

Integration test memerlukan emulator/HP Android yang aktif atau perangkat yang didukung Flutter. Perintah alternatif:
```bash
flutter test integration_test
```

## Screenshot untuk pengumpulan

Simpan screenshot asli dari aplikasi dan hasil pengujian ke folder `screenshots/`, lalu lengkapi daftar berikut dengan nama file yang sesuai.

| Bukti | File screenshot |
|---|---|
| Home Screen dengan ringkasan saldo | `screenshots/home_screen.png` |
| Tambah Transaksi Screen | `screenshots/tambah_transaksi.png` |
| Hasil `flutter test` | `screenshots/flutter_test.png` |
| Hasil integration test | `screenshots/integration_test.png` |

Screenshot belum disertakan karena harus diambil dari aplikasi dan perangkat pengujian yang benar-benar dijalankan. Jangan gunakan gambar contoh sebagai bukti test.

## GitHub
Buat repository GitHub bernama `nusa_kas`, kemudian jalankan:
```bash
git init
git add .
git commit -m "Initial commit - NusaKas"
git branch -M main
git remote add origin https://github.com/USERNAME/nusa_kas.git
git push -u origin main
```
Ganti `USERNAME` dengan username GitHub milikmu.
