import '../../core/models/container_model.dart';
import '../repositories/container_repository.dart';

class GetContainersUseCase {
  final ContainerRepository _repository;

  GetContainersUseCase(this._repository);

  Future<List<ContainerModel>> call() => _repository.getManagedContainers();
  
  Stream<List<ContainerModel>> watch() => _repository.watchContainers();
}

class GetAvailableContainersUseCase {
  final ContainerRepository _repository;

  GetAvailableContainersUseCase(this._repository);

  Future<List<String>> call() => _repository.getAvailableContainers();
  
  Stream<List<String>> watch() => _repository.watchAvailableContainers();
}

class AddAvailableContainerUseCase {
  final ContainerRepository _repository;

  AddAvailableContainerUseCase(this._repository);

  Future<void> call(String name) async {
    if (name.trim().isEmpty) {
      throw ArgumentError('Имя контейнера не может быть пустым');
    }
    return _repository.addAvailableContainer(name.trim());
  }
}

class AddContainerToManagedUseCase {
  final ContainerRepository _repository;

  AddContainerToManagedUseCase(this._repository);

  Future<ContainerModel> call(String name) => _repository.addContainerFromAvailable(name);
}

class StartContainerUseCase {
  final ContainerRepository _repository;

  StartContainerUseCase(this._repository);

  Future<ContainerModel> call(String id) => _repository.startContainer(id);
}

class StopContainerUseCase {
  final ContainerRepository _repository;

  StopContainerUseCase(this._repository);

  Future<ContainerModel> call(String id) => _repository.stopContainer(id);
}

class RemoveContainerUseCase {
  final ContainerRepository _repository;

  RemoveContainerUseCase(this._repository);

  Future<void> call(String id) => _repository.removeContainer(id);
}
