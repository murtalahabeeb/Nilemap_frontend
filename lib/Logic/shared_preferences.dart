import 'package:shared_preferences/shared_preferences.dart';

class UserPreferences {
  static final UserPreferences _instance = UserPreferences._ctor();
  factory UserPreferences() {
    return _instance;
  }

  UserPreferences._ctor();

  SharedPreferences _prefs;

  init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  destroy() async {
    await _prefs.clear();
  }

  get id {
    return _prefs.getInt('id') ?? 0;
  }

  get token {
    return _prefs.getString('token') ?? '';
  }

  Future setId(int value) async {
    return _prefs.setInt('id', value);
  }

  Future setToken(String value) {
    return _prefs.setString('token', value);
  }
}
