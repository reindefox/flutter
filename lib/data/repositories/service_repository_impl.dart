import '../../core/models/service_model.dart';
import '../../domain/repositories/service_repository.dart';
import '../datasources/local/service_local_datasource.dart';

class ServiceRepositoryImpl implements ServiceRepository {
  final ServiceLocalDataSource _localDataSource;

  ServiceRepositoryImpl(this._localDataSource);

  @override
  Future<List<ServiceModel>> getManagedServices() async {
    return _localDataSource.getServices();
  }

  @override
  Future<List<String>> getAvailableServices() async {
    return _localDataSource.getAvailableServices();
  }

  @override
  Future<void> addAvailableService(String name) async {
    _localDataSource.addAvailableService(name);
  }

  @override
  Future<ServiceModel> addServiceFromAvailable(String name) async {
    return _localDataSource.addServiceFromAvailable(name);
  }

  @override
  Future<ServiceModel> startService(String id) async {
    return _localDataSource.startService(id);
  }

  @override
  Future<ServiceModel> stopService(String id) async {
    return _localDataSource.stopService(id);
  }

  @override
  Future<void> removeService(String id) async {
    _localDataSource.removeService(id);
  }

  @override
  Stream<List<ServiceModel>> watchServices() {
    return _localDataSource.servicesStream;
  }

  @override
  Stream<List<String>> watchAvailableServices() {
    return _localDataSource.availableStream;
  }
}
