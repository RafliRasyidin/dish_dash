import 'package:dio/dio.dart';

import '../data/remote/api/ApiRestaurant.dart';
import '../data/remote/api/ApiService.dart';
import '../data/repository/RestaurantRepository.dart';
import 'AppModule.dart';

Future<void> initNetworkDependencies() async {
  final dio = Dio(
      BaseOptions(
        baseUrl: baseUrl,
        connectTimeout: const Duration(seconds: 20),
        receiveTimeout: const Duration(seconds: 20),
        sendTimeout: const Duration(seconds: 30),
      )
  );
  locator.registerSingleton(dio);
  locator.registerSingleton(ApiRestaurant(locator<Dio>()));
  locator.registerSingleton(RestaurantRepositoryImpl(locator<ApiRestaurant>()));
}