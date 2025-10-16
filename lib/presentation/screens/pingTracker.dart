import 'package:flutter/material.dart';
import 'base/contentPage.dart';
import 'package:project/state/ping_state.dart';

class WidgetColumnPage extends StatelessWidget {
  const WidgetColumnPage({super.key});

  @override
  Widget build(BuildContext context) {
    final state = PingStateProvider.of(context);
    final pings = state.pings;

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
                onPressed: state.sendPing,
                child: const Text('Отправить пинг'),
              ),
              const SizedBox(width: 10),
              ElevatedButton(
                onPressed: state.clearPings,
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
                      title: Text('${pings[i]['time']} / Проверка соединения до сервера...'),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            width: 50,
                            height: 30,
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              color: pings[i]['ping'] == null ? Colors.grey.shade300 : Colors.teal.shade100,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              pings[i]['ping']?.toString() ?? '...',
                              style: const TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ),
                          const SizedBox(width: 10),
                          IconButton(
                            icon: const Icon(Icons.delete, color: Colors.red),
                            onPressed: () => state.removePing(pings[i]['time'] as String),
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
