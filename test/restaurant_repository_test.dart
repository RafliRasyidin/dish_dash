import 'package:dio/dio.dart';
import 'package:dish_dash/data/remote/api/ApiRestaurant.dart';
import 'package:dish_dash/data/remote/api/ApiService.dart';
import 'package:dish_dash/data/remote/response/ListRestaurantResponse.dart';
import 'package:dish_dash/data/repository/RestaurantRepository.dart';
import 'package:dish_dash/di/AppModule.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http_mock_adapter/http_mock_adapter.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'DataDummy.dart';
import 'restaurant_repository_test.mocks.dart';

@GenerateMocks([Dio])
void main() {
  group("Restaurant Repository Test", () {
    final dio = MockDio();
    late ApiRestaurant apiRestaurant;
    late RestaurantRepositoryImpl restaurantRepository;

    setUpAll(() async {
      apiRestaurant = ApiRestaurant(dio);
      restaurantRepository = RestaurantRepositoryImpl(apiRestaurant);
    });

    test("should contain at least one item", () async {
      when(dio.get("$baseUrl/list"))
        .thenAnswer((realInvocation) async => Response(
          data: dummyRestaurantsResponse.toMap(),
          statusCode: 200,
          requestOptions: RequestOptions(),
      ));
      final restaurants = await restaurantRepository.getRestaurants();
      final result = restaurants.isNotEmpty;
      expect(result, true);
      verify(dio.get("$baseUrl/list"));
    });

    test("should return empty list if the keyword search 'qwertyuiop'", () async {
      const keyword = "qwrtyuiop";
      when(dio.get(
        "$baseUrl/search",
        queryParameters: {
          "q": keyword
        }
      )).thenAnswer((realInvocation) async => Response(
        data: dummySearchRestaurantsEmptyResponse.toMap(),
        statusCode: 200,
        requestOptions: RequestOptions()
      ));
      final restaurants = await restaurantRepository.searchRestaurant(keyword);
      final result = restaurants.isEmpty;
      expect(result, true);
    });

    test("should return at least 1 item if the keyword search 'cafe'", () async {
      const keyword = "cafe";
      when(dio.get(
          "$baseUrl/search",
          queryParameters: {
            "q": keyword
          }
      )).thenAnswer((realInvocation) async => Response(
        data: dummySearchRestaurantsResponse.toMap(),
        statusCode: 200,
        requestOptions: RequestOptions()
      ));
      final restaurants = await restaurantRepository.searchRestaurant(keyword);
      final result = restaurants.isNotEmpty;
      expect(result, true);
    });
  });
}