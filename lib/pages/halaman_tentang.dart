import 'package:flutter/material.dart';

class HalamanTentang extends StatelessWidget {
  const HalamanTentang({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(title: const Text('Tentang AgriClima')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Text(
            'Tujuan Aplikasi',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: colorScheme.onSurface,
            ),
          ),
          const SizedBox(height: 8),
          const Card(
            child: ListTile(
              leading: Icon(Icons.eco),
              title: Text('AgriClima LTSM'),
              subtitle: Text(
                'Aplikasi pemantauan dan prediksi mikroklimat 24 jam ke depan untuk menentukan status lahan dan rekomendasi perawatan tanaman.',
              ),
            ),
          ),
          const SizedBox(height: 16),
          Text(
            'Lokasi Pemantauan',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: colorScheme.onSurface,
            ),
          ),
          const SizedBox(height: 8),
          const Card(
            child: ListTile(
              leading: Icon(Icons.place),
              title: Text('Petak 1'),
              subtitle: Text('Lokasi pemantauan lahan bagian pertama'),
            ),
          ),
          const Card(
            child: ListTile(
              leading: Icon(Icons.place),
              title: Text('Petak 2'),
              subtitle: Text('Lokasi pemantauan lahan bagian kedua'),
            ),
          ),
          const SizedBox(height: 16),
          Text(
            'Daftar Parameter Mikroklimat',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: colorScheme.onSurface,
            ),
          ),
          const SizedBox(height: 8),
          const Card(
            child: ListTile(
              leading: Icon(Icons.thermostat),
              title: Text('Suhu Udara (°C)'),
              subtitle: Text('Parameter suhu udara di sekitar lahan'),
            ),
          ),
          const Card(
            child: ListTile(
              leading: Icon(Icons.air),
              title: Text('Kelembapan Udara (%)'),
              subtitle: Text('Parameter kelembapan udara (0 - 100%)'),
            ),
          ),
          const Card(
            child: ListTile(
              leading: Icon(Icons.water_drop),
              title: Text('Kelembapan Tanah (%)'),
              subtitle: Text('Parameter kelembapan tanah penentu status (0 - 100%)'),
            ),
          ),
        ],
      ),
    );
  }
}
