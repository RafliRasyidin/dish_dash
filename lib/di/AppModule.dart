import 'package:dish_dash/di/DatabaseModule.dart';
import 'package:dish_dash/di/NetworkModule.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get_it/get_it.dart';

final locator = GetIt.instance;
final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

Future<void> initDependencies() async {
  await initNetworkDependencies();
  await initDatabaseDependencies();
}