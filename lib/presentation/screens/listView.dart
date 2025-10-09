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

  void _addContainer() {
    final name = _controller.text.trim();
    if (name.isEmpty) return;

    setState(() {
      containers.add({
        'name': name,
        'running': false,
        'log': 'Контейнер создан',
      });
    });
    _controller.clear();
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

  void _removeContainer(int index) {
    setState(() {
      containers.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    return ContentPage(
      title: 'Docker контейнеры',
      color: Colors.blue,
      body: ListView(
        padding: const EdgeInsets.all(16),
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
          const SizedBox(height: 20),

          ...containers.asMap().entries.map((entry) {
            final index = entry.key;
            final container = entry.value;
            final bool running = container['running'];

            return Card(
              margin: const EdgeInsets.symmetric(vertical: 6),
              child: ListTile(
                title: Text(
                  container['name'],
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                subtitle: Text(container['log']),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: Icon(
                        running ? Icons.stop : Icons.play_arrow,
                        color: running ? Colors.red : Colors.green,
                      ),
                      tooltip: running ? 'Остановить' : 'Запустить',
                      onPressed: () => running
                          ? _stopContainer(index)
                          : _startContainer(index),
                    ),
                    IconButton(
                      icon: const Icon(Icons.delete, color: Colors.grey),
                      tooltip: 'Удалить',
                      onPressed: () => _removeContainer(index),
                    ),
                  ],
                ),
              ),
            );
          }),
        ],
      ),
    );
  }
}
