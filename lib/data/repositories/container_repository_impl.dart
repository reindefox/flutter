import '../../core/models/container_model.dart';
import '../../domain/repositories/container_repository.dart';
import '../../domain/repositories/api_repository.dart';
import '../datasources/local/container_local_datasource.dart';

class ContainerRepositoryImpl implements ContainerRepository {
  final ContainerLocalDataSource _localDataSource;
  final GithubApiRepository _githubRepository;

  ContainerRepositoryImpl(this._localDataSource, this._githubRepository);

  @override
  Future<List<ContainerModel>> getManagedContainers() async {
    return _localDataSource.getContainers();
  }

  @override
  Future<List<String>> getAvailableContainers() async {
    return _localDataSource.getAvailableContainers();
  }

  @override
  Future<void> addAvailableContainer(String name) async {
    _localDataSource.addAvailableContainer(name);
  }

  @override
  Future<ContainerModel> addContainerFromAvailable(String name) async {
    return _localDataSource.addContainerFromAvailable(name);
  }

  @override
  Future<ContainerModel> addContainerFromGithubRepository(String owner, String repo) async {
    final githubRepo = await _githubRepository.getRepository(owner, repo);
    return _localDataSource.addContainerFromGithubRepository(githubRepo);
  }

  @override
  Future<ContainerModel> startContainer(String id) async {
    return _localDataSource.startContainer(id);
  }

  @override
  Future<ContainerModel> stopContainer(String id) async {
    return _localDataSource.stopContainer(id);
  }

  @override
  Future<void> removeContainer(String id) async {
    _localDataSource.removeContainer(id);
  }

  @override
  Stream<List<ContainerModel>> watchContainers() {
    return _localDataSource.containersStream;
  }

  @override
  Stream<List<String>> watchAvailableContainers() {
    return _localDataSource.availableStream;
  }
}
