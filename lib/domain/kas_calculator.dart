import 'models/transaksi.dart';

class KasCalculator {
  const KasCalculator();

  int totalPemasukan(List<Transaksi> transaksi) {
    return transaksi
        .where((item) => item.jenis == JenisTransaksi.pemasukan)
        .fold(0, (total, item) => total + item.nominal);
  }

  int totalPengeluaran(List<Transaksi> transaksi) {
    return transaksi
        .where((item) => item.jenis == JenisTransaksi.pengeluaran)
        .fold(0, (total, item) => total + item.nominal);
  }

  int hitungSaldo(List<Transaksi> transaksi) {
    return totalPemasukan(transaksi) - totalPengeluaran(transaksi);
  }
}
