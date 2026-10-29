import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'pages/halaman_beranda.dart';
import 'pages/halaman_input_prediksi.dart';
import 'pages/halaman_pengaturan.dart';
import 'pages/halaman_prediksi.dart';
import 'pages/halaman_statistik.dart';
import 'pages/halaman_tentang.dart';
import 'state/prediksi_bloc.dart';

void main() {
  runApp(
    BlocProvider(create: (_) => PrediksiBloc(), child: const AgriClimaApp()),
  );
}

class AppRoutes {
  static const String beranda = '/';
  static const String tentang = '/tentang';
  static const String inputPrediksi = '/input-prediksi';
}

class AppTheme {
  static final ThemeData lightTheme = ThemeData(
    useMaterial3: true,
    colorScheme: ColorScheme.fromSeed(
      seedColor: Colors.green,
      brightness: Brightness.light,
    ),
  );

  static final ThemeData darkTheme = ThemeData(
    useMaterial3: true,
    colorScheme: ColorScheme.fromSeed(
      seedColor: Colors.green,
      brightness: Brightness.dark,
    ),
  );
}

class AgriClimaApp extends StatelessWidget {
  const AgriClimaApp({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PrediksiBloc, PrediksiState>(
      builder: (context, state) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'AgriClima',
          theme: AppTheme.lightTheme,
          darkTheme: AppTheme.darkTheme,
          themeMode: state.themeMode,
          initialRoute: AppRoutes.beranda,
          routes: {
            AppRoutes.beranda: (context) => const KerangkaNavigasi(),
            AppRoutes.tentang: (context) => const HalamanTentang(),
            AppRoutes.inputPrediksi: (context) => const HalamanInputPrediksi(),
          },
        );
      },
    );
  }
}

class KerangkaNavigasi extends StatefulWidget {
  const KerangkaNavigasi({super.key});

  @override
  State<KerangkaNavigasi> createState() => _KerangkaNavigasiState();
}

class _KerangkaNavigasiState extends State<KerangkaNavigasi> {
  int indeksTab = 0;

  final List<Widget> halaman = const [
    HalamanBeranda(),
    HalamanPrediksi(),
    HalamanStatistik(),
    HalamanPengaturan(),
  ];

  final List<String> namaTab = const [
    'Beranda',
    'Prediksi',
    'Statistik',
    'Pengaturan',
  ];

  @override
  Widget build(BuildContext context) {
    final totalData = context.select<PrediksiBloc, int>(
      (bloc) => bloc.state.totalSemuaPrediksi,
    );

    return Scaffold(
      appBar: AppBar(title: Text('AgriClima - ${namaTab[indeksTab]}')),
      body: IndexedStack(index: indeksTab, children: halaman),
      bottomNavigationBar: NavigationBar(
        selectedIndex: indeksTab,
        onDestinationSelected: (indeks) {
          setState(() {
            indeksTab = indeks;
          });
        },
        destinations: [
          const NavigationDestination(
            icon: Icon(Icons.home_outlined),
            selectedIcon: Icon(Icons.home),
            label: 'Beranda',
          ),
          NavigationDestination(
            icon: Badge(
              isLabelVisible: totalData > 0,
              label: Text('$totalData'),
              child: const Icon(Icons.eco_outlined),
            ),
            selectedIcon: Badge(
              isLabelVisible: totalData > 0,
              label: Text('$totalData'),
              child: const Icon(Icons.eco),
            ),
            label: 'Prediksi',
          ),
          const NavigationDestination(
            icon: Icon(Icons.bar_chart_outlined),
            selectedIcon: Icon(Icons.bar_chart),
            label: 'Statistik',
          ),
          const NavigationDestination(
            icon: Icon(Icons.settings_outlined),
            selectedIcon: Icon(Icons.settings),
            label: 'Pengaturan',
          ),
        ],
      ),
    );
  }
}
