// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_state.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$UserState on _UserState, Store {
  Computed<Map<String, String>>? _$currentUserComputed;

  @override
  Map<String, String> get currentUser =>
      (_$currentUserComputed ??= Computed<Map<String, String>>(
        () => super.currentUser,
        name: '_UserState.currentUser',
      )).value;

  late final _$nameAtom = Atom(name: '_UserState.name', context: context);

  @override
  String get name {
    _$nameAtom.reportRead();
    return super.name;
  }

  @override
  set name(String value) {
    _$nameAtom.reportWrite(value, super.name, () {
      super.name = value;
    });
  }

  late final _$emailAtom = Atom(name: '_UserState.email', context: context);

  @override
  String get email {
    _$emailAtom.reportRead();
    return super.email;
  }

  @override
  set email(String value) {
    _$emailAtom.reportWrite(value, super.email, () {
      super.email = value;
    });
  }

  late final _$avatarUrlAtom = Atom(
    name: '_UserState.avatarUrl',
    context: context,
  );

  @override
  String get avatarUrl {
    _$avatarUrlAtom.reportRead();
    return super.avatarUrl;
  }

  @override
  set avatarUrl(String value) {
    _$avatarUrlAtom.reportWrite(value, super.avatarUrl, () {
      super.avatarUrl = value;
    });
  }

  late final _$_UserStateActionController = ActionController(
    name: '_UserState',
    context: context,
  );

  @override
  void updateUser({String? name, String? email, String? avatarUrl}) {
    final _$actionInfo = _$_UserStateActionController.startAction(
      name: '_UserState.updateUser',
    );
    try {
      return super.updateUser(name: name, email: email, avatarUrl: avatarUrl);
    } finally {
      _$_UserStateActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
name: ${name},
email: ${email},
avatarUrl: ${avatarUrl},
currentUser: ${currentUser}
    ''';
  }
}
