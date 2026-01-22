import 'package:flutter/material.dart';
import '../../core/theme/app_theme.dart';
import '../../data/models/blog_model.dart';

class BlogDetailScreen extends StatelessWidget {
  final BlogPost post;

  const BlogDetailScreen({super.key, required this.post});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 250,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              background: post.firstImageUrl != null
                  ? Image.network(
                      post.firstImageUrl!,
                      fit: BoxFit.cover,
                      errorBuilder: (ctx, err, stack) =>
                          Container(color: AppColors.primary),
                    )
                  : Container(color: AppColors.primary),
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.all(24),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                Text(post.title, style: AppTextStyles.h1),
                const SizedBox(height: 16),
                Row(
                  children: [
                    const Icon(
                      Icons.person,
                      size: 16,
                      color: AppColors.textSecondary,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      post.authorName ?? "Admin",
                      style: AppTextStyles.bodySmall,
                    ),
                    const SizedBox(width: 16),
                    const Icon(
                      Icons.calendar_today,
                      size: 16,
                      color: AppColors.textSecondary,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      '${post.createdAt.day}/${post.createdAt.month}/${post.createdAt.year}',
                      style: AppTextStyles.bodySmall,
                    ),
                  ],
                ),
                const Divider(height: 32),
                Text(
                  post.content,
                  style: AppTextStyles.body.copyWith(height: 1.6),
                ),
                const SizedBox(height: 40),
                if (post.tags.isNotEmpty)
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: post.tags.map((tag) {
                      return Chip(
                        label: Text(tag),
                        backgroundColor: AppColors.primary.withOpacity(0.1),
                        labelStyle: const TextStyle(color: AppColors.primary),
                        side: BorderSide.none,
                      );
                    }).toList(),
                  ),
                const SizedBox(height: 100),
              ]),
            ),
          ),
        ],
      ),
    );
  }
}
