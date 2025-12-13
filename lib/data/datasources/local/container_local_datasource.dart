import 'dart:async';
import '../../../core/models/container_model.dart';

import '../../../core/models/api/api_models.dart';

class ContainerDTO {
  final String id;
  final String name;
  final bool running;
  final String log;
  final DateTime? startedAt;
  final GithubRepository? repository;

  ContainerDTO({
    required this.id,
    required this.name,
    required this.running,
    required this.log,
    this.startedAt,
    this.repository,
  });

  ContainerModel toModel() {
    return ContainerModel(
      id: id,
      name: name,
      isRunning: running,
      log: log,
      startedAt: startedAt,
      repository: repository,
    );
  }

  factory ContainerDTO.fromModel(ContainerModel model) {
    return ContainerDTO(
      id: model.id,
      name: model.name,
      running: model.isRunning,
      log: model.log,
      startedAt: model.startedAt,
      repository: model.repository,
    );
  }
}

class ContainerLocalDataSource {
  final List<ContainerDTO> _containers = [];
  final List<String> _availableContainers = ['nginx', 'redis', 'postgres', 'prometheus'];
  
  final _containersController = StreamController<List<ContainerModel>>.broadcast();
  final _availableController = StreamController<List<String>>.broadcast();

  Stream<List<ContainerModel>> get containersStream => _containersController.stream;
  Stream<List<String>> get availableStream => _availableController.stream;

  List<ContainerModel> getContainers() {
    return _containers.map((dto) => dto.toModel()).toList();
  }

  List<String> getAvailableContainers() {
    return List.unmodifiable(_availableContainers);
  }

  void addAvailableContainer(String name) {
    if (!_availableContainers.contains(name)) {
      _availableContainers.add(name);
      _notifyAvailableChanged();
    }
  }

  ContainerModel addContainerFromAvailable(String name) {
    if (_containers.any((c) => c.name == name && c.repository == null)) {
      throw StateError('Контейнер уже добавлен');
    }
    
    final dto = ContainerDTO(
      id: DateTime.now().microsecondsSinceEpoch.toString(),
      name: name,
      running: false,
      log: 'Контейнер добавлен из доступных',
    );
    _containers.add(dto);
    _notifyContainersChanged();
    return dto.toModel();
  }

  ContainerModel addContainerFromGithubRepository(GithubRepository repository) {
    final containerName = repository.fullName;
    if (_containers.any((c) => c.repository?.fullName == containerName)) {
      throw StateError('Репозиторий уже добавлен как контейнер');
    }
    
    final dto = ContainerDTO(
      id: DateTime.now().microsecondsSinceEpoch.toString(),
      name: containerName,
      running: false,
      log: 'Контейнер добавлен из GitHub репозитория: ${repository.description ?? repository.name}',
      repository: repository,
    );
    _containers.add(dto);
    _notifyContainersChanged();
    return dto.toModel();
  }

  Future<ContainerModel> startContainer(String id) async {
    final index = _containers.indexWhere((c) => c.id == id);
    if (index == -1) throw StateError('Контейнер не найден');
    
    final current = _containers[index];
    if (current.running) return current.toModel();
    
    _containers[index] = ContainerDTO(
      id: current.id,
      name: current.name,
      running: false,
      log: 'Запуск контейнера...',
    );
    _notifyContainersChanged();
    
    await Future.delayed(const Duration(seconds: 1));
    
    _containers[index] = ContainerDTO(
      id: current.id,
      name: current.name,
      running: true,
      log: 'Контейнер запущен ✅',
      startedAt: DateTime.now(),
    );
    _notifyContainersChanged();
    
    return _containers[index].toModel();
  }

  Future<ContainerModel> stopContainer(String id) async {
    final index = _containers.indexWhere((c) => c.id == id);
    if (index == -1) throw StateError('Контейнер не найден');
    
    final current = _containers[index];
    if (!current.running) return current.toModel();
    
    _containers[index] = ContainerDTO(
      id: current.id,
      name: current.name,
      running: true,
      log: 'Остановка контейнера...',
    );
    _notifyContainersChanged();
    
    await Future.delayed(const Duration(seconds: 1));
    
    _containers[index] = ContainerDTO(
      id: current.id,
      name: current.name,
      running: false,
      log: 'Контейнер остановлен ⛔',
    );
    _notifyContainersChanged();
    
    return _containers[index].toModel();
  }

  void removeContainer(String id) {
    _containers.removeWhere((c) => c.id == id);
    _notifyContainersChanged();
  }

  void _notifyContainersChanged() {
    _containersController.add(getContainers());
  }

  void _notifyAvailableChanged() {
    _availableController.add(getAvailableContainers());
  }

  void dispose() {
    _containersController.close();
    _availableController.close();
  }
}
