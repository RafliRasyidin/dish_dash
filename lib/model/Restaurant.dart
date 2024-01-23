

import 'package:dish_dash/model/DetailRestaurant.dart';

class Restaurant {
  String id;
  String name;
  String description;
  String city;
  String address;
  String pictureId;
  List<Category> categories;
  Menus menus;
  double rating;
  List<CustomerReview> customerReviews;

  Restaurant({
    required this.id,
    required this.name,
    required this.description,
    required this.city,
    required this.address,
    required this.pictureId,
    required this.categories,
    required this.menus,
    required this.rating,
    required this.customerReviews,
  });

  Restaurant copyWith({
    required String id,
    required String name,
    required String description,
    required String city,
    required String address,
    required String pictureId,
    required List<Category> categories,
    required Menus menus,
    required double rating,
    required List<CustomerReview> customerReviews,
  }) =>
      Restaurant(
        id: id,
        name: name,
        description: description,
        city: city,
        address: address,
        pictureId: pictureId,
        categories: categories,
        menus: menus,
        rating: rating,
        customerReviews: customerReviews,
      );
}

class Category {
  String name;

  Category({
    required this.name,
  });

  Category copyWith({
    required String name,
  }) => Category(name: name,);
}

class CustomerReview {
  String name;
  String review;
  String date;

  CustomerReview({
    required this.name,
    required this.review,
    required this.date,
  });

  CustomerReview copyWith({
    required String name,
    required String review,
    required String date,
  }) =>
      CustomerReview(
        name: name,
        review: review,
        date: date,
      );
}

class Menus {
  List<Category> foods;
  List<Category> drinks;

  Menus({
    required this.foods,
    required this.drinks,
  });

  Menus copyWith({
    required List<Category> foods,
    required List<Category> drinks,
  }) =>
      Menus(
        foods: foods,
        drinks: drinks,
      );
}

extension RestaurantExt on Restaurant {
  DetailRestaurant toDetailRestaurant() => DetailRestaurant(
    id: id,
    name: name,
    description: description,
    city: city, address: address,
    pictureId: pictureId,
    categories: categories,
    menus: menus,
    rating: rating,
    customerReviews: customerReviews
  );
}
