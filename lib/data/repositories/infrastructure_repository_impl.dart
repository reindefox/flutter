import 'package:project/data/datasources/remote/infrastructure_datasource.dart';
import 'package:project/domain/repositories/api_repository.dart'
    show InfrastructureRepository;

class InfrastructureRepositoryImpl implements InfrastructureRepository {
  final InfrastructureDataSource _dataSource;

  InfrastructureRepositoryImpl(this._dataSource);

  @override
  Future<InfrastructureStatus> getMainServerStatus() {
    return _dataSource.getMainServerStatus();
  }

  @override
  Future<List<InfrastructureService>> getServicesStatus() {
    return _dataSource.getServicesStatus();
  }
}
