import 'dart:io';

import 'package:dish_dash/data/remote/api/ApiRestaurant.dart';
import 'package:dish_dash/data/remote/request/ReviewRequest.dart';
import 'package:dish_dash/data/remote/response/DetailRestaurantResponse.dart';
import 'package:dish_dash/data/remote/response/PostReviewResponse.dart';
import 'package:dish_dash/model/Restaurant.dart';

import '../remote/response/ListRestaurantResponse.dart';

abstract class RestaurantRepository {
  Future<List<Restaurant>> getRestaurants();
  Future<Restaurant> getDetailRestaurant(String id);
  Future<List<Restaurant>> searchRestaurant(String query);
  Future<String> postReview(
    String id,
    String name,
    String review
  );
}

class RestaurantRepositoryImpl implements RestaurantRepository {
  final _api = ApiRestaurant();

  @override
  Future<List<Restaurant>> getRestaurants() async {
    try {
      final response = await _api.getRestaurants();
      switch (response.statusCode) {
        case 200: {
          final data = ListRestaurantsResponse.fromJson(response.data);
          return data.restaurants?.map((e) => e.toRestaurant()).toList() ?? List.empty();
        }
        case 500: throw HttpException(response.statusMessage ?? "Internal Server Error");
        default: throw HttpException(response.statusMessage ?? "Failed to fetch data restaurants");
      }
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<Restaurant> getDetailRestaurant(String id) async {
    try {
      final response = await _api.getDetailRestaurant(id);
      switch (response.statusCode) {
        case 200: {
          final data = DetailRestaurantsResponse.fromJson(response.data);
          return data.restaurant!.toRestaurant();
        }
        case 500: throw HttpException(response.statusMessage ?? "Internal Server Error");
        default: throw HttpException(response.statusMessage ?? "Failed to fetch data restaurants");
      }
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<String> postReview(String id, String name, String review) async {
    try {
      final param = ReviewRequest(id: id, name: name, review: review);
      final response = await _api.postReview(param);
      switch (response.statusCode) {
        case 200 || 201: {
          final data = PostReviewResponse.fromJson(response.data);
          final message = data.message ?? "Success";
          return message;
        }
        case 500: throw HttpException(response.statusMessage ?? "Internal Server Error");
        default: throw HttpException(response.statusMessage ?? "Failed to post review");
      }
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<List<Restaurant>> searchRestaurant(String query) async {
    try {
      print("Try to search: $query");
      final response = await _api.searchRestaurant(query);
      switch (response.statusCode) {
        case 200: {
          final data = ListRestaurantsResponse.fromJson(response.data);
          return data.restaurants?.map((e) => e.toRestaurant()).toList() ?? List.empty();
        }
        case 500: {
          throw HttpException(response.statusMessage ?? "Internal Server Error");
        }
        default: {
          throw HttpException(response.statusMessage ?? "Failed to fetch data restaurants");
        }
      }
    } catch (e) {
      print("Error: $e");
      rethrow;
    }
  }

}