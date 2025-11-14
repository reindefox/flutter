// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'container_state.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$ContainerState on _ContainerState, Store {
  late final _$containersAtom = Atom(
    name: '_ContainerState.containers',
    context: context,
  );

  @override
  ObservableList<Map<String, dynamic>> get containers {
    _$containersAtom.reportRead();
    return super.containers;
  }

  @override
  set containers(ObservableList<Map<String, dynamic>> value) {
    _$containersAtom.reportWrite(value, super.containers, () {
      super.containers = value;
    });
  }

  late final _$availableContainersAtom = Atom(
    name: '_ContainerState.availableContainers',
    context: context,
  );

  @override
  ObservableList<String> get availableContainers {
    _$availableContainersAtom.reportRead();
    return super.availableContainers;
  }

  @override
  set availableContainers(ObservableList<String> value) {
    _$availableContainersAtom.reportWrite(value, super.availableContainers, () {
      super.availableContainers = value;
    });
  }

  late final _$_ContainerStateActionController = ActionController(
    name: '_ContainerState',
    context: context,
  );

  @override
  void addAvailableContainer(String name) {
    final _$actionInfo = _$_ContainerStateActionController.startAction(
      name: '_ContainerState.addAvailableContainer',
    );
    try {
      return super.addAvailableContainer(name);
    } finally {
      _$_ContainerStateActionController.endAction(_$actionInfo);
    }
  }

  @override
  void addContainerFromAvailable(String name) {
    final _$actionInfo = _$_ContainerStateActionController.startAction(
      name: '_ContainerState.addContainerFromAvailable',
    );
    try {
      return super.addContainerFromAvailable(name);
    } finally {
      _$_ContainerStateActionController.endAction(_$actionInfo);
    }
  }

  @override
  void startContainer(int index) {
    final _$actionInfo = _$_ContainerStateActionController.startAction(
      name: '_ContainerState.startContainer',
    );
    try {
      return super.startContainer(index);
    } finally {
      _$_ContainerStateActionController.endAction(_$actionInfo);
    }
  }

  @override
  void stopContainer(int index) {
    final _$actionInfo = _$_ContainerStateActionController.startAction(
      name: '_ContainerState.stopContainer',
    );
    try {
      return super.stopContainer(index);
    } finally {
      _$_ContainerStateActionController.endAction(_$actionInfo);
    }
  }

  @override
  void removeContainer(String name) {
    final _$actionInfo = _$_ContainerStateActionController.startAction(
      name: '_ContainerState.removeContainer',
    );
    try {
      return super.removeContainer(name);
    } finally {
      _$_ContainerStateActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
containers: ${containers},
availableContainers: ${availableContainers}
    ''';
  }
}
