import 'dart:convert';
import 'package:flutter/material.dart';
import '../../core/theme/app_theme.dart';
import '../../data/models/community_models.dart';

class TrainerDetailScreen extends StatelessWidget {
  final TrainerModel trainer;

  const TrainerDetailScreen({super.key, required this.trainer});

  @override
  Widget build(BuildContext context) {
    final profile = trainer.profile;
    final List specializations = profile['specializations'] ?? [];
    final bio = profile['bio'] ?? 'No bio available.';
    final experience = profile['experience_years'] ?? 0;
    final rating = profile['rating'] ?? 5.0; // Mock rating if not available
    final clientCount = profile['client_count'] ?? 100; // Mock count

    return Scaffold(
      backgroundColor: Colors.white,
      body: CustomScrollView(
        slivers: [
          // 1. Sliver App Bar with Hero Image
          SliverAppBar(
            expandedHeight: 300,
            pinned: true,
            backgroundColor: AppColors.primary,
            flexibleSpace: FlexibleSpaceBar(
              title: Text(
                trainer.fullName,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  shadows: [Shadow(color: Colors.black45, blurRadius: 10)],
                ),
              ),
              background: Stack(
                fit: StackFit.expand,
                children: [
                  _buildProfileImage(trainer.profilePicture),
                  // Gradient Overlay
                  Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.transparent,
                          Colors.black.withOpacity(0.7),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // 2. Profile Content
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Stats Row
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _buildStatItem(
                        'Experience',
                        '$experience Years',
                        Icons.history,
                      ),
                      _buildStatItem('Clients', '$clientCount+', Icons.people),
                      _buildStatItem(
                        'Rating',
                        '$rating',
                        Icons.star,
                        color: Colors.amber,
                      ),
                    ],
                  ),
                  const Divider(height: 48),

                  // Specializations
                  if (specializations.isNotEmpty) ...[
                    Text(
                      'Specializations',
                      style: AppTextStyles.h3.copyWith(
                        color: AppColors.grey900,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: specializations.map<Widget>((spec) {
                        return Chip(
                          label: Text(spec.toString()),
                          backgroundColor: AppColors.primary.withOpacity(0.1),
                          labelStyle: TextStyle(
                            color: AppColors.primary,
                            fontWeight: FontWeight.bold,
                          ),
                          side: BorderSide.none,
                          shape: const StadiumBorder(),
                        );
                      }).toList(),
                    ),
                    const SizedBox(height: 24),
                  ],

                  // Bio
                  Text(
                    'About Coach',
                    style: AppTextStyles.h3.copyWith(color: AppColors.grey900),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    bio,
                    style: AppTextStyles.body.copyWith(
                      color: AppColors.grey600,
                      height: 1.6,
                    ),
                  ),

                  const SizedBox(height: 40),

                  // Action Button
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        // Placeholder for booking/contact
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Booking feature coming soon!'),
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        elevation: 4,
                        shadowColor: AppColors.primary.withOpacity(0.4),
                      ),
                      child: const Text(
                        'Book Session',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 40),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatItem(
    String label,
    String value,
    IconData icon, {
    Color? color,
  }) {
    return Column(
      children: [
        Icon(icon, color: color ?? AppColors.primary, size: 28),
        const SizedBox(height: 8),
        Text(
          value,
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        Text(label, style: TextStyle(fontSize: 12, color: AppColors.grey500)),
      ],
    );
  }

  Widget _buildProfileImage(String? source) {
    if (source == null || source.isEmpty) {
      return _buildPlaceholder();
    }

    if (source.startsWith('http')) {
      return Image.network(
        source,
        fit: BoxFit.cover,
        errorBuilder: (_, __, ___) => _buildPlaceholder(),
      );
    }

    try {
      String base64String = source;
      if (source.contains(',')) {
        base64String = source.split(',').last;
      }
      return Image.memory(
        base64Decode(base64String),
        fit: BoxFit.cover,
        errorBuilder: (_, __, ___) => _buildPlaceholder(),
      );
    } catch (_) {
      return _buildPlaceholder();
    }
  }

  Widget _buildPlaceholder() {
    return Container(
      color: AppColors.grey800,
      child: const Icon(Icons.person, size: 100, color: Colors.white),
    );
  }
}
