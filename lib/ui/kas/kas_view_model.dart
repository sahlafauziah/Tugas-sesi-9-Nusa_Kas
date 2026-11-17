import 'package:flutter/foundation.dart';

import '../../data/repositories/transaksi_repository.dart';
import '../../domain/kas_calculator.dart';
import '../../domain/models/transaksi.dart';

class KasViewModel extends ChangeNotifier {
  KasViewModel({
    required TransaksiRepository repository,
    KasCalculator calculator = const KasCalculator(),
  })  : _repository = repository,
        _calculator = calculator;

  final TransaksiRepository _repository;
  final KasCalculator _calculator;

  List<Transaksi> get transaksi => _repository.getAll();
  int get totalPemasukan => _calculator.totalPemasukan(transaksi);
  int get totalPengeluaran => _calculator.totalPengeluaran(transaksi);
  int get saldo => _calculator.hitungSaldo(transaksi);

  String? tambahTransaksi({
    required String keterangan,
    required int nominal,
    required JenisTransaksi jenis,
  }) {
    if (keterangan.trim().isEmpty) return 'Keterangan wajib diisi.';
    if (nominal <= 0) return 'Nominal harus lebih dari nol.';
    if (jenis == JenisTransaksi.pengeluaran && nominal > saldo) {
      return 'Pengeluaran melebihi saldo yang tersedia.';
    }

    _repository.tambah(
      Transaksi(
        id: DateTime.now().microsecondsSinceEpoch.toString(),
        keterangan: keterangan.trim(),
        nominal: nominal,
        jenis: jenis,
        tanggal: DateTime.now(),
      ),
    );
    notifyListeners();
    return null;
  }

  void hapusTransaksi(String id) {
    _repository.hapus(id);
    notifyListeners();
  }
}
