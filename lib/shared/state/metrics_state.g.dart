// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'metrics_state.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$MetricsState on _MetricsState, Store {
  late final _$cpuUsageAtom = Atom(
    name: '_MetricsState.cpuUsage',
    context: context,
  );

  @override
  double get cpuUsage {
    _$cpuUsageAtom.reportRead();
    return super.cpuUsage;
  }

  @override
  set cpuUsage(double value) {
    _$cpuUsageAtom.reportWrite(value, super.cpuUsage, () {
      super.cpuUsage = value;
    });
  }

  late final _$memoryUsageAtom = Atom(
    name: '_MetricsState.memoryUsage',
    context: context,
  );

  @override
  double get memoryUsage {
    _$memoryUsageAtom.reportRead();
    return super.memoryUsage;
  }

  @override
  set memoryUsage(double value) {
    _$memoryUsageAtom.reportWrite(value, super.memoryUsage, () {
      super.memoryUsage = value;
    });
  }

  late final _$diskUsageAtom = Atom(
    name: '_MetricsState.diskUsage',
    context: context,
  );

  @override
  double get diskUsage {
    _$diskUsageAtom.reportRead();
    return super.diskUsage;
  }

  @override
  set diskUsage(double value) {
    _$diskUsageAtom.reportWrite(value, super.diskUsage, () {
      super.diskUsage = value;
    });
  }

  late final _$_MetricsStateActionController = ActionController(
    name: '_MetricsState',
    context: context,
  );

  @override
  void startMonitoring() {
    final _$actionInfo = _$_MetricsStateActionController.startAction(
      name: '_MetricsState.startMonitoring',
    );
    try {
      return super.startMonitoring();
    } finally {
      _$_MetricsStateActionController.endAction(_$actionInfo);
    }
  }

  @override
  void stopMonitoring() {
    final _$actionInfo = _$_MetricsStateActionController.startAction(
      name: '_MetricsState.stopMonitoring',
    );
    try {
      return super.stopMonitoring();
    } finally {
      _$_MetricsStateActionController.endAction(_$actionInfo);
    }
  }

  @override
  void _updateMetrics() {
    final _$actionInfo = _$_MetricsStateActionController.startAction(
      name: '_MetricsState._updateMetrics',
    );
    try {
      return super._updateMetrics();
    } finally {
      _$_MetricsStateActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
cpuUsage: ${cpuUsage},
memoryUsage: ${memoryUsage},
diskUsage: ${diskUsage}
    ''';
  }
}
