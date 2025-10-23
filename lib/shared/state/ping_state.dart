import 'package:flutter/widgets.dart';

class PingState extends ChangeNotifier {
  final List<Map<String, dynamic>> pings = [];

  void sendPing() {
    final String id = DateTime.now().microsecondsSinceEpoch.toString();
    final String time = DateTime.now().toLocal().toIso8601String().substring(11, 19);
    pings.add({'id': id, 'time': time, 'ping': null});
    notifyListeners();

    final int index = pings.length - 1;
    Future.delayed(const Duration(seconds: 1), () {
      if (index < pings.length) {
        pings[index]['ping'] = DateTime.now().millisecond % 100 + 1;
        notifyListeners();
      }
    });
  }

  void clearPings() {
    pings.clear();
    notifyListeners();
  }

  void removePing(String id) {
    pings.removeWhere((ping) => ping['id'] == id);
    notifyListeners();
  }
}

class PingStateProvider extends InheritedNotifier<PingState> {
  const PingStateProvider({super.key, required super.notifier, required super.child});

  static PingState of(BuildContext context) {
    final provider = context.dependOnInheritedWidgetOfExactType<PingStateProvider>();
    assert(provider != null, 'PingStateProvider not found in widget tree');
    return provider!.notifier!;
  }
}


