import '../models/workout_model.dart';
import '../remote/workout_remote_data_source.dart';

class WorkoutRepository {
  final WorkoutRemoteDataSource _remoteDataSource;

  WorkoutRepository(this._remoteDataSource);

  Future<List<WorkoutModel>> getWorkouts() async {
    return await _remoteDataSource.getWorkouts();
  }

  Future<WorkoutModel> getWorkout(String id) async {
    return await _remoteDataSource.getWorkout(id);
  }

  Future<WorkoutModel> createWorkout(Map<String, dynamic> data) async {
    return await _remoteDataSource.createWorkout(data);
  }

  Future<WorkoutModel> updateWorkout(
    String id,
    Map<String, dynamic> data,
  ) async {
    return await _remoteDataSource.updateWorkout(id, data);
  }

  Future<void> deleteWorkout(String id) async {
    await _remoteDataSource.deleteWorkout(id);
  }
}
