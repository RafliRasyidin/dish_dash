
import 'package:dish_dash/data/local/entities/FavoriteEntity.dart';
import 'package:floor/floor.dart';

@dao
abstract class FavoriteDao {
  @Query("SELECT * FROM favorite")
  Future<List<Favorite>> getFavorites();

  @insert
  Future<void> insertFavorite(Favorite favorite);
  
  @delete
  Future<void> deleteFavorite(Favorite favorite);
  
  @Query("SELECT * FROM favorite WHERE id = :id")
  Future<Favorite?> getFavoriteById(String id);

  @Query("SELECT * FROM favorite WHERE name LIKE '%'||:search||'%'")
  Future<List<Favorite>> searchFavorite(String search);
}