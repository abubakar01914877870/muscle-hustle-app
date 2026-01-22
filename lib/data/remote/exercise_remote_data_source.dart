import 'package:dio/dio.dart';
import '../../core/constants/api_constants.dart';
import '../../core/network/api_client.dart';
import '../models/exercise_model.dart';

abstract class ExerciseRemoteDataSource {
  Future<List<ExerciseModel>> getExercises({
    String? muscleGroup,
    String? category,
    String? search,
    int page = 1,
    int limit = 20,
  });
}

class ExerciseRemoteDataSourceImpl implements ExerciseRemoteDataSource {
  final ApiClient _apiClient;

  ExerciseRemoteDataSourceImpl(this._apiClient);

  @override
  Future<List<ExerciseModel>> getExercises({
    String? muscleGroup,
    String? category,
    String? search,
    int page = 1,
    int limit = 20,
  }) async {
    try {
      final Map<String, dynamic> queryParams = {
        'page': page,
        'limit': limit,
      };
      if (muscleGroup != null && muscleGroup != 'All') {
        queryParams['muscle_group'] = muscleGroup;
      }
      if (category != null) {
        queryParams['category'] = category;
      }
      if (search != null && search.isNotEmpty) {
        queryParams['search'] = search;
      }

      final response = await _apiClient.dio.get(
        ApiConstants.exercisesPublic,
        queryParameters: queryParams,
      );

      final List<dynamic> data = response.data['exercises'];
      return data.map((json) => ExerciseModel.fromJson(json)).toList();
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
