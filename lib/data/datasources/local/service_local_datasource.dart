import 'dart:async';
import '../../../core/models/service_model.dart';

class ServiceDTO {
  final String id;
  final String name;
  final String status;
  final String log;
  final DateTime? lastUpdated;

  ServiceDTO({
    required this.id,
    required this.name,
    required this.status,
    required this.log,
    this.lastUpdated,
  });

  ServiceModel toModel() {
    return ServiceModel(
      id: id,
      name: name,
      status: _parseStatus(status),
      log: log,
      lastUpdated: lastUpdated,
    );
  }

  ServiceStatus _parseStatus(String status) {
    switch (status) {
      case 'Запущен':
        return ServiceStatus.running;
      case 'Ошибка':
        return ServiceStatus.error;
      default:
        return ServiceStatus.stopped;
    }
  }

  factory ServiceDTO.fromModel(ServiceModel model) {
    return ServiceDTO(
      id: model.id,
      name: model.name,
      status: model.status.displayName,
      log: model.log,
      lastUpdated: model.lastUpdated,
    );
  }
}

class ServiceLocalDataSource {
  final List<ServiceDTO> _services = [];
  final List<String> _availableServices = ['Сервис A', 'Сервис B', 'Сервис C', 'Сервис D'];
  
  final _servicesController = StreamController<List<ServiceModel>>.broadcast();
  final _availableController = StreamController<List<String>>.broadcast();

  Stream<List<ServiceModel>> get servicesStream => _servicesController.stream;
  Stream<List<String>> get availableStream => _availableController.stream;

  List<ServiceModel> getServices() {
    return _services.map((dto) => dto.toModel()).toList();
  }

  List<String> getAvailableServices() {
    return List.unmodifiable(_availableServices);
  }

  void addAvailableService(String name) {
    if (!_availableServices.contains(name)) {
      _availableServices.add(name);
      _notifyAvailableChanged();
    }
  }

  ServiceModel addServiceFromAvailable(String name) {
    if (_services.any((s) => s.name == name)) {
      throw StateError('Сервис уже добавлен');
    }
    
    final dto = ServiceDTO(
      id: DateTime.now().microsecondsSinceEpoch.toString(),
      name: name,
      status: 'Остановлен',
      log: 'Сервис добавлен из доступных',
    );
    _services.add(dto);
    _notifyServicesChanged();
    return dto.toModel();
  }

  Future<ServiceModel> startService(String id) async {
    final index = _services.indexWhere((s) => s.id == id);
    if (index == -1) throw StateError('Сервис не найден');
    
    final current = _services[index];
    if (current.status == 'Запущен') return current.toModel();
    
    _services[index] = ServiceDTO(
      id: current.id,
      name: current.name,
      status: 'Остановлен',
      log: 'Запуск сервиса...',
    );
    _notifyServicesChanged();
    
    await Future.delayed(const Duration(seconds: 1));
    
    _services[index] = ServiceDTO(
      id: current.id,
      name: current.name,
      status: 'Запущен',
      log: 'Сервис запущен ✅',
      lastUpdated: DateTime.now(),
    );
    _notifyServicesChanged();
    
    return _services[index].toModel();
  }

  Future<ServiceModel> stopService(String id) async {
    final index = _services.indexWhere((s) => s.id == id);
    if (index == -1) throw StateError('Сервис не найден');
    
    final current = _services[index];
    if (current.status != 'Запущен') return current.toModel();
    
    _services[index] = ServiceDTO(
      id: current.id,
      name: current.name,
      status: 'Запущен',
      log: 'Остановка сервиса...',
    );
    _notifyServicesChanged();
    
    await Future.delayed(const Duration(seconds: 1));
    
    _services[index] = ServiceDTO(
      id: current.id,
      name: current.name,
      status: 'Остановлен',
      log: 'Сервис остановлен ⛔',
      lastUpdated: DateTime.now(),
    );
    _notifyServicesChanged();
    
    return _services[index].toModel();
  }

  void removeService(String id) {
    _services.removeWhere((s) => s.id == id);
    _notifyServicesChanged();
  }

  void _notifyServicesChanged() {
    _servicesController.add(getServices());
  }

  void _notifyAvailableChanged() {
    _availableController.add(getAvailableServices());
  }

  void dispose() {
    _servicesController.close();
    _availableController.close();
  }
}
