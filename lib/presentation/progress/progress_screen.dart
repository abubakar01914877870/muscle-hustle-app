import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fl_chart/fl_chart.dart';
import '../../core/theme/app_theme.dart';
import '../auth/providers/auth_provider.dart';
import '../../core/constants/api_constants.dart';

class ProgressScreen extends ConsumerWidget {
  const ProgressScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final apiClient = ref.watch(apiClientProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Progress Tracking')),
      body: FutureBuilder(
        future: apiClient.dio.get(ApiConstants.progress),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          final entries = snapshot.data?.data['entries'] as List? ?? [];

          if (entries.isEmpty) {
            return const Center(child: Text('No progress entries found'));
          }

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Weight Progress', style: AppTextStyles.h2),
                const SizedBox(height: 24),
                SizedBox(
                  height: 300,
                  child: LineChart(
                    LineChartData(
                      gridData: const FlGridData(show: false),
                      titlesData: const FlTitlesData(show: false),
                      borderData: FlBorderData(show: false),
                      lineBarsData: [
                        LineChartBarData(
                          spots: entries.asMap().entries.map((e) {
                            final weight = e.value['weight']?.toDouble() ?? 0.0;
                            return FlSpot(e.key.toDouble(), weight);
                          }).toList(),
                          isCurved: true,
                          color: AppColors.primary,
                          barWidth: 4,
                          belowBarData: BarAreaData(
                            show: true,
                            color: AppColors.primary.withOpacity(0.1),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 32),
                const Text('History', style: AppTextStyles.h3),
                const SizedBox(height: 16),
                ...entries
                    .map(
                      (entry) => Card(
                        margin: const EdgeInsets.only(bottom: 12),
                        child: ListTile(
                          leading: const CircleAvatar(
                            backgroundColor: AppColors.primary,
                            child: Icon(
                              Icons.monitor_weight,
                              color: Colors.white,
                            ),
                          ),
                          title: Text('${entry['weight']} kg'),
                          subtitle: Text(
                            entry['recorded_date']?.split('T')[0] ?? '',
                          ),
                          trailing: entry['body_fat'] != null
                              ? Text('${entry['body_fat']}% BF')
                              : null,
                        ),
                      ),
                    )
                    .toList(),
              ],
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // TODO: Add new entry
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
