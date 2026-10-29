import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../models/hasil_prediksi.dart';
import 'prediksi_bloc.dart';

class PrediksiModel extends ChangeNotifier {
  final List<HasilPrediksi> _daftar = [];
  String _filterPetak = 'Semua';
  ThemeMode _themeMode = ThemeMode.light;

  List<HasilPrediksi> get daftar => List.unmodifiable(_daftar);
  String get filterPetak => _filterPetak;
  ThemeMode get themeMode => _themeMode;

  List<HasilPrediksi> get daftarTersaring {
    if (_filterPetak == 'Semua') return _daftar;
    return _daftar.where((item) => item.petak == _filterPetak).toList();
  }

  int get total => daftarTersaring.length;
  int get optimal =>
      daftarTersaring.where((item) => item.status == 'Optimal').length;
  int get perluTindakan => daftarTersaring
      .where(
        (item) => item.status == 'Kering' || item.status == 'Terlalu Lembap',
      )
      .length;

  void tambahData(HasilPrediksi data) {
    _daftar.insert(0, data);
    notifyListeners();
  }

  void hapusData(String id) {
    _daftar.removeWhere((item) => item.id == id);
    notifyListeners();
  }

  void ubahData(HasilPrediksi dataBaru) {
    final idx = _daftar.indexWhere((item) => item.id == dataBaru.id);
    if (idx != -1) {
      _daftar[idx] = dataBaru;
      notifyListeners();
    }
  }

  void ubahFilterPetak(String petak) {
    _filterPetak = petak;
    notifyListeners();
  }

  void ubahThemeMode(bool modeGelap) {
    _themeMode = modeGelap ? ThemeMode.dark : ThemeMode.light;
    notifyListeners();
  }
}

class PrediksiCubit extends Cubit<PrediksiState> {
  PrediksiCubit() : super(const PrediksiState());

  void tambahData(HasilPrediksi data) {
    emit(state.copyWith(daftarPrediksi: [data, ...state.daftarPrediksi]));
  }

  void hapusData(String id) {
    emit(
      state.copyWith(
        daftarPrediksi: state.daftarPrediksi
            .where((item) => item.id != id)
            .toList(),
      ),
    );
  }

  void ubahData(HasilPrediksi dataBaru) {
    emit(
      state.copyWith(
        daftarPrediksi: state.daftarPrediksi
            .map((item) => item.id == dataBaru.id ? dataBaru : item)
            .toList(),
      ),
    );
  }

  void filterPetak(String petak) {
    emit(state.copyWith(filterPetak: petak));
  }

  void ubahModeGelap(bool aktif) {
    emit(
      state.copyWith(
        themeMode: aktif ? ThemeMode.dark : ThemeMode.light,
      ),
    );
  }
}
