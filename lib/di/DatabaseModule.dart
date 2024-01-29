import 'package:shared_preferences/shared_preferences.dart';

import '../data/local/dao/FavoriteDao.dart';
import '../data/local/db/dish_dash_database.dart';
import '../data/local/preferences/AppPreferences.dart';
import '../data/repository/FavoriteRepository.dart';
import 'AppModule.dart';

Future<void> initDatabaseDependencies() async {
  final db = await $FloorDishDashDatabase.databaseBuilder(DishDashDatabase.dbName).build();
  if (!locator.isRegistered<DishDashDatabase>()) {
    locator.registerSingleton(db);
  }

  if (!locator.isRegistered<FavoriteDao>()) {
    locator.registerSingleton(db.favoriteDao);
  }

  if (!locator.isRegistered<FavoriteRepositoryImpl>()) {
    locator.registerSingleton(FavoriteRepositoryImpl(locator<FavoriteDao>()));
  }

  final prefs = await SharedPreferences.getInstance();
  if (!locator.isRegistered<SharedPreferences>()) {
    locator.registerSingleton(prefs);
  }

  if (!locator.isRegistered<AppPreferencesImpl>()) {
    locator.registerSingleton(AppPreferencesImpl(locator<SharedPreferences>()));
  }

}