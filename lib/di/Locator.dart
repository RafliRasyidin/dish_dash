import 'package:dio/dio.dart';
import 'package:dish_dash/data/local/dao/FavoriteDao.dart';
import 'package:dish_dash/data/local/db/dish_dash_database.dart';
import 'package:dish_dash/data/remote/api/ApiRestaurant.dart';
import 'package:dish_dash/data/repository/FavoriteRepository.dart';
import 'package:dish_dash/data/repository/RestaurantRepository.dart';
import 'package:get_it/get_it.dart';

import '../data/remote/api/ApiService.dart';

final locator = GetIt.instance;

Future<void> initDependencies() async {
  final db = await $FloorDishDashDatabase.databaseBuilder(DishDashDatabase.dbName).build();
  locator.registerSingleton(db);
  locator.registerSingleton(db.favoriteDao);
  locator.registerSingleton(FavoriteRepositoryImpl(locator<FavoriteDao>()));

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