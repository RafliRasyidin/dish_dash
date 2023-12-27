import 'dart:io';

import 'package:dish_dash/data/repository/RestaurantRepository.dart';
import 'package:dish_dash/model/ResultState.dart';
import 'package:flutter/material.dart';

import '../../../model/Restaurant.dart';

class DetailViewModel extends ChangeNotifier {
  final _repo = RestaurantRepositoryImpl();

  ResultState<Restaurant> resultState = ResultState.loading();

  void _setState(ResultState<Restaurant> state) {
    resultState = state;
    notifyListeners();
  }

  Future<void> getDetailRestaurant(String idRestaurant) async {
    resultState = ResultState.loading();
    _repo.getDetailRestaurant(idRestaurant)
      .then((value) => _setState(ResultState.success(value)))
      .onError((error, stackTrace) {
      if (error is HttpException) {
        _setState(ResultState.failure(error.message));
      } else {
        _setState(ResultState.noConnection());
      }
    });
  }
}