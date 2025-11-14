import 'package:mobx/mobx.dart';

part 'service_state.g.dart';

class ServiceState = _ServiceState with _$ServiceState;

abstract class _ServiceState with Store {
  @observable
  ObservableList<Map<String, dynamic>> services = ObservableList<Map<String, dynamic>>();

  @observable
  ObservableList<String> availableServices = ObservableList<String>.of([
    'Сервис A',
    'Сервис B',
    'Сервис C',
    'Сервис D',
  ]);

  @action
  void addAvailableService(String name) {
    if (name.trim().isEmpty) return;
    if (availableServices.contains(name)) return;
    availableServices.add(name);
  }

  @action
  void addServiceFromAvailable(String name) {
    if (services.any((s) => s['name'] == name)) return;
    services.add({
      'name': name,
      'status': 'Остановлен',
      'log': 'Сервис добавлен из доступных',
    });
  }

  @action
  void startService(int index) {
    if (index < 0 || index >= services.length) return;
    if (services[index]['status'] == 'Запущен') return;
    final name = services[index]['name'];
    services[index] = {
      'name': name,
      'status': 'Остановлен',
      'log': 'Запуск сервиса...',
    };
    Future.delayed(const Duration(seconds: 1), () {
      runInAction(() {
        if (index < services.length && services[index]['name'] == name) {
          services[index] = {
            'name': name,
            'status': 'Запущен',
            'log': 'Сервис запущен ✅',
          };
        }
      });
    });
  }

  @action
  void stopService(int index) {
    if (index < 0 || index >= services.length) return;
    if (services[index]['status'] != 'Запущен') return;
    final name = services[index]['name'];
    services[index] = {
      'name': name,
      'status': 'Запущен',
      'log': 'Остановка сервиса...',
    };
    Future.delayed(const Duration(seconds: 1), () {
      runInAction(() {
        if (index < services.length && services[index]['name'] == name) {
          services[index] = {
            'name': name,
            'status': 'Остановлен',
            'log': 'Сервис остановлен ⛔',
          };
        }
      });
    });
  }

  @action
  void removeService(String name) {
    services.removeWhere((service) => service['name'] == name);
  }
}
