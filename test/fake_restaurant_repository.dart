import 'package:dish_dash/data/remote/api/ApiRestaurant.dart';
import 'package:dish_dash/data/repository/RestaurantRepository.dart';
import 'package:dish_dash/model/Restaurant.dart';

class FakeRestaurantRepository implements RestaurantRepository {

  ApiRestaurant _apiRestaurant;

  FakeRestaurantRepository(this._apiRestaurant);

  @override
  Future<Restaurant> getDetailRestaurant(String id) {
    // TODO: implement getDetailRestaurant
    throw UnimplementedError();
  }

  @override
  Future<List<Restaurant>> getRestaurants() {
    // TODO: implement getRestaurants
    throw UnimplementedError();
  }

  @override
  Future<String> postReview(String id, String name, String review) {
    // TODO: implement postReview
    throw UnimplementedError();
  }

  @override
  Future<List<Restaurant>> searchRestaurant(String query) {
    // TODO: implement searchRestaurant
    throw UnimplementedError();
  }

}