import 'package:dish_dash/data/local/entities/FavoriteEntity.dart';

import 'Restaurant.dart';

class DetailRestaurant {
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
  bool isFavorite;

  DetailRestaurant({
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
    this.isFavorite = false
  });

  DetailRestaurant copyWith({
    String? id,
    String? name,
    String? description,
    String? city,
    String? address,
    String? pictureId,
    List<Category>? categories,
    Menus? menus,
    double? rating,
    List<CustomerReview>? customerReviews,
    bool? isFavorite,
  }) {
    return DetailRestaurant(
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
      isFavorite: isFavorite ?? this.isFavorite,
    );
  }
}

extension DetailRestaurantExt on DetailRestaurant {
  Favorite toFavorite() => Favorite(
    id: id,
    name: name,
    description: description,
    city: city,
    address: address,
    pictureId: pictureId,
    rating: rating
  );
}