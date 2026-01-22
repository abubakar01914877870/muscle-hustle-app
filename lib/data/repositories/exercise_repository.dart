import '../models/exercise_model.dart';
import '../remote/exercise_remote_data_source.dart';

class ExerciseRepository {
  final ExerciseRemoteDataSource _remoteDataSource;

  ExerciseRepository(this._remoteDataSource);

  Future<List<ExerciseModel>> getExercises({
    String? muscleGroup,
    String? category,
    String? search,
  }) async {
    return await _remoteDataSource.getExercises(
      muscleGroup: muscleGroup,
      category: category,
      search: search,
    );
  }
}
