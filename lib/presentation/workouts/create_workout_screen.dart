import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/theme/app_theme.dart';
import '../../../data/models/exercise_model.dart';
import '../../../data/models/workout_model.dart';
import 'providers/workout_providers.dart';
import '../exercises/providers/exercise_provider.dart';

class CreateWorkoutScreen extends ConsumerStatefulWidget {
  final WorkoutModel? editingWorkout;
  const CreateWorkoutScreen({super.key, this.editingWorkout});

  @override
  ConsumerState<CreateWorkoutScreen> createState() =>
      _CreateWorkoutScreenState();
}

class _CreateWorkoutScreenState extends ConsumerState<CreateWorkoutScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _durationController = TextEditingController();

  String _difficulty = 'Beginner';
  final List<String> _difficulties = ['Beginner', 'Intermediate', 'Advanced'];

  // Selected exercises
  final List<ExerciseModel> _selectedExercises = [];
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    if (widget.editingWorkout != null) {
      final w = widget.editingWorkout!;
      _nameController.text = w.name;
      _descriptionController.text = w.description ?? '';
      _durationController.text = w.duration.toString();
      _difficulty = w.difficulty;
      if (w.exercises != null) {
        _selectedExercises.addAll(w.exercises!);
      }
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    _durationController.dispose();
    super.dispose();
  }

  Future<void> _saveWorkout() async {
    if (!_formKey.currentState!.validate()) return;
    if (_selectedExercises.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select at least one exercise')),
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      final workoutData = {
        'name': _nameController.text.trim(),
        'description': _descriptionController.text.trim(),
        'duration': int.tryParse(_durationController.text) ?? 30,
        'difficulty': _difficulty,
        'exercise_ids': _selectedExercises.map((e) => e.id).toList(),
      };

      if (widget.editingWorkout != null) {
        // Update existing
        await ref
            .read(workoutsProvider.notifier)
            .updateWorkout(widget.editingWorkout!.id, workoutData);
      } else {
        // Create new
        await ref.read(workoutsProvider.notifier).createWorkout(workoutData);
      }

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              widget.editingWorkout != null
                  ? 'Workout updated!'
                  : 'Workout created!',
            ),
          ),
        );
        Navigator.pop(context); // Go back
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Failed to save workout: $e')));
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  void _showExercisePicker() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      builder: (context) => _ExercisePickerSheet(
        alreadySelected: _selectedExercises,
        onExercisesSelected: (exercises) {
          setState(() {
            _selectedExercises.clear();
            _selectedExercises.addAll(exercises);
          });
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.editingWorkout != null ? 'Edit Workout' : 'Create New Workout',
        ),
        actions: [
          TextButton(
            onPressed: _isLoading ? null : _saveWorkout,
            child: _isLoading
                ? const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : const Text('Save', style: TextStyle(fontSize: 16)),
          ),
        ],
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            // Name
            TextFormField(
              controller: _nameController,
              decoration: const InputDecoration(
                labelText: 'Workout Name',
                hintText: 'e.g., Upper Body Power',
                prefixIcon: Icon(Icons.fitness_center),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter a name';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),

            // Description
            TextFormField(
              controller: _descriptionController,
              decoration: const InputDecoration(
                labelText: 'Description',
                hintText: 'Brief description of the workout',
                prefixIcon: Icon(Icons.description),
              ),
              maxLines: 2,
            ),
            const SizedBox(height: 16),

            // Duration and Difficulty Row
            Row(
              children: [
                Expanded(
                  child: TextFormField(
                    controller: _durationController,
                    decoration: const InputDecoration(
                      labelText: 'Duration (min)',
                      hintText: '45',
                      prefixIcon: Icon(Icons.timer),
                    ),
                    keyboardType: TextInputType.number,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: DropdownButtonFormField<String>(
                    value: _difficulty,
                    decoration: const InputDecoration(
                      labelText: 'Difficulty',
                      prefixIcon: Icon(Icons.bar_chart),
                    ),
                    items: _difficulties.map((level) {
                      return DropdownMenuItem(value: level, child: Text(level));
                    }).toList(),
                    onChanged: (value) {
                      if (value != null) setState(() => _difficulty = value);
                    },
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),

            // Exercises Section Header
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Exercises (${_selectedExercises.length})',
                  style: AppTextStyles.h3,
                ),
                TextButton.icon(
                  onPressed: _showExercisePicker,
                  icon: const Icon(Icons.add),
                  label: const Text('Add Exercise'),
                ),
              ],
            ),
            const SizedBox(height: 8),

            // Selected Exercises List
            if (_selectedExercises.isEmpty)
              Container(
                padding: const EdgeInsets.all(32),
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: Colors.grey.shade50,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.grey.shade200),
                ),
                child: const Column(
                  children: [
                    Icon(
                      Icons.add_circle_outline,
                      size: 48,
                      color: Colors.grey,
                    ),
                    SizedBox(height: 8),
                    Text(
                      'Add exercises to your workout',
                      style: TextStyle(color: Colors.grey),
                    ),
                  ],
                ),
              )
            else
              ReorderableListView(
                buildDefaultDragHandles: false, // We use custom handle
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                onReorder: (oldIndex, newIndex) {
                  setState(() {
                    if (oldIndex < newIndex) {
                      newIndex -= 1;
                    }
                    final item = _selectedExercises.removeAt(oldIndex);
                    _selectedExercises.insert(newIndex, item);
                  });
                },
                children: [
                  for (
                    int index = 0;
                    index < _selectedExercises.length;
                    index++
                  )
                    ListTile(
                      key: ValueKey(_selectedExercises[index].id),
                      contentPadding: EdgeInsets.zero,
                      leading: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: AppColors.primary.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Icon(
                          Icons.fitness_center,
                          color: AppColors.primary,
                          size: 20,
                        ),
                      ),
                      title: Text(
                        _selectedExercises[index].name,
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      subtitle: Text(
                        _selectedExercises[index].muscleGroup ?? 'General',
                      ),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          // Delete Button
                          IconButton(
                            icon: const Icon(
                              Icons.delete_outline,
                              color: Colors.red,
                            ),
                            onPressed: () {
                              setState(() {
                                _selectedExercises.removeAt(index);
                              });
                            },
                          ),
                          // Drag Handle
                          ReorderableDragStartListener(
                            index: index,
                            child: const Padding(
                              padding: EdgeInsets.symmetric(horizontal: 8),
                              child: Icon(
                                Icons.drag_handle,
                                color: Colors.grey,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                ],
              ),
          ],
        ),
      ),
    );
  }
}

