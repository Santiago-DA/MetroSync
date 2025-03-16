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
    return Card(
      margin: const EdgeInsets.all(8.0),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // User who posted it
            Row(
              children: [
                const CircleAvatar(
                  backgroundImage: AssetImage(
                      'assets/user_avatar.png'), // Replace with actual user avatar
                  radius: 20,
                ),
                const SizedBox(width: 8),
                Text(
                  userName,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Title
            Text(
              title,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),

            // Description
            Text(
              description,
              style: const TextStyle(
                fontSize: 14,
                color: Colors.grey,
              ),
            ),
            const SizedBox(height: 8),

            // Content Label
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: Colors.blue.withOpacity(0.2),
                borderRadius: BorderRadius.circular(4),
              ),
              child: Text(
                contentLabel,
                style: const TextStyle(
                  color: Colors.blue,
                  fontSize: 12,
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Likes and Comments
            Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.thumb_up, size: 20),
                  onPressed: () {
                    // Handle like action
                  },
                ),
                Text('$likes Likes'),
                const SizedBox(width: 16),
                IconButton(
                  icon: const Icon(Icons.comment, size: 20),
                  onPressed: () {
                    // Handle comment action
                  },
                ),
                Text('$comments Comments'),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
