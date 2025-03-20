import 'package:flutter/material.dart';

class PostWidget extends StatelessWidget {
  final String userName;
  final String title;
  final String description;
  final String contentLabel;
  final int likes;
  final int comments;

  const PostWidget({
    Key? key,
    required this.userName,
    required this.title,
    required this.description,
    required this.contentLabel,
    required this.likes,
    required this.comments,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      margin: const EdgeInsets.all(8.0),
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // User who posted it
            Row(
              children: [
                CircleAvatar(
                  backgroundImage: AssetImage(
                      'assets/user_avatar.png'),
                  radius: 20,
                ),
                const SizedBox(width: 8),
                Text(
                  userName,
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Title
            Text(
              title,
              style: theme.textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),

            // Description
            Text(
              description,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.secondary,
              ),
            ),
            const SizedBox(height: 8),

            // Content Label
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: theme.colorScheme.primary.withOpacity(0.2),
                borderRadius: BorderRadius.circular(4),
              ),
              child: Text(
                contentLabel,
                style: theme.textTheme.labelSmall?.copyWith(
                  color: theme.colorScheme.primary,
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Likes and Comments
            Row(
              children: [
                IconButton(
                  icon: Icon(Icons.thumb_up, size: 20, color: theme.colorScheme.primary),
                  onPressed: () {
                    // Handle like action
                  },
                ),
                Text(
                  '$likes Likes',
                  style: theme.textTheme.bodyMedium,
                ),
                const SizedBox(width: 16),
                IconButton(
                  icon: Icon(Icons.comment, size: 20, color: theme.colorScheme.primary),
                  onPressed: () {
                    // Handle comment action
                  },
                ),
                Text(
                  '$comments Comments',
                  style: theme.textTheme.bodyMedium,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}