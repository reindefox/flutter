import '../../core/models/service_model.dart';
import '../repositories/service_repository.dart';

class GetServicesUseCase {
  final ServiceRepository _repository;

  GetServicesUseCase(this._repository);

  Future<List<ServiceModel>> call() => _repository.getManagedServices();
  
  Stream<List<ServiceModel>> watch() => _repository.watchServices();
}

class GetAvailableServicesUseCase {
  final ServiceRepository _repository;

  GetAvailableServicesUseCase(this._repository);

  Future<List<String>> call() => _repository.getAvailableServices();
  
  Stream<List<String>> watch() => _repository.watchAvailableServices();
}

class AddAvailableServiceUseCase {
  final ServiceRepository _repository;

  AddAvailableServiceUseCase(this._repository);

  Future<void> call(String name) async {
    if (name.trim().isEmpty) {
      throw ArgumentError('Имя сервиса не может быть пустым');
    }
    return _repository.addAvailableService(name.trim());
  }
}

class AddServiceToManagedUseCase {
  final ServiceRepository _repository;

  AddServiceToManagedUseCase(this._repository);

  Future<ServiceModel> call(String name) => _repository.addServiceFromAvailable(name);
}

class StartServiceUseCase {
  final ServiceRepository _repository;

  StartServiceUseCase(this._repository);

  Future<ServiceModel> call(String id) => _repository.startService(id);
}

class StopServiceUseCase {
  final ServiceRepository _repository;

  StopServiceUseCase(this._repository);

  Future<ServiceModel> call(String id) => _repository.stopService(id);
}

class RemoveServiceUseCase {
  final ServiceRepository _repository;

  RemoveServiceUseCase(this._repository);

  Future<void> call(String id) => _repository.removeService(id);
}
