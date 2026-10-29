import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../state/prediksi_bloc.dart';
import '../widgets/prediksi_card.dart';
import '../widgets/stat_card.dart';

class HalamanPrediksi extends StatelessWidget {
  const HalamanPrediksi({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return BlocBuilder<PrediksiBloc, PrediksiState>(
      builder: (context, state) {
        final daftar = state.daftarTersaring;

        return Scaffold(
          floatingActionButton: FloatingActionButton.extended(
            onPressed: () => Navigator.pushNamed(context, '/input-prediksi'),
            icon: const Icon(Icons.add),
            label: const Text('Prediksi baru'),
          ),
          body: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  'Riwayat Prediksi',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: colorScheme.onSurface,
                  ),
                ),
                const SizedBox(height: 8),
                SizedBox(
                  width: double.infinity,
                  child: SegmentedButton<String>(
                    segments: const [
                      ButtonSegment(value: 'Semua', label: Text('Semua')),
                      ButtonSegment(value: 'Petak 1', label: Text('Petak 1')),
                      ButtonSegment(value: 'Petak 2', label: Text('Petak 2')),
                    ],
                    selected: {state.filterPetak},
                    onSelectionChanged: (pilihanBaru) {
                      context.read<PrediksiBloc>().add(
                        FilterPetakEvent(pilihanBaru.first),
                      );
                    },
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Expanded(
                      child: StatCard(
                        judul: 'Total',
                        nilai: state.totalPrediksi,
                      ),
                    ),
                    Expanded(
                      child: StatCard(
                        judul: 'Optimal',
                        nilai: state.jumlahOptimal,
                      ),
                    ),
                    Expanded(
                      child: StatCard(
                        judul: 'Perlu Tindakan',
                        nilai: state.jumlahPerluTindakan,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Expanded(
                  child: daftar.isEmpty
                      ? const Center(child: Text('Belum ada data'))
                      : ListView.builder(
                          itemCount: daftar.length,
                          itemBuilder: (context, index) {
                            final item = daftar[index];
                            return PrediksiCard(
                              prediksi: item,
                              onUbah: () {
                                Navigator.pushNamed(
                                  context,
                                  '/input-prediksi',
                                  arguments: item,
                                );
                              },
                              onHapus: () {
                                context.read<PrediksiBloc>().add(
                                  HapusPrediksiEvent(item.id),
                                );
                              },
                            );
                          },
                        ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
