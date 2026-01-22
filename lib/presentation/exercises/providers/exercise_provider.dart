import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../data/models/exercise_model.dart';
import '../../../data/repositories/exercise_repository.dart';
import '../../../data/remote/exercise_remote_data_source.dart';
import '../../auth/providers/auth_provider.dart';

// Remote data source provider
final exerciseRemoteDataSourceProvider = Provider<ExerciseRemoteDataSource>((
  ref,
) {
  final apiClient = ref.read(apiClientProvider);
  return ExerciseRemoteDataSourceImpl(apiClient);
});

// Repository provider
final exerciseRepositoryProvider = Provider<ExerciseRepository>((ref) {
  final remoteDataSource = ref.read(exerciseRemoteDataSourceProvider);
  return ExerciseRepository(remoteDataSource);
});

// Exercises state notifier
class ExercisesNotifier extends StateNotifier<AsyncValue<List<ExerciseModel>>> {
  final ExerciseRepository _repository;

  ExercisesNotifier(this._repository) : super(const AsyncValue.loading()) {
    loadExercises();
  }

  Future<void> loadExercises({
    String? muscleGroup,
    String? category,
    String? search,
    int page = 1,
    int limit = 20,
  }) async {
    try {
      state = const AsyncValue.loading();
      final exercises = await _repository.getExercises(
        muscleGroup: muscleGroup,
        category: category,
        search: search,
        page: page,
        limit: limit,
      );
      state = AsyncValue.data(exercises);
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
    }
  }
}

// Exercises list provider
final exercisesProvider =
    StateNotifierProvider<ExercisesNotifier, AsyncValue<List<ExerciseModel>>>((
      ref,
    ) {
      final repository = ref.watch(exerciseRepositoryProvider);
      return ExercisesNotifier(repository);
    });
