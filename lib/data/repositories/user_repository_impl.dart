import '../../core/models/user_model.dart';
import '../../domain/repositories/user_repository.dart';
import '../datasources/local/user_local_datasource.dart';

class UserRepositoryImpl implements UserRepository {
  final UserLocalDataSource _localDataSource;

  UserRepositoryImpl(this._localDataSource);

  @override
  Future<UserModel> getCurrentUser() async {
    return _localDataSource.getCurrentUser();
  }

  @override
  Future<UserModel> updateCurrentUser({
    String? name,
    String? email,
    String? avatarUrl,
  }) async {
    return _localDataSource.updateCurrentUser(
      name: name,
      email: email,
      avatarUrl: avatarUrl,
    );
  }

  @override
  Future<List<UserModel>> getAllUsers() async {
    return _localDataSource.getAllUsers();
  }

  @override
  Future<UserModel?> getUserById(String id) async {
    return _localDataSource.getUserById(id);
  }

  @override
  Future<UserModel> addUser(UserModel user) async {
    return _localDataSource.addUser(user);
  }

  @override
  Future<UserModel> updateUser(UserModel user) async {
    return _localDataSource.updateUser(user);
  }

  @override
  Future<void> deleteUser(String id) async {
    _localDataSource.deleteUser(id);
  }

  @override
  Future<UserModel> toggleUserStatus(String id) async {
    return _localDataSource.toggleUserStatus(id);
  }

  @override
  Stream<UserModel> watchCurrentUser() {
    return _localDataSource.currentUserStream;
  }

  @override
  Stream<List<UserModel>> watchUsers() {
    return _localDataSource.usersStream;
  }
}
