import 'dart:async';
import 'package:flutter/material.dart';
import '../../../shared/widgets/content_page.dart';
import '../../../core/models/service_model.dart';
import '../../../domain/usecases/service_usecases.dart';
import '../../../shared/di/service_locator.dart';

class ServicesPage extends StatefulWidget {
  const ServicesPage({super.key});

  @override
  State<ServicesPage> createState() => _ListViewSeparatedPageState();
}

class ListViewSeparatedPage extends ServicesPage {
  const ListViewSeparatedPage({super.key});
}

class _ListViewSeparatedPageState extends State<ListViewSeparatedPage> {
  final TextEditingController _controller = TextEditingController();
  
  late final GetServicesUseCase _getServices;
  late final GetAvailableServicesUseCase _getAvailableServices;
  late final AddAvailableServiceUseCase _addAvailableService;
  late final AddServiceToManagedUseCase _addServiceToManaged;
  late final StartServiceUseCase _startService;
  late final StopServiceUseCase _stopService;
  late final RemoveServiceUseCase _removeService;

  List<ServiceModel> _services = [];
  List<String> _availableServices = [];
  StreamSubscription? _servicesSub;
  StreamSubscription? _availableSub;

  @override
  void initState() {
    super.initState();
    _getServices = getIt<GetServicesUseCase>();
    _getAvailableServices = getIt<GetAvailableServicesUseCase>();
    _addAvailableService = getIt<AddAvailableServiceUseCase>();
    _addServiceToManaged = getIt<AddServiceToManagedUseCase>();
    _startService = getIt<StartServiceUseCase>();
    _stopService = getIt<StopServiceUseCase>();
    _removeService = getIt<RemoveServiceUseCase>();

    _loadData();
    _subscribeToChanges();
  }

  Future<void> _loadData() async {
    final services = await _getServices();
    final available = await _getAvailableServices();
    setState(() {
      _services = services;
      _availableServices = available;
    });
  }

  void _subscribeToChanges() {
    _servicesSub = _getServices.watch().listen((services) {
      setState(() => _services = services);
    });
    _availableSub = _getAvailableServices.watch().listen((available) {
      setState(() => _availableServices = available);
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    _servicesSub?.cancel();
    _availableSub?.cancel();
    super.dispose();
  }

  Color _statusColor(ServiceStatus status) {
    switch (status) {
      case ServiceStatus.running:
        return Colors.green;
      case ServiceStatus.error:
        return Colors.red;
      case ServiceStatus.stopped:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    return ContentPage(
      title: 'Сервисы',
      color: Colors.orange,
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _controller,
                    decoration: const InputDecoration(
                      labelText: 'Имя сервиса',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                ElevatedButton(
                  onPressed: () async {
                    try {
                      await _addAvailableService(_controller.text.trim());
                      _controller.clear();
                    } catch (e) {
                    }
                  },
                  child: const Text('Добавить'),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Expanded(
              child: LayoutBuilder(
                builder: (context, constraints) {
                  final isWide = constraints.maxWidth > 700;
                  return isWide
                      ? Row(
                          children: [
                            Expanded(child: _buildAvailableServicesCard()),
                            const SizedBox(width: 12),
                            Expanded(child: _buildManagedServicesCard()),
                          ],
                        )
                      : Column(
                          children: [
                            _buildAvailableServicesCard(),
                            const SizedBox(height: 12),
                            Expanded(child: _buildManagedServicesCard()),
                          ],
                        );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAvailableServicesCard() {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Доступные сервисы:',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Expanded(
              child: ListView.builder(
                itemCount: _availableServices.length,
                itemBuilder: (context, index) {
                  final serviceName = _availableServices[index];
                  final alreadyManaged = _services.any((s) => s.name == serviceName);
                  return ListTile(
                    title: Text(serviceName),
                    trailing: ElevatedButton(
                      onPressed: alreadyManaged
                          ? null
                          : () => _addServiceToManaged(serviceName),
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                      ),
                      child: const Text('Добавить'),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildManagedServicesCard() {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: Padding(
        padding: const EdgeInsets.all(8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 4, vertical: 8),
              child: Text(
                'Управление сервисами:',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ),
            const Divider(height: 4),
            Expanded(
              child: ListView.separated(
                itemCount: _services.length,
                separatorBuilder: (_, __) => const Divider(height: 1),
                itemBuilder: (context, index) {
                  final service = _services[index];

                  return ListTile(
                    dense: true,
                    title: Text(
                      service.name,
                      style: const TextStyle(fontWeight: FontWeight.w600),
                    ),
                    subtitle: Text(
                      service.log,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    leading: Chip(
                      label: Text(
                        service.status.displayName,
                        style: const TextStyle(color: Colors.white, fontSize: 12),
                      ),
                      backgroundColor: _statusColor(service.status),
                      visualDensity: VisualDensity.compact,
                    ),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: Icon(
                            service.isRunning ? Icons.stop_circle : Icons.play_circle_fill,
                            color: service.isRunning ? Colors.red : Colors.green,
                            size: 22,
                          ),
                          tooltip: service.isRunning ? 'Остановить' : 'Запустить',
                          onPressed: () => service.isRunning
                              ? _stopService(service.id)
                              : _startService(service.id),
                        ),
                        IconButton(
                          icon: const Icon(Icons.delete_outline, color: Colors.grey, size: 20),
                          tooltip: 'Удалить',
                          onPressed: () => _removeService(service.id),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
