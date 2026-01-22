import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/theme/app_theme.dart';
import '../auth/providers/auth_provider.dart';

class ProfileEditScreen extends ConsumerStatefulWidget {
  const ProfileEditScreen({super.key});

  @override
  ConsumerState<ProfileEditScreen> createState() => _ProfileEditScreenState();
}

class _ProfileEditScreenState extends ConsumerState<ProfileEditScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _heightController = TextEditingController();
  final _weightController = TextEditingController();
  final _targetWeightController = TextEditingController();

  String? _fitnessLevel;
  String? _fitnessGoal;
  bool _isLoading = false;

  final List<String> _fitnessLevels = ['Beginner', 'Intermediate', 'Advanced'];

  final List<String> _fitnessGoals = [
    'Build Muscle',
    'Lose Weight',
    'Get Fit',
    'Maintain',
  ];

  @override
  void initState() {
    super.initState();
    // Pre-fill form with current user data
    final user = ref.read(currentUserProvider);
    if (user != null) {
      _nameController.text = user.fullName ?? '';
      _heightController.text = user.height?.toString() ?? '';
      _weightController.text = user.weight?.toString() ?? '';
      _targetWeightController.text = user.targetWeight?.toString() ?? '';

      // Only set if value exists in dropdown list
      if (user.fitnessLevel != null &&
          _fitnessLevels.contains(user.fitnessLevel)) {
        _fitnessLevel = user.fitnessLevel;
      }
      if (user.fitnessGoal != null &&
          _fitnessGoals.contains(user.fitnessGoal)) {
        _fitnessGoal = user.fitnessGoal;
      }
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _heightController.dispose();
    _weightController.dispose();
    _targetWeightController.dispose();
    super.dispose();
  }

  Future<void> _saveProfile() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      final updateData = <String, dynamic>{};

      if (_nameController.text.isNotEmpty) {
        updateData['full_name'] = _nameController.text;
      }
      if (_heightController.text.isNotEmpty) {
        updateData['height'] = double.parse(_heightController.text);
      }
      if (_weightController.text.isNotEmpty) {
        updateData['weight'] = double.parse(_weightController.text);
      }
      if (_targetWeightController.text.isNotEmpty) {
        updateData['target_weight'] = double.parse(
          _targetWeightController.text,
        );
      }
      if (_fitnessLevel != null) {
        updateData['fitness_level'] = _fitnessLevel;
      }
      if (_fitnessGoal != null) {
        updateData['fitness_goal'] = _fitnessGoal;
      }

      await ref.read(authProvider.notifier).updateProfile(updateData);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Profile updated successfully!'),
            backgroundColor: AppColors.success,
          ),
        );
        Navigator.pop(context);
      }
    } catch (e, stackTrace) {
      // Print error for debugging
      print('Profile update error: $e');
      print('Stack trace: $stackTrace');

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to update profile: $e'),
            backgroundColor: AppColors.error,
            duration: const Duration(seconds: 5),
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authProvider);
    final user = authState.user;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Profile'),
        actions: [
          TextButton(
            onPressed: _isLoading ? null : _saveProfile,
            child: _isLoading
                ? const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : const Text('Save'),
          ),
        ],
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16.0),
          children: [
            // Profile Photo
            Center(
              child: Stack(
                children: [
                  CircleAvatar(
                    radius: 60,
                    backgroundColor: AppColors.primary.withOpacity(0.1),
                    child: user?.profilePicture != null
                        ? ClipOval(
                            child: Image.network(
                              user!.profilePicture!,
                              width: 120,
                              height: 120,
                              fit: BoxFit.cover,
                              errorBuilder: (_, __, ___) => Icon(
                                Icons.person,
                                size: 60,
                                color: AppColors.primary,
                              ),
                            ),
                          )
                        : Icon(
                            Icons.person,
                            size: 60,
                            color: AppColors.primary,
                          ),
                  ),
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: Container(
                      decoration: BoxDecoration(
                        color: AppColors.primary,
                        shape: BoxShape.circle,
                      ),
                      child: IconButton(
                        icon: const Icon(Icons.camera_alt, color: Colors.white),
                        onPressed: () {
                          // TODO: Implement image picker
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Photo upload coming soon!'),
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32),

            // Full Name
            TextFormField(
              controller: _nameController,
              decoration: const InputDecoration(
                labelText: 'Full Name',
                prefixIcon: Icon(Icons.person_outline),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter your name';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),

            // Email (Read-only)
            TextFormField(
              initialValue: user?.email ?? '',
              decoration: const InputDecoration(
                labelText: 'Email',
                prefixIcon: Icon(Icons.email_outlined),
              ),
              enabled: false,
            ),
            const SizedBox(height: 16),

            // Height
            TextFormField(
              controller: _heightController,
              decoration: const InputDecoration(
                labelText: 'Height (cm)',
                prefixIcon: Icon(Icons.height),
                suffixText: 'cm',
              ),
              keyboardType: TextInputType.number,
              validator: (value) {
                if (value != null && value.isNotEmpty) {
                  final height = double.tryParse(value);
                  if (height == null || height <= 0 || height > 300) {
                    return 'Please enter a valid height';
                  }
                }
                return null;
              },
            ),
            const SizedBox(height: 16),

            // Current Weight
            TextFormField(
              controller: _weightController,
              decoration: const InputDecoration(
                labelText: 'Current Weight (kg)',
                prefixIcon: Icon(Icons.monitor_weight_outlined),
                suffixText: 'kg',
              ),
              keyboardType: TextInputType.number,
              validator: (value) {
                if (value != null && value.isNotEmpty) {
                  final weight = double.tryParse(value);
                  if (weight == null || weight <= 0 || weight > 500) {
                    return 'Please enter a valid weight';
                  }
                }
                return null;
              },
            ),
            const SizedBox(height: 16),

            // Target Weight
            TextFormField(
              controller: _targetWeightController,
              decoration: const InputDecoration(
                labelText: 'Target Weight (kg)',
                prefixIcon: Icon(Icons.flag_outlined),
                suffixText: 'kg',
              ),
              keyboardType: TextInputType.number,
              validator: (value) {
                if (value != null && value.isNotEmpty) {
                  final weight = double.tryParse(value);
                  if (weight == null || weight <= 0 || weight > 500) {
                    return 'Please enter a valid weight';
                  }
                }
                return null;
              },
            ),
            const SizedBox(height: 16),

            // Fitness Level
            DropdownButtonFormField<String>(
              value: _fitnessLevel,
              decoration: const InputDecoration(
                labelText: 'Fitness Level',
                prefixIcon: Icon(Icons.fitness_center),
              ),
              items: _fitnessLevels
                  .map(
                    (level) =>
                        DropdownMenuItem(value: level, child: Text(level)),
                  )
                  .toList(),
              onChanged: (value) {
                setState(() => _fitnessLevel = value);
              },
            ),
            const SizedBox(height: 16),

            // Fitness Goal
            DropdownButtonFormField<String>(
              value: _fitnessGoal,
              decoration: const InputDecoration(
                labelText: 'Fitness Goal',
                prefixIcon: Icon(Icons.track_changes),
              ),
              items: _fitnessGoals
                  .map(
                    (goal) => DropdownMenuItem(value: goal, child: Text(goal)),
                  )
                  .toList(),
              onChanged: (value) {
                setState(() => _fitnessGoal = value);
              },
            ),
            const SizedBox(height: 32),

            // Save Button
            ElevatedButton(
              onPressed: _isLoading ? null : _saveProfile,
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
              child: _isLoading
                  ? const SizedBox(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                      ),
                    )
                  : const Text('Save Changes'),
            ),
            const SizedBox(height: 8),

            // Cancel Button
            TextButton(
              onPressed: _isLoading
                  ? null
                  : () {
                      Navigator.pop(context);
                    },
              child: const Text('Cancel'),
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}
