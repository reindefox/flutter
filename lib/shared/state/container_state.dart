import 'package:mobx/mobx.dart';

part 'container_state.g.dart';

class ContainerState = _ContainerState with _$ContainerState;

abstract class _ContainerState with Store {
  @observable
  ObservableList<Map<String, dynamic>> containers = ObservableList<Map<String, dynamic>>();

  @observable
  ObservableList<String> availableContainers = ObservableList<String>.of([
    'nginx',
    'redis',
    'postgres',
    'prometheus',
  ]);

  @action
  void addAvailableContainer(String name) {
    if (name.trim().isEmpty) return;
    if (availableContainers.contains(name)) return;
    availableContainers.add(name);
  }

  @action
  void addContainerFromAvailable(String name) {
    if (containers.any((c) => c['name'] == name)) return;
    containers.add({
      'name': name,
      'running': false,
      'log': 'Контейнер добавлен из доступных',
    });
  }

  @action
  void startContainer(int index) {
    if (index < 0 || index >= containers.length) return;
    if (containers[index]['running'] == true) return;
    final name = containers[index]['name'];
    containers[index] = {
      'name': name,
      'running': false,
      'log': 'Запуск контейнера...',
    };
    Future.delayed(const Duration(seconds: 1), () {
      runInAction(() {
        if (index < containers.length && containers[index]['name'] == name) {
          containers[index] = {
            'name': name,
            'running': true,
            'log': 'Контейнер запущен ✅',
          };
        }
      });
    });
  }

  @action
  void stopContainer(int index) {
    if (index < 0 || index >= containers.length) return;
    if (containers[index]['running'] != true) return;
    final name = containers[index]['name'];
    containers[index] = {
      'name': name,
      'running': false,
      'log': 'Остановка контейнера...',
    };
    Future.delayed(const Duration(seconds: 1), () {
      runInAction(() {
        if (index < containers.length && containers[index]['name'] == name) {
          containers[index] = {
            'name': name,
            'running': false,
            'log': 'Контейнер остановлен ⛔',
          };
        }
      });
    });
  }

  @action
  void removeContainer(String name) {
    containers.removeWhere((container) => container['name'] == name);
  }
}
