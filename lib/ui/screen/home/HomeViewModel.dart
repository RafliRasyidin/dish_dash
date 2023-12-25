import 'dart:io';

import 'package:flutter/material.dart';

import '../../../data/repository/RestaurantRepository.dart';
import '../../../model/Restaurant.dart';
import '../../../model/ResultState.dart';

class HomeViewModel extends ChangeNotifier {
  final _repo = RestaurantRepositoryImpl();

  ResultState<List<Restaurant>> result = ResultState.loading();

  HomeViewModel() {
    getRestaurants();
  }

  void _setState(ResultState<List<Restaurant>> state) {
    result = state;
    notifyListeners();
  }

  Future<void> getRestaurants() async {
    _setState(ResultState.loading());
    _repo.getRestaurants()
      .then((value) {
        if (value.isNotEmpty) {
          _setState(ResultState.success(value));
        } else {
          _setState(ResultState.empty());
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