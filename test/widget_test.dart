import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:agriclima_ltsm_707012400122/main.dart';
import 'package:agriclima_ltsm_707012400122/models/hasil_prediksi.dart';
import 'package:agriclima_ltsm_707012400122/state/prediksi_bloc.dart';

void main() {
  testWidgets('AgriClima LSTM menampilkan halaman beranda dan 4 tab navigasi', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(
      BlocProvider(
        create: (_) => PrediksiBloc(),
        child: const AgriClimaApp(),
      ),
    );

    expect(find.text('Selamat Datang di AgriClima LSTM'), findsOneWidget);
    expect(find.byType(NavigationBar), findsOneWidget);
    expect(find.text('AgriClima - Beranda'), findsOneWidget);

    await tester.tap(find.text('Tentang Aplikasi'));
    await tester.pumpAndSettle();
    expect(find.text('Tujuan Aplikasi'), findsOneWidget);
    expect(find.text('Petak 1'), findsOneWidget);
    expect(find.text('Petak 2'), findsOneWidget);

    await tester.pageBack();
    await tester.pumpAndSettle();

    await tester.tap(find.text('Prediksi'));
    await tester.pumpAndSettle();
    expect(find.text('AgriClima - Prediksi'), findsOneWidget);
    expect(find.text('Belum ada data'), findsOneWidget);
    expect(find.text('Prediksi Baru'), findsOneWidget);
  });

  testWidgets('Badge hanya menghitung data Perlu Tindakan dan form validasi bekerja', (
    WidgetTester tester,
  ) async {
    final bloc = PrediksiBloc();
    bloc.add(
      TambahPrediksiEvent(
        HasilPrediksi(
          id: '1',
          petak: 'Petak 1',
          tanaman: 'Padi',
          suhuUdara: 28,
          kelembapanUdara: 70,
          kelembapanTanah: 55,
          namaPetugas: 'Ani',
          waktu: DateTime(2026, 10, 22, 10, 0),
        ),
      ),
    );
    bloc.add(
      TambahPrediksiEvent(
        HasilPrediksi(
          id: '2',
          petak: 'Petak 2',
          tanaman: 'Cabai',
          suhuUdara: 29,
          kelembapanUdara: 75,
          kelembapanTanah: 35,
          namaPetugas: 'Budi',
          waktu: DateTime(2026, 10, 22, 15, 7),
        ),
      ),
    );
    bloc.add(
      TambahPrediksiEvent(
        HasilPrediksi(
          id: '3',
          petak: 'Petak 1',
          tanaman: 'Jagung',
          suhuUdara: 25,
          kelembapanUdara: 85,
          kelembapanTanah: 80,
          namaPetugas: 'Cici',
          waktu: DateTime(2026, 10, 22, 16, 0),
        ),
      ),
    );

    await tester.pumpWidget(
      BlocProvider.value(
        value: bloc,
        child: const AgriClimaApp(),
      ),
    );
    await tester.pumpAndSettle();

    final badge = tester.widget<Badge>(find.byType(Badge).first);
    expect(badge.isLabelVisible, isTrue);
    expect((badge.label as Text).data, '2');

    await tester.tap(find.text('Pengaturan'));
    await tester.pumpAndSettle();
    await tester.tap(find.byType(Switch));
    await tester.pumpAndSettle();
    expect(bloc.state.isModeGelap, isTrue);

    await bloc.close();
  });

  test('HasilPrediksi dan buatDataSimulasi memenuhi aturan Tabel A, B, dan rentang nilai', () {
    final kering = HasilPrediksi(
      id: 'k',
      petak: 'Petak 1',
      tanaman: 'Padi',
      suhuUdara: 30,
      kelembapanUdara: 60,
      kelembapanTanah: 39.9,
      namaPetugas: 'Budi',
      waktu: DateTime(2026, 10, 22),
    );
    expect(kering.status, 'Kering');
    expect(kering.rekomendasi, 'Segera lakukan penyiraman atau irigasi');
    expect(kering.warnaStatus, Colors.orange);

    final optimal = HasilPrediksi(
      id: 'o',
      petak: 'Petak 1',
      tanaman: 'Jagung',
      suhuUdara: 28,
      kelembapanUdara: 70,
      kelembapanTanah: 70,
      namaPetugas: 'Budi',
      waktu: DateTime(2026, 10, 22),
    );
    expect(optimal.status, 'Optimal');
    expect(optimal.rekomendasi, 'Pertahankan pola perawatan saat ini');
    expect(optimal.warnaStatus, Colors.green);

    final lembap = HasilPrediksi(
      id: 'l',
      petak: 'Petak 2',
      tanaman: 'Cabai',
      suhuUdara: 24,
      kelembapanUdara: 85,
      kelembapanTanah: 70.1,
      namaPetugas: 'Budi',
      waktu: DateTime(2026, 10, 22),
    );
    expect(lembap.status, 'Terlalu Lembap');
    expect(lembap.rekomendasi, 'Kurangi penyiraman dan periksa drainase');
    expect(lembap.warnaStatus, Colors.blue);

    final simulasi = buatDataSimulasi();
    expect(simulasi.length, 10);
    for (final item in simulasi) {
      expect(['Petak 1', 'Petak 2'], contains(item.petak));
      expect(['Padi', 'Jagung', 'Cabai'], contains(item.tanaman));
      expect(item.suhuUdara, inInclusiveRange(18, 35));
      expect(item.kelembapanUdara, inInclusiveRange(40, 100));
      expect(item.kelembapanTanah, inInclusiveRange(20, 90));
    }
  });
}
