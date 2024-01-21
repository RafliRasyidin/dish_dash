import 'package:dish_dash/data/local/dao/FavoriteDao.dart';
import 'package:dish_dash/data/local/entities/FavoriteEntity.dart';
import 'package:floor/floor.dart';

// required package imports
import 'dart:async';
import 'package:sqflite/sqflite.dart' as sqflite;
part 'dish_dash_database.g.dart';

@Database(version: 1, entities: [Favorite])
abstract class DishDashDatabase extends FloorDatabase {
  FavoriteDao get favoriteDao;

  static const dbName = "dish_dash.db";
}