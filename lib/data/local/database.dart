import 'dart:io';
import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;

part 'database.g.dart';

/// Users Table
class Users extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get serverId => text().nullable()(); // ID from server
  TextColumn get username => text()();
  TextColumn get email => text()();
  TextColumn get role => text().withDefault(const Constant('user'))();
  TextColumn get profileData => text().nullable()(); // JSON string
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
  DateTimeColumn get updatedAt => dateTime().withDefault(currentDateAndTime)();
  DateTimeColumn get lastSyncedAt => dateTime().nullable()();
}

/// Workouts Table
class Workouts extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get serverId => text().nullable()();
  TextColumn get name => text()();
  TextColumn get description => text().nullable()();
  DateTimeColumn get scheduledDate => dateTime().nullable()();
  BoolColumn get isCompleted => boolean().withDefault(const Constant(false))();
  BoolColumn get isRestDay => boolean().withDefault(const Constant(false))();
  IntColumn get userId => integer().nullable()();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
  DateTimeColumn get updatedAt => dateTime().withDefault(currentDateAndTime)();
  DateTimeColumn get lastSyncedAt => dateTime().nullable()();
  BoolColumn get isDeleted => boolean().withDefault(const Constant(false))();
  
  @override
  List<Set<Column>> get uniqueKeys => [
    {scheduledDate, name}, // Prevent duplicate workouts on same date
  ];
}

/// Exercises Table
class Exercises extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get serverId => text().nullable()();
  TextColumn get name => text()();
  TextColumn get description => text().nullable()();
  TextColumn get category => text().nullable()();
  TextColumn get muscleGroup => text().nullable()();
  TextColumn get equipment => text().nullable()();
  TextColumn get instructions => text().nullable()();
  TextColumn get imageUrl => text().nullable()();
  TextColumn get videoUrl => text().nullable()();
  BoolColumn get isCustom => boolean().withDefault(const Constant(false))();
  IntColumn get userId => integer().nullable()();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
  DateTimeColumn get updatedAt => dateTime().withDefault(currentDateAndTime)();
  DateTimeColumn get lastSyncedAt => dateTime().nullable()();
  BoolColumn get isDeleted => boolean().withDefault(const Constant(false))();
}

/// Workout Exercises (Junction Table)
class WorkoutExercises extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get workoutId => integer()();
  IntColumn get exerciseId => integer()();
  IntColumn get sets => integer().withDefault(const Constant(3))();
  IntColumn get reps => integer().withDefault(const Constant(10))();
  TextColumn get weight => text().nullable()();
  IntColumn get orderIndex => integer().withDefault(const Constant(0))();
  BoolColumn get isCompleted => boolean().withDefault(const Constant(false))();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
}

/// Progress Entries Table
class ProgressEntries extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get serverId => text().nullable()();
  IntColumn get userId => integer()();
  RealColumn get weight => real().nullable()();
  RealColumn get bodyFat => real().nullable()();
  TextColumn get measurements => text().nullable()(); // JSON string
  TextColumn get notes => text().nullable()();
  TextColumn get photoUrl => text().nullable()();
  TextColumn get localPhotoPath => text().nullable()();
  DateTimeColumn get recordedDate => dateTime().withDefault(currentDateAndTime)();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
  DateTimeColumn get updatedAt => dateTime().withDefault(currentDateAndTime)();
  DateTimeColumn get lastSyncedAt => dateTime().nullable()();
  BoolColumn get isDeleted => boolean().withDefault(const Constant(false))();
}

/// Diet Plans Table
class DietPlans extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get serverId => text().nullable()();
  IntColumn get userId => integer()();
  TextColumn get name => text()();
  TextColumn get description => text().nullable()();
  IntColumn get dayOfWeek => integer()(); // 1-7 (Monday-Sunday)
  TextColumn get meals => text(); // JSON string with meal details
  IntColumn get totalCalories => integer().nullable()();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
  DateTimeColumn get updatedAt => dateTime().withDefault(currentDateAndTime)();
  DateTimeColumn get lastSyncedAt => dateTime().nullable()();
  BoolColumn get isDeleted => boolean().withDefault(const Constant(false))();
}

/// Pending Changes Table (for offline sync queue)
class PendingChanges extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get tableName => text()();
  IntColumn get recordId => integer()();
  TextColumn get operation => text()(); // 'create', 'update', 'delete'
  TextColumn get data => text(); // JSON string
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
  IntColumn get retryCount => integer().withDefault(const Constant(0))();
}

/// Sync Metadata Table
class SyncMetadata extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get tableName => text().unique()();
  DateTimeColumn get lastSyncedAt => dateTime()();
}

/// Main Database Class
@DriftDatabase(tables: [
  Users,
  Workouts,
  Exercises,
  WorkoutExercises,
  ProgressEntries,
  DietPlans,
  PendingChanges,
  SyncMetadata,
])
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());

  @override
  int get schemaVersion => 1;

  @override
  MigrationStrategy get migration => MigrationStrategy(
    onCreate: (Migrator m) async {
      await m.createAll();
    },
    onUpgrade: (Migrator m, int from, int to) async {
      // Handle future migrations here
    },
  );
}

/// Open database connection
LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    final dbFolder = await getApplicationDocumentsDirectory();
    final file = File(p.join(dbFolder.path, 'muscle_hustle.db'));
    return NativeDatabase(file);
  });
}
