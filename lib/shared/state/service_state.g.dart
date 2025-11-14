// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'service_state.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$ServiceState on _ServiceState, Store {
  late final _$servicesAtom = Atom(
    name: '_ServiceState.services',
    context: context,
  );

  @override
  ObservableList<Map<String, dynamic>> get services {
    _$servicesAtom.reportRead();
    return super.services;
  }

  @override
  set services(ObservableList<Map<String, dynamic>> value) {
    _$servicesAtom.reportWrite(value, super.services, () {
      super.services = value;
    });
  }

  late final _$availableServicesAtom = Atom(
    name: '_ServiceState.availableServices',
    context: context,
  );

  @override
  ObservableList<String> get availableServices {
    _$availableServicesAtom.reportRead();
    return super.availableServices;
  }

  @override
  set availableServices(ObservableList<String> value) {
    _$availableServicesAtom.reportWrite(value, super.availableServices, () {
      super.availableServices = value;
    });
  }

  late final _$_ServiceStateActionController = ActionController(
    name: '_ServiceState',
    context: context,
  );

  @override
  void addAvailableService(String name) {
    final _$actionInfo = _$_ServiceStateActionController.startAction(
      name: '_ServiceState.addAvailableService',
    );
    try {
      return super.addAvailableService(name);
    } finally {
      _$_ServiceStateActionController.endAction(_$actionInfo);
    }
  }

  @override
  void addServiceFromAvailable(String name) {
    final _$actionInfo = _$_ServiceStateActionController.startAction(
      name: '_ServiceState.addServiceFromAvailable',
    );
    try {
      return super.addServiceFromAvailable(name);
    } finally {
      _$_ServiceStateActionController.endAction(_$actionInfo);
    }
  }

  @override
  void startService(int index) {
    final _$actionInfo = _$_ServiceStateActionController.startAction(
      name: '_ServiceState.startService',
    );
    try {
      return super.startService(index);
    } finally {
      _$_ServiceStateActionController.endAction(_$actionInfo);
    }
  }

  @override
  void stopService(int index) {
    final _$actionInfo = _$_ServiceStateActionController.startAction(
      name: '_ServiceState.stopService',
    );
    try {
      return super.stopService(index);
    } finally {
      _$_ServiceStateActionController.endAction(_$actionInfo);
    }
  }

  @override
  void removeService(String name) {
    final _$actionInfo = _$_ServiceStateActionController.startAction(
      name: '_ServiceState.removeService',
    );
    try {
      return super.removeService(name);
    } finally {
      _$_ServiceStateActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
services: ${services},
availableServices: ${availableServices}
    ''';
  }
}
