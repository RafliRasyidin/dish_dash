// To parse this JSON data, do
//
//     final listRestaurantsResponse = listRestaurantsResponseFromJson(jsonString);

import 'dart:convert';

import 'package:dish_dash/model/Restaurant.dart';

ListRestaurantsResponse listRestaurantsResponseFromJson(String str) => ListRestaurantsResponse.fromJson(json.decode(str));

class ListRestaurantsResponse {
  bool? error;
  String? message;
  int? count;
  List<RestaurantItemResponse>? restaurants;

  ListRestaurantsResponse({
    this.error,
    this.message,
    this.count,
    required this.restaurants,
  });

  ListRestaurantsResponse copyWith({
    bool? error,
    String? message,
    int? count,
    List<RestaurantItemResponse>? restaurants,
  }) =>
      ListRestaurantsResponse(
        error: error ?? this.error,
        message: message ?? this.message,
        count: count ?? this.count,
        restaurants: restaurants ?? this.restaurants,
      );

  factory ListRestaurantsResponse.fromJson(Map<String, dynamic> json) => ListRestaurantsResponse(
    error: json["error"],
    message: json["message"],
    count: json["count"],
    restaurants: json["restaurants"] == null ? [] : List<RestaurantItemResponse>.from(json["restaurants"]!.map((x) => RestaurantItemResponse.fromJson(x))),
  );

  Map<String, dynamic> toMap() {
    return {
      'error': this.error,
      'message': this.message,
      'count': this.count,
      'restaurants': this.restaurants?.map((e) => e.toMap()),
    };
  }

  factory ListRestaurantsResponse.fromMap(Map<String, dynamic> map) {
    return ListRestaurantsResponse(
      error: map['error'] as bool,
      message: map['message'] as String,
      count: map['count'] as int,
      restaurants: map['restaurants'] as List<RestaurantItemResponse>,
    );
  }
}

class RestaurantItemResponse {
  String? id;
  String? name;
  String? description;
  String? pictureId;
  String? city;
  double? rating;

  RestaurantItemResponse({
    required this.id,
    required this.name,
    required this.description,
    required this.pictureId,
    required this.city,
    required this.rating,
  });

  RestaurantItemResponse copyWith({
    String? id,
    String? name,
    String? description,
    String? pictureId,
    String? city,
    double? rating,
  }) =>
      RestaurantItemResponse(
        id: id ?? this.id,
        name: name ?? this.name,
        description: description ?? this.description,
        pictureId: pictureId ?? this.pictureId,
        city: city ?? this.city,
        rating: rating ?? this.rating,
      );

  factory RestaurantItemResponse.fromJson(Map<String, dynamic> json) => RestaurantItemResponse(
    id: json["id"],
    name: json["name"],
    description: json["description"],
    pictureId: json["pictureId"],
    city: json["city"],
    rating: json["rating"]?.toDouble(),
  );

  Map<String, dynamic> toMap() {
    return {
      'id': this.id,
      'name': this.name,
      'description': this.description,
      'pictureId': this.pictureId,
      'city': this.city,
      'rating': this.rating,
    };
  }

}

extension RestaurantItemResponseExt on RestaurantItemResponse {
  Restaurant toRestaurant() => Restaurant(
    id: id ?? "",
    name: name ?? "",
    description: description ?? "",
    city: city ?? "",
    address: "",
    pictureId: pictureId ?? "",
    categories: List.empty(),
    menus: Menus(foods: List.empty(), drinks: List.empty()),
    rating: rating ?? 0,
    customerReviews: List.empty()
  );
}
