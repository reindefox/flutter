import '../../core/models/service_model.dart';

abstract class ServiceRepository {
  Future<List<ServiceModel>> getManagedServices();

  Future<List<String>> getAvailableServices();

  Future<void> addAvailableService(String name);

  Future<ServiceModel> addServiceFromAvailable(String name);

  Future<ServiceModel> startService(String id);

  Future<ServiceModel> stopService(String id);

  Future<void> removeService(String id);

  Stream<List<ServiceModel>> watchServices();

  Stream<List<String>> watchAvailableServices();
}
