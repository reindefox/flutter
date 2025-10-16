import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'base/contentPage.dart';

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
  final List<Map<String, dynamic>> services = [];
  final List<String> availableServices = [
    'Сервис A',
    'Сервис B',
    'Сервис C',
    'Сервис D',
  ];
  final Random _random = Random();

  void _addService() {
    final name = _controller.text.trim();
    if (name.isEmpty) return;
    if (availableServices.contains(name)) {
      _controller.clear();
      return;
    }
    setState(() {
      availableServices.add(name);
    });
    _controller.clear();
  }

  void _startService(int index) {
    if (services[index]['status'] == 'Запущен') return;

    setState(() {
      services[index]['log'] = 'Запуск сервиса...';
    });

    Future.delayed(const Duration(seconds: 1), () {
      if (!mounted) return;

      setState(() {
        services[index]['status'] = 'Запущен';
        services[index]['log'] = 'Сервис запущен ✅';
      });
    });
  }

  void _stopService(int index) {
    if (services[index]['status'] != 'Запущен') return;

    setState(() {
      services[index]['log'] = 'Остановка сервиса...';
    });

    Future.delayed(const Duration(seconds: 1), () {
      if (!mounted) return;
      setState(() {
        services[index]['status'] = 'Остановлен';
        services[index]['log'] = 'Сервис остановлен ⛔';
      });
    });
  }

  void _removeService(String name) {
    setState(() {
      services.removeWhere((service) => service['name'] == name);
    });
  }

  void _addServiceFromAvailable(String name) {
    setState(() {
      services.add({
        'name': name,
        'status': 'Остановлен',
        'log': 'Сервис добавлен из доступных',
      });
    });
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
                  onPressed: _addService,
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
                itemCount: availableServices.length,
                itemBuilder: (context, index) {
                  final serviceName = availableServices[index];
                  final alreadyManaged = services.any((s) => s['name'] == serviceName);
                  return ListTile(
                    title: Text(serviceName),
                    trailing: ElevatedButton(
                      onPressed: alreadyManaged ? null : () => _addServiceFromAvailable(serviceName),
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
                itemCount: services.length,
                separatorBuilder: (_, __) => const Divider(height: 1),
                itemBuilder: (context, index) {
                  final service = services[index];
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
                          onPressed: () => status == 'Запущен' ? _stopService(index) : _startService(index),
                        ),
                        IconButton(
                          icon: const Icon(Icons.delete_outline, color: Colors.grey, size: 20),
                          tooltip: 'Удалить',
                          onPressed: () => _removeService(service['name']),
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
