import 'package:dio/dio.dart';
import '../../core/network/api_client.dart';
import '../../core/constants/api_constants.dart';
import '../models/community_models.dart';

abstract class CommunityRemoteDataSource {
  Future<List<GymModel>> getGyms();
  Future<GymModel> getGym(String id);
  Future<List<TrainerModel>> getTrainers();
  Future<TrainerModel> getTrainer(String id);
}

class CommunityRemoteDataSourceImpl implements CommunityRemoteDataSource {
  final ApiClient _apiClient;

  CommunityRemoteDataSourceImpl(this._apiClient);

  @override
  Future<List<GymModel>> getGyms() async {
    try {
      final response = await _apiClient.dio.get(
        '${ApiConstants.community}/gyms',
      );
      final data = response.data['data'] as List;
      return data.map((json) => GymModel.fromJson(json)).toList();
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  @override
  Future<GymModel> getGym(String id) async {
    try {
      final response = await _apiClient.dio.get(
        '${ApiConstants.community}/gyms/$id',
      );
      return GymModel.fromJson(response.data['data']);
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  @override
  Future<List<TrainerModel>> getTrainers() async {
    try {
      final response = await _apiClient.dio.get(
        '${ApiConstants.community}/trainers',
      );
      final data = response.data['data'] as List;
      return data.map((json) => TrainerModel.fromJson(json)).toList();
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  @override
  Future<TrainerModel> getTrainer(String id) async {
    try {
      final response = await _apiClient.dio.get(
        '${ApiConstants.community}/trainers/$id',
      );
      return TrainerModel.fromJson(response.data['data']);
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  String _handleError(DioException e) {
    return e.message ?? 'Unknown error';
  }
}
