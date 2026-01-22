import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/theme/app_theme.dart';
import '../auth/providers/auth_provider.dart';
import '../auth/login_screen.dart';
import 'profile_edit_screen.dart';
import 'widgets/stat_card.dart';

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  double? _calculateBMI(double? height, double? weight) {
    if (height == null || weight == null || height == 0) return null;
    // BMI = weight (kg) / (height (m))^2
    final heightInMeters = height / 100;
    return weight / (heightInMeters * heightInMeters);
  }

  String _formatBMI(double? bmi) {
    if (bmi == null) return '-';
    return bmi.toStringAsFixed(1);
  }

  Future<void> _handleLogout(BuildContext context, WidgetRef ref) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Logout'),
        content: const Text('Are you sure you want to logout?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            style: TextButton.styleFrom(foregroundColor: AppColors.error),
            child: const Text('Logout'),
          ),
        ],
      ),
    );

    if (confirmed == true && context.mounted) {
      await ref.read(authProvider.notifier).logout();
      if (context.mounted) {
        Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (_) => const LoginScreen()),
          (route) => false,
        );
      }
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(currentUserProvider);

    if (user == null) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    final bmi = _calculateBMI(user.height, user.weight);

    return Scaffold(
      appBar: AppBar(title: const Text('Profile')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Profile Header
            const SizedBox(height: 16),
            CircleAvatar(
              radius: 60,
              backgroundColor: AppColors.primary.withOpacity(0.1),
              child: user.profilePicture != null
                  ? ClipOval(
                      child: Image.network(
                        user.profilePicture!,
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
                  : Icon(Icons.person, size: 60, color: AppColors.primary),
            ),
            const SizedBox(height: 16),
            Text(user.fullName ?? 'User', style: AppTextStyles.h2),
            const SizedBox(height: 4),
            Text(
              user.email,
              style: AppTextStyles.bodySmall.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
            const SizedBox(height: 16),
            OutlinedButton.icon(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const ProfileEditScreen()),
                );
              },
              icon: const Icon(Icons.edit),
              label: const Text('Edit Profile'),
            ),
            const SizedBox(height: 32),

            // Stats Grid
            GridView.count(
              crossAxisCount: 2,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
              childAspectRatio: 1.2,
              children: [
                StatCard(
                  icon: Icons.monitor_weight_outlined,
                  label: 'Current Weight',
                  value: user.weight != null ? '${user.weight} kg' : '-',
                ),
                StatCard(
                  icon: Icons.height,
                  label: 'Height',
                  value: user.height != null ? '${user.height} cm' : '-',
                ),
                StatCard(
                  icon: Icons.flag_outlined,
                  label: 'Target Weight',
                  value: user.targetWeight != null
                      ? '${user.targetWeight} kg'
                      : '-',
                  iconColor: AppColors.success,
                ),
                StatCard(
                  icon: Icons.analytics_outlined,
                  label: 'BMI',
                  value: _formatBMI(bmi),
                  iconColor: AppColors.secondary,
                ),
              ],
            ),
            const SizedBox(height: 24),

            // Personal Info Section
            Card(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: AppColors.primary,
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(12),
                        topRight: Radius.circular(12),
                      ),
                    ),
                    child: Text(
                      'Personal Info',
                      style: AppTextStyles.h3.copyWith(color: Colors.white),
                    ),
                  ),
                  ListTile(
                    title: const Text('Fitness Level'),
                    trailing: Text(
                      user.fitnessLevel ?? '-',
                      style: AppTextStyles.body.copyWith(
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  const Divider(height: 1),
                  ListTile(
                    title: const Text('Fitness Goal'),
                    trailing: Text(
                      user.fitnessGoal ?? '-',
                      style: AppTextStyles.body.copyWith(
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32),

            // Logout Button
            OutlinedButton.icon(
              onPressed: () => _handleLogout(context, ref),
              icon: const Icon(Icons.logout),
              label: const Text('Logout'),
              style: OutlinedButton.styleFrom(
                foregroundColor: AppColors.error,
                side: BorderSide(color: AppColors.error),
                minimumSize: const Size(double.infinity, 48),
              ),
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}
