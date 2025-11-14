// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ping_state.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$PingState on _PingState, Store {
  late final _$pingsAtom = Atom(name: '_PingState.pings', context: context);

  @override
  ObservableList<Map<String, dynamic>> get pings {
    _$pingsAtom.reportRead();
    return super.pings;
  }

  @override
  set pings(ObservableList<Map<String, dynamic>> value) {
    _$pingsAtom.reportWrite(value, super.pings, () {
      super.pings = value;
    });
  }

  late final _$_PingStateActionController = ActionController(
    name: '_PingState',
    context: context,
  );

  @override
  void sendPing() {
    final _$actionInfo = _$_PingStateActionController.startAction(
      name: '_PingState.sendPing',
    );
    try {
      return super.sendPing();
    } finally {
      _$_PingStateActionController.endAction(_$actionInfo);
    }
  }

  @override
  void clearPings() {
    final _$actionInfo = _$_PingStateActionController.startAction(
      name: '_PingState.clearPings',
    );
    try {
      return super.clearPings();
    } finally {
      _$_PingStateActionController.endAction(_$actionInfo);
    }
  }

  @override
  void removePing(String id) {
    final _$actionInfo = _$_PingStateActionController.startAction(
      name: '_PingState.removePing',
    );
    try {
      return super.removePing(id);
    } finally {
      _$_PingStateActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
pings: ${pings}
    ''';
  }
}
