import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../state/prediksi_bloc.dart';

class HalamanStatistik extends StatelessWidget {
  const HalamanStatistik({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return BlocBuilder<PrediksiBloc, PrediksiState>(
      builder: (context, state) {
        final dataStatus = state.jumlahPerStatus;
        final jmlKering = dataStatus['Kering'] ?? 0;
        final jmlOptimal = dataStatus['Optimal'] ?? 0;
        final jmlLembap = dataStatus['Terlalu Lembap'] ?? 0;

        return Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Statistik Status Mikroklimat',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: colorScheme.onSurface,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Kering: $jmlKering | Optimal: $jmlOptimal | Terlalu Lembap: $jmlLembap',
                style: TextStyle(color: colorScheme.onSurfaceVariant),
              ),
              const SizedBox(height: 24),
              Expanded(
                child: BarChart(
                  BarChartData(
                    titlesData: FlTitlesData(
                      topTitles: const AxisTitles(
                        sideTitles: SideTitles(showTitles: false),
                      ),
                      rightTitles: const AxisTitles(
                        sideTitles: SideTitles(showTitles: false),
                      ),
                      bottomTitles: AxisTitles(
                        sideTitles: SideTitles(
                          showTitles: true,
                          getTitlesWidget: (value, meta) {
                            switch (value.toInt()) {
                              case 0:
                                return const Text('Kering');
                              case 1:
                                return const Text('Optimal');
                              case 2:
                                return const Text('Terlalu Lembap');
                              default:
                                return const Text('');
                            }
                          },
                        ),
                      ),
                    ),
                    barGroups: [
                      BarChartGroupData(
                        x: 0,
                        barRods: [
                          BarChartRodData(
                            toY: jmlKering.toDouble(),
                            color: Colors.orange,
                            width: 24,
                          ),
                        ],
                      ),
                      BarChartGroupData(
                        x: 1,
                        barRods: [
                          BarChartRodData(
                            toY: jmlOptimal.toDouble(),
                            color: Colors.green,
                            width: 24,
                          ),
                        ],
                      ),
                      BarChartGroupData(
                        x: 2,
                        barRods: [
                          BarChartRodData(
                            toY: jmlLembap.toDouble(),
                            color: Colors.blue,
                            width: 24,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
