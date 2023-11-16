// To parse this JSON data, do
//
//     final restaurant = restaurantFromJson(jsonString);

import 'dart:convert';

RestaurantResponse restaurantResponseFromJson(String json) => RestaurantResponse.fromJson(jsonDecode(json));

class RestaurantResponse {
  List<Restaurant> restaurants;

  RestaurantResponse({required this.restaurants});

  factory RestaurantResponse.fromJson(Map<String, dynamic> json) => RestaurantResponse(
    restaurants: List<Restaurant>.from(json["restaurants"].map((x) => Restaurant.fromJson(x))),
  );
}

Restaurant restaurantFromJson(String str) => Restaurant.fromJson(json.decode(str));

String restaurantToJson(Restaurant data) => json.encode(data.toJson());

class Restaurant {
  String id;
  String name;
  String description;
  String pictureId;
  String city;
  double rating;
  Menus menus;

  Restaurant({
    required this.id,
    required this.name,
    required this.description,
    required this.pictureId,
    required this.city,
    required this.rating,
    required this.menus,
  });

  factory Restaurant.fromJson(Map<String, dynamic> json) => Restaurant(
    id: json["id"],
    name: json["name"],
    description: json["description"],
    pictureId: json["pictureId"],
    city: json["city"],
    rating: json["rating"]?.toDouble(),
    menus: Menus.fromJson(json["menus"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "description": description,
    "pictureId": pictureId,
    "city": city,
    "rating": rating,
    "menus": menus.toJson(),
  };
}

class Menus {
  List<Drink> foods;
  List<Drink> drinks;

  Menus({
    required this.foods,
    required this.drinks,
  });

  factory Menus.fromJson(Map<String, dynamic> json) => Menus(
    foods: List<Drink>.from(json["foods"].map((x) => Drink.fromJson(x))),
    drinks: List<Drink>.from(json["drinks"].map((x) => Drink.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "foods": List<dynamic>.from(foods.map((x) => x.toJson())),
    "drinks": List<dynamic>.from(drinks.map((x) => x.toJson())),
  };
}

class Drink {
  String name;

  Drink({
    required this.name,
  });

  factory Drink.fromJson(Map<String, dynamic> json) => Drink(
    name: json["name"],
  );

  Map<String, dynamic> toJson() => {
    "name": name,
  };
}

List<Restaurant> parseRestaurants(String? json) {
  if (json == null) {
    return List.empty();
  }
  return restaurantResponseFromJson(json).restaurants;
}
