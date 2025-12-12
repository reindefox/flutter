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
  bool _isSending = false;

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

  Future<void> _handleSendPing() async {
    setState(() => _isSending = true);
    await _sendPing();
    setState(() => _isSending = false);
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

          Container(
            margin: const EdgeInsets.all(12),
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.green.shade50,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.green.shade200),
            ),
            child: Row(
              children: [
                Icon(Icons.info_outline, color: Colors.green.shade700, size: 20),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'Проверка сетевой доступности серверов инфраструктуры',
                    style: TextStyle(fontSize: 12, color: Colors.green.shade700),
                  ),
                ),
              ],
            ),
          ),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: _isSending ? null : _handleSendPing,
                    icon: _isSending
                        ? const SizedBox(
                            width: 16,
                            height: 16,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : const Icon(Icons.network_ping),
                    label: const Text('Проверить соединение'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      foregroundColor: Colors.white,
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                ElevatedButton.icon(
                  onPressed: _pings.isEmpty ? null : () => _clearHistory(),
                  icon: const Icon(Icons.delete_sweep),
                  label: const Text('Очистить'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.grey.shade600,
                    foregroundColor: Colors.white,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),

          Expanded(
            child: _pings.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.network_ping, size: 64, color: Colors.grey.shade300),
                        const SizedBox(height: 16),
                        Text(
                          'Нажмите "Проверить соединение" для контроля\nдоступности целевых серверов',
                          textAlign: TextAlign.center,
                          style: TextStyle(color: Colors.grey.shade500),
                        ),
                      ],
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    itemCount: _pings.length,
                    itemBuilder: (context, index) {
                      final ping = _pings[index];
                      return _buildPingCard(ping);
                    },
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildPingCard(PingModel ping) {
    final Color statusColor;
    if (!ping.isComplete) {
      statusColor = Colors.grey;
    } else if (ping.hasError) {
      statusColor = Colors.red;
    } else if (ping.latencyMs! < 200) {
      statusColor = Colors.green;
    } else if (ping.latencyMs! < 500) {
      statusColor = Colors.orange;
    } else {
      statusColor = Colors.red;
    }

    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        leading: Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: statusColor.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(
            _getServerIcon(ping.api),
            color: statusColor,
            size: 20,
          ),
        ),
        title: Text(
          ping.displayName,
          style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              ping.formattedTime,
              style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
            ),
            if (ping.api != null)
              Container(
                margin: const EdgeInsets.only(top: 4),
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: _getServerColor(ping.api).withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  _getServerLabel(ping.api),
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w500,
                    color: _getServerColor(ping.api),
                  ),
                ),
              ),
          ],
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              decoration: BoxDecoration(
                color: statusColor.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                ping.latencyText,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: statusColor,
                  fontSize: 13,
                ),
              ),
            ),
            const SizedBox(width: 8),
            IconButton(
              icon: const Icon(Icons.close, size: 18),
              color: Colors.grey,
              onPressed: () => _removePing(ping.id),
            ),
          ],
        ),
      ),
    );
  }

  IconData _getServerIcon(String? api) {
    switch (api) {
      case 'GitHub':
        return Icons.cloud;
      case 'JSONPlaceholder':
        return Icons.dns;
      default:
        return Icons.computer;
    }
  }

  Color _getServerColor(String? api) {
    switch (api) {
      case 'GitHub':
        return Colors.blueGrey.shade700;
      case 'JSONPlaceholder':
        return Colors.teal.shade700;
      default:
        return Colors.grey.shade700;
    }
  }

  String _getServerLabel(String? api) {
    switch (api) {
      case 'GitHub':
        return 'Внешний сервер';
      case 'JSONPlaceholder':
        return 'Сервер данных';
      default:
        return 'Сервер';
    }
  }
}
