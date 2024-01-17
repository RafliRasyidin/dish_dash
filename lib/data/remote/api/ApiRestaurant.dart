import 'package:dio/dio.dart';
import 'package:dish_dash/data/remote/api/ApiService.dart';
import 'package:dish_dash/data/remote/request/ReviewRequest.dart';

class ApiRestaurant {

  Future<Response> getRestaurants() async {
    final response = await dio.get("/list");
    return response;
  }

  Future<Response> getDetailRestaurant(String id) async {
    final response = await dio.get("/detail/$id",);
    return response;
  }

  Future<Response> searchRestaurant(String query) async {
    final response = await dio.get(
      "/search",
      queryParameters: { "q" : query }
    );
    return response;
  }

  Future<Response> postReview(ReviewRequest param) async {
    final response = await dio.post(
      "/review",
      data: param.toJson()
    );
    return response;
  }
}