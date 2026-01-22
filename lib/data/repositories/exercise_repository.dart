import '../models/exercise_model.dart';
import '../remote/exercise_remote_data_source.dart';

class ExerciseRepository {
  final ExerciseRemoteDataSource _remoteDataSource;

  ExerciseRepository(this._remoteDataSource);

  Future<List<ExerciseModel>> getExercises({
    String? muscleGroup,
    String? category,
    String? search,
    int page = 1,
    int limit = 20,
  }) async {
    return await _remoteDataSource.getExercises(
      muscleGroup: muscleGroup,
      category: category,
      search: search,
      page: page,
      limit: limit,
    );
  }
}
