import 'package:dio/dio.dart';
import '../../core/network/api_client.dart';
import '../../core/constants/api_constants.dart';
import '../models/blog_model.dart';

abstract class BlogRemoteDataSource {
  Future<List<BlogPost>> getPosts({int page = 1, int perPage = 10});
  Future<BlogPost> getPost(String id);
}

class BlogRemoteDataSourceImpl implements BlogRemoteDataSource {
  final ApiClient _apiClient;

  BlogRemoteDataSourceImpl(this._apiClient);

  @override
  Future<List<BlogPost>> getPosts({int page = 1, int perPage = 10}) async {
    try {
      final response = await _apiClient.dio.get(
        '${ApiConstants.blog}/posts',
        queryParameters: {'page': page, 'per_page': perPage},
      );

      final data = response.data['data']['posts'] as List;
      return data.map((json) => BlogPost.fromJson(json)).toList();
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  @override
  Future<BlogPost> getPost(String id) async {
    try {
      final response = await _apiClient.dio.get(
        '${ApiConstants.blog}/posts/$id',
      );
      return BlogPost.fromJson(response.data['data']);
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  String _handleError(DioException e) {
    // Basic error handling, reuse from auth or extract to utility
    return e.message ?? 'Unknown error';
  }
}
