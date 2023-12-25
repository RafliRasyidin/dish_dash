import 'dart:convert';

import 'package:dish_dash/model/Restaurant.dart';

DetailRestaurantsResponse detailRestaurantsResponseFromJson(String str) => DetailRestaurantsResponse.fromJson(json.decode(str));

class DetailRestaurantsResponse {
  bool? error;
  String? message;
  RestaurantResponse? restaurant;

  DetailRestaurantsResponse({
    this.error,
    this.message,
    this.restaurant,
  });

  DetailRestaurantsResponse copyWith({
    bool? error,
    String? message,
    RestaurantResponse? restaurant,
  }) =>
      DetailRestaurantsResponse(
        error: error ?? this.error,
        message: message ?? this.message,
        restaurant: restaurant ?? this.restaurant,
      );

  factory DetailRestaurantsResponse.fromJson(Map<String, dynamic> json) => DetailRestaurantsResponse(
    error: json["error"],
    message: json["message"],
    restaurant: json["restaurant"] == null ? null : RestaurantResponse.fromJson(json["restaurant"]),
  );

}

class RestaurantResponse {
  String? id;
  String? name;
  String? description;
  String? city;
  String? address;
  String? pictureId;
  List<CategoriesResponse>? categories;
  MenusResponse? menus;
  double? rating;
  List<CustomerReviewsResponse>? customerReviews;

  RestaurantResponse({
    this.id,
    this.name,
    this.description,
    this.city,
    this.address,
    this.pictureId,
    this.categories,
    this.menus,
    this.rating,
    this.customerReviews,
  });

  RestaurantResponse copyWith({
    String? id,
    String? name,
    String? description,
    String? city,
    String? address,
    String? pictureId,
    List<CategoriesResponse>? categories,
    MenusResponse? menus,
    double? rating,
    List<CustomerReviewsResponse>? customerReviews,
  }) =>
      RestaurantResponse(
        id: id ?? this.id,
        name: name ?? this.name,
        description: description ?? this.description,
        city: city ?? this.city,
        address: address ?? this.address,
        pictureId: pictureId ?? this.pictureId,
        categories: categories ?? this.categories,
        menus: menus ?? this.menus,
        rating: rating ?? this.rating,
        customerReviews: customerReviews ?? this.customerReviews,
      );

  factory RestaurantResponse.fromJson(Map<String, dynamic> json) => RestaurantResponse(
    id: json["id"],
    name: json["name"],
    description: json["description"],
    city: json["city"],
    address: json["address"],
    pictureId: json["pictureId"],
    categories: json["categories"] == null ? [] : List<CategoriesResponse>.from(json["categories"]!.map((x) => CategoriesResponse.fromJson(x))),
    menus: json["menus"] == null ? null : MenusResponse.fromJson(json["menus"]),
    rating: json["rating"]?.toDouble(),
    customerReviews: json["customerReviews"] == null ? [] : List<CustomerReviewsResponse>.from(json["customerReviews"]!.map((x) => CustomerReviewsResponse.fromJson(x))),
  );

}

extension RestaurantResponseExt on RestaurantResponse {
  Restaurant toRestaurant() => Restaurant(
      id: id ?? "",
      name: name ?? "",
      description: description ?? "",
      city: city ?? "",
      address: address ?? "",
      pictureId: pictureId ?? "",
      categories:  categories?.map((e) => e.toCategory()).toList() ?? List.empty(),
      menus: menus?.toMenus() ?? Menus(foods: List.empty(), drinks: List.empty()),
      rating: rating ?? 0,
      customerReviews: customerReviews?.map((e) => e.toCustomerReview()).toList() ?? List.empty()
  );
}

class CategoriesResponse {
  String? name;

  CategoriesResponse({
    this.name,
  });

  CategoriesResponse copyWith({
    String? name,
  }) =>
      CategoriesResponse(
        name: name ?? this.name,
      );

  factory CategoriesResponse.fromJson(Map<String, dynamic> json) => CategoriesResponse(
    name: json["name"],
  );
}

extension CategoriesResponseExt on CategoriesResponse {
  Category toCategory() => Category(name: name ?? "");
}

class CustomerReviewsResponse {
  String? name;
  String? review;
  String? date;

  CustomerReviewsResponse({
    this.name,
    this.review,
    this.date,
  });

  CustomerReviewsResponse copyWith({
    String? name,
    String? review,
    String? date,
  }) =>
      CustomerReviewsResponse(
        name: name ?? this.name,
        review: review ?? this.review,
        date: date ?? this.date,
      );

  factory CustomerReviewsResponse.fromJson(Map<String, dynamic> json) => CustomerReviewsResponse(
    name: json["name"],
    review: json["review"],
    date: json["date"],
  );
}

extension CustomerReviewsResponseExt on CustomerReviewsResponse {
  CustomerReview toCustomerReview() => CustomerReview(
    name: name ?? "",
    review: review ?? "",
    date: date ?? ""
  );
}

class MenusResponse {
  List<CategoriesResponse>? foods;
  List<CategoriesResponse>? drinks;

  MenusResponse({
    this.foods,
    this.drinks,
  });

  MenusResponse copyWith({
    List<CategoriesResponse>? foods,
    List<CategoriesResponse>? drinks,
  }) =>
      MenusResponse(
        foods: foods ?? this.foods,
        drinks: drinks ?? this.drinks,
      );

  factory MenusResponse.fromJson(Map<String, dynamic> json) => MenusResponse(
    foods: json["foods"] == null ? [] : List<CategoriesResponse>.from(json["foods"]!.map((x) => CategoriesResponse.fromJson(x))),
    drinks: json["drinks"] == null ? [] : List<CategoriesResponse>.from(json["drinks"]!.map((x) => CategoriesResponse.fromJson(x))),
  );

}

extension MenusResponseExt on MenusResponse {
  Menus toMenus() => Menus(
      foods: foods?.map((e) => e.toCategory()).toList() ?? List.empty(),
      drinks: drinks?.map((e) => e.toCategory()).toList() ?? List.empty()
  );
}