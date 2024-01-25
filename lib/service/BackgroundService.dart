import 'dart:isolate';
import 'dart:math';
import 'dart:ui';

import 'package:dish_dash/data/repository/RestaurantRepository.dart';
import 'package:dish_dash/di/Locator.dart';
import 'package:dish_dash/model/Restaurant.dart';
import 'package:dish_dash/util/NotificationHelper.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

final ReceivePort port = ReceivePort();

class BackgroundService {
  static BackgroundService? _instance;
  static const String _isolateName = "isolate";
  static SendPort? _uiSendPort;
  static const idBackgroundJob = 999;

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

  static Future<void> callback() async {
    try {
      print("Schedule Reminder!");
      final NotificationHelper notificationHelper = NotificationHelper();
      final restaurantRepository = locator<RestaurantRepositoryImpl>();
      final data = await restaurantRepository.getRestaurants();
      final randomIndex = Random().nextInt(data.length);
      final randomRestaurant = data[randomIndex].toDetailRestaurant();
      await notificationHelper.showNotification(
        locator<FlutterLocalNotificationsPlugin>(),
        randomRestaurant
      );

      _uiSendPort ??= IsolateNameServer.lookupPortByName(_isolateName);
      _uiSendPort?.send(null);
    } catch (e) {
      print(e);
    }
  }
}