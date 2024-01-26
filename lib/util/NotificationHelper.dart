import 'dart:convert';

import 'package:dish_dash/model/DetailRestaurant.dart';
import 'package:dish_dash/util/Navigator.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:rxdart/rxdart.dart';

final selectNotificationSubject = BehaviorSubject<String>();

class NotificationHelper {

  static NotificationHelper? _instance;
  NotificationHelper._internal() {
    _instance = this;
  }
  factory NotificationHelper() => _instance ?? NotificationHelper._internal();

  static const channelId = "919";
  static const channelName = "Reminder";
  static const channelDescription = "Reminder Recommended Restaurant";

  Future<void> initNotifications(FlutterLocalNotificationsPlugin plugin) async {
    var initSettingAndroid = const AndroidInitializationSettings("app_icon");
    var initSettingIos = const DarwinInitializationSettings(
      requestAlertPermission: false,
      requestBadgePermission: false,
      requestSoundPermission: false
    );

    var initSetting = InitializationSettings(android: initSettingAndroid, iOS: initSettingIos);

    await plugin.initialize(
      initSetting,
      onDidReceiveNotificationResponse: (NotificationResponse response) async {
        final payload = response.payload;
        if (payload != null) {
          print("Notification Payload: $payload");
        }
        selectNotificationSubject.add(payload ?? "Empty Payload");
      }
    );
  }

  Future<void> showNotification(
    FlutterLocalNotificationsPlugin plugin,
    DetailRestaurant restaurant
  ) async {
    var androidChannelSpecifics = const AndroidNotificationDetails(
      channelId,
      channelName,
      channelDescription: channelDescription,
      importance: Importance.max,
      priority: Priority.high,
      ticker: "ticker",
      styleInformation: DefaultStyleInformation(true, true)
    );

    var iosChannelSpecifics = const DarwinNotificationDetails();
    var platformChannelSpecifics = NotificationDetails(
      android: androidChannelSpecifics,
      iOS: iosChannelSpecifics
    );

    var titleNotification = "For You Restaurant!";
    var restaurantName = restaurant.name;

    await plugin.show(
      0,
      titleNotification,
      restaurantName,
      platformChannelSpecifics,
      payload: json.encode(restaurant.toJson())
    );
  }

  void configSelectNotificationSubject(String route) {
    selectNotificationSubject.stream.listen((String payload) async {
      var restaurant = DetailRestaurant.fromJson(json.decode(payload));
      Navigation.intentWithData(route, restaurant);
    });
  }

  void requestNotificationPermission(FlutterLocalNotificationsPlugin plugin) {
    plugin.resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()?.requestNotificationsPermission();
  }
}