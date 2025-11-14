import 'package:mobx/mobx.dart';

part 'user_state.g.dart';

class UserState = _UserState with _$UserState;

abstract class _UserState with Store {
  @observable
  String name = 'Лев Герасимов';

  @observable
  String email = 'reindefox@example.com';

  @observable
  String avatarUrl = 'https://churchillpolarbears.org/app/uploads/2020/01/GWB-Silver-Fox.jpg';

  @computed
  Map<String, String> get currentUser => {
        'name': name,
        'email': email,
        'avatarUrl': avatarUrl,
      };

  @action
  void updateUser({String? name, String? email, String? avatarUrl}) {
    if (name != null) this.name = name;
    if (email != null) this.email = email;
    if (avatarUrl != null) this.avatarUrl = avatarUrl;
  }
}
