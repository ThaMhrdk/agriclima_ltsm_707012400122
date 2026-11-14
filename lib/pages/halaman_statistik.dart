import 'dart:math';

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
        final maxJumlah = max(jmlKering, max(jmlOptimal, jmlLembap));
        final maxY = (maxJumlah < 5 ? 5 : maxJumlah + 1).toDouble();
        final intervalY = maxY <= 10 ? 1.0 : (maxY / 5).ceilToDouble();

        return Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Jumlah Prediksi per Status Mikroklimat',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: colorScheme.onSurface,
                ),
              ),
              const SizedBox(height: 16),
              Expanded(
                child: BarChart(
                  BarChartData(
                    minY: 0,
                    maxY: maxY,
                    titlesData: FlTitlesData(
                      topTitles: const AxisTitles(
                        sideTitles: SideTitles(showTitles: false),
                      ),
                      rightTitles: const AxisTitles(
                        sideTitles: SideTitles(showTitles: false),
                      ),
                      leftTitles: AxisTitles(
                        sideTitles: SideTitles(
                          showTitles: true,
                          reservedSize: 28,
                          interval: intervalY,
                          getTitlesWidget: (value, meta) {
                            if (value % 1 != 0) {
                              return const SizedBox.shrink();
                            }
                            return Text(
                              '${value.toInt()}',
                              style: TextStyle(
                                fontSize: 12,
                                color: colorScheme.onSurfaceVariant,
                              ),
                            );
                          },
                        ),
                      ),
                      bottomTitles: AxisTitles(
                        sideTitles: SideTitles(
                          showTitles: true,
                          reservedSize: 30,
                          getTitlesWidget: (value, meta) {
                            String label;
                            switch (value.toInt()) {
                              case 0:
                                label = 'Kering';
                                break;
                              case 1:
                                label = 'Optimal';
                                break;
                              case 2:
                                label = 'Terlalu Lembap';
                                break;
                              default:
                                label = '';
                            }
                            return Padding(
                              padding: const EdgeInsets.only(top: 6),
                              child: Text(
                                label,
                                style: TextStyle(
                                  fontSize: 12,
                                  color: colorScheme.onSurface,
                                ),
                              ),
                            );
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
