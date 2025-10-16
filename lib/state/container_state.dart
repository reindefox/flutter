import 'package:flutter/widgets.dart';

class ContainerState extends ChangeNotifier {
  final List<Map<String, dynamic>> containers = [];
  final List<String> availableContainers = ['nginx', 'redis', 'postgres', 'prometheus'];

  void addAvailableContainer(String name) {
    if (name.trim().isEmpty) return;
    if (availableContainers.contains(name)) return;
    availableContainers.add(name);
    notifyListeners();
  }

  void addContainerFromAvailable(String name) {
    if (containers.any((c) => c['name'] == name)) return;
    containers.add({'name': name, 'running': false, 'log': 'Контейнер добавлен из доступных'});
    notifyListeners();
  }

  void startContainer(int index) {
    if (index < 0 || index >= containers.length) return;
    if (containers[index]['running'] == true) return;
    containers[index]['log'] = 'Запуск контейнера...';
    notifyListeners();
    Future.delayed(const Duration(seconds: 1), () {
      if (index < containers.length) {
        containers[index]['running'] = true;
        containers[index]['log'] = 'Контейнер запущен ✅';
        notifyListeners();
      }
    });
  }

  void stopContainer(int index) {
    if (index < 0 || index >= containers.length) return;
    if (containers[index]['running'] != true) return;
    containers[index]['log'] = 'Остановка контейнера...';
    notifyListeners();
    Future.delayed(const Duration(seconds: 1), () {
      if (index < containers.length) {
        containers[index]['running'] = false;
        containers[index]['log'] = 'Контейнер остановлен ⛔';
        notifyListeners();
      }
    });
  }

  void removeContainer(String name) {
    containers.removeWhere((container) => container['name'] == name);
    notifyListeners();
  }
}

class ContainerStateProvider extends InheritedNotifier<ContainerState> {
  const ContainerStateProvider({super.key, required super.notifier, required super.child});

  static ContainerState of(BuildContext context) {
    final provider = context.dependOnInheritedWidgetOfExactType<ContainerStateProvider>();
    assert(provider != null, 'ContainerStateProvider not found in widget tree');
    return provider!.notifier!;
  }
}


