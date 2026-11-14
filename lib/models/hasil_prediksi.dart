import 'package:flutter/material.dart';

class HasilPrediksi {
  final String id;
  final String petak;
  final String tanaman;
  final double suhuUdara;
  final double kelembapanUdara;
  final double kelembapanTanah;
  final String namaPetugas;
  final DateTime waktu;

  const HasilPrediksi({
    required this.id,
    required this.petak,
    required this.tanaman,
    required this.suhuUdara,
    required this.kelembapanUdara,
    required this.kelembapanTanah,
    required this.namaPetugas,
    required this.waktu,
  });

  static const Map<String, String> catatanPerawatanTanaman = {
    'Padi':
        'Jaga genangan air 2–5 cm pada fase vegetatif dan keringkan lahan menjelang panen.',
    'Jagung':
        'Siram saat tanah mulai kering dan hindari genangan di sekitar perakaran.',
    'Cabai':
        'Gunakan mulsa untuk menjaga kelembapan tanah dan siram pada pagi atau sore hari.',
  };

  String get status {
    if (kelembapanTanah < 40) {
      return 'Kering';
    } else if (kelembapanTanah <= 70) {
      return 'Optimal';
    } else {
      return 'Terlalu Lembap';
    }
  }

  String get rekomendasi {
    switch (status) {
      case 'Kering':
        return 'Segera lakukan penyiraman atau irigasi';
      case 'Optimal':
        return 'Pertahankan pola perawatan saat ini';
      case 'Terlalu Lembap':
      default:
        return 'Kurangi penyiraman dan periksa drainase';
    }
  }

  String get catatanPerawatan {
    return catatanPerawatanTanaman[tanaman] ??
        'Pantau kondisi tanaman secara rutin.';
  }

  IconData get ikonStatus {
    switch (status) {
      case 'Kering':
        return Icons.wb_sunny;
      case 'Optimal':
        return Icons.check_circle;
      case 'Terlalu Lembap':
      default:
        return Icons.water_drop;
    }
  }

  Color get warnaStatus {
    if (status == 'Kering') {
      return Colors.orange;
    } else if (status == 'Optimal') {
      return Colors.green;
    } else {
      return Colors.blue;
    }
  }

  String get waktuTerformat {
    final tgl = waktu.day.toString().padLeft(2, '0');
    final bln = waktu.month.toString().padLeft(2, '0');
    final thn = waktu.year;
    final jam = waktu.hour.toString().padLeft(2, '0');
    final mnt = waktu.minute.toString().padLeft(2, '0');
    return '$tgl/$bln/$thn $jam:$mnt';
  }
}
