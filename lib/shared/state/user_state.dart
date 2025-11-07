import 'package:flutter/widgets.dart';

class UserState extends ChangeNotifier {
  Map<String, String> currentUser = {
    'name': 'Лев Герасимов',
    'email': 'reindefox@example.com',
    'avatarUrl': 'https://churchillpolarbears.org/app/uploads/2020/01/GWB-Silver-Fox.jpg'
  };

  void updateUser({String? name, String? email}) {
    final updated = Map<String, String>.from(currentUser);
    if (name != null) updated['name'] = name;
    if (email != null) updated['email'] = email;
    currentUser = updated;
    notifyListeners();
  }
}

class _UserStateInherited extends InheritedWidget {
  final UserState userState;

  const _UserStateInherited({
    required this.userState,
    required super.child,
  });

  @override
  bool updateShouldNotify(_UserStateInherited oldWidget) {
    return userState != oldWidget.userState;
  }
}

class UserStateProvider extends StatefulWidget {
  final UserState userState;
  final Widget child;

  const UserStateProvider({
    super.key,
    required this.userState,
    required this.child,
  });

  static UserState of(BuildContext context) {
    final provider = context.dependOnInheritedWidgetOfExactType<_UserStateInherited>();
    assert(provider != null, 'UserStateProvider not found in widget tree');
    return provider!.userState;
  }

  @override
  State<UserStateProvider> createState() => _UserStateProviderState();
}

class _UserStateProviderState extends State<UserStateProvider> {
  @override
  void initState() {
    super.initState();
    widget.userState.addListener(_onStateChanged);
  }

  @override
  void dispose() {
    widget.userState.removeListener(_onStateChanged);
    super.dispose();
  }

  void _onStateChanged() {
    setState(() {
    });
  }

  @override
  Widget build(BuildContext context) {
    return _UserStateInherited(
      userState: widget.userState,
      child: widget.child,
    );
  }
}


