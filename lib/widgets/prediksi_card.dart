import 'package:flutter/material.dart';

import '../models/hasil_prediksi.dart';

class PrediksiCard extends StatelessWidget {
  final HasilPrediksi prediksi;
  final VoidCallback onUbah;
  final VoidCallback onHapus;

  const PrediksiCard({
    super.key,
    required this.prediksi,
    required this.onUbah,
    required this.onHapus,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ListTile(
              contentPadding: EdgeInsets.zero,
              leading: Icon(
                prediksi.ikonStatus,
                color: prediksi.warnaStatus,
                size: 32,
              ),
              title: Text(
                '${prediksi.petak} - ${prediksi.tanaman}',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: colorScheme.onSurface,
                ),
              ),
              subtitle: Text(
                'Status: ${prediksi.status}',
                style: TextStyle(
                  color: prediksi.warnaStatus,
                  fontWeight: FontWeight.w600,
                ),
              ),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    icon: const Icon(Icons.edit_outlined),
                    tooltip: 'Ubah',
                    onPressed: onUbah,
                  ),
                  IconButton(
                    icon: const Icon(Icons.delete_outline),
                    tooltip: 'Hapus',
                    onPressed: onHapus,
                  ),
                ],
              ),
            ),
            Text(
              'Kelembapan Tanah: ${prediksi.kelembapanTanah.toInt()}%',
              style: TextStyle(color: colorScheme.onSurface),
            ),
            const SizedBox(height: 4),
            LinearProgressIndicator(
              value: (prediksi.kelembapanTanah / 100).clamp(0.0, 1.0),
              color: prediksi.warnaStatus,
            ),
            const SizedBox(height: 8),
            Text(
              'Suhu Udara: ${prediksi.suhuUdara.toInt()} °C',
              style: TextStyle(color: colorScheme.onSurface),
            ),
            const SizedBox(height: 2),
            Text(
              'Kelembapan Udara: ${prediksi.kelembapanUdara.toInt()}%',
              style: TextStyle(color: colorScheme.onSurface),
            ),
            const SizedBox(height: 6),
            Text(
              'Rekomendasi: ${prediksi.rekomendasi}',
              style: TextStyle(color: colorScheme.onSurfaceVariant),
            ),
            const SizedBox(height: 2),
            Text(
              'Catatan ${prediksi.tanaman}: ${prediksi.catatanPerawatan}',
              style: TextStyle(
                fontSize: 12,
                color: colorScheme.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              '${prediksi.namaPetugas} • ${prediksi.waktuTerformat}',
              style: TextStyle(
                fontSize: 12,
                color: colorScheme.onSurfaceVariant,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
