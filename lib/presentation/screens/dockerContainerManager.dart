import 'dart:async';
import 'package:flutter/material.dart';
import 'base/contentPage.dart';

class ListViewPage extends StatefulWidget {
  const ListViewPage({super.key});

  @override
  State<ListViewPage> createState() => _ListViewPageState();
}

class _ListViewPageState extends State<ListViewPage> {
  final TextEditingController _controller = TextEditingController();
  final List<Map<String, dynamic>> containers = [];

  final List<String> availableContainers = [
    'nginx',
    'redis',
    'postgres',
    'prometheus',
  ];

  void _addContainer() {
    final name = _controller.text.trim();
    if (name.isEmpty) return;
    if (availableContainers.contains(name)) {
      _controller.clear();
      return;
    }
    setState(() {
      availableContainers.add(name);
    });
    _controller.clear();
  }

  void _addContainerFromAvailable(String name) {
    if (containers.any((c) => c['name'] == name)) return;
    setState(() {
      containers.add({
        'name': name,
        'running': false,
        'log': 'Контейнер добавлен из доступных',
      });
    });
  }

  Color _statusColor(bool running) {
    return running ? Colors.green : Colors.grey;
  }

  void _startContainer(int index) {
    if (containers[index]['running']) return;

    setState(() {
      containers[index]['log'] = 'Запуск контейнера...';
    });

    Future.delayed(const Duration(seconds: 1), () {
      if (!mounted) return;
      setState(() {
        containers[index]['running'] = true;
        containers[index]['log'] = 'Контейнер запущен ✅';
      });
    });
  }

  void _stopContainer(int index) {
    if (!containers[index]['running']) return;

    setState(() {
      containers[index]['log'] = 'Остановка контейнера...';
    });

    Future.delayed(const Duration(seconds: 1), () {
      if (!mounted) return;
      setState(() {
        containers[index]['running'] = false;
        containers[index]['log'] = 'Контейнер остановлен ⛔';
      });
    });
  }

  void _removeContainer(String name) {
    setState(() {
      containers.removeWhere((container) => container['name'] == name);
    });
  }

  @override
  Widget build(BuildContext context) {
    return ContentPage(
      title: 'Docker контейнеры',
      color: Colors.blue,
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
                      labelText: 'Имя контейнера',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                ElevatedButton(
                  onPressed: _addContainer,
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
                            Expanded(child: _buildAvailableContainersCard()),
                            const SizedBox(width: 12),
                            Expanded(child: _buildManagedContainersCard()),
                          ],
                        )
                      : Column(
                          children: [
                            _buildAvailableContainersCard(),
                            const SizedBox(height: 12),
                            Expanded(child: _buildManagedContainersCard()),
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

  Widget _buildAvailableContainersCard() {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Доступные контейнеры:',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Expanded(
              child: ListView.builder(
                itemCount: availableContainers.length,
                itemBuilder: (context, index) {
                  final name = availableContainers[index];
                  final alreadyManaged = containers.any((c) => c['name'] == name);
                  return ListTile(
                    dense: true,
                    contentPadding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
                    title: Text(name),
                    trailing: ElevatedButton(
                      onPressed: alreadyManaged ? null : () => _addContainerFromAvailable(name),
                      child: const Text('Добавить'),
                      style: ElevatedButton.styleFrom(padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8)),
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

  Widget _buildManagedContainersCard() {
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
              child: Text('Управление контейнерами:', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            ),
            const Divider(height: 4),
            Expanded(
              child: ListView.separated(
                itemCount: containers.length,
                separatorBuilder: (_, __) => const Divider(height: 1),
                itemBuilder: (context, index) {
                  final container = containers[index];
                  final bool running = container['running'] as bool;
                  return ListTile(
                    dense: true,
                    title: Text(container['name'], style: const TextStyle(fontWeight: FontWeight.w600)),
                    subtitle: Text(container['log'], maxLines: 1, overflow: TextOverflow.ellipsis),
                    leading: Chip(
                      label: Text(running ? 'Запущен' : 'Остановлен', style: const TextStyle(color: Colors.white, fontSize: 12)),
                      backgroundColor: _statusColor(running),
                      visualDensity: VisualDensity.compact,
                    ),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: Icon(running ? Icons.stop_circle : Icons.play_circle_fill, color: running ? Colors.red : Colors.green, size: 22),
                          tooltip: running ? 'Остановить' : 'Запустить',
                          onPressed: () => running ? _stopContainer(index) : _startContainer(index),
                        ),
                        IconButton(
                          icon: const Icon(Icons.delete_outline, color: Colors.grey, size: 20),
                          tooltip: 'Удалить',
                          onPressed: () => _removeContainer(container['name']),
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