class _ExercisePickerSheet extends ConsumerStatefulWidget {
  final Function(List<ExerciseModel>) onExercisesSelected;
  final List<ExerciseModel> alreadySelected;

  const _ExercisePickerSheet({
    required this.onExercisesSelected,
    required this.alreadySelected,
  });

  @override
  ConsumerState<_ExercisePickerSheet> createState() =>
      _ExercisePickerSheetState();
}

class _ExercisePickerSheetState extends ConsumerState<_ExercisePickerSheet> {
  final List<ExerciseModel> _tempSelected = [];
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // Pre-select exercises that are already in the workout
    _tempSelected.addAll(widget.alreadySelected);
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final exercisesAsync = ref.watch(exercisesProvider);

    return Container(
      height: MediaQuery.of(context).size.height * 0.8,
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Select Exercises', style: AppTextStyles.h3),
              TextButton(
                onPressed: () {
                  widget.onExercisesSelected(_tempSelected);
                  Navigator.pop(context);
                },
                child: Text('Done (${_tempSelected.length})'),
              ),
            ],
          ),
          // Search Field
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Search exercises...',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                contentPadding: const EdgeInsets.symmetric(horizontal: 16),
              ),
              onChanged: (value) => setState(() {}),
            ),
          ),
          const Divider(),
          Expanded(
            child: exercisesAsync.when(
              data: (exercises) {
                // Filter exercises
                final query = _searchController.text.toLowerCase();
                final filteredExercises = exercises.where((e) {
                  return e.name.toLowerCase().contains(query) ||
                      (e.muscleGroup?.toLowerCase().contains(query) ?? false);
                }).toList();

                if (filteredExercises.isEmpty) {
                  return const Center(child: Text('No exercises found'));
                }
                return ListView.builder(
                  itemCount: filteredExercises.length,
                  itemBuilder: (context, index) {
                    final exercise = filteredExercises[index];
                    final isSelected = _tempSelected.any(
                      (e) => e.id == exercise.id,
                    );
                    return CheckboxListTile(
                      title: Text(exercise.name),
                      subtitle: Text(exercise.muscleGroup ?? ''),
                      value: isSelected,
                      onChanged: (bool? value) {
                        setState(() {
                          if (value == true) {
                            if (!_tempSelected.any(
                              (e) => e.id == exercise.id,
                            )) {
                              _tempSelected.add(exercise);
                            }
                          } else {
                            _tempSelected.removeWhere(
                              (e) => e.id == exercise.id,
                            );
                          }
                        });
                      },
                    );
                  },
                );
              },
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (err, stack) => Center(child: Text('Error: $err')),
            ),
          ),
        ],
      ),
    );
  }
}
