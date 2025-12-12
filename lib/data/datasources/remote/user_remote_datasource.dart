import 'dart:async';
import 'package:dio/dio.dart';
import 'package:project/core/models/user_model.dart';
import 'package:project/core/services/dio_client.dart';




class UserRemoteDataSource {
  static const String _baseUrl = 'https://jsonplaceholder.typicode.com';
  
  final DioClient _dioClient;
  
  List<UserModel> _users = [];
  bool _isLoaded = false;
  
  final _usersController = StreamController<List<UserModel>>.broadcast();

  UserRemoteDataSource(this._dioClient);

  Stream<List<UserModel>> get usersStream => _usersController.stream;

  Future<List<UserModel>> fetchUsers() async {
    try {
      final response = await _dioClient.get<List<dynamic>>(
        '$_baseUrl/users',
      );
      
      if (response.data == null) {
        return _users;
      }
      
      _users = response.data!.map((json) {
        final data = json as Map<String, dynamic>;
        return UserModel(
          id: data['id'].toString(),
          name: data['name'] as String,
          email: data['email'] as String,
          role: _mapRole(data['id'] as int),
          status: _mapStatus(data['id'] as int),
          lastLogin: DateTime.now().subtract(Duration(days: data['id'] as int)),
          avatarUrl: 'https://i.pravatar.cc/150?u=${data['email']}',
        );
      }).toList();
      
      _isLoaded = true;
      _notifyChanged();
      return _users;
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  Future<List<UserModel>> getAllUsers() async {
    if (!_isLoaded) {
      return fetchUsers();
    }
    return _users;
  }

  Future<UserModel> getUserById(String id) async {
    try {
      final response = await _dioClient.get<Map<String, dynamic>>(
        '$_baseUrl/users/$id',
      );
      
      if (response.data == null) {
        throw Exception('Пользователь не найден');
      }
      
      final data = response.data!;
      return UserModel(
        id: data['id'].toString(),
        name: data['name'] as String,
        email: data['email'] as String,
        role: _mapRole(data['id'] as int),
        status: _mapStatus(data['id'] as int),
        lastLogin: DateTime.now().subtract(Duration(days: data['id'] as int)),
        avatarUrl: 'https://i.pravatar.cc/150?u=${data['email']}',
      );
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  UserModel? getCachedUserById(String id) {
    try {
      return _users.firstWhere((u) => u.id == id);
    } catch (_) {
      return null;
    }
  }

  void deleteUser(String id) {
    _users.removeWhere((u) => u.id == id);
    _notifyChanged();
  }

  UserModel toggleUserStatus(String id) {
    final index = _users.indexWhere((u) => u.id == id);
    if (index == -1) throw StateError('Пользователь не найден');
    
    final current = _users[index];
    final newStatus = current.status == UserStatus.active 
        ? UserStatus.inactive 
        : UserStatus.active;
    
    _users[index] = current.copyWith(status: newStatus);
    _notifyChanged();
    return _users[index];
  }

  void _notifyChanged() {
    _usersController.add(_users);
  }

  UserRole _mapRole(int id) {
    if (id == 1) return UserRole.admin;
    if (id <= 3) return UserRole.operator;
    return UserRole.user;
  }

  UserStatus _mapStatus(int id) {
    return id % 3 == 0 ? UserStatus.inactive : UserStatus.active;
  }

  Exception _handleError(DioException e) {
    switch (e.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return Exception('Время ожидания истекло');
      case DioExceptionType.connectionError:
        return Exception('Нет подключения к интернету');
      case DioExceptionType.badResponse:
        return Exception('Ошибка сервера: ${e.response?.statusCode}');
      default:
        return Exception('Ошибка загрузки данных');
    }
  }

  void dispose() {
    _usersController.close();
  }
}
