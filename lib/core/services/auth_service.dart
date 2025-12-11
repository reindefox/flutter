import 'package:flutter/foundation.dart';
import '../models/user_model.dart';
import 'secure_storage_service.dart';

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
  final SecureStorageService _secureStorage;
  
  bool _isAuthenticated = false;
  UserModel? _currentUser;
  
  final Map<String, AuthCredentials> _registeredUsers = {};
  
  final Map<String, UserModel> _userModels = {};

  bool get isAuthenticated => _isAuthenticated;
  UserModel? get currentUser => _currentUser;

  AuthService(this._secureStorage) {
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

  Future<bool> tryRestoreSession() async {
    final savedEmail = await _secureStorage.getUserEmail();
    if (savedEmail == null) return false;
    
    final user = _userModels[savedEmail];
    if (user == null) return false;
    
    _currentUser = user;
    _isAuthenticated = true;
    notifyListeners();
    return true;
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
    
    _userModels[email] = user.copyWith(
      lastLogin: DateTime.now(),
    );
    
    _currentUser = _userModels[email];
    _isAuthenticated = true;
    
    await _secureStorage.saveAuthData(
      email: email,
      userData: {
        'id': _currentUser!.id,
        'name': _currentUser!.name,
        'email': _currentUser!.email,
        'role': _currentUser!.role.index,
      },
    );
    
    notifyListeners();
    
    return true;
  }

  Future<bool> register(String email, String password, String name) async {
    await Future.delayed(const Duration(milliseconds: 500));
    
    if (_registeredUsers.containsKey(email)) {
      return false;
    }
    
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
    
    _currentUser = newUser;
    _isAuthenticated = true;
    
    await _secureStorage.saveAuthData(
      email: email,
      userData: {
        'id': newUser.id,
        'name': newUser.name,
        'email': newUser.email,
        'role': newUser.role.index,
      },
    );
    
    notifyListeners();
    
    return true;
  }

  Future<void> logout() async {
    _isAuthenticated = false;
    _currentUser = null;
    
    await _secureStorage.clearAuthData();
    
    notifyListeners();
  }
}
