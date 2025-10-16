import 'package:flutter/widgets.dart';

class ServiceState extends ChangeNotifier {
  final List<Map<String, dynamic>> services = [];
  final List<String> availableServices = ['Сервис A', 'Сервис B', 'Сервис C', 'Сервис D'];

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

class ServiceStateProvider extends InheritedNotifier<ServiceState> {
  const ServiceStateProvider({super.key, required super.notifier, required super.child});

  static ServiceState of(BuildContext context) {
    final provider = context.dependOnInheritedWidgetOfExactType<ServiceStateProvider>();
    assert(provider != null, 'ServiceStateProvider not found in widget tree');
    return provider!.notifier!;
  }
}


