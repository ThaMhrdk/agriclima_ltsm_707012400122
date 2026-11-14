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
  bool sudahValidasi = false;
  bool suhuDisentuh = false;
  bool kelembapanUdaraDisentuh = false;
  bool kelembapanTanahDisentuh = false;
  bool petugasDisentuh = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!sudahIsiDataEdit) {
      final dataEdit =
          ModalRoute.of(context)?.settings.arguments as HasilPrediksi?;
      if (dataEdit != null) {
        petakTerpilih = dataEdit.petak;
        tanamanTerpilih = dataEdit.tanaman;
        suhuController.text = dataEdit.suhuUdara.toString();
        kelembapanUdaraController.text = dataEdit.kelembapanUdara.toString();
        kelembapanTanahController.text = dataEdit.kelembapanTanah.toString();
        petugasController.text = dataEdit.namaPetugas;
      }
      sudahIsiDataEdit = true;
    }
  }

  String? get errorSuhu {
    final teks = suhuController.text.trim();
    if (teks.isEmpty) {
      if (sudahValidasi || suhuDisentuh) {
        return 'Suhu harus berupa angka';
      }
      return null;
    }
    final nilai = double.tryParse(teks);
    if (nilai == null || !nilai.isFinite) {
      return 'Suhu harus berupa angka';
    }
    return null;
  }

  String? get errorKelembapanUdara {
    final teks = kelembapanUdaraController.text.trim();
    if (teks.isEmpty) {
      if (sudahValidasi || kelembapanUdaraDisentuh) {
        return 'Kelembapan udara harus angka 0-100';
      }
      return null;
    }
    final nilai = double.tryParse(teks);
    if (nilai == null || !nilai.isFinite || nilai < 0 || nilai > 100) {
      return 'Kelembapan udara harus angka 0-100';
    }
    return null;
  }

  String? get errorKelembapanTanah {
    final teks = kelembapanTanahController.text.trim();
    if (teks.isEmpty) {
      if (sudahValidasi || kelembapanTanahDisentuh) {
        return 'Kelembapan tanah harus angka 0-100';
      }
      return null;
    }
    final nilai = double.tryParse(teks);
    if (nilai == null || !nilai.isFinite || nilai < 0 || nilai > 100) {
      return 'Kelembapan tanah harus angka 0-100';
    }
    return null;
  }

  String? get errorPetugas {
    if (petugasController.text.trim().isEmpty) {
      if (sudahValidasi || petugasDisentuh) {
        return 'Nama petugas tidak boleh kosong';
      }
    }
    return null;
  }

  bool get formValid {
    final suhu = double.tryParse(suhuController.text.trim());
    final kUdara = double.tryParse(kelembapanUdaraController.text.trim());
    final kTanah = double.tryParse(kelembapanTanahController.text.trim());
    return suhu != null &&
        suhu.isFinite &&
        kUdara != null &&
        kUdara.isFinite &&
        kUdara >= 0 &&
        kUdara <= 100 &&
        kTanah != null &&
        kTanah.isFinite &&
        kTanah >= 0 &&
        kTanah <= 100 &&
        petugasController.text.trim().isNotEmpty;
  }

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
      setState(() {
        sudahValidasi = true;
      });
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
        title: const Text('Konfirmasi'),
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
                const SnackBar(content: Text('Data tersimpan')),
              );
              Navigator.pop(context);
            },
            child: const Text('Ya, Simpan'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final dataEdit =
        ModalRoute.of(context)?.settings.arguments as HasilPrediksi?;

    return Scaffold(
      appBar: AppBar(
        title: Text(dataEdit != null ? 'Ubah Prediksi' : 'Input Prediksi'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text('Petak'),
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
              keyboardType: const TextInputType.numberWithOptions(
                decimal: true,
              ),
              decoration: InputDecoration(
                labelText: 'Prediksi Suhu Udara (°C)',
                border: const OutlineInputBorder(),
                errorText: errorSuhu,
              ),
              onChanged: (_) => setState(() {
                suhuDisentuh = true;
              }),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: kelembapanUdaraController,
              keyboardType: const TextInputType.numberWithOptions(
                decimal: true,
              ),
              decoration: InputDecoration(
                labelText: 'Prediksi Kelembapan Udara (%)',
                border: const OutlineInputBorder(),
                errorText: errorKelembapanUdara,
              ),
              onChanged: (_) => setState(() {
                kelembapanUdaraDisentuh = true;
              }),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: kelembapanTanahController,
              keyboardType: const TextInputType.numberWithOptions(
                decimal: true,
              ),
              decoration: InputDecoration(
                labelText: 'Prediksi Kelembapan Tanah (%)',
                border: const OutlineInputBorder(),
                errorText: errorKelembapanTanah,
              ),
              onChanged: (_) => setState(() {
                kelembapanTanahDisentuh = true;
              }),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: petugasController,
              decoration: InputDecoration(
                labelText: 'Nama Petugas',
                border: const OutlineInputBorder(),
                errorText: errorPetugas,
              ),
              onChanged: (_) => setState(() {
                petugasDisentuh = true;
              }),
            ),
            CheckboxListTile(
              value: dataSudahBenar,
              title: const Text('Data sudah benar'),
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
