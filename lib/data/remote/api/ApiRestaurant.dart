import 'package:dio/dio.dart';
import 'package:dish_dash/data/remote/api/ApiService.dart';
import 'package:dish_dash/data/remote/request/ReviewRequest.dart';

class ApiRestaurant {
  final Dio _dio;

  ApiRestaurant(this._dio);

  Future<Response> getRestaurants() async {
    final response = await _dio.get("$baseUrl/list");
    return response;
  }

  Future<Response> getDetailRestaurant(String id) async {
    final response = await _dio.get("$baseUrl/detail/$id",);
    return response;
  }

  Future<Response> searchRestaurant(String query) async {
    final response = await _dio.get(
      "$baseUrl/search",
      queryParameters: { "q" : query }
    );
    return response;
  }

  Future<Response> postReview(ReviewRequest param) async {
    final response = await _dio.post(
      "$baseUrl/review",
      data: param.toJson()
    );
    return response;
  }
}