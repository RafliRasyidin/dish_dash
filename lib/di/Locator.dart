import 'package:dio/dio.dart';
import 'package:dish_dash/data/local/db/dish_dash_database.dart';
import 'package:dish_dash/data/remote/api/ApiRestaurant.dart';
import 'package:dish_dash/data/repository/RestaurantRepository.dart';
import 'package:get_it/get_it.dart';

import '../data/remote/api/ApiService.dart';

final locator = GetIt.instance;

Future<void> initDependencies() async {
  final db = await $FloorDishDashDatabase.databaseBuilder(DishDashDatabase.dbName).build();
  locator.registerSingleton<DishDashDatabase>(db);

  final dio = Dio(
      BaseOptions(
        baseUrl: baseUrl,
        connectTimeout: const Duration(seconds: 20),
        receiveTimeout: const Duration(seconds: 20),
        sendTimeout: const Duration(seconds: 30),
      )
  );
  locator.registerSingleton<Dio>(dio);

  locator.registerSingleton<ApiRestaurant>(ApiRestaurant(locator<Dio>()));

  locator.registerSingleton(RestaurantRepositoryImpl(locator<ApiRestaurant>()));
}