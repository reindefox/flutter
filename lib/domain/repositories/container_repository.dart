import '../../core/models/container_model.dart';
import 'api_repository.dart';

abstract class ContainerRepository {
  Future<List<ContainerModel>> getManagedContainers();

  Future<List<String>> getAvailableContainers();

  Future<void> addAvailableContainer(String name);

  Future<ContainerModel> addContainerFromAvailable(String name);

  Future<ContainerModel> addContainerFromGithubRepository(String owner, String repo);

  Future<ContainerModel> startContainer(String id);

  Future<ContainerModel> stopContainer(String id);

  Future<void> removeContainer(String id);

  Stream<List<ContainerModel>> watchContainers();

  Stream<List<String>> watchAvailableContainers();
}
