import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import '../../../shared/widgets/content_page.dart';
import 'package:project/shared/state/ping_state.dart';
import 'package:project/shared/di/service_locator.dart';

class WidgetColumnPage extends StatelessWidget {
  const WidgetColumnPage({super.key});

  @override
  Widget build(BuildContext context) {
    final pingState = getIt<PingState>();

    return ContentPage(
      title: 'Пинги',
      color: Colors.green,
      body: Observer(
        builder: (_) => Column(
          children: [
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: pingState.sendPing,
                  child: const Text('Отправить пинг'),
                ),
                const SizedBox(width: 10),
                ElevatedButton(
                  onPressed: pingState.clearPings,
                  child: const Text('Очистить'),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    for (int i = 0; i < pingState.pings.length; i++)
                      ListTile(
                        title: Text('${pingState.pings[i]['time']} / Проверка соединения до сервера...'),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Container(
                              width: 50,
                              height: 30,
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                color: pingState.pings[i]['ping'] == null
                                    ? Colors.grey.shade300
                                    : Colors.teal.shade100,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Text(
                                pingState.pings[i]['ping']?.toString() ?? '...',
                                style: const TextStyle(fontWeight: FontWeight.bold),
                              ),
                            ),
                            const SizedBox(width: 10),
                            IconButton(
                              icon: const Icon(Icons.delete, color: Colors.red),
                              onPressed: () => pingState.removePing(
                                pingState.pings[i]['id'] as String,
                              ),
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
      ),
    );
  }
}
