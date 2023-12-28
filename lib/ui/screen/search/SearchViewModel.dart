import 'dart:io';

import 'package:dish_dash/data/repository/RestaurantRepository.dart';
import 'package:dish_dash/model/Restaurant.dart';
import 'package:dish_dash/model/ResultState.dart';
import 'package:flutter/material.dart';

class SearchViewModel extends ChangeNotifier {
  final _repo = RestaurantRepositoryImpl();

  ResultState<List<Restaurant>> result = ResultState.idle();

  void _setState(ResultState<List<Restaurant>> state) {
    result = state;
    notifyListeners();
  }

  Future<void> searchRestaurant(String query) async {
    _setState(ResultState.loading());
    _repo.searchRestaurant(query)
      .then((value) {
        if (value.isEmpty) {
          _setState(ResultState.empty());
        } else {
          _setState(ResultState.success(value));
        }
    })
    .onError((error, stackTrace) {
      if (error is HttpException) {
        _setState(ResultState.failure(error.message));
      } else {
        _setState(ResultState.noConnection());
      }
    });
  }
}