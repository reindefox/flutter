import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'base/contentPage.dart';

class ListViewSeparatedPage extends StatefulWidget {
  const ListViewSeparatedPage({super.key});

  @override
  State<ListViewSeparatedPage> createState() => _ListViewSeparatedPageState();
}

class _ListViewSeparatedPageState extends State<ListViewSeparatedPage> {
  final TextEditingController _controller = TextEditingController();
  final List<Map<String, dynamic>> services = [];
  final Random _random = Random();

  void _addService() {
    final name = _controller.text.trim();
    if (name.isEmpty) return;

    setState(() {
      services.add({
        'name': name,
        'status': 'Остановлен',
        'log': 'Сервис добавлен',
      });
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

  void _removeService(int index) {
    setState(() {
      services.removeAt(index);
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
              child: ListView.separated(
                itemCount: services.length,
                separatorBuilder: (_, __) => const Divider(height: 1),
                itemBuilder: (context, index) {
                  final service = services[index];
                  final status = service['status'];

                  return ListTile(
                    title: Text(
                      service['name'],
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text(service['log']),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: Icon(
                            status == 'Запущен' ? Icons.stop : Icons.play_arrow,
                            color: status == 'Запущен'
                                ? Colors.red
                                : Colors.green,
                          ),
                          tooltip: status == 'Запущен'
                              ? 'Остановить'
                              : 'Запустить',
                          onPressed: () => status == 'Запущен'
                              ? _stopService(index)
                              : _startService(index),
                        ),
                        IconButton(
                          icon: const Icon(Icons.delete, color: Colors.grey),
                          tooltip: 'Удалить',
                          onPressed: () => _removeService(index),
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
