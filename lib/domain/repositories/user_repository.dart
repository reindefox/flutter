import '../../core/models/user_model.dart';

abstract class UserRepository {
  Future<UserModel> getCurrentUser();

  Future<UserModel> updateCurrentUser({
    String? name,
    String? email,
    String? avatarUrl,
  });

  Future<List<UserModel>> getAllUsers();

  Future<UserModel?> getUserById(String id);

  Future<UserModel> addUser(UserModel user);

  Future<UserModel> updateUser(UserModel user);

  Future<void> deleteUser(String id);

  Future<UserModel> toggleUserStatus(String id);

  Stream<UserModel> watchCurrentUser();

  Stream<List<UserModel>> watchUsers();
}
