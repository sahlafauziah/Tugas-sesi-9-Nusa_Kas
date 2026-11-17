import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:flutter/material.dart';
import 'package:nusa_kas/main.dart';
import 'package:nusa_kas/data/repositories/transaksi_repository.dart';
import 'package:nusa_kas/ui/kas/kas_view_model.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('menambah dua transaksi dan saldo terhitung benar',
      (tester) async {
    final viewModel = KasViewModel(repository: TransaksiRepository());
    await tester.pumpWidget(NusaKasApp(viewModel: viewModel));
    await tester.pumpAndSettle();

    // Transaksi pertama: pemasukan Rp100.000.
    await tester.tap(find.byKey(const Key('tambahTransaksiButton')));
    await tester.pumpAndSettle();
    await tester.enterText(
        find.byKey(const Key('keteranganField')), 'Iuran anggota');
    await tester.enterText(find.byKey(const Key('nominalField')), '100000');
    await tester.tap(find.byKey(const Key('simpanButton')));
    await tester.pumpAndSettle();

    expect(find.text('Rp100.000'), findsWidgets);

    // Transaksi kedua: pengeluaran Rp25.000.
    await tester.tap(find.byKey(const Key('tambahTransaksiButton')));
    await tester.pumpAndSettle();
    await tester.enterText(
        find.byKey(const Key('keteranganField')), 'Beli perlengkapan');
    await tester.enterText(find.byKey(const Key('nominalField')), '25000');
    await tester.tap(find.byKey(const Key('jenisDropdown')));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Pengeluaran').last);
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const Key('simpanButton')));
    await tester.pumpAndSettle();

    expect(viewModel.transaksi, hasLength(2));
    expect(viewModel.saldo, 75000);
    expect(find.byKey(const Key('saldoValue')), findsOneWidget);
    expect(find.text('Rp75.000'), findsOneWidget);
  });
}
