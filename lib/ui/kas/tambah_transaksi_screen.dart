import 'package:flutter/material.dart';

import '../../domain/models/transaksi.dart';
import 'kas_view_model.dart';

class TambahTransaksiScreen extends StatefulWidget {
  const TambahTransaksiScreen({super.key, required this.viewModel});

  final KasViewModel viewModel;

  @override
  State<TambahTransaksiScreen> createState() => _TambahTransaksiScreenState();
}

class _TambahTransaksiScreenState extends State<TambahTransaksiScreen> {
  final _formKey = GlobalKey<FormState>();
  final _keteranganController = TextEditingController();
  final _nominalController = TextEditingController();
  JenisTransaksi _jenis = JenisTransaksi.pemasukan;
  String? _pesanError;

  @override
  void dispose() {
    _keteranganController.dispose();
    _nominalController.dispose();
    super.dispose();
  }

  void _simpan() {
    if (!_formKey.currentState!.validate()) return;
    final nominal = int.tryParse(
      _nominalController.text.replaceAll('.', '').replaceAll(',', ''),
    );
    if (nominal == null) return;

    final error = widget.viewModel.tambahTransaksi(
      keterangan: _keteranganController.text,
      nominal: nominal,
      jenis: _jenis,
    );

    if (error != null) {
      setState(() => _pesanError = error);
      return;
    }
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Tambah transaksi')),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            Container(
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                color: const Color(0xFFEFE9FB),
                borderRadius: BorderRadius.circular(18),
              ),
              child: const Row(
                children: [
                  Icon(Icons.edit_note, color: Color(0xFF7458B5), size: 30),
                  SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      'Catat setiap uang yang masuk dan keluar agar kas tetap terpantau.',
                      style: TextStyle(color: Color(0xFF574875)),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            const Text('Keterangan',
                style: TextStyle(fontWeight: FontWeight.w700)),
            const SizedBox(height: 8),
            TextFormField(
              key: const Key('keteranganField'),
              controller: _keteranganController,
              decoration: const InputDecoration(
                hintText: 'Contoh: Iuran anggota',
                prefixIcon: Icon(Icons.description_outlined),
              ),
              validator: (value) =>
                  value == null || value.trim().isEmpty
                      ? 'Keterangan wajib diisi'
                      : null,
            ),
            const SizedBox(height: 18),
            const Text('Nominal',
                style: TextStyle(fontWeight: FontWeight.w700)),
            const SizedBox(height: 8),
            TextFormField(
              key: const Key('nominalField'),
              controller: _nominalController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                hintText: 'Masukkan nominal',
                prefixText: 'Rp ',
                prefixIcon: Icon(Icons.payments_outlined),
              ),
              validator: (value) {
                final amount = int.tryParse(
                  (value ?? '').replaceAll('.', '').replaceAll(',', ''),
                );
                if (amount == null) return 'Nominal harus berupa angka';
                if (amount <= 0) return 'Nominal harus lebih dari nol';
                return null;
              },
            ),
            const SizedBox(height: 18),
            const Text('Jenis transaksi',
                style: TextStyle(fontWeight: FontWeight.w700)),
            const SizedBox(height: 8),
            DropdownButtonFormField<JenisTransaksi>(
              key: const Key('jenisDropdown'),
              initialValue: _jenis,
              decoration: const InputDecoration(
                prefixIcon: Icon(Icons.swap_vert_circle_outlined),
              ),
              items: const [
                DropdownMenuItem(
                  value: JenisTransaksi.pemasukan,
                  child: Text('Pemasukan'),
                ),
                DropdownMenuItem(
                  value: JenisTransaksi.pengeluaran,
                  child: Text('Pengeluaran'),
                ),
              ],
              onChanged: (value) {
                if (value != null) setState(() => _jenis = value);
              },
            ),
            if (_pesanError != null) ...[
              const SizedBox(height: 14),
              Text(_pesanError!,
                  key: const Key('formError'),
                  style: const TextStyle(color: Colors.red)),
            ],
            const SizedBox(height: 28),
            FilledButton.icon(
              key: const Key('simpanButton'),
              onPressed: _simpan,
              icon: const Icon(Icons.save_outlined),
              label: const Padding(
                padding: EdgeInsets.symmetric(vertical: 14),
                child: Text('Simpan transaksi'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
