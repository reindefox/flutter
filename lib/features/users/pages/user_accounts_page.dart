import 'dart:async';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import '../../../core/models/user_model.dart';
import '../../../domain/usecases/user_usecases.dart';
import '../../../domain/usecases/api_usecases.dart';
import '../../../core/models/api/api_models.dart';
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
  late final GetApiUsersUseCase _getApiUsers;

  List<UserModel> _users = [];
  List<ApiUser>? _apiUsers;
  StreamSubscription? _usersSub;
  
  bool _isLoadingFromApi = false;
  String? _apiError;
  bool _showApiUsers = false;

  @override
  void initState() {
    super.initState();
    _getAllUsers = getIt<GetAllUsersUseCase>();
    _deleteUser = getIt<DeleteUserUseCase>();
    _toggleUserStatus = getIt<ToggleUserStatusUseCase>();
    _getApiUsers = getIt<GetApiUsersUseCase>();

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

  Future<void> _loadFromApi() async {
    setState(() {
      _isLoadingFromApi = true;
      _apiError = null;
    });
    
    try {
      final apiUsers = await _getApiUsers();
      setState(() {
        _apiUsers = apiUsers;
        _showApiUsers = true;
        _isLoadingFromApi = false;
      });
    } catch (e) {
      setState(() {
        _apiError = e.toString();
        _isLoadingFromApi = false;
      });
    }
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
            icon: const Icon(Icons.cloud_download),
            onPressed: _isLoadingFromApi ? null : _loadFromApi,
            tooltip: 'Загрузить с сервера',
          ),
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: _showAddUserDialog,
            tooltip: 'Добавить пользователя',
          ),
        ],
      ),
      body: Column(
        children: [

          if (_apiUsers != null)
            Container(
              margin: const EdgeInsets.all(12),
              child: Row(
                children: [
                  Expanded(
                    child: _buildSourceButton(
                      'Локальные',
                      Icons.storage,
                      !_showApiUsers,
                      () => setState(() => _showApiUsers = false),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: _buildSourceButton(
                      'С сервера',
                      Icons.cloud,
                      _showApiUsers,
                      () => setState(() => _showApiUsers = true),
                    ),
                  ),
                ],
              ),
            ),

          if (_showApiUsers && _apiUsers != null)
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 12),
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Colors.indigo.shade50,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.indigo.shade200),
              ),
              child: Row(
                children: [
                  Icon(Icons.cloud_done, color: Colors.indigo.shade700, size: 18),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'Данные загружены с сервера пользователей',
                      style: TextStyle(fontSize: 11, color: Colors.indigo.shade700),
                    ),
                  ),
                ],
              ),
            ),

          if (_isLoadingFromApi)
            const Padding(
              padding: EdgeInsets.all(16),
              child: Center(child: CircularProgressIndicator()),
            ),

          if (_apiError != null)
            Container(
              margin: const EdgeInsets.all(12),
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.red.shade50,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: [
                  const Icon(Icons.error, color: Colors.red),
                  const SizedBox(width: 8),
                  Expanded(child: Text(_apiError!)),
                ],
              ),
            ),

          Expanded(
            child: _showApiUsers && _apiUsers != null
                ? _buildApiUsersList()
                : _buildLocalUsersList(),
          ),
        ],
      ),
    );
  }

  Widget _buildSourceButton(
    String label,
    IconData icon,
    bool isSelected,
    VoidCallback onTap,
  ) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
        decoration: BoxDecoration(
          color: isSelected ? Colors.indigo : Colors.grey.shade200,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 18,
              color: isSelected ? Colors.white : Colors.grey.shade700,
            ),
            const SizedBox(width: 6),
            Text(
              label,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: isSelected ? Colors.white : Colors.grey.shade700,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildApiUsersList() {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: _apiUsers!.length,
      itemBuilder: (context, index) {
        final apiUser = _apiUsers![index];
        return _buildApiUserCard(apiUser);
      },
    );
  }

  Widget _buildApiUserCard(ApiUser apiUser) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 2,
      child: ListTile(
        leading: CircleAvatar(
          radius: 24,
          backgroundColor: Colors.indigo.withValues(alpha: 0.1),
          child: ClipOval(
            child: CachedNetworkImage(
              imageUrl: 'https://i.pravatar.cc/150?u=${apiUser.email}',
              width: 48,
              height: 48,
              fit: BoxFit.cover,
              placeholder: (context, url) => Container(
                color: Colors.indigo.withValues(alpha: 0.1),
                child: const Center(
                  child: SizedBox(
                    width: 16,
                    height: 16,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  ),
                ),
              ),
              errorWidget: (context, url, error) => Icon(
                Icons.person,
                color: Colors.indigo.shade300,
              ),
            ),
          ),
        ),
        title: Text(
          apiUser.name,
          style: const TextStyle(fontWeight: FontWeight.w600),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(apiUser.email),
            if (apiUser.company != null)
              Text(
                apiUser.company!.name,
                style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
              ),
            if (apiUser.address != null)
              Text(
                apiUser.address!.fullAddress,
                style: TextStyle(fontSize: 11, color: Colors.grey.shade500),
              ),
          ],
        ),
        trailing: Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: BoxDecoration(
            color: Colors.indigo.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Text(
            '@${apiUser.username}',
            style: TextStyle(
              fontSize: 11,
              color: Colors.indigo.shade700,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        isThreeLine: true,
      ),
    );
  }

  Widget _buildLocalUsersList() {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: _users.length,
      itemBuilder: (context, index) {
        final user = _users[index];
        return _buildUserCard(user);
      },
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

  }

  void _showEditUserDialog(UserModel user) {

  }

  void _showResetPasswordDialog(UserModel user) {

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
