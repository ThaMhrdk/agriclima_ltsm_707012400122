import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../models/hasil_prediksi.dart';

List<HasilPrediksi> buatDataSimulasi() {
  final random = Random();
  const daftarPetak = ['Petak 1', 'Petak 2'];
  const daftarTanaman = ['Padi', 'Jagung', 'Cabai'];
  const daftarPetugas = ['Budi', 'Siti', 'Rizky', 'Andi', 'Dewi'];

  return List<HasilPrediksi>.generate(10, (index) {
    return HasilPrediksi(
      id: '${DateTime.now().microsecondsSinceEpoch}_$index',
      petak: daftarPetak[random.nextInt(daftarPetak.length)],
      tanaman: daftarTanaman[random.nextInt(daftarTanaman.length)],
      suhuUdara: (18 + random.nextInt(18)).toDouble(),
      kelembapanUdara: (40 + random.nextInt(61)).toDouble(),
      kelembapanTanah: (20 + random.nextInt(71)).toDouble(),
      namaPetugas: daftarPetugas[random.nextInt(daftarPetugas.length)],
      waktu: DateTime.now().subtract(Duration(hours: index)),
    );
  });
}

sealed class PrediksiEvent {}

class TambahPrediksiEvent extends PrediksiEvent {
  final HasilPrediksi hasilPrediksi;
  TambahPrediksiEvent(this.hasilPrediksi);
}

class HapusPrediksiEvent extends PrediksiEvent {
  final String id;
  HapusPrediksiEvent(this.id);
}

class UbahPrediksiEvent extends PrediksiEvent {
  final HasilPrediksi hasilPrediksiBaru;
  UbahPrediksiEvent(this.hasilPrediksiBaru);
}

class FilterPetakEvent extends PrediksiEvent {
  final String petak;
  FilterPetakEvent(this.petak);
}

class MuatDataSimulasiEvent extends PrediksiEvent {}

class HapusSemuaPrediksiEvent extends PrediksiEvent {}

class UbahModeGelapEvent extends PrediksiEvent {
  final bool modeGelapAktif;
  UbahModeGelapEvent(this.modeGelapAktif);
}

class PrediksiState {
  final List<HasilPrediksi> daftarPrediksi;
  final String filterPetak;
  final ThemeMode themeMode;

  const PrediksiState({
    this.daftarPrediksi = const [],
    this.filterPetak = 'Semua',
    this.themeMode = ThemeMode.light,
  });

  bool get isModeGelap => themeMode == ThemeMode.dark;

  int get totalSemuaPrediksi => daftarPrediksi.length;

  List<HasilPrediksi> get daftarTersaring {
    if (filterPetak == 'Semua') {
      return daftarPrediksi;
    }
    return daftarPrediksi.where((item) => item.petak == filterPetak).toList();
  }

  int get totalPrediksi => daftarTersaring.length;

  int get jumlahOptimal =>
      daftarTersaring.where((item) => item.status == 'Optimal').length;

  int get jumlahPerluTindakan => daftarTersaring
      .where(
        (item) => item.status == 'Kering' || item.status == 'Terlalu Lembap',
      )
      .length;

  Map<String, int> get jumlahPerStatus {
    final Map<String, int> hasil = {
      'Kering': 0,
      'Optimal': 0,
      'Terlalu Lembap': 0,
    };
    for (final item in daftarPrediksi) {
      hasil[item.status] = (hasil[item.status] ?? 0) + 1;
    }
    return hasil;
  }

  PrediksiState copyWith({
    List<HasilPrediksi>? daftarPrediksi,
    String? filterPetak,
    ThemeMode? themeMode,
  }) {
    return PrediksiState(
      daftarPrediksi: daftarPrediksi ?? this.daftarPrediksi,
      filterPetak: filterPetak ?? this.filterPetak,
      themeMode: themeMode ?? this.themeMode,
    );
  }
}

class PrediksiBloc extends Bloc<PrediksiEvent, PrediksiState> {
  PrediksiBloc() : super(const PrediksiState()) {
    on<TambahPrediksiEvent>((event, emit) {
      emit(
        state.copyWith(
          daftarPrediksi: [event.hasilPrediksi, ...state.daftarPrediksi],
        ),
      );
    });

    on<HapusPrediksiEvent>((event, emit) {
      emit(
        state.copyWith(
          daftarPrediksi: state.daftarPrediksi
              .where((item) => item.id != event.id)
              .toList(),
        ),
      );
    });

    on<UbahPrediksiEvent>((event, emit) {
      final listBaru = state.daftarPrediksi.map((item) {
        if (item.id == event.hasilPrediksiBaru.id) {
          return event.hasilPrediksiBaru;
        }
        return item;
      }).toList();
      emit(state.copyWith(daftarPrediksi: listBaru));
    });

    on<FilterPetakEvent>((event, emit) {
      emit(state.copyWith(filterPetak: event.petak));
    });

    on<MuatDataSimulasiEvent>((event, emit) {
      final dataSimulasi = buatDataSimulasi();
      emit(
        state.copyWith(
          daftarPrediksi: [...dataSimulasi, ...state.daftarPrediksi],
        ),
      );
    });

    on<HapusSemuaPrediksiEvent>((event, emit) {
      emit(state.copyWith(daftarPrediksi: []));
    });

    on<UbahModeGelapEvent>((event, emit) {
      emit(
        state.copyWith(
          themeMode: event.modeGelapAktif ? ThemeMode.dark : ThemeMode.light,
        ),
      );
    });
  }
}
