import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../state/prediksi_bloc.dart';

class HalamanPengaturan extends StatelessWidget {
  const HalamanPengaturan({super.key});

  void konfirmasiHapusSemua(BuildContext context) {
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Hapus Semua Data'),
        content: const Text(
          'Apakah yakin ingin menghapus semua data prediksi?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text('Batal'),
          ),
          ElevatedButton(
            onPressed: () {
              context.read<PrediksiBloc>().add(HapusSemuaPrediksiEvent());
              Navigator.pop(dialogContext);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Semua data dihapus')),
              );
            },
            child: const Text('Hapus'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PrediksiBloc, PrediksiState>(
      builder: (context, state) {
        return ListView(
          padding: const EdgeInsets.all(16),
          children: [
            SwitchListTile(
              title: const Text('Mode Gelap'),
              subtitle: const Text('Ubah tampilan aplikasi ke mode gelap'),
              value: state.isModeGelap,
              onChanged: (nilai) {
                context.read<PrediksiBloc>().add(UbahModeGelapEvent(nilai));
              },
            ),
            const Divider(height: 24),
            ElevatedButton.icon(
              onPressed: () {
                context.read<PrediksiBloc>().add(MuatDataSimulasiEvent());
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('10 data simulasi dimuat')),
                );
              },
              icon: const Icon(Icons.refresh),
              label: const Text('Muat Data Simulasi'),
            ),
            const SizedBox(height: 12),
            OutlinedButton.icon(
              onPressed: () => konfirmasiHapusSemua(context),
              icon: const Icon(Icons.delete_outline),
              label: const Text('Hapus Semua Data'),
            ),
          ],
        );
      },
    );
  }
}
