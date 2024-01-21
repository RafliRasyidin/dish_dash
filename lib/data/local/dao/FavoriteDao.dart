
import 'package:dish_dash/data/local/entities/FavoriteEntity.dart';
import 'package:floor/floor.dart';

@dao
abstract class FavoriteDao {
  @Query("SELECT * FROM Favorite")
  Future<List<Favorite>> getFavorites();

  @insert
  Future<void> insertFavorite(Favorite favorite);
  
  @delete
  Future<void> deleteFavorite(Favorite favorite);
  
  @Query("SELECT * FROM Favorite WHERE id = :id")
  Future<Favorite?> getFavoriteById(String id);
}