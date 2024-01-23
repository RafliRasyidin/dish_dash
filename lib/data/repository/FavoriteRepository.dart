import 'package:dish_dash/data/local/entities/FavoriteEntity.dart';

import '../local/dao/FavoriteDao.dart';

abstract class FavoriteRepository {
  Future<List<Favorite>> getFavorites(String search);
  Future<Favorite?> getFavoriteById(String id);
  Future<void> insertFavorite(Favorite favorite);
  Future<void> deleteFavorite(Favorite favorite);
}

class FavoriteRepositoryImpl implements FavoriteRepository {
  final FavoriteDao _dao;

  FavoriteRepositoryImpl(this._dao);

  @override
  Future<Favorite?> getFavoriteById(String id) async {
    final data = await _dao.getFavoriteById(id);
    return data;
  }

  @override
  Future<List<Favorite>> getFavorites(String search) async {
    if (search.isNotEmpty) {
      final data = await _dao.searchFavorite(search);
      return data;
    } else {
      final data = await _dao.getFavorites();
      return data;
    }
  }

  @override
  Future<void> insertFavorite(Favorite favorite) async {
    await _dao.insertFavorite(favorite);
  }

  @override
  Future<void> deleteFavorite(Favorite favorite) async {
    await _dao.deleteFavorite(favorite);
  }

}