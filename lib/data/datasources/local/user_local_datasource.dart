import 'dart:async';
import '../../../core/models/user_model.dart';

class UserDTO {
  final String id;
  final String name;
  final String email;
  final String role;
  final String status;
  final DateTime? lastLogin;
  final String? avatarUrl;

  UserDTO({
    required this.id,
    required this.name,
    required this.email,
    required this.role,
    required this.status,
    this.lastLogin,
    this.avatarUrl,
  });

  UserModel toModel() {
    return UserModel(
      id: id,
      name: name,
      email: email,
      role: _parseRole(role),
      status: _parseStatus(status),
      lastLogin: lastLogin,
      avatarUrl: avatarUrl,
    );
  }

  UserRole _parseRole(String role) {
    switch (role) {
      case 'admin':
        return UserRole.admin;
      case 'operator':
        return UserRole.operator;
      default:
        return UserRole.user;
    }
  }

  UserStatus _parseStatus(String status) {
    return status == 'active' ? UserStatus.active : UserStatus.inactive;
  }

  factory UserDTO.fromModel(UserModel model) {
    return UserDTO(
      id: model.id,
      name: model.name,
      email: model.email,
      role: model.role.name,
      status: model.status.name,
      lastLogin: model.lastLogin,
      avatarUrl: model.avatarUrl,
    );
  }
}

class UserLocalDataSource {
  UserDTO _currentUser = UserDTO(
    id: '1',
    name: 'Лев Герасимов',
    email: 'reindefox@example.com',
    role: 'admin',
    status: 'active',
    lastLogin: DateTime.now(),
    avatarUrl: 'https://churchillpolarbears.org/app/uploads/2020/01/GWB-Silver-Fox.jpg',
  );

  final List<UserDTO> _users = [
    UserDTO(
      id: '1',
      name: 'Лев Герасимов',
      email: 'reindefox@example.com',
      role: 'admin',
      status: 'active',
      lastLogin: DateTime(2025, 10, 23, 18, 0),
      avatarUrl: 'https://churchillpolarbears.org/app/uploads/2020/01/GWB-Silver-Fox.jpg',
    ),
    UserDTO(
      id: '2',
      name: 'Михаил Черепов',
      email: 'example@example.com',
      role: 'operator',
      status: 'active',
      lastLogin: DateTime(2025, 10, 22, 18, 0),
      avatarUrl: 'https://pbs.twimg.com/media/GMw5Rz7XwAA34KI.jpg',
    ),
    UserDTO(
      id: '3',
      name: 'Денис Потёмкин',
      email: 'example@example.com',
      role: 'operator',
      status: 'inactive',
      lastLogin: DateTime(2025, 10, 21, 18, 0),
      avatarUrl: 'https://www.citypng.com/public/uploads/preview/funny-ginger-memes-cat-transparent-png-735811696684715rzr8agw7dy.png',
    ),
    UserDTO(
      id: '4',
      name: 'Эмиль Керимов',
      email: 'example@example.com',
      role: 'operator',
      status: 'active',
      lastLogin: DateTime(2025, 10, 20, 18, 0),
      avatarUrl: 'https://ih1.redbubble.net/image.5161777834.1583/bg,f8f8f8-flat,750x,075,f-pad,750x1000,f8f8f8.webp',
    ),
    UserDTO(
      id: '5',
      name: 'Мистер Бин',
      email: 'example@example.com',
      role: 'user',
      status: 'active',
      lastLogin: DateTime(2025, 10, 20, 18, 0),
      avatarUrl: 'https://media.tenor.com/Zgh_7dE978kAAAAM/mr-bean.gif',
    ),
  ];

  final _currentUserController = StreamController<UserModel>.broadcast();
  final _usersController = StreamController<List<UserModel>>.broadcast();

  Stream<UserModel> get currentUserStream => _currentUserController.stream;
  Stream<List<UserModel>> get usersStream => _usersController.stream;

  UserModel getCurrentUser() {
    return _currentUser.toModel();
  }

  UserModel updateCurrentUser({String? name, String? email, String? avatarUrl}) {
    _currentUser = UserDTO(
      id: _currentUser.id,
      name: name ?? _currentUser.name,
      email: email ?? _currentUser.email,
      role: _currentUser.role,
      status: _currentUser.status,
      lastLogin: _currentUser.lastLogin,
      avatarUrl: avatarUrl ?? _currentUser.avatarUrl,
    );
    _notifyCurrentUserChanged();
    return _currentUser.toModel();
  }

  List<UserModel> getAllUsers() {
    return _users.map((dto) => dto.toModel()).toList();
  }

  UserModel? getUserById(String id) {
    try {
      return _users.firstWhere((u) => u.id == id).toModel();
    } catch (_) {
      return null;
    }
  }

  UserModel addUser(UserModel user) {
    final dto = UserDTO.fromModel(user);
    _users.add(dto);
    _notifyUsersChanged();
    return dto.toModel();
  }

  UserModel updateUser(UserModel user) {
    final index = _users.indexWhere((u) => u.id == user.id);
    if (index == -1) throw StateError('Пользователь не найден');
    
    final dto = UserDTO.fromModel(user);
    _users[index] = dto;
    _notifyUsersChanged();
    return dto.toModel();
  }

  void deleteUser(String id) {
    _users.removeWhere((u) => u.id == id);
    _notifyUsersChanged();
  }

  UserModel toggleUserStatus(String id) {
    final index = _users.indexWhere((u) => u.id == id);
    if (index == -1) throw StateError('Пользователь не найден');
    
    final current = _users[index];
    final newStatus = current.status == 'active' ? 'inactive' : 'active';
    
    _users[index] = UserDTO(
      id: current.id,
      name: current.name,
      email: current.email,
      role: current.role,
      status: newStatus,
      lastLogin: current.lastLogin,
      avatarUrl: current.avatarUrl,
    );
    _notifyUsersChanged();
    return _users[index].toModel();
  }

  void _notifyCurrentUserChanged() {
    _currentUserController.add(_currentUser.toModel());
  }

  void _notifyUsersChanged() {
    _usersController.add(getAllUsers());
  }

  void dispose() {
    _currentUserController.close();
    _usersController.close();
  }
}
