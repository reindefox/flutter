import 'package:mobx/mobx.dart';

part 'ping_state.g.dart';

class PingState = _PingState with _$PingState;

abstract class _PingState with Store {
  @observable
  ObservableList<Map<String, dynamic>> pings = ObservableList<Map<String, dynamic>>();

  @action
  void sendPing() {
    final String id = DateTime.now().microsecondsSinceEpoch.toString();
    final String time = DateTime.now().toLocal().toIso8601String().substring(11, 19);
    pings.add({'id': id, 'time': time, 'ping': null});

    final int index = pings.length - 1;
    Future.delayed(const Duration(seconds: 1), () {
      runInAction(() {
        if (index < pings.length && pings[index]['id'] == id) {
          pings[index] = {
            'id': id,
            'time': time,
            'ping': DateTime.now().millisecond % 100 + 1,
          };
        }
      });
    });
  }

  @action
  void clearPings() {
    pings.clear();
  }

  @action
  void removePing(String id) {
    pings.removeWhere((ping) => ping['id'] == id);
  }
}
