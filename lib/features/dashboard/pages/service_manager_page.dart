import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import '../../../shared/widgets/content_page.dart';
import 'package:project/shared/state/service_state.dart';
import 'package:project/shared/di/service_locator.dart';

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
  late final ServiceState _serviceState;

  @override
  void initState() {
    super.initState();
    _serviceState = getIt<ServiceState>();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Color _statusColor(String status) {
    switch (status) {
      case 'Запущен':
        return Colors.green;
      case 'Ошибка':
        return Colors.red;
      case 'Остановлен':
      default:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    return ContentPage(
      title: 'Сервисы',
      color: Colors.orange,
      body: Observer(
        builder: (_) => Padding(
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
                    onPressed: () {
                      _serviceState.addAvailableService(_controller.text.trim());
                      _controller.clear();
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
                              Expanded(child: _buildAvailableServicesCard(_serviceState)),
                              const SizedBox(width: 12),
                              Expanded(child: _buildManagedServicesCard(_serviceState)),
                            ],
                          )
                        : Column(
                            children: [
                              _buildAvailableServicesCard(_serviceState),
                              const SizedBox(height: 12),
                              Expanded(child: _buildManagedServicesCard(_serviceState)),
                            ],
                          );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAvailableServicesCard(ServiceState state) {
    return Observer(
      builder: (_) => Card(
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
                  itemCount: state.availableServices.length,
                  itemBuilder: (context, index) {
                    final serviceName = state.availableServices[index];
                    final alreadyManaged = state.services.any((s) => s['name'] == serviceName);
                    return ListTile(
                      title: Text(serviceName),
                      trailing: ElevatedButton(
                        onPressed: alreadyManaged
                            ? null
                            : () => state.addServiceFromAvailable(serviceName),
                        child: const Text('Добавить'),
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildManagedServicesCard(ServiceState state) {
    return Observer(
      builder: (_) => Card(
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
                  itemCount: state.services.length,
                  separatorBuilder: (_, __) => const Divider(height: 1),
                  itemBuilder: (context, index) {
                    final service = state.services[index];
                    final status = service['status'] as String;

                    return ListTile(
                      dense: true,
                      title: Text(service['name'], style: const TextStyle(fontWeight: FontWeight.w600)),
                      subtitle: Text(service['log'], maxLines: 1, overflow: TextOverflow.ellipsis),
                      leading: Chip(
                        label: Text(status, style: const TextStyle(color: Colors.white, fontSize: 12)),
                        backgroundColor: _statusColor(status),
                        visualDensity: VisualDensity.compact,
                      ),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: Icon(
                              status == 'Запущен' ? Icons.stop_circle : Icons.play_circle_fill,
                              color: status == 'Запущен' ? Colors.red : Colors.green,
                              size: 22,
                            ),
                            tooltip: status == 'Запущен' ? 'Остановить' : 'Запустить',
                            onPressed: () => status == 'Запущен'
                                ? state.stopService(index)
                                : state.startService(index),
                          ),
                          IconButton(
                            icon: const Icon(Icons.delete_outline, color: Colors.grey, size: 20),
                            tooltip: 'Удалить',
                            onPressed: () => state.removeService(service['name'] as String),
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
      ),
    );
  }
}
