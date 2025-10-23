import 'dart:ui';

import 'package:flutter/material.dart';

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

class User {
  final String id;
  final String name;
  final String email;
  final UserRole role;
  final UserStatus status;
  final String lastLogin;
  final String? avatarUrl;

  const User({
    required this.id,
    required this.name,
    required this.email,
    required this.role,
    required this.status,
    required this.lastLogin,
    this.avatarUrl,
  });

  User copyWith({
    String? id,
    String? name,
    String? email,
    UserRole? role,
    UserStatus? status,
    String? lastLogin,
    String? avatarUrl,
  }) {
    return User(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      role: role ?? this.role,
      status: status ?? this.status,
      lastLogin: lastLogin ?? this.lastLogin,
      avatarUrl: avatarUrl ?? this.avatarUrl,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'role': role.name,
      'status': status.name,
      'lastLogin': lastLogin,
      'avatarUrl': avatarUrl,
    };
  }

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'] as String,
      name: json['name'] as String,
      email: json['email'] as String,
      role: UserRole.values.firstWhere((e) => e.name == json['role']),
      status: UserStatus.values.firstWhere((e) => e.name == json['status']),
      lastLogin: json['lastLogin'] as String,
      avatarUrl: json['avatarUrl'] as String?,
    );
  }
}

extension UserRoleExtension on UserRole {
  Color get color {
    switch (this) {
      case UserRole.admin:
        return Colors.red;
      case UserRole.operator:
        return Colors.blue;
      case UserRole.user:
        return Colors.green;
    }
  }
}

extension UserStatusExtension on UserStatus {
  Color get color {
    switch (this) {
      case UserStatus.active:
        return Colors.green;
      case UserStatus.inactive:
        return Colors.orange;
    }
  }
}
