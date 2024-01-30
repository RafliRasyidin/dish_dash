import 'package:dio/dio.dart';

import '../data/remote/api/ApiRestaurant.dart';
import '../data/remote/api/ApiService.dart';
import '../data/repository/RestaurantRepository.dart';
import 'AppModule.dart';

Future<void> initNetworkDependencies() async {
  final dio = Dio(
      BaseOptions(
        connectTimeout: const Duration(seconds: 20),
        receiveTimeout: const Duration(seconds: 20),
        sendTimeout: const Duration(seconds: 30),
      )
  );
  if (!locator.isRegistered<Dio>()) {
    locator.registerSingleton(dio);
  }

  if (!locator.isRegistered<ApiRestaurant>()) {
    locator.registerSingleton(ApiRestaurant(locator<Dio>()));
  }

  if (!locator.isRegistered<RestaurantRepositoryImpl>()) {
    locator.registerSingleton(RestaurantRepositoryImpl(locator<ApiRestaurant>()));
  }
}