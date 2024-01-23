import 'package:dish_dash/model/Restaurant.dart';
import 'package:floor/floor.dart';

@Entity(tableName: "favorite")
class Favorite {
  @primaryKey
  final String id;
  final String name;
  final String description;
  final String city;
  final String address;
  final String pictureId;
  final double rating;

  Favorite({
    required this.id,
    required this.name,
    required this.description,
    required this.city,
    required this.address,
    required this.pictureId,
    required this.rating
 });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'city': city,
      'address': address,
      'pictureId': pictureId,
      'rating': rating,
    };
  }

  factory Favorite.fromMap(Map<String, dynamic> map) {
    return Favorite(
      id: map['id'] as String,
      name: map['name'] as String,
      description: map['description'] as String,
      city: map['city'] as String,
      address: map['address'] as String,
      pictureId: map['pictureId'] as String,
      rating: map['rating'] as double,
    );
  }
}

extension FavoriteEntityExt on Favorite {
  Restaurant toRestaurant() => Restaurant(
    id: id,
    name: name,
    description: description,
    city: city,
    address: address,
    pictureId: pictureId,
    categories: List.empty(),
    menus: Menus(foods: List.empty(), drinks: List.empty()),
    rating: rating,
    customerReviews: List.empty()
  );
}
