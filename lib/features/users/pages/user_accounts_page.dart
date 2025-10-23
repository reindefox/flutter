import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import '../models/user_models.dart';

class UserAccountsPage extends StatefulWidget {
  const UserAccountsPage({super.key});

  @override
  State<UserAccountsPage> createState() => _UserAccountsPageState();
}

class _UserAccountsPageState extends State<UserAccountsPage> {
  final List<User> _users = [
    const User(
      id: '1',
      name: 'Лев Герасимов',
      email: 'reindefox@example.com',
      role: UserRole.admin,
      status: UserStatus.active,
      lastLogin: '2025-10-23 18:00',
      avatarUrl: 'https://churchillpolarbears.org/app/uploads/2020/01/GWB-Silver-Fox.jpg',
    ),
    const User(
      id: '2',
      name: 'Михаил Черепов',
      email: 'example@example.com',
      role: UserRole.operator,
      status: UserStatus.active,
      lastLogin: '2025-10-22 18:00',
      avatarUrl: 'https://pbs.twimg.com/media/GMw5Rz7XwAA34KI.jpg'
    ),
    const User(
      id: '3',
      name: 'Денис Потёмкин',
      email: 'example@example.com',
      role: UserRole.operator,
      status: UserStatus.inactive,
      lastLogin: '2025-10-21 18:00',
      avatarUrl: 'https://www.citypng.com/public/uploads/preview/funny-ginger-memes-cat-transparent-png-735811696684715rzr8agw7dy.png'
    ),
    const User(
      id: '4',
      name: 'Эмиль Керимов',
      email: 'example@example.com',
      role: UserRole.operator,
      status: UserStatus.active,
      lastLogin: '2025-10-20 18:00',
      avatarUrl: 'https://ih1.redbubble.net/image.5161777834.1583/bg,f8f8f8-flat,750x,075,f-pad,750x1000,f8f8f8.webp'
    ),
    const User(
      id: '5',
      name: 'Мистер Бин',
      email: 'example@example.com',
      role: UserRole.user,
      status: UserStatus.active,
      lastLogin: '2025-10-20 18:00',
      avatarUrl: 'https://media.tenor.com/Zgh_7dE978kAAAAM/mr-bean.gif'
    ),
  ];

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

  Widget _buildUserCard(User user) {
    final isActive = user.status == UserStatus.active;
    
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 2,
      child: ListTile(
        leading: CircleAvatar(
          radius: 24,
          backgroundColor: isActive ? Colors.green.withValues(alpha: 0.1) : Colors.grey.withValues(alpha: 0.1),
          backgroundImage: user.avatarUrl != null ? CachedNetworkImageProvider(user.avatarUrl!) : null,
          child: user.avatarUrl == null 
            ? Icon(
                Icons.person,
                color: isActive ? Colors.green : Colors.grey,
              )
            : null,
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
                    color: user.role.color.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    user.role.displayName,
                    style: TextStyle(
                      fontSize: 12,
                      color: user.role.color,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                  decoration: BoxDecoration(
                    color: user.status.color.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    user.status.displayName,
                    style: TextStyle(
                      fontSize: 12,
                      color: user.status.color,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 4),
            Text(
              'Последний вход: ${user.lastLogin}',
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

  void _handleUserAction(String action, User user) {
    switch (action) {
      case 'edit':
        _showEditUserDialog(user);
        break;
      case 'toggle_status':
        _toggleUserStatus(user);
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
  }

  void _showEditUserDialog(User user) {
  }

  void _toggleUserStatus(User user) {
  }

  void _showResetPasswordDialog(User user) {
  }

  void _showDeleteUserDialog(User user) {
  }
}
