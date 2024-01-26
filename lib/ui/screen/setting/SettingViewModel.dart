import 'package:android_alarm_manager_plus/android_alarm_manager_plus.dart';
import 'package:dish_dash/data/local/preferences/AppPreferences.dart';
import 'package:dish_dash/service/BackgroundService.dart';
import 'package:dish_dash/util/DateTimeHelper.dart';
import 'package:flutter/material.dart';

class SettingViewModel extends ChangeNotifier {

  final AppPreferences _preferences;

  SettingViewModel(this._preferences) {
    getReminder();
  }

  var _isActive = false;
  bool get isActive => _isActive;

  Future<void> setRemainder(bool isActive) async {
    _preferences.setRemainder(isActive);
    notifyListeners();
    if (isActive) {
      print("Scheduling Recommendation Restaurant");
      await AndroidAlarmManager.periodic(
        const Duration(hours: 24),
        BackgroundService.idBackgroundJob,
        BackgroundService.callback,
        startAt: DateTimeHelper.format(),
        exact: true,
        wakeup: true
      );
    } else {
      print("Schedule Recommendation Restaurant Cancelled");
      await AndroidAlarmManager.cancel(BackgroundService.idBackgroundJob);
    }
  }

  void getReminder() {
    _isActive = _preferences.getRemainder();
    notifyListeners();
  }

}