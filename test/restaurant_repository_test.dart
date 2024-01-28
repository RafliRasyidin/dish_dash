import 'package:dio/dio.dart';
import 'package:dish_dash/data/remote/api/ApiRestaurant.dart';
import 'package:dish_dash/data/remote/api/ApiService.dart';
import 'package:dish_dash/data/repository/RestaurantRepository.dart';
import 'package:dish_dash/di/AppModule.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group("Restaurant Repository Test", () {
    late RestaurantRepositoryImpl restaurantRepository;

    setUpAll(() async {
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
      restaurantRepository = locator<RestaurantRepositoryImpl>();
    });

    test("should contain at least one item", () async {
      final restaurants = await restaurantRepository.getRestaurants();
      final result = restaurants.isNotEmpty;
      expect(result, true);
    });

    test("should return empty list if the keyword search 'qwertyuiop'", () async {
      const keyword = "qwrtyuiop";
      final restaurants = await restaurantRepository.searchRestaurant(keyword);
      final result = restaurants.isEmpty;
      expect(result, true);
    });

    test("should return at least 1 item if the keyword search 'cafe'", () async {
      const keyword = "cafe";
      final restaurants = await restaurantRepository.searchRestaurant(keyword);
      final result = restaurants.isNotEmpty;
      expect(result, true);
    });
  });
}