enum UserStatus {
  active('Активен'),
  inactive('Неактивен');

  const UserStatus(this.displayName);
  final String displayName;
}

enum UserRole {
  admin('Администратор'),
  operator('Оператор'),
  user('Пользователь');

  const UserRole(this.displayName);
  final String displayName;
}

class UserModel {
  final String id;
  final String name;
  final String email;
  final UserRole role;
  final UserStatus status;
  final DateTime? lastLogin;
  final String? avatarUrl;

  const UserModel({
    required this.id,
    required this.name,
    required this.email,
    required this.role,
    required this.status,
    this.lastLogin,
    this.avatarUrl,
  });

  UserModel copyWith({
    String? id,
    String? name,
    String? email,
    UserRole? role,
    UserStatus? status,
    DateTime? lastLogin,
    String? avatarUrl,
  }) {
    return UserModel(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      role: role ?? this.role,
      status: status ?? this.status,
      lastLogin: lastLogin ?? this.lastLogin,
      avatarUrl: avatarUrl ?? this.avatarUrl,
    );
  }

  bool get isActive => status == UserStatus.active;

  bool get isAdmin => role == UserRole.admin;

  bool get canManageSystem => role == UserRole.admin || role == UserRole.operator;

  String get lastLoginFormatted {
    if (lastLogin == null) return 'Никогда';
    final d = lastLogin!;
    return '${d.day.toString().padLeft(2, '0')}.${d.month.toString().padLeft(2, '0')}.${d.year} '
        '${d.hour.toString().padLeft(2, '0')}:${d.minute.toString().padLeft(2, '0')}';
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is UserModel && runtimeType == other.runtimeType && id == other.id;

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() => 'UserModel(id: $id, name: $name, role: $role)';
}
