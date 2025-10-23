import 'package:flutter/material.dart';
import 'package:project/shared/state/user_state.dart';
import 'package:provider/provider.dart';
import 'package:cached_network_image/cached_network_image.dart';

class UserProfilePage extends StatelessWidget {
  const UserProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    final state = context.watch<UserState>();
    final user = state.currentUser;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blueGrey,
        title: const Text('Профиль'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(
                  radius: 28,
                  backgroundColor: Colors.blueGrey.withValues(alpha: 0.2),
                  child: ClipOval(
                    child: CachedNetworkImage(
                      imageUrl: user['avatarUrl']!,
                      width: 56,
                      height: 56,
                      fit: BoxFit.cover,
                      placeholder: (context, url) => Container(
                        width: 56,
                        height: 56,
                        color: Colors.blueGrey.withValues(alpha: 0.1),
                        child: const Center(
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor: AlwaysStoppedAnimation<Color>(Colors.blueGrey),
                          ),
                        ),
                      ),
                      errorWidget: (context, url, error) => Container(
                        width: 56,
                        height: 56,
                        color: Colors.blueGrey.withValues(alpha: 0.1),
                        child: const Icon(
                          Icons.person,
                          size: 28,
                          color: Colors.blueGrey,
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(user['name'] ?? '', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w700)),
                      const SizedBox(height: 4),
                      Text(user['email'] ?? '', style: TextStyle(color: Colors.grey.shade700)),
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


