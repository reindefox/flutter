import 'dart:async';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../../core/models/user_model.dart';
import '../../../domain/usecases/user_usecases.dart';
import '../../../shared/di/service_locator.dart';

class UserProfilePage extends StatefulWidget {
  const UserProfilePage({super.key});

  @override
  State<UserProfilePage> createState() => _UserProfilePageState();
}

class _UserProfilePageState extends State<UserProfilePage> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  
  late final GetCurrentUserUseCase _getCurrentUser;
  late final UpdateCurrentUserUseCase _updateCurrentUser;

  UserModel? _user;
  StreamSubscription? _userSub;

  @override
  void initState() {
    super.initState();
    _getCurrentUser = getIt<GetCurrentUserUseCase>();
    _updateCurrentUser = getIt<UpdateCurrentUserUseCase>();

    _loadUser();
    _subscribeToChanges();
  }

  Future<void> _loadUser() async {
    final user = await _getCurrentUser();
    setState(() {
      _user = user;
      _nameController.text = user.name;
      _emailController.text = user.email;
    });
  }

  void _subscribeToChanges() {
    _userSub = _getCurrentUser.watch().listen((user) {
      setState(() => _user = user);
    });
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _userSub?.cancel();
    super.dispose();
  }

  void _saveChanges() async {
    final name = _nameController.text.trim();
    final email = _emailController.text.trim();
    
    if (name.isNotEmpty || email.isNotEmpty) {
      await _updateCurrentUser(
        name: name.isNotEmpty ? name : null,
        email: email.isNotEmpty ? email : null,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_user == null) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

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
                    child: _user!.avatarUrl != null
                        ? CachedNetworkImage(
                            imageUrl: _user!.avatarUrl!,
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
                          )
                        : const Icon(
                            Icons.person,
                            size: 28,
                            color: Colors.blueGrey,
                          ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        _user!.name,
                        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        _user!.email,
                        style: TextStyle(color: Colors.grey.shade700),
                      ),
                      const SizedBox(height: 4),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                        decoration: BoxDecoration(
                          color: _user!.isAdmin ? Colors.red.withValues(alpha: 0.1) : Colors.blue.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          _user!.role.displayName,
                          style: TextStyle(
                            fontSize: 12,
                            color: _user!.isAdmin ? Colors.red : Colors.blue,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
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
    );
  }
}
