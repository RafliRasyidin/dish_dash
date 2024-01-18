import 'dart:io';

import 'package:dish_dash/data/repository/RestaurantRepository.dart';
import 'package:dish_dash/model/ResultState.dart';
import 'package:dish_dash/ui/screen/detail/DetailState.dart';
import 'package:flutter/material.dart';

import '../../../model/Restaurant.dart';

class DetailViewModel extends ChangeNotifier {
  final _repo = RestaurantRepositoryImpl();

  DetailState<Restaurant> resultState = DetailState.loading();

  /*String _review = "";
  String _name = "";

  void onNameChange(String text) {
    _name = text;
    notifyListeners();
  }

  void onReviewChange(String text) {
    _review = text;
    notifyListeners();
  }*/

  void _setState(DetailState<Restaurant> state) {
    resultState = state;
    notifyListeners();
  }

  Future<void> getDetailRestaurant(String idRestaurant) async {
    resultState = DetailState.loading();
    _repo.getDetailRestaurant(idRestaurant)
      .then((value) => _setState(DetailState.hasData(value)))
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
    _repo.postReview(id, name, review)
      .then((value) => _setState(DetailState.success(null)))
      .onError((error, stackTrace) {
        if (error is HttpException) {
          _setState(DetailState.failure(error.message));
        } else {
          _setState(DetailState.noConnection());
        }
    });
  }
}