import 'package:dish_dash/ui/screen/detail/DetailRestaurantScreen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../model/Restaurant.dart';
import '../../component/SearchBox.dart';

//ignore: must_be_immutable
class SearchRestaurantScreen extends StatefulWidget {
  static const routeName = "search_restaurant";

  List<Restaurant> restaurants;

  SearchRestaurantScreen({
    super.key,
    required this.restaurants
  });

  @override
  State<SearchRestaurantScreen> createState() => _SearchRestaurantScreenState();
}

class _SearchRestaurantScreenState extends State<SearchRestaurantScreen> {
  String _searchedText = "";
  bool _isEmpty = true;
  late List<Restaurant> restaurants = [];
  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
          backgroundColor: Theme.of(context).colorScheme.background,
          body: Column(
            children: [
              _buildAppBar(context),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12.0),
                  child: Column(
                    children: [
                      SearchBox(
                        text: _searchedText,
                        autoFocus: true,
                        hint: "Search restaurant here...",
                        onTextChange: (newText) {
                          setState(() {
                              _searchedText = newText;
                              if (_searchedText.isEmpty) {
                                restaurants = [];
                                _isEmpty = true;
                              } else{
                                _searchRestaurants();
                              }
                          });
                        },
                      ),
                      const SizedBox(height: 16,),
                      _buildListRestaurant()
                    ],
                  ),
                ),
              ),
            ],
          ),
        )
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: SvgPicture.asset(
        "assets/empty_search.svg",
        width: 180,
        height: 180,
      ),
    );
  }

  Widget _buildListRestaurant() {
    return Expanded(
      child: _isEmpty ? _buildEmptyState() : ListView.builder(
          itemCount: restaurants.length,
          shrinkWrap: true,
          itemBuilder: (context, index) {
            final item = restaurants[index];
            final isLastIndex = index == restaurants.length - 1;
            return _buildItemRestaurant(item, context, isLastIndex);
          }
      ),
    );
  }

  Widget _buildItemRestaurant(Restaurant item, BuildContext context, bool isLastIndex) {
    return InkWell(
      onTap: () {
        Navigator.pushNamed(
          context,
          DetailRestaurantScreen.routeName,
          arguments: item
        );
      },
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Hero(
                tag: item.pictureId,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Image.network(
                    item.pictureId,
                    height: 64,
                    width: 64,
                    fit: BoxFit.fill,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item.name,
                      style: Theme.of(context).textTheme.labelMedium?.copyWith(
                        color: Theme.of(context).colorScheme.onBackground
                      ),
                    ),
                    Text(
                      item.city,
                      style: Theme.of(context).textTheme.labelSmall?.copyWith(
                        color: Theme.of(context).colorScheme.outline
                      ),
                    ),
                    Row(
                      children: [
                        Icon(
                          Icons.star,
                          color: Theme.of(context).colorScheme.outline,
                          size: 16,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          item.rating.toString(),
                          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: Theme.of(context).colorScheme.outline
                          ),
                        )
                      ],
                    )
                  ],
                )
              )
            ],
          ),
          const SizedBox(height: 16),
          Divider(
            thickness: .5,
            color: Theme.of(context).colorScheme.surfaceVariant,
          ),
          SizedBox(height: isLastIndex ? 0 : 16,)
        ],
      ),
    );
  }

  _searchRestaurants() async {
    setState(() {
      final searchedRestaurants = widget.restaurants.where((element){
        final name = element.name.toLowerCase();
        return name.contains(_searchedText.toLowerCase());
      }).toList();
      restaurants = searchedRestaurants;
      _isEmpty = restaurants.isEmpty;
    });
  }

  Widget _buildAppBar(BuildContext context) {
    return AppBar(
      leading: InkWell(
        customBorder: const CircleBorder(),
        child: Icon(
          Icons.chevron_left,
          color: Theme.of(context).colorScheme.onBackground,
        ),
        onTap: () {
          Navigator.pop(context);
        },
      ),
      title: const Text("Search"),
      titleSpacing: 0,
    );
  }
}
