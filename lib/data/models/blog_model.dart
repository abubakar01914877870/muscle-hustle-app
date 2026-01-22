class BlogPost {
  final String id;
  final String title;
  final String content;
  final String? authorName;
  final String? contentType;
  final List<dynamic> images;
  final List<String> tags;
  final int views;
  final String status;
  final DateTime createdAt;
  final DateTime updatedAt;
  final DateTime? publishedAt;

  BlogPost({
    required this.id,
    required this.title,
    required this.content,
    this.authorName,
    this.contentType,
    this.images = const [],
    this.tags = const [],
    this.views = 0,
    this.status = 'draft',
    required this.createdAt,
    required this.updatedAt,
    this.publishedAt,
  });

  factory BlogPost.fromJson(Map<String, dynamic> json) {
    return BlogPost(
      id: json['_id'] as String,
      title: json['title'] as String,
      content: json['content'] as String,
      authorName: json['author_name'] as String?,
      contentType: json['content_type'] as String?,
      images: json['images'] as List<dynamic>? ?? [],
      tags: (json['tags'] as List?)?.map((e) => e as String).toList() ?? [],
      views: json['view_count'] as int? ?? 0,
      status: json['status'] as String? ?? 'draft',
      createdAt:
          DateTime.tryParse(json['created_at']?.toString() ?? '') ??
          DateTime.now(),
      updatedAt:
          DateTime.tryParse(json['updated_at']?.toString() ?? '') ??
          DateTime.now(),
      publishedAt: json['published_at'] != null
          ? DateTime.tryParse(json['published_at'].toString())
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'title': title,
      'content': content,
      'author_name': authorName,
      'content_type': contentType,
      'images': images,
      'tags': tags,
      'view_count': views,
      'status': status,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
      'published_at': publishedAt?.toIso8601String(),
    };
  }

  String? get firstImageUrl {
    if (images.isNotEmpty &&
        images.first is Map &&
        images.first['download_url'] != null) {
      return images.first['download_url'] as String;
    }
    return null;
  }
}
