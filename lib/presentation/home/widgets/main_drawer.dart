import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/theme/app_theme.dart';
import '../../auth/providers/auth_provider.dart';
import '../../blog/blog_list_screen.dart';
import '../../gyms/gym_list_screen.dart';
import '../../trainers/trainer_list_screen.dart';
import '../../planner/calendar_screen.dart';
import '../../diet/diet_plans_screen.dart';
import '../../progress/progress_screen.dart';

class MainDrawer extends ConsumerWidget {
  const MainDrawer({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authProvider);
    final user = authState.user;

    return Drawer(
      backgroundColor: Colors.white,
      child: Column(
        children: [
          _buildHeader(user),
          Expanded(
            child: ListView(
              padding: EdgeInsets.zero,
              children: [
                _buildSectionHeader('Tools'),
                _buildDrawerItem(
                  context,
                  icon: Icons.calendar_month_rounded,
                  title: 'Calendar',
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const CalendarScreen()),
                  ),
                ),
                _buildDrawerItem(
                  context,
                  icon: Icons.restaurant_rounded,
                  title: 'Diet Plans',
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const DietPlansScreen()),
                  ),
                ),
                _buildDrawerItem(
                  context,
                  icon: Icons.bar_chart_rounded,
                  title: 'Progress Tracking',
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const ProgressScreen()),
                  ),
                ),
                const Divider(height: 32, indent: 16, endIndent: 16),
                _buildSectionHeader('Community'),
                _buildDrawerItem(
                  context,
                  icon: Icons.article_outlined,
                  title: 'Blog',
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const BlogListScreen()),
                  ),
                ),
                _buildDrawerItem(
                  context,
                  icon: Icons.location_on_outlined,
                  title: 'Gyms',
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const GymListScreen()),
                  ),
                ),
                _buildDrawerItem(
                  context,
                  icon: Icons.people_outline,
                  title: 'Trainers',
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const TrainerListScreen(),
                    ),
                  ),
                ),
                const Divider(height: 32, indent: 16, endIndent: 16),
                _buildDrawerItem(
                  context,
                  icon: Icons.logout_rounded,
                  title: 'Logout',
                  color: Colors.redAccent,
                  onTap: () async {
                    Navigator.pop(context); // Close drawer
                    await ref.read(authProvider.notifier).logout();
                  },
                ),
              ],
            ),
          ),
          _buildFooter(),
        ],
      ),
    );
  }

  Widget _buildHeader(user) {
    return Container(
      padding: const EdgeInsets.only(top: 60, bottom: 24, left: 24, right: 24),
      decoration: BoxDecoration(color: AppColors.primary.withOpacity(0.05)),
      child: Row(
        children: [
          CircleAvatar(
            radius: 30,
            backgroundColor: AppColors.primary.withOpacity(0.1),
            child: const Icon(Icons.person, size: 30, color: AppColors.primary),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  user?.fullName ?? 'User',
                  style: AppTextStyles.h3,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                Text(
                  user?.email ?? '',
                  style: AppTextStyles.caption.copyWith(
                    color: AppColors.grey500,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 16, 24, 8),
      child: Text(
        title.toUpperCase(),
        style: AppTextStyles.caption.copyWith(
          color: AppColors.grey400,
          fontWeight: FontWeight.bold,
          letterSpacing: 1.2,
        ),
      ),
    );
  }

  Widget _buildDrawerItem(
    BuildContext context, {
    required IconData icon,
    required String title,
    required VoidCallback onTap,
    Color? color,
  }) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 24),
      leading: Icon(icon, color: color ?? AppColors.grey600),
      title: Text(
        title,
        style: AppTextStyles.body.copyWith(
          color: color ?? AppColors.grey800,
          fontWeight: FontWeight.w500,
        ),
      ),
      onTap: () {
        Navigator.pop(context); // Close drawer
        onTap();
      },
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
    );
  }

  Widget _buildFooter() {
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.network(
                'https://api.dicebear.com/7.x/bottts/png?seed=muscle&backgroundColor=transparent',
                height: 20,
              ),
              const SizedBox(width: 8),
              Text(
                'Muscle Hustle v1.0',
                style: AppTextStyles.caption.copyWith(color: AppColors.grey400),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
