import 'dart:async';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import '../../../core/models/user_model.dart';
import '../../../domain/usecases/user_usecases.dart';
import '../../../shared/di/service_locator.dart';

class UserAccountsPage extends StatefulWidget {
  const UserAccountsPage({super.key});

  @override
  State<UserAccountsPage> createState() => _UserAccountsPageState();
}

class _UserAccountsPageState extends State<UserAccountsPage> {
  late final GetAllUsersUseCase _getAllUsers;
  late final DeleteUserUseCase _deleteUser;
  late final ToggleUserStatusUseCase _toggleUserStatus;

  List<UserModel> _users = [];
  StreamSubscription? _usersSub;

  @override
  void initState() {
    super.initState();
    _getAllUsers = getIt<GetAllUsersUseCase>();
    _deleteUser = getIt<DeleteUserUseCase>();
    _toggleUserStatus = getIt<ToggleUserStatusUseCase>();

    _loadUsers();
    _subscribeToChanges();
  }

  Future<void> _loadUsers() async {
    final users = await _getAllUsers();
    setState(() => _users = users);
  }

  void _subscribeToChanges() {
    _usersSub = _getAllUsers.watch().listen((users) {
      setState(() => _users = users);
    });
  }

  @override
  void dispose() {
    _usersSub?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.indigo,
        title: const Text('Учётные записи'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: _showAddUserDialog,
            tooltip: 'Добавить пользователя',
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: _users.length,
              itemBuilder: (context, index) {
                final user = _users[index];
                return _buildUserCard(user);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildUserCard(UserModel user) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 2,
      child: ListTile(
        leading: CircleAvatar(
          radius: 24,
          backgroundColor: user.isActive 
              ? Colors.green.withValues(alpha: 0.1) 
              : Colors.grey.withValues(alpha: 0.1),
          child: user.avatarUrl != null
              ? ClipOval(
                  child: CachedNetworkImage(
                    imageUrl: user.avatarUrl!,
                    width: 48,
                    height: 48,
                    fit: BoxFit.cover,
                    placeholder: (context, url) => Container(
                      width: 48,
                      height: 48,
                      color: user.isActive 
                          ? Colors.green.withValues(alpha: 0.1) 
                          : Colors.grey.withValues(alpha: 0.1),
                      child: Center(
                        child: SizedBox(
                          width: 16,
                          height: 16,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor: AlwaysStoppedAnimation<Color>(
                              user.isActive ? Colors.green : Colors.grey,
                            ),
                          ),
                        ),
                      ),
                    ),
                    errorWidget: (context, url, error) => Container(
                      width: 48,
                      height: 48,
                      color: user.isActive 
                          ? Colors.green.withValues(alpha: 0.1) 
                          : Colors.grey.withValues(alpha: 0.1),
                      child: Icon(
                        Icons.person,
                        color: user.isActive ? Colors.green : Colors.grey,
                        size: 24,
                      ),
                    ),
                  ),
                )
              : Icon(
                  Icons.person,
                  color: user.isActive ? Colors.green : Colors.grey,
                  size: 24,
                ),
        ),
        title: Text(
          user.name,
          style: const TextStyle(fontWeight: FontWeight.w600),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(user.email),
            const SizedBox(height: 4),
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                  decoration: BoxDecoration(
                    color: _roleColor(user.role).withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    user.role.displayName,
                    style: TextStyle(
                      fontSize: 12,
                      color: _roleColor(user.role),
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                  decoration: BoxDecoration(
                    color: _statusColor(user.status).withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    user.status.displayName,
                    style: TextStyle(
                      fontSize: 12,
                      color: _statusColor(user.status),
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 4),
            Text(
              'Последний вход: ${user.lastLoginFormatted}',
              style: const TextStyle(fontSize: 12, color: Colors.grey),
            ),
          ],
        ),
        trailing: PopupMenuButton<String>(
          onSelected: (value) => _handleUserAction(value, user),
          itemBuilder: (context) => [
            const PopupMenuItem(
              value: 'edit',
              child: Row(
                children: [
                  Icon(Icons.edit, size: 18),
                  SizedBox(width: 8),
                  Text('Редактировать'),
                ],
              ),
            ),
            const PopupMenuItem(
              value: 'toggle_status',
              child: Row(
                children: [
                  Icon(Icons.toggle_on, size: 18),
                  SizedBox(width: 8),
                  Text('Изменить статус'),
                ],
              ),
            ),
            const PopupMenuItem(
              value: 'reset_password',
              child: Row(
                children: [
                  Icon(Icons.lock_reset, size: 18),
                  SizedBox(width: 8),
                  Text('Сбросить пароль'),
                ],
              ),
            ),
            const PopupMenuItem(
              value: 'delete',
              child: Row(
                children: [
                  Icon(Icons.delete, size: 18, color: Colors.red),
                  SizedBox(width: 8),
                  Text('Удалить', style: TextStyle(color: Colors.red)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Color _roleColor(UserRole role) {
    switch (role) {
      case UserRole.admin:
        return Colors.red;
      case UserRole.operator:
        return Colors.blue;
      case UserRole.user:
        return Colors.green;
    }
  }

  Color _statusColor(UserStatus status) {
    switch (status) {
      case UserStatus.active:
        return Colors.green;
      case UserStatus.inactive:
        return Colors.orange;
    }
  }

  void _handleUserAction(String action, UserModel user) {
    switch (action) {
      case 'edit':
        _showEditUserDialog(user);
        break;
      case 'toggle_status':
        _toggleUserStatus(user.id);
        break;
      case 'reset_password':
        _showResetPasswordDialog(user);
        break;
      case 'delete':
        _showDeleteUserDialog(user);
        break;
    }
  }

  void _showAddUserDialog() {
    // TODO: Реализовать диалог добавления пользователя
  }

  void _showEditUserDialog(UserModel user) {
    // TODO: Реализовать диалог редактирования пользователя
  }

  void _showResetPasswordDialog(UserModel user) {
    // TODO: Реализовать диалог сброса пароля
  }

  void _showDeleteUserDialog(UserModel user) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Удаление пользователя'),
        content: Text('Вы уверены, что хотите удалить пользователя ${user.name}?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Отмена'),
          ),
          ElevatedButton(
            onPressed: () {
              _deleteUser(user.id);
              Navigator.of(context).pop();
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('Удалить'),
          ),
        ],
      ),
    );
  }
}
