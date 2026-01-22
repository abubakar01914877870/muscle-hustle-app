import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../auth/providers/auth_provider.dart';
import '../../../core/constants/api_constants.dart';

part 'planner_provider.g.dart';

@riverpod
Future<Map<String, dynamic>> plannerAssignments(
  PlannerAssignmentsRef ref, {
  required DateTime start,
  required DateTime end,
}) async {
  final apiClient = ref.watch(apiClientProvider);
  final dio = apiClient.dio;

  final startStr =
      "${start.year}-${start.month.toString().padLeft(2, '0')}-${start.day.toString().padLeft(2, '0')}";
  final endStr =
      "${end.year}-${end.month.toString().padLeft(2, '0')}-${end.day.toString().padLeft(2, '0')}";

  final response = await dio.get(
    ApiConstants.planner + '/assignments',
    queryParameters: {'start_date': startStr, 'end_date': endStr},
  );

  if (response.data['status'] == 'success') {
    return response.data['data'];
  }
  throw Exception(response.data['message'] ?? 'Failed to load assignments');
}
