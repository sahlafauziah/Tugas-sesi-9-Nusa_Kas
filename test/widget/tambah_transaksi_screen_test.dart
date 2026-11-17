import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:nusa_kas/data/repositories/transaksi_repository.dart';
import 'package:nusa_kas/domain/models/transaksi.dart';
import 'package:nusa_kas/ui/kas/kas_view_model.dart';
import 'package:nusa_kas/ui/kas/tambah_transaksi_screen.dart';

void main() {
  late KasViewModel viewModel;

  setUp(() {
    viewModel = KasViewModel(repository: TransaksiRepository());
  });

  Widget buildSubject() => MaterialApp(
        home: TambahTransaksiScreen(viewModel: viewModel),
      );

  testWidgets('menampilkan kolom form dan tombol simpan', (tester) async {
    await tester.pumpWidget(buildSubject());

    expect(find.byKey(const Key('keteranganField')), findsOneWidget);
    expect(find.byKey(const Key('nominalField')), findsOneWidget);
    expect(find.byKey(const Key('jenisDropdown')), findsOneWidget);
    expect(find.byKey(const Key('simpanButton')), findsOneWidget);
  });

  testWidgets('validasi menampilkan pesan saat keterangan kosong', (tester) async {
    await tester.pumpWidget(buildSubject());

    await tester.tap(find.byKey(const Key('simpanButton')));
    await tester.pump();

    expect(find.text('Keterangan wajib diisi'), findsOneWidget);
    expect(viewModel.transaksi, isEmpty);
  });

  testWidgets('form valid berhasil menyimpan pemasukan', (tester) async {
    await tester.pumpWidget(buildSubject());

    await tester.enterText(
        find.byKey(const Key('keteranganField')), 'Iuran anggota');
    await tester.enterText(find.byKey(const Key('nominalField')), '50000');
    await tester.tap(find.byKey(const Key('simpanButton')));
    await tester.pumpAndSettle();

    expect(viewModel.transaksi, hasLength(1));
    expect(viewModel.transaksi.first.nominal, 50000);
    expect(viewModel.transaksi.first.jenis, JenisTransaksi.pemasukan);
  });
}
