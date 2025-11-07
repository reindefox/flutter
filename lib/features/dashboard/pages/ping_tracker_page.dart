import 'package:flutter/material.dart';
import '../../../shared/widgets/content_page.dart';
import 'package:project/shared/state/ping_state.dart';
import 'package:project/shared/di/service_locator.dart';

class WidgetColumnPage extends StatefulWidget {
  const WidgetColumnPage({super.key});

  @override
  State<WidgetColumnPage> createState() => _WidgetColumnPageState();
}

class _WidgetColumnPageState extends State<WidgetColumnPage> {
  late final PingState _pingState;

  @override
  void initState() {
    super.initState();
    _pingState = getIt<PingState>();
    _pingState.addListener(_onStateChanged);
  }

  @override
  void dispose() {
    _pingState.removeListener(_onStateChanged);
    super.dispose();
  }

  void _onStateChanged() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final pings = _pingState.pings;

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
                onPressed: _pingState.sendPing,
                child: const Text('Отправить пинг'),
              ),
              const SizedBox(width: 10),
              ElevatedButton(
                onPressed: _pingState.clearPings,
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
                            onPressed: () => _pingState.removePing(pings[i]['id'] as String),
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
