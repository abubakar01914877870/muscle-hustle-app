import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/theme/app_theme.dart';
import '../../../data/models/workout_model.dart';
import 'providers/workout_providers.dart';
import 'create_workout_screen.dart';
import '../exercises/widgets/exercise_quick_view_sheet.dart';

class WorkoutDetailScreen extends ConsumerWidget {
  final WorkoutModel workout;

  const WorkoutDetailScreen({super.key, required this.workout});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // In a real app we might want to fetch fresh details, but passing object is fine for now
    // If we need exercises details (sets/reps), we might need to fetch if not in list model

    // For now, let's assume we might need to fetch details to get specific exercises list if not loaded
    // But our API list_plans returns everything (unlikely for large lists) or just summary.
    // Our get_plan API returns 'exercises' list. list_plans returns basic info.
    // So we should fetch details here.

    final workoutDetailAsync = ref.watch(workoutDetailProvider(workout.id));

    return Scaffold(
      body: workoutDetailAsync.when(
        data: (workoutDetails) {
          // Use the fetched details which includes exercises
          return _buildContent(context, ref, workoutDetails);
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, stack) => Scaffold(
          appBar: AppBar(),
          body: Center(child: Text('Error: $err')),
        ),
      ),
    );
  }

  Widget _buildContent(
    BuildContext context,
    WidgetRef ref,
    WorkoutModel workout,
  ) {
    return CustomScrollView(
      slivers: [
        // AppBar with Image
        SliverAppBar(
          expandedHeight: 200,
          pinned: true,
          flexibleSpace: FlexibleSpaceBar(
            title: Text(workout.name),
            background: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    AppColors.primary,
                    AppColors.primary.withOpacity(0.7),
                  ],
                ),
              ),
              child: const Center(
                child: Icon(
                  Icons.fitness_center,
                  size: 80,
                  color: Colors.white24,
                ),
              ),
            ),
          ),
          actions: [
            IconButton(
              icon: const Icon(Icons.edit),
              onPressed: () {
                Navigator.of(context)
                    .push(
                      MaterialPageRoute(
                        builder: (_) => CreateWorkoutScreen(
                          editingWorkout: workout, // Pass current workout
                        ),
                      ),
                    )
                    .then((_) {
                      // Refresh details when back
                      ref.refresh(workoutDetailProvider(workout.id));
                    });
              },
            ),
            IconButton(
              icon: const Icon(Icons.delete),
              onPressed: () async {
                final confirm = await showDialog<bool>(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: const Text('Delete Workout'),
                    content: const Text(
                      'Are you sure you want to delete this workout plan?',
                    ),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(context, false),
                        child: const Text('Cancel'),
                      ),
                      TextButton(
                        onPressed: () => Navigator.pop(context, true),
                        style: TextButton.styleFrom(
                          foregroundColor: Colors.red,
                        ),
                        child: const Text('Delete'),
                      ),
                    ],
                  ),
                );

                if (confirm == true) {
                  await ref
                      .read(workoutsProvider.notifier)
                      .deleteWorkout(workout.id);
                  if (context.mounted) {
                    Navigator.pop(context); // Go back to list
                  }
                }
              },
            ),
          ],
        ),

        // Content
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Stats Row
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _buildStatItem(
                      Icons.timer,
                      '${workout.duration} min',
                      'Duration',
                    ),
                    _buildStatItem(
                      Icons.fitness_center,
                      '${workout.exercises?.length ?? 0}',
                      'Exercises',
                    ),
                    _buildStatItem(
                      Icons.bar_chart,
                      workout.difficulty,
                      'Level',
                    ),
                  ],
                ),
                const SizedBox(height: 24),

                if (workout.description != null) ...[
                  const Text('Description', style: AppTextStyles.h3),
                  const SizedBox(height: 8),
                  Text(workout.description!, style: AppTextStyles.body),
                  const SizedBox(height: 24),
                ],

                const Text('Exercises', style: AppTextStyles.h3),
                const SizedBox(height: 16),
              ],
            ),
          ),
        ),

        // Exercises List
        if (workout.exercises != null && workout.exercises!.isNotEmpty)
          SliverList(
            delegate: SliverChildBuilderDelegate((context, index) {
              final exercise = workout.exercises![index];
              return ListTile(
                leading: CircleAvatar(
                  backgroundColor: AppColors.secondary.withOpacity(0.2),
                  child: Text('${index + 1}'),
                ),
                title: Text(exercise.name),
                subtitle: Text(exercise.muscleGroup ?? ''),
                onTap: () {
                  showModalBottomSheet(
                    context: context,
                    isScrollControlled: true,
                    useSafeArea: true,
                    builder: (context) =>
                        ExerciseQuickViewSheet(exercise: exercise),
                  );
                },
              );
            }, childCount: workout.exercises!.length),
          )
        else
          const SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.all(16),
              child: Text('No exercises in this plan.'),
            ),
          ),

        const SliverToBoxAdapter(child: SizedBox(height: 80)), // Fab space
      ],
    );
  }

  Widget _buildStatItem(IconData icon, String value, String label) {
    return Column(
      children: [
        Icon(icon, color: AppColors.primary),
        const SizedBox(height: 4),
        Text(
          value,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
        Text(label, style: const TextStyle(color: Colors.grey, fontSize: 12)),
      ],
    );
  }
}
