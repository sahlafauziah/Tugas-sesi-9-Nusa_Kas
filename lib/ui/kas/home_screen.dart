import 'package:flutter/material.dart';

import '../../domain/models/transaksi.dart';
import 'kas_view_model.dart';
import 'tambah_transaksi_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key, required this.viewModel});

  final KasViewModel viewModel;

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String rupiah(int value) {
    final digits = value.abs().toString();
    final buffer = StringBuffer();
    for (var i = 0; i < digits.length; i++) {
      buffer.write(digits[i]);
      final remaining = digits.length - i - 1;
      if (remaining > 0 && remaining % 3 == 0) buffer.write('.');
    }
    return '${value < 0 ? '-' : ''}Rp${buffer.toString()}';
  }

  String tanggal(DateTime date) =>
      '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}';

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: widget.viewModel,
      builder: (context, _) {
        final vm = widget.viewModel;
        return Scaffold(
          appBar: AppBar(
            title: const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('NusaKas', style: TextStyle(fontWeight: FontWeight.w800)),
                Text('Catatan kas himpunan',
                    style: TextStyle(fontSize: 12, color: Color(0xFF817895))),
              ],
            ),
            actions: [
              Padding(
                padding: const EdgeInsets.only(right: 16),
                child: CircleAvatar(
                  backgroundColor: const Color(0xFFECE5FA),
                  child: Icon(Icons.account_balance_wallet_outlined,
                      color: Theme.of(context).colorScheme.primary),
                ),
              ),
            ],
          ),
          body: SafeArea(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(18, 12, 18, 8),
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(22),
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [Color(0xFF9B83D2), Color(0xFF7458B5)],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(24),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('Saldo kas saat ini',
                            style: TextStyle(color: Colors.white70)),
                        const SizedBox(height: 8),
                        Text(rupiah(vm.saldo), key: const Key('saldoValue'),
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 30,
                              fontWeight: FontWeight.w800,
                            )),
                        const SizedBox(height: 18),
                        Row(
                          children: [
                            Expanded(child: _summary('Pemasukan', vm.totalPemasukan,
                                Icons.south_west, const Color(0xFFD9F6E8))),
                            const SizedBox(width: 12),
                            Expanded(child: _summary('Pengeluaran', vm.totalPengeluaran,
                                Icons.north_east, const Color(0xFFFFE1E8))),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 14, 20, 10),
                  child: Row(
                    children: [
                      const Expanded(
                        child: Text('Riwayat transaksi',
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.w800)),
                      ),
                      Text('${vm.transaksi.length} transaksi',
                          style: const TextStyle(color: Color(0xFF817895))),
                    ],
                  ),
                ),
                Expanded(
                  child: vm.transaksi.isEmpty
                      ? const Center(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(Icons.receipt_long_outlined,
                                  size: 48, color: Color(0xFFB8A9D7)),
                              SizedBox(height: 10),
                              Text('Belum ada transaksi',
                                  style: TextStyle(
                                      color: Color(0xFF817895),
                                      fontWeight: FontWeight.w600)),
                              Text('Tambahkan transaksi pertamamu.',
                                  style: TextStyle(color: Color(0xFF9A91A9))),
                            ],
                          ),
                        )
                      : ListView.builder(
                          padding: const EdgeInsets.fromLTRB(16, 0, 16, 90),
                          itemCount: vm.transaksi.length,
                          itemBuilder: (context, index) {
                            final item = vm.transaksi[index];
                            final masuk = item.jenis == JenisTransaksi.pemasukan;
                            return Dismissible(
                              key: ValueKey(item.id),
                              direction: DismissDirection.endToStart,
                              background: Container(
                                margin: const EdgeInsets.only(bottom: 10),
                                alignment: Alignment.centerRight,
                                padding: const EdgeInsets.only(right: 22),
                                decoration: BoxDecoration(
                                  color: const Color(0xFFFFE4E9),
                                  borderRadius: BorderRadius.circular(18),
                                ),
                                child: const Icon(Icons.delete_outline,
                                    color: Color(0xFFC64D69)),
                              ),
                              onDismissed: (_) {
                                vm.hapusTransaksi(item.id);
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(content: Text('Transaksi dihapus')),
                                );
                              },
                              child: Card(
                                margin: const EdgeInsets.only(bottom: 10),
                                child: ListTile(
                                  contentPadding: const EdgeInsets.symmetric(
                                      horizontal: 15, vertical: 5),
                                  leading: CircleAvatar(
                                    backgroundColor: masuk
                                        ? const Color(0xFFE0F5EA)
                                        : const Color(0xFFFFE8ED),
                                    child: Icon(
                                      masuk ? Icons.south_west : Icons.north_east,
                                      color: masuk
                                          ? const Color(0xFF32966A)
                                          : const Color(0xFFC64D69),
                                    ),
                                  ),
                                  title: Text(item.keterangan,
                                      style: const TextStyle(
                                          fontWeight: FontWeight.w700)),
                                  subtitle: Text(tanggal(item.tanggal)),
                                  trailing: Text(
                                    '${masuk ? '+' : '-'}${rupiah(item.nominal)}',
                                    style: TextStyle(
                                      fontWeight: FontWeight.w800,
                                      color: masuk
                                          ? const Color(0xFF32966A)
                                          : const Color(0xFFC64D69),
                                    ),
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                ),
              ],
            ),
          ),
          floatingActionButton: FloatingActionButton.extended(
            key: const Key('tambahTransaksiButton'),
            onPressed: () async {
              await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) =>
                      TambahTransaksiScreen(viewModel: widget.viewModel),
                ),
              );
            },
            icon: const Icon(Icons.add),
            label: const Text('Tambah transaksi'),
          ),
        );
      },
    );
  }

  Widget _summary(String label, int value, IconData icon, Color tint) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.16),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 16,
            backgroundColor: tint,
            child: Icon(icon, size: 17, color: const Color(0xFF5D4A83)),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label,
                    style: const TextStyle(
                        color: Colors.white70, fontSize: 11)),
                const SizedBox(height: 3),
                Text(rupiah(value),
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                        fontWeight: FontWeight.w700)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
