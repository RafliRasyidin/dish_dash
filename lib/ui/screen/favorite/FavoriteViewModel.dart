import 'package:dish_dash/data/local/entities/FavoriteEntity.dart';
import 'package:dish_dash/data/repository/FavoriteRepository.dart';
import 'package:dish_dash/model/Restaurant.dart';
import 'package:flutter/material.dart';

import '../../../model/ResultState.dart';

class FavoriteViewModel extends ChangeNotifier {
  final FavoriteRepositoryImpl _repo;

  FavoriteViewModel(this._repo) {
    getFavoriteRestaurants("");
  }

  ResultState<List<Restaurant>> result = ResultState.loading();

  void _setState(ResultState<List<Restaurant>> state) {
    result = state;
    notifyListeners();
  }

  Future<void> getFavoriteRestaurants(String search) async {
    _setState(ResultState.loading());
    _repo.getFavorites(search)
      .then((value) {
        if (value.isNotEmpty) {
          final restaurants = value.map((e) => e.toRestaurant());
          _setState(ResultState.success(restaurants.toList()));
        } else {
          _setState(ResultState.empty());
        }
      });
  }
}