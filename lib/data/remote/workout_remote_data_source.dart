import 'package:dio/dio.dart';
import '../../core/constants/api_constants.dart';
import '../../core/network/api_client.dart';
import '../models/workout_model.dart';

abstract class WorkoutRemoteDataSource {
  Future<List<WorkoutModel>> getWorkouts();
  Future<WorkoutModel> getWorkout(String id);
  Future<WorkoutModel> createWorkout(Map<String, dynamic> data);
  Future<WorkoutModel> updateWorkout(String id, Map<String, dynamic> data);
  Future<void> deleteWorkout(String id);
}

class WorkoutRemoteDataSourceImpl implements WorkoutRemoteDataSource {
  final ApiClient _apiClient;

  WorkoutRemoteDataSourceImpl(this._apiClient);

  @override
  Future<List<WorkoutModel>> getWorkouts() async {
    try {
      final response = await _apiClient.dio.get('/plans');
      final List<dynamic> data = response.data['plans'];
      return data.map((json) => WorkoutModel.fromJson(json)).toList();
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  @override
  Future<WorkoutModel> getWorkout(String id) async {
    try {
      final response = await _apiClient.dio.get('/plans/$id');
      return WorkoutModel.fromJson(response.data['plan']);
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  @override
  Future<WorkoutModel> createWorkout(Map<String, dynamic> data) async {
    try {
      final response = await _apiClient.dio.post('/plans', data: data);
      return WorkoutModel.fromJson(response.data['plan']);
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  @override
  Future<WorkoutModel> updateWorkout(
    String id,
    Map<String, dynamic> data,
  ) async {
    try {
      final response = await _apiClient.dio.put('/plans/$id', data: data);
      return WorkoutModel.fromJson(response.data['plan']);
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  @override
  Future<void> deleteWorkout(String id) async {
    try {
      await _apiClient.dio.delete('/plans/$id');
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  Exception _handleError(DioException e) {
    if (e.response != null) {
      final message = e.response?.data['error'] ?? 'Unknown error';
      return Exception(message);
    }
    return Exception('Network error: ${e.message}');
  }
}
