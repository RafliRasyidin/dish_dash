import 'package:shared_preferences/shared_preferences.dart';

abstract class AppPreferences {
  static const remainderKey = "RemainderKey";

  void setRemainder(bool isActive);
  bool getRemainder();
}

class AppPreferencesImpl extends AppPreferences {
  final SharedPreferences _prefs;

  AppPreferencesImpl(this._prefs);

  @override
  void setRemainder(bool isActive) async {
    await _prefs.setBool(AppPreferences.remainderKey, isActive);
  }

  @override
  bool getRemainder() {
    return _prefs.getBool(AppPreferences.remainderKey) ?? false;
  }

}