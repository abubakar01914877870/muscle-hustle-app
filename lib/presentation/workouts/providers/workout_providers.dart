import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../data/models/workout_model.dart';
import '../../../../data/repositories/workout_repository.dart';
import '../../../../data/remote/workout_remote_data_source.dart';
import '../../auth/providers/auth_provider.dart';

// Remote data source provider
final workoutRemoteDataSourceProvider = Provider<WorkoutRemoteDataSource>((
  ref,
) {
  final apiClient = ref.read(apiClientProvider);
  return WorkoutRemoteDataSourceImpl(apiClient);
});

// Repository provider
final workoutRepositoryProvider = Provider<WorkoutRepository>((ref) {
  final remoteDataSource = ref.read(workoutRemoteDataSourceProvider);
  return WorkoutRepository(remoteDataSource);
});

// Workouts state notifier
class WorkoutsNotifier extends StateNotifier<AsyncValue<List<WorkoutModel>>> {
  final WorkoutRepository _repository;

  WorkoutsNotifier(this._repository) : super(const AsyncValue.loading()) {
    loadWorkouts();
  }

  Future<void> loadWorkouts() async {
    try {
      state = const AsyncValue.loading();
      final workouts = await _repository.getWorkouts();
      state = AsyncValue.data(workouts);
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
    }
  }

  Future<void> createWorkout(Map<String, dynamic> data) async {
    try {
      final newWorkout = await _repository.createWorkout(data);
      final currentList = state.value ?? [];
      state = AsyncValue.data([...currentList, newWorkout]);
    } catch (e) {
      rethrow;
    }
  }

  Future<void> updateWorkout(String id, Map<String, dynamic> data) async {
    try {
      final updatedWorkout = await _repository.updateWorkout(id, data);
      final currentList = state.value ?? [];
      // Replace the old workout with updated one
      final newList = currentList
          .map((w) => w.id == id ? updatedWorkout : w)
          .toList();
      state = AsyncValue.data(newList);
    } catch (e) {
      rethrow;
    }
  }

  Future<void> deleteWorkout(String id) async {
    try {
      await _repository.deleteWorkout(id);
      final currentList = state.value ?? [];
      state = AsyncValue.data(currentList.where((w) => w.id != id).toList());
    } catch (e) {
      rethrow;
    }
  }
}

// Workouts list provider
final workoutsProvider =
    StateNotifierProvider<WorkoutsNotifier, AsyncValue<List<WorkoutModel>>>((
      ref,
    ) {
      final repository = ref.watch(workoutRepositoryProvider);
      return WorkoutsNotifier(repository);
    });

// Single workout detail provider
final workoutDetailProvider = FutureProvider.family<WorkoutModel, String>((
  ref,
  id,
) async {
  final repository = ref.watch(workoutRepositoryProvider);
  return repository.getWorkout(id);
});
