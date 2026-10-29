import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../models/hasil_prediksi.dart';
import '../state/prediksi_bloc.dart';

class HalamanInputPrediksi extends StatefulWidget {
  const HalamanInputPrediksi({super.key});

  @override
  State<HalamanInputPrediksi> createState() => _HalamanInputPrediksiState();
}

class _HalamanInputPrediksiState extends State<HalamanInputPrediksi> {
  final suhuController = TextEditingController();
  final kelembapanUdaraController = TextEditingController();
  final kelembapanTanahController = TextEditingController();
  final petugasController = TextEditingController();

  String petakTerpilih = 'Petak 1';
  String tanamanTerpilih = 'Padi';
  bool dataSudahBenar = false;
  bool sudahIsiDataEdit = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!sudahIsiDataEdit) {
      final dataEdit =
          ModalRoute.of(context)?.settings.arguments as HasilPrediksi?;
      if (dataEdit != null) {
        petakTerpilih = dataEdit.petak;
        tanamanTerpilih = dataEdit.tanaman;
        suhuController.text = dataEdit.suhuUdara.toInt().toString();
        kelembapanUdaraController.text = dataEdit.kelembapanUdara
            .toInt()
            .toString();
        kelembapanTanahController.text = dataEdit.kelembapanTanah
            .toInt()
            .toString();
        petugasController.text = dataEdit.namaPetugas;
      }
      sudahIsiDataEdit = true;
    }
  }

  String? get errorSuhu {
    final teks = suhuController.text.trim();
    if (teks.isEmpty || double.tryParse(teks) == null) {
      return 'Suhu harus berupa angka';
    }
    return null;
  }

  String? get errorKelembapanUdara {
    final nilai = double.tryParse(kelembapanUdaraController.text.trim());
    if (nilai == null || nilai < 0 || nilai > 100) {
      return 'Kelembapan udara harus angka 0-100';
    }
    return null;
  }

  String? get errorKelembapanTanah {
    final nilai = double.tryParse(kelembapanTanahController.text.trim());
    if (nilai == null || nilai < 0 || nilai > 100) {
      return 'Kelembapan tanah harus angka 0-100';
    }
    return null;
  }

  String? get errorPetugas {
    if (petugasController.text.trim().isEmpty) {
      return 'Nama petugas tidak boleh kosong';
    }
    return null;
  }

  bool get formValid =>
      errorSuhu == null &&
      errorKelembapanUdara == null &&
      errorKelembapanTanah == null &&
      errorPetugas == null;

  @override
  void dispose() {
    suhuController.dispose();
    kelembapanUdaraController.dispose();
    kelembapanTanahController.dispose();
    petugasController.dispose();
    super.dispose();
  }

  void konfirmasiSimpan() {
    if (!formValid) {
      setState(() {});
      return;
    }

    final dataEdit =
        ModalRoute.of(context)?.settings.arguments as HasilPrediksi?;

    final prediksi = HasilPrediksi(
      id: dataEdit?.id ?? DateTime.now().millisecondsSinceEpoch.toString(),
      petak: petakTerpilih,
      tanaman: tanamanTerpilih,
      suhuUdara: double.parse(suhuController.text.trim()),
      kelembapanUdara: double.parse(kelembapanUdaraController.text.trim()),
      kelembapanTanah: double.parse(kelembapanTanahController.text.trim()),
      namaPetugas: petugasController.text.trim(),
      waktu: dataEdit?.waktu ?? DateTime.now(),
    );

    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Konfirmasi Simpan'),
        content: Text(
          'Simpan prediksi ${prediksi.tanaman} di ${prediksi.petak}?\n'
          'Status: ${prediksi.status}',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text('Batal'),
          ),
          ElevatedButton(
            onPressed: () {
              if (dataEdit != null) {
                context.read<PrediksiBloc>().add(UbahPrediksiEvent(prediksi));
              } else {
                context.read<PrediksiBloc>().add(TambahPrediksiEvent(prediksi));
              }
              Navigator.pop(dialogContext);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Data Tersimpan')),
              );
              Navigator.pop(context);
            },
            child: const Text('Simpan'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Input Hasil Prediksi')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text('Pilih Petak:'),
            RadioGroup<String>(
              groupValue: petakTerpilih,
              onChanged: (nilai) {
                if (nilai != null) {
                  setState(() {
                    petakTerpilih = nilai;
                  });
                }
              },
              child: const Column(
                children: [
                  RadioListTile<String>(
                    title: Text('Petak 1'),
                    value: 'Petak 1',
                  ),
                  RadioListTile<String>(
                    title: Text('Petak 2'),
                    value: 'Petak 2',
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),
            DropdownButtonFormField<String>(
              initialValue: tanamanTerpilih,
              decoration: const InputDecoration(
                labelText: 'Nama Tanaman',
                border: OutlineInputBorder(),
              ),
              items: const [
                DropdownMenuItem(value: 'Padi', child: Text('Padi')),
                DropdownMenuItem(value: 'Jagung', child: Text('Jagung')),
                DropdownMenuItem(value: 'Cabai', child: Text('Cabai')),
              ],
              onChanged: (nilai) {
                setState(() {
                  tanamanTerpilih = nilai!;
                });
              },
            ),
            const SizedBox(height: 12),
            TextField(
              controller: suhuController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: 'Prediksi Suhu Udara (°C)',
                border: const OutlineInputBorder(),
                errorText: errorSuhu,
              ),
              onChanged: (_) => setState(() {}),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: kelembapanUdaraController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: 'Prediksi Kelembapan Udara (%)',
                border: const OutlineInputBorder(),
                errorText: errorKelembapanUdara,
              ),
              onChanged: (_) => setState(() {}),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: kelembapanTanahController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: 'Prediksi Kelembapan Tanah (%)',
                border: const OutlineInputBorder(),
                errorText: errorKelembapanTanah,
              ),
              onChanged: (_) => setState(() {}),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: petugasController,
              decoration: InputDecoration(
                labelText: 'Nama Petugas',
                border: const OutlineInputBorder(),
                errorText: errorPetugas,
              ),
              onChanged: (_) => setState(() {}),
            ),
            CheckboxListTile(
              value: dataSudahBenar,
              title: const Text('Data sudah Benar'),
              onChanged: (nilai) {
                setState(() {
                  dataSudahBenar = nilai ?? false;
                });
              },
            ),
            const SizedBox(height: 12),
            ElevatedButton(
              onPressed: dataSudahBenar ? konfirmasiSimpan : null,
              child: const Text('Simpan'),
            ),
          ],
        ),
      ),
    );
  }
}
