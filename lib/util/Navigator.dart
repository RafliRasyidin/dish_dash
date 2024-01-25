import 'package:flutter/material.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey();

class Navigation {
  static intentWithData(String routeName, Object arg) {
    navigatorKey.currentState?.pushNamed(routeName, arguments: arg);
  }

  static back() => navigatorKey.currentState?.pop();
}