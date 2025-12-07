import 'dart:async';
import 'package:flutter/material.dart';
import '../../../shared/widgets/content_page.dart';
import '../../../core/models/ping_model.dart';
import '../../../domain/usecases/ping_usecases.dart';
import '../../../shared/di/service_locator.dart';

class WidgetColumnPage extends StatefulWidget {
  const WidgetColumnPage({super.key});

  @override
  State<WidgetColumnPage> createState() => _WidgetColumnPageState();
}

class _WidgetColumnPageState extends State<WidgetColumnPage> {
  late final GetPingHistoryUseCase _getPingHistory;
  late final SendPingUseCase _sendPing;
  late final RemovePingUseCase _removePing;
  late final ClearPingHistoryUseCase _clearHistory;

  List<PingModel> _pings = [];
  StreamSubscription? _pingSub;

  @override
  void initState() {
    super.initState();
    _getPingHistory = getIt<GetPingHistoryUseCase>();
    _sendPing = getIt<SendPingUseCase>();
    _removePing = getIt<RemovePingUseCase>();
    _clearHistory = getIt<ClearPingHistoryUseCase>();

    _loadData();
    _subscribeToChanges();
  }

  Future<void> _loadData() async {
    final pings = await _getPingHistory();
    setState(() => _pings = pings);
  }

  void _subscribeToChanges() {
    _pingSub = _getPingHistory.watch().listen((pings) {
      setState(() => _pings = pings);
    });
  }

  @override
  void dispose() {
    _pingSub?.cancel();
    super.dispose();
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
                onPressed: () => _sendPing(),
                child: const Text('Отправить пинг'),
              ),
              const SizedBox(width: 10),
              ElevatedButton(
                onPressed: () => _clearHistory(),
                child: const Text('Очистить'),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  for (final ping in _pings)
                    ListTile(
                      title: Text('${ping.formattedTime} / Проверка соединения до сервера...'),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            width: 50,
                            height: 30,
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              color: ping.isComplete
                                  ? Colors.teal.shade100
                                  : Colors.grey.shade300,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              ping.latencyText,
                              style: const TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ),
                          const SizedBox(width: 10),
                          IconButton(
                            icon: const Icon(Icons.delete, color: Colors.red),
                            onPressed: () => _removePing(ping.id),
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
