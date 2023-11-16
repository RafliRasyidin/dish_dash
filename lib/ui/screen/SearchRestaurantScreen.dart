import 'package:flutter/material.dart';

class SearchRestaurantScreen extends StatefulWidget {
  static const routeName = "search_restaurant";

  const SearchRestaurantScreen({super.key});

  @override
  State<SearchRestaurantScreen> createState() => _SearchRestaurantScreenState();
}

class _SearchRestaurantScreenState extends State<SearchRestaurantScreen> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
          backgroundColor: Theme.of(context).colorScheme.background,
          body: Column(
            children: [

            ],
          ),
        )
    );
  }
}
