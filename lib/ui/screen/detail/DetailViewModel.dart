import 'dart:io';

import 'package:dish_dash/data/repository/RestaurantRepository.dart';
import 'package:dish_dash/model/DetailRestaurant.dart';
import 'package:dish_dash/ui/screen/detail/DetailState.dart';
import 'package:flutter/material.dart';

import '../../../data/repository/FavoriteRepository.dart';
import '../../../model/Restaurant.dart';

class DetailViewModel extends ChangeNotifier {
  final RestaurantRepositoryImpl _restaurantRepository;
  final FavoriteRepositoryImpl _favoriteRepository;

  DetailViewModel(this._restaurantRepository, this._favoriteRepository);

  DetailState<DetailRestaurant> resultState = DetailState.loading();

  var _isPostReview = false;
  bool get isPostReview => _isPostReview;

  void setStatePostReview(bool isPostingReview) {
    _isPostReview = isPostingReview;
    notifyListeners();
  }

  void _setState(DetailState<DetailRestaurant> state) {
    resultState = state;
    notifyListeners();
  }

  Future<void> getDetailRestaurant(String idRestaurant) async {
    resultState = DetailState.loading();
    var data = await _favoriteRepository.getFavoriteById(idRestaurant);
    final isFavorite = data != null;
    _restaurantRepository.getDetailRestaurant(idRestaurant)
      .then((value) {
        var detailRestaurant = value.toDetailRestaurant();
        detailRestaurant = detailRestaurant.copyWith(isFavorite: isFavorite);
        _setState(DetailState.hasData(detailRestaurant));
      })
      .onError((error, stackTrace) {
        if (error is HttpException) {
          _setState(DetailState.failure(error.message));
        } else {
          _setState(DetailState.noConnection());
        }
    });
  }

  Future<void> postReview(String id, String name, String review) async {
    _setState(DetailState.loading());
    _restaurantRepository.postReview(id, name, review)
      .then((value) => _setState(DetailState.success(null)))
      .onError((error, stackTrace) {
        if (error is HttpException) {
          _setState(DetailState.failure(error.message));
        } else {
          _setState(DetailState.noConnection());
        }
    });
  }

  Future<void> setFavorite(DetailRestaurant restaurant) async {
    final isFavorite = restaurant.isFavorite;
    if (isFavorite) {
      await _favoriteRepository.deleteFavorite(restaurant.toFavorite());
    } else {
      await _favoriteRepository.insertFavorite(restaurant.toFavorite());
    }
    getDetailRestaurant(restaurant.id);
  }
}