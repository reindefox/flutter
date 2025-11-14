import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:project/shared/state/user_state.dart';
import 'package:project/shared/di/service_locator.dart';
import 'package:cached_network_image/cached_network_image.dart';

class UserProfilePage extends StatefulWidget {
  const UserProfilePage({super.key});

  @override
  State<UserProfilePage> createState() => _UserProfilePageState();
}

class _UserProfilePageState extends State<UserProfilePage> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  late final UserState _userState;

  @override
  void initState() {
    super.initState();
    _userState = getIt<UserState>();
    _nameController.text = _userState.name;
    _emailController.text = _userState.email;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  void _saveChanges() {
    if (_nameController.text.trim().isNotEmpty || _emailController.text.trim().isNotEmpty) {
      _userState.updateUser(
        name: _nameController.text.trim().isNotEmpty ? _nameController.text.trim() : null,
        email: _emailController.text.trim().isNotEmpty ? _emailController.text.trim() : null,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blueGrey,
        title: const Text('Профиль'),
        centerTitle: true,
      ),
      body: Observer(
        builder: (_) => Padding(
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
                        imageUrl: _userState.avatarUrl,
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
                        Text(
                          _userState.name,
                          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          _userState.email,
                          style: TextStyle(color: Colors.grey.shade700),
                        ),
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
              TextField(
                controller: _emailController,
                decoration: const InputDecoration(
                  labelText: 'Email',
                  hintText: 'Введите email',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.email),
                ),
              ),
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _saveChanges,
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
      ),
    );
  }
}
