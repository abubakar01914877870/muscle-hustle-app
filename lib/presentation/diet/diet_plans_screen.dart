import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/theme/app_theme.dart';
import '../auth/providers/auth_provider.dart';
import '../../core/constants/api_constants.dart';

class DietPlansScreen extends ConsumerWidget {
  const DietPlansScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final apiClient = ref.watch(apiClientProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('My Diet Plans')),
      body: FutureBuilder(
        future: apiClient.dio.get(ApiConstants.dietPlans),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          final plans = snapshot.data?.data['plans'] as List? ?? [];

          if (plans.isEmpty) {
            return const Center(child: Text('No diet plans found'));
          }

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: plans.length,
            itemBuilder: (context, index) {
              final plan = plans[index];
              return Card(
                margin: const EdgeInsets.only(bottom: 16),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(plan['name'], style: AppTextStyles.h3),
                          Text(
                            '${plan['total_calories']} kcal',
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              color: AppColors.primary,
                            ),
                          ),
                        ],
                      ),
                      const Divider(height: 24),
                      ...(plan['meals'] as List)
                          .map(
                            (meal) => Padding(
                              padding: const EdgeInsets.only(bottom: 8),
                              child: Row(
                                children: [
                                  const Icon(
                                    Icons.restaurant_menu,
                                    size: 16,
                                    color: AppColors.grey400,
                                  ),
                                  const SizedBox(width: 8),
                                  Expanded(
                                    child: Text(
                                      meal['name'],
                                      style: AppTextStyles.bodySmall,
                                    ),
                                  ),
                                  Text(
                                    '${meal['calories']} kcal',
                                    style: AppTextStyles.caption,
                                  ),
                                ],
                              ),
                            ),
                          )
                          .toList(),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
