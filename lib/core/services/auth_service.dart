import 'package:flutter/foundation.dart';
import '../models/user_model.dart';

class AuthCredentials {
  final String email;
  final String password;
  final String name;

  AuthCredentials({
    required this.email,
    required this.password,
    required this.name,
  });
}

class AuthService extends ChangeNotifier {
  bool _isAuthenticated = false;
  UserModel? _currentUser;
  
  final Map<String, AuthCredentials> _registeredUsers = {};
  
  final Map<String, UserModel> _userModels = {};

  bool get isAuthenticated => _isAuthenticated;
  UserModel? get currentUser => _currentUser;

  AuthService() {
    _initializeTestUser();
  }

  void _initializeTestUser() {
    const testEmail = 'test@mail.ru';
    const testPassword = 'testtest';
    const testName = 'Лев Герасимов';
    
    _registeredUsers[testEmail] = AuthCredentials(
      email: testEmail,
      password: testPassword,
      name: testName,
    );
    
    _userModels[testEmail] = const UserModel(
      id: '1',
      name: testName,
      email: testEmail,
      role: UserRole.admin,
      status: UserStatus.active,
      lastLogin: null,
    );
  }

  Future<bool> login(String email, String password) async {
    await Future.delayed(const Duration(milliseconds: 500));
    
    final credentials = _registeredUsers[email];
    
    if (credentials == null || credentials.password != password) {
      return false;
    }
    
    final user = _userModels[email];
    if (user == null) {
      return false;
    }
    
    // Обновляем время последнего входа
    _userModels[email] = user.copyWith(
      lastLogin: DateTime.now(),
    );
    
    _currentUser = _userModels[email];
    _isAuthenticated = true;
    notifyListeners();
    
    return true;
  }

  Future<bool> register(String email, String password, String name) async {
    // Имитация задержки сети
    await Future.delayed(const Duration(milliseconds: 500));
    
    if (_registeredUsers.containsKey(email)) {
      return false; // Пользователь уже существует
    }
    
    // Создаем нового пользователя
    final userId = DateTime.now().millisecondsSinceEpoch.toString();
    final newUser = UserModel(
      id: userId,
      name: name,
      email: email,
      role: UserRole.user,
      status: UserStatus.active,
      lastLogin: DateTime.now(),
    );
    
    _registeredUsers[email] = AuthCredentials(
      email: email,
      password: password,
      name: name,
    );
    
    _userModels[email] = newUser;
    
    // Автоматически входим после регистрации
    _currentUser = newUser;
    _isAuthenticated = true;
    notifyListeners();
    
    return true;
  }

  void logout() {
    _isAuthenticated = false;
    _currentUser = null;
    notifyListeners();
  }
}
