import 'package:flutter/widgets.dart';

class UserState extends ChangeNotifier {
  Map<String, String> currentUser = {
    'name': 'Лев Герасимов',
    'email': 'reindefox@example.com',
  };

  void updateUser({String? name, String? email}) {
    final updated = Map<String, String>.from(currentUser);
    if (name != null) updated['name'] = name;
    if (email != null) updated['email'] = email;
    currentUser = updated;
    notifyListeners();
  }
}

class UserStateProvider extends InheritedNotifier<UserState> {
  const UserStateProvider({super.key, required super.notifier, required super.child});

  static UserState of(BuildContext context) {
    final provider = context.dependOnInheritedWidgetOfExactType<UserStateProvider>();
    assert(provider != null, 'UserStateProvider not found in widget tree');
    return provider!.notifier!;
  }
}


