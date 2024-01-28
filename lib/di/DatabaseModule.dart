import 'package:shared_preferences/shared_preferences.dart';

import '../data/local/dao/FavoriteDao.dart';
import '../data/local/db/dish_dash_database.dart';
import '../data/local/preferences/AppPreferences.dart';
import '../data/repository/FavoriteRepository.dart';
import 'AppModule.dart';

Future<void> initDatabaseDependencies() async {
  final db = await $FloorDishDashDatabase.databaseBuilder(DishDashDatabase.dbName).build();
  locator.registerSingleton(db);
  locator.registerSingleton(db.favoriteDao);
  locator.registerSingleton(FavoriteRepositoryImpl(locator<FavoriteDao>()));

  final prefs = await SharedPreferences.getInstance();
  locator.registerSingleton(prefs);
  locator.registerSingleton(AppPreferencesImpl(locator<SharedPreferences>()));
}