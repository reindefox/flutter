import 'dart:math';
import 'package:flutter/widgets.dart';

class AppState extends ChangeNotifier {
  final Random _random = Random();

  Map<String, String> currentUser = {
    'name': 'Лев Герасимов',
    'email': 'reindefox@example.com',
  };

  void updateUser({String? name, String? email}) {
    final updated = Map<String, String>.from(currentUser);
    if (name != null) updated['name'] = name;
    if (email != null) updated['email'] = email;
    currentUser = updated;
    notifyListeners();
  }

  final List<Map<String, dynamic>> pings = [];

  final List<Map<String, dynamic>> containers = [];
  final List<String> availableContainers = [
    'nginx',
    'redis',
    'postgres',
    'prometheus',
  ];

  final List<Map<String, dynamic>> services = [];
  final List<String> availableServices = [
    'Сервис A',
    'Сервис B',
    'Сервис C',
    'Сервис D',
  ];

  void sendPing() {
    final String time = DateTime.now().toLocal().toIso8601String().substring(11, 19);
    pings.add({'time': time, 'ping': null});
    notifyListeners();

    final int index = pings.length - 1;
    Future.delayed(const Duration(seconds: 1), () {
      if (index < pings.length) {
        pings[index]['ping'] = _random.nextInt(100) + 1;
        notifyListeners();
      }
    });
  }

  void clearPings() {
    pings.clear();
    notifyListeners();
  }

  void removePing(String time) {
    pings.removeWhere((ping) => ping['time'] == time);
    notifyListeners();
  }

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

  void addAvailableService(String name) {
    if (name.trim().isEmpty) return;
    if (availableServices.contains(name)) return;
    availableServices.add(name);
    notifyListeners();
  }

  void addServiceFromAvailable(String name) {
    if (services.any((s) => s['name'] == name)) return;
    services.add({'name': name, 'status': 'Остановлен', 'log': 'Сервис добавлен из доступных'});
    notifyListeners();
  }

  void startService(int index) {
    if (index < 0 || index >= services.length) return;
    if (services[index]['status'] == 'Запущен') return;
    services[index]['log'] = 'Запуск сервиса...';
    notifyListeners();
    Future.delayed(const Duration(seconds: 1), () {
      if (index < services.length) {
        services[index]['status'] = 'Запущен';
        services[index]['log'] = 'Сервис запущен ✅';
        notifyListeners();
      }
    });
  }

  void stopService(int index) {
    if (index < 0 || index >= services.length) return;
    if (services[index]['status'] != 'Запущен') return;
    services[index]['log'] = 'Остановка сервиса...';
    notifyListeners();
    Future.delayed(const Duration(seconds: 1), () {
      if (index < services.length) {
        services[index]['status'] = 'Остановлен';
        services[index]['log'] = 'Сервис остановлен ⛔';
        notifyListeners();
      }
    });
  }

  void removeService(String name) {
    services.removeWhere((service) => service['name'] == name);
    notifyListeners();
  }
}

class AppStateProvider extends InheritedNotifier<AppState> {
  const AppStateProvider({super.key, required super.notifier, required super.child});

  static AppState of(BuildContext context) {
    final provider = context.dependOnInheritedWidgetOfExactType<AppStateProvider>();
    assert(provider != null, 'AppStateProvider not found in widget tree');
    return provider!.notifier!;
  }
}


