import 'package:flutter/material.dart';
import '../../core/theme/app_theme.dart';
import '../../data/models/community_models.dart';
import 'package:url_launcher/url_launcher.dart';

class GymDetailScreen extends StatelessWidget {
  final GymModel gym;

  const GymDetailScreen({super.key, required this.gym});

  Future<void> _launchUrl(String urlString) async {
    final Uri url = Uri.parse(urlString);
    if (!await launchUrl(url)) {
      // Handle error
      debugPrint('Could not launch $url');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 300,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              title: Text(gym.name), // May conflict if image is busy
              background: gym.images.isNotEmpty
                  ? Image.network(gym.images.first, fit: BoxFit.cover)
                  : Container(color: AppColors.primary),
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.all(24),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                Row(
                  children: [
                    const Icon(Icons.location_on, color: AppColors.primary),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(gym.address, style: AppTextStyles.body),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                if (gym.phone.isNotEmpty)
                  Row(
                    children: [
                      const Icon(Icons.phone, color: AppColors.primary),
                      const SizedBox(width: 8),
                      Text(gym.phone, style: AppTextStyles.body),
                    ],
                  ),
                const SizedBox(height: 24),
                Text('About Us', style: AppTextStyles.h2),
                const SizedBox(height: 8),
                Text(
                  gym.description,
                  style: AppTextStyles.body.copyWith(height: 1.6),
                ),
                const SizedBox(height: 32),
                if (gym.googleMapLink.isNotEmpty)
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: () => _launchUrl(gym.googleMapLink),
                      icon: const Icon(Icons.map),
                      label: const Text('View on Map'),
                    ),
                  ),
                const SizedBox(height: 32),
                // Gallery could go here
                if (gym.images.length > 1) ...[
                  Text('Gallery', style: AppTextStyles.h2),
                  const SizedBox(height: 16),
                  SizedBox(
                    height: 120,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: gym.images.length - 1,
                      itemBuilder: (context, index) {
                        return Padding(
                          padding: const EdgeInsets.only(right: 12),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: Image.network(
                              gym.images[index + 1],
                              height: 120,
                              width: 120,
                              fit: BoxFit.cover,
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
                const SizedBox(height: 50),
              ]),
            ),
          ),
        ],
      ),
    );
  }
}
