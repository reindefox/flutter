import 'package:flutter/material.dart';
import 'package:project/shared/state/user_state.dart';
import 'package:cached_network_image/cached_network_image.dart';

class UserProfilePage extends StatefulWidget {
  const UserProfilePage({super.key});

  @override
  State<UserProfilePage> createState() => _UserProfilePageState();
}

class _UserProfilePageState extends State<UserProfilePage> {
  UserState? _userState;
  final TextEditingController _nameController = TextEditingController();

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_userState == null) {
      _userState = UserStateProvider.of(context);
      _userState!.addListener(_onUserStateChanged);
      _nameController.text = _userState!.currentUser['name'] ?? '';
    }
  }

  @override
  void dispose() {
    _userState?.removeListener(_onUserStateChanged);
    _nameController.dispose();
    super.dispose();
  }

  void _onUserStateChanged() {
    if (mounted) {
      setState(() {
        _nameController.text = _userState!.currentUser['name'] ?? '';
      });
    }
  }

  void _saveName() {
    if (_nameController.text.trim().isNotEmpty) {
      _userState?.updateUser(name: _nameController.text.trim());
    }
  }

  @override
  Widget build(BuildContext context) {
    final state = UserStateProvider.of(context);
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
            const SizedBox(height: 24),
            TextField(
              controller: _nameController,
              decoration: const InputDecoration(
                labelText: 'Имя',
                hintText: 'Введите имя',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.person),
              ),
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _saveName,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  backgroundColor: Colors.blueGrey,
                  foregroundColor: Colors.white,
                ),
                child: const Text('Сохранить'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}


