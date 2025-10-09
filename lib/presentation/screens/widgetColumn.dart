import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'base/contentPage.dart';

class WidgetColumnPage extends StatefulWidget {
  const WidgetColumnPage({super.key});

  @override
  State<WidgetColumnPage> createState() => _WidgetColumnPageState();
}

class _WidgetColumnPageState extends State<WidgetColumnPage> {
  final List<Map<String, dynamic>> pings = [];
  final Random _random = Random();

  void _sendPing() {
    final String time = DateTime.now().toLocal().toIso8601String().substring(
      11,
      19,
    );

    setState(() {
      pings.add({'time': time, 'ping': null});
    });
    final int index = pings.length - 1;

    Future.delayed(const Duration(seconds: 1), () {
      if (!mounted) return;
      final int pingValue = _random.nextInt(100) + 1;

      if (index < pings.length) {
        setState(() {
          pings[index]['ping'] = pingValue;
        });
      }
    });
  }

  void _removePing(int index) {
    setState(() {
      pings.removeAt(index);
    });
  }

  void _clearPings() {
    setState(() {
      pings.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    return ContentPage(
      title: 'Пинги',
      color: Colors.green,
      body: Column(
        children: [
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                onPressed: _sendPing,
                child: const Text('Отправить пинг'),
              ),
              const SizedBox(width: 10),
              ElevatedButton(
                onPressed: _clearPings,
                child: const Text('Очистить'),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  for (int i = 0; i < pings.length; i++)
                    ListTile(
                      title: Text(
                        '${pings[i]['time']} / Проверка соединения до сервера...',
                      ),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            width: 50,
                            height: 30,
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              color: pings[i]['ping'] == null
                                  ? Colors.grey.shade300
                                  : Colors.teal.shade100,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              pings[i]['ping']?.toString() ?? '...',
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          const SizedBox(width: 10),
                          IconButton(
                            icon: const Icon(Icons.delete, color: Colors.red),
                            onPressed: () => _removePing(i),
                          ),
                        ],
                      ),
                    ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
