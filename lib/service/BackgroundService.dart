import 'dart:isolate';
import 'dart:math';
import 'dart:ui';

import 'package:dish_dash/data/repository/RestaurantRepository.dart';
import 'package:dish_dash/di/AppModule.dart';
import 'package:dish_dash/model/Restaurant.dart';
import 'package:dish_dash/util/NotificationHelper.dart';

final ReceivePort port = ReceivePort();

class BackgroundService {
  static BackgroundService? _instance;
  static const String _isolateName = "isolate";
  static SendPort? _uiSendPort;
  static const idBackgroundJob = 1;

  BackgroundService._internal() {
    _instance = this;
  }

  factory BackgroundService() => _instance ?? BackgroundService._internal();

  void initializeIsolate() {
    IsolateNameServer.registerPortWithName(
      port.sendPort,
      _isolateName
    );
  }

  @pragma('vm:entry-point')
  static Future<void> callback() async {
    try {
      print("Schedule Reminder!");
      await initDependencies();
      final NotificationHelper notificationHelper = NotificationHelper();
      final restaurantRepository = locator<RestaurantRepositoryImpl>();
      final data = await restaurantRepository.getRestaurants();
      final randomIndex = Random().nextInt(data.length);
      final randomRestaurant = data[randomIndex].toDetailRestaurant();
      await notificationHelper.showNotification(
        flutterLocalNotificationsPlugin,
        randomRestaurant
      );

      _uiSendPort ??= IsolateNameServer.lookupPortByName(_isolateName);
      _uiSendPort?.send(null);
    } catch (e) {
      print(e);
    }
  }
}