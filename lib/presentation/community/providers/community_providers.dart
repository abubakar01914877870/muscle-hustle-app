import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../auth/providers/auth_provider.dart';
import '../../../data/repositories/community_repository.dart';
import '../../../data/models/blog_model.dart';
import '../../../data/models/community_models.dart';

import '../../../data/remote/blog_remote_data_source.dart';
import '../../../data/remote/community_remote_data_source.dart';

part 'community_providers.g.dart';

@riverpod
BlogRepository blogRepository(BlogRepositoryRef ref) {
  final apiClient = ref.watch(apiClientProvider);
  final remoteDataSource = BlogRemoteDataSourceImpl(apiClient);
  return BlogRepository(remoteDataSource);
}

@riverpod
CommunityRepository communityRepository(CommunityRepositoryRef ref) {
  final apiClient = ref.watch(apiClientProvider);
  final remoteDataSource = CommunityRemoteDataSourceImpl(apiClient);
  return CommunityRepository(remoteDataSource);
}

@riverpod
Future<List<BlogPost>> blogPosts(BlogPostsRef ref) async {
  final repository = ref.watch(blogRepositoryProvider);
  return repository.getPosts();
}

@riverpod
Future<List<GymModel>> gyms(GymsRef ref) async {
  final repository = ref.watch(communityRepositoryProvider);
  return repository.getGyms();
}

@riverpod
Future<List<TrainerModel>> trainers(TrainersRef ref) async {
  final repository = ref.watch(communityRepositoryProvider);
  return repository.getTrainers();
}
