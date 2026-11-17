import 'package:flutter_test/flutter_test.dart';
import 'package:nusa_kas/data/repositories/transaksi_repository.dart';
import 'package:nusa_kas/domain/kas_calculator.dart';
import 'package:nusa_kas/domain/models/transaksi.dart';
import 'package:nusa_kas/ui/kas/kas_view_model.dart';

Transaksi item(String id, int nominal, JenisTransaksi jenis) => Transaksi(
      id: id,
      keterangan: id,
      nominal: nominal,
      jenis: jenis,
      tanggal: DateTime(2026, 1, 1),
    );

void main() {
  const calculator = KasCalculator();

  group('KasCalculator', () {
    test('saldo dari daftar kosong adalah nol', () {
      expect(calculator.hitungSaldo([]), 0);
    });

    test('total pemasukan dari daftar kosong adalah nol', () {
      expect(calculator.totalPemasukan([]), 0);
    });

    test('total pengeluaran dari daftar kosong adalah nol', () {
      expect(calculator.totalPengeluaran([]), 0);
    });

    test('menghitung satu pemasukan', () {
      expect(calculator.totalPemasukan([
        item('1', 100000, JenisTransaksi.pemasukan),
      ]), 100000);
    });

    test('menjumlahkan beberapa pemasukan', () {
      expect(calculator.totalPemasukan([
        item('1', 100000, JenisTransaksi.pemasukan),
        item('2', 50000, JenisTransaksi.pemasukan),
      ]), 150000);
    });

    test('menjumlahkan beberapa pengeluaran', () {
      expect(calculator.totalPengeluaran([
        item('1', 20000, JenisTransaksi.pengeluaran),
        item('2', 30000, JenisTransaksi.pengeluaran),
      ]), 50000);
    });

    test('menghitung saldo dari pemasukan dikurangi pengeluaran', () {
      final data = [
        item('1', 150000, JenisTransaksi.pemasukan),
        item('2', 40000, JenisTransaksi.pengeluaran),
      ];
      expect(calculator.hitungSaldo(data), 110000);
    });

    test('saldo dapat bernilai negatif jika data historis demikian', () {
      final data = [item('1', 25000, JenisTransaksi.pengeluaran)];
      expect(calculator.hitungSaldo(data), -25000);
    });
  });

  group('Aturan transaksi KasViewModel', () {
    test('menolak nominal nol', () {
      final vm = KasViewModel(repository: TransaksiRepository());
      expect(vm.tambahTransaksi(
        keterangan: 'Iuran', nominal: 0, jenis: JenisTransaksi.pemasukan,
      ), isNotNull);
      expect(vm.transaksi, isEmpty);
    });

    test('menolak nominal negatif', () {
      final vm = KasViewModel(repository: TransaksiRepository());
      expect(vm.tambahTransaksi(
        keterangan: 'Iuran', nominal: -1, jenis: JenisTransaksi.pemasukan,
      ), isNotNull);
      expect(vm.transaksi, isEmpty);
    });

    test('pengeluaran tepat sama dengan saldo diterima', () {
      final vm = KasViewModel(repository: TransaksiRepository());
      vm.tambahTransaksi(
        keterangan: 'Dana awal', nominal: 100000,
        jenis: JenisTransaksi.pemasukan,
      );
      expect(vm.tambahTransaksi(
        keterangan: 'Pembelian', nominal: 100000,
        jenis: JenisTransaksi.pengeluaran,
      ), isNull);
      expect(vm.saldo, 0);
    });

    test('menolak pengeluaran yang melebihi saldo', () {
      final vm = KasViewModel(repository: TransaksiRepository());
      vm.tambahTransaksi(
        keterangan: 'Dana awal', nominal: 100000,
        jenis: JenisTransaksi.pemasukan,
      );
      expect(vm.tambahTransaksi(
        keterangan: 'Pembelian', nominal: 100001,
        jenis: JenisTransaksi.pengeluaran,
      ), isNotNull);
      expect(vm.saldo, 100000);
    });
  });
}
