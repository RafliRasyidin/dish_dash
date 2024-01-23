import 'package:dish_dash/di/Locator.dart';
import 'package:dish_dash/model/DetailRestaurant.dart';
import 'package:dish_dash/ui/screen/detail/DetailRestaurantScreen.dart';
import 'package:dish_dash/ui/screen/favorite/FavoriteScreen.dart';
import 'package:dish_dash/ui/screen/home/HomeScreen.dart';
import 'package:dish_dash/ui/screen/search/SearchRestaurantScreen.dart';
import 'package:dish_dash/ui/screen/setting/SettingScreen.dart';
import 'package:dish_dash/ui/styles/Colors.dart';
import 'package:dish_dash/ui/styles/Typography.dart';
import 'package:flutter/material.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initDependencies();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: lightColorScheme,
        textTheme: typography,
        useMaterial3: true,
        appBarTheme: const AppBarTheme(elevation: 0),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: Theme.of(context).colorScheme.primary,
            foregroundColor: Theme.of(context).colorScheme.onPrimary,
            textStyle: Theme.of(context).textTheme.labelLarge,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16.0)
            )
          ),
        )
      ),
      darkTheme: ThemeData(
        colorScheme: darkColorScheme,
        useMaterial3: true,
          appBarTheme: const AppBarTheme(elevation: 0),
          elevatedButtonTheme: ElevatedButtonThemeData(
              style: ElevatedButton.styleFrom(
                  backgroundColor: Theme.of(context).colorScheme.primary,
                  foregroundColor: Theme.of(context).colorScheme.onPrimary,
                  textStyle: Theme.of(context).textTheme.labelLarge,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16.0)
                  )
              )
          )
      ),
      initialRoute: HomeScreen.routeName,
      routes: {
        HomeScreen.routeName: (context) => const HomeScreen(),
        DetailRestaurantScreen.routeName: (context) => DetailRestaurantScreen(
          restaurant: ModalRoute.of(context)?.settings.arguments as DetailRestaurant
        ),
        SearchRestaurantScreen.routeName: (context) => const SearchRestaurantScreen(),
        FavoriteScreen.routeName: (context) => FavoriteScreen(),
        SettingScreen.routeName: (context) => SettingScreen()
      },
    );
  }
}
