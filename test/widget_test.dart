import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:agriclima_ltsm_707012400122/main.dart';
import 'package:agriclima_ltsm_707012400122/state/prediksi_bloc.dart';

void main() {
  testWidgets('AgriClima LTSM menampilkan halaman beranda dan 4 tab navigasi', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(
      BlocProvider(
        create: (_) => PrediksiBloc(),
        child: const AgriClimaApp(),
      ),
    );

    expect(find.text('Selamat Datang di AgriClima LTSM'), findsOneWidget);
    expect(find.byType(NavigationBar), findsOneWidget);
  });
}
