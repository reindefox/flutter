import '../../core/models/user_model.dart';
import '../repositories/user_repository.dart';

class GetCurrentUserUseCase {
  final UserRepository _repository;

  GetCurrentUserUseCase(this._repository);

  Future<UserModel> call() => _repository.getCurrentUser();
  
  Stream<UserModel> watch() => _repository.watchCurrentUser();
}

class UpdateCurrentUserUseCase {
  final UserRepository _repository;

  UpdateCurrentUserUseCase(this._repository);

  Future<UserModel> call({String? name, String? email, String? avatarUrl}) {
    return _repository.updateCurrentUser(
      name: name,
      email: email,
      avatarUrl: avatarUrl,
    );
  }
}

class GetAllUsersUseCase {
  final UserRepository _repository;

  GetAllUsersUseCase(this._repository);

  Future<List<UserModel>> call() => _repository.getAllUsers();
  
  Stream<List<UserModel>> watch() => _repository.watchUsers();
}

class AddUserUseCase {
  final UserRepository _repository;

  AddUserUseCase(this._repository);

  Future<UserModel> call(UserModel user) => _repository.addUser(user);
}

class UpdateUserUseCase {
  final UserRepository _repository;

  UpdateUserUseCase(this._repository);

  Future<UserModel> call(UserModel user) => _repository.updateUser(user);
}

class DeleteUserUseCase {
  final UserRepository _repository;

  DeleteUserUseCase(this._repository);

  Future<void> call(String id) => _repository.deleteUser(id);
}

class ToggleUserStatusUseCase {
  final UserRepository _repository;

  ToggleUserStatusUseCase(this._repository);

  Future<UserModel> call(String id) => _repository.toggleUserStatus(id);
}
