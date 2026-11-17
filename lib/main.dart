import 'package:flutter/material.dart';

import 'data/repositories/transaksi_repository.dart';
import 'ui/kas/home_screen.dart';
import 'ui/kas/kas_view_model.dart';

void main() {
  runApp(NusaKasApp(viewModel: KasViewModel(repository: TransaksiRepository())));
}

class NusaKasApp extends StatelessWidget {
  const NusaKasApp({super.key, required this.viewModel});

  final KasViewModel viewModel;

  static const Color lilac = Color(0xFF8E75C8);

  @override
  Widget build(BuildContext context) {
    final colorScheme = ColorScheme.fromSeed(
      seedColor: lilac,
      brightness: Brightness.light,
    );

    return MaterialApp(
      title: 'NusaKas',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: colorScheme,
        scaffoldBackgroundColor: const Color(0xFFF8F5FF),
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFFF8F5FF),
          foregroundColor: Color(0xFF30264A),
          centerTitle: false,
          elevation: 0,
        ),
        cardTheme: CardThemeData(
          color: Colors.white,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
            side: const BorderSide(color: Color(0xFFECE5FA)),
          ),
        ),
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: const Color(0xFFFBFAFF),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: const BorderSide(color: Color(0xFFE4DDF2)),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: const BorderSide(color: Color(0xFFE4DDF2)),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: const BorderSide(color: lilac, width: 1.6),
          ),
        ),
      ),
      home: HomeScreen(viewModel: viewModel),
    );
  }
}
