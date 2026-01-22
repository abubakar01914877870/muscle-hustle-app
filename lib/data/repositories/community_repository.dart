import '../remote/blog_remote_data_source.dart';
import '../remote/community_remote_data_source.dart';
import '../models/blog_model.dart';
import '../models/community_models.dart';

class BlogRepository {
  final BlogRemoteDataSource _remoteDataSource;

  BlogRepository(this._remoteDataSource);

  Future<List<BlogPost>> getPosts({int page = 1, int perPage = 10}) async {
    return _remoteDataSource.getPosts(page: page, perPage: perPage);
  }

  Future<BlogPost> getPost(String id) async {
    return _remoteDataSource.getPost(id);
  }
}

class CommunityRepository {
  final CommunityRemoteDataSource _remoteDataSource;

  CommunityRepository(this._remoteDataSource);

  Future<List<GymModel>> getGyms() async {
    return _remoteDataSource.getGyms();
  }

  Future<GymModel> getGym(String id) async {
    return _remoteDataSource.getGym(id);
  }

  Future<List<TrainerModel>> getTrainers() async {
    return _remoteDataSource.getTrainers();
  }

  Future<TrainerModel> getTrainer(String id) async {
    return _remoteDataSource.getTrainer(id);
  }
}
