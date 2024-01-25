import 'package:dish_dash/data/remote/api/ApiService.dart';
import 'package:dish_dash/data/repository/RestaurantRepository.dart';
import 'package:dish_dash/di/Locator.dart';
import 'package:dish_dash/model/Restaurant.dart';
import 'package:dish_dash/generated/assets.dart';
import 'package:dish_dash/model/ResultState.dart';
import 'package:dish_dash/ui/component/SearchBox.dart';
import 'package:dish_dash/ui/screen/detail/DetailRestaurantScreen.dart';
import 'package:dish_dash/ui/screen/favorite/FavoriteScreen.dart';
import 'package:dish_dash/ui/screen/home/HomeViewModel.dart';
import 'package:dish_dash/ui/screen/search/SearchRestaurantScreen.dart';
import 'package:dish_dash/ui/screen/setting/SettingScreen.dart';
import 'package:dish_dash/util/NotificationHelper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';

import '../../component/NegativeState.dart';

class HomeScreen extends StatefulWidget {
  static const routeName = "home";

  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String _searchedText = "";
  late HomeViewModel _viewModel;
  final _notificationHelper = NotificationHelper();

  @override
  void initState() {
    _viewModel = HomeViewModel(locator<RestaurantRepositoryImpl>());
    _notificationHelper.requestNotificationPermission(locator<FlutterLocalNotificationsPlugin>());
    _notificationHelper.configSelectNotificationSubject(DetailRestaurantScreen.routeName);
    super.initState();
  }

  @override
  void dispose() {
    selectNotificationSubject.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
          backgroundColor: Theme.of(context).colorScheme.background,
          body: ChangeNotifierProvider(
            create: (_) => _viewModel,
            child: Consumer<HomeViewModel>(
              builder: (context, vm, _) {
                switch (vm.result.status) {
                  case Status.loading:
                    return Container(
                        color: Theme.of(context).colorScheme.background,
                        child: const Center(child: CircularProgressIndicator())
                    );
                  case Status.success: return _buildContent(vm.result.data!);
                  case Status.noConnection:
                    return NegativeState(
                        image: Assets.assetsImgNoInternet,
                        description: "No Internet Connection",
                        onClick: () { _viewModel.getRestaurants(); },
                        button: const Text("Try Again")
                    );
                  case Status.empty:
                    return NegativeState(
                        image: Assets.assetsImgNoInternet,
                        description: "Cafe Not Found",
                        onClick: () { _viewModel.getRestaurants(); },
                        button: const Text("Try Again")
                    );
                  case Status.failure:
                    return NegativeState(
                        image: Assets.assetsImgNoInternet,
                        description: vm.result.message!,
                        onClick: () { _viewModel.getRestaurants(); },
                        button: const Text("Try Again")
                    );
                  default: return Container();
                }
              },
            ),
          ),
        )
    );
  }

  Widget _buildContent(List<Restaurant> restaurants) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildTextNearbyRestaurant(context, restaurants),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: InkWell(
                    child: SearchBox(
                      text: _searchedText,
                      hint: "Search restaurant here...",
                      onTextChange: (newText) {
                        setState(() {
                          _searchedText = newText;
                        });
                      },
                      enabled: false,
                    ),
                    onTap: () {
                      Navigator.pushNamed(
                          context,
                          SearchRestaurantScreen.routeName,
                          arguments: restaurants
                      );
                    },
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            _buildListTitleSection(context, "Best Restaurant"),
            const SizedBox(height: 16),
            SizedBox(
              height: 154,
              child: ListView.builder(
                  itemCount: restaurants.length,
                  physics: const ClampingScrollPhysics(),
                  shrinkWrap: true,
                  scrollDirection: Axis.horizontal,
                  itemBuilder: (context, index) {
                    final item = restaurants[index];
                    return _buildItemRestaurant(item, context);
                  }
              ),
            ),
            const SizedBox(height: 16),
            _buildListTitleSection(context, "Recommended For You!"),
            const SizedBox(height: 16),
            SizedBox(
              height: 154,
              child: ListView.builder(
                  itemCount: restaurants.length,
                  physics: const ClampingScrollPhysics(),
                  shrinkWrap: true,
                  scrollDirection: Axis.horizontal,
                  itemBuilder: (context, index) {
                    final item = restaurants[index];
                    return _buildItemRestaurant(item, context);
                  }
              ),
            ),
            const SizedBox(height: 16),
            _buildListTitleSection(context, "All Restaurants"),
            const SizedBox(height: 16),
            _buildListAllRestaurants(restaurants)
          ],
        ),
      ),
    );
  }

  Widget _buildListAllRestaurants(List<Restaurant> restaurants) {
    return ListView.builder(
      itemCount: restaurants.length,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemBuilder: (context, index) {
        final item = restaurants[index];
        return _buildItemAllRestaurants(item, context);
      },
    );
  }

  Widget _buildItemAllRestaurants(Restaurant item, BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.pushNamed(
            context,
            DetailRestaurantScreen.routeName,
            arguments: item.toDetailRestaurant()
        );
      },
      child: Padding(
        padding: const EdgeInsets.only(bottom: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Hero(
                tag: item.pictureId,
                child: Image.network(
                  "$urlImageMedium/${item.pictureId}",
                  width: double.infinity,
                  height: 160,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Flexible(
                  child: Text(
                    item.name,
                    style: Theme.of(context).textTheme.titleMedium,
                    overflow: TextOverflow.ellipsis,
                  )
                ),
                Row(
                  children: [
                    Icon(
                      Icons.star,
                      size: 12,
                      color: Theme.of(context).colorScheme.onBackground,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      item.rating.toString(),
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  ],
                )
              ],
            ),
            Text(
              item.description,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: Theme.of(context).colorScheme.outline
              ),
              overflow: TextOverflow.ellipsis,
              maxLines: 2,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildItemRestaurant(Restaurant item, BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.pushNamed(
          context,
          DetailRestaurantScreen.routeName,
          arguments: item.toDetailRestaurant()
        );
      },
      child: Padding(
        padding: const EdgeInsets.only(right: 16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.network(
                "$urlImageSmall/${item.pictureId}",
                width: 180,
                height: 100,
                fit: BoxFit.fill,
              ),
            ),
            const SizedBox(height: 8,),
            SizedBox(
              width: 180,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Flexible(
                    child: Text(
                      item.name,
                      style: Theme.of(context).textTheme.titleMedium,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  Row(
                    children: [
                      const Icon(
                        Icons.star,
                        size: 12,
                        color: Colors.amber,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        item.rating.toString(),
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                    ],
                  )
                ],
              ),
            ),
            SizedBox(
              width: 180,
              child: Text(
                item.city,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: Theme.of(context).colorScheme.outline
                ),
                overflow: TextOverflow.ellipsis,
                maxLines: 2,
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildListTitleSection(BuildContext context, String title) {
    return Text(
      title,
      style: Theme.of(context).textTheme.titleLarge?.copyWith(
        color: Theme.of(context).colorScheme.onBackground,
      ),
      textAlign: TextAlign.left,
    );
  }

  Widget _buildTextNearbyRestaurant(BuildContext context, List<Restaurant> restaurants) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Expanded(
          child: Row(
            children: [
              SvgPicture.asset(
                Assets.assetsIcPinLocation,
                height: 16,
                width: 16,
                colorFilter: ColorFilter.mode(Theme.of(context).colorScheme.onBackground, BlendMode.srcIn),
              ),
              const SizedBox(width: 8,),
              Text(
                "${restaurants.length} Restaurants near you...",
                style: Theme.of(context).textTheme.labelMedium,
              ),
            ],
          )
        ),
        const SizedBox(width: 12),
        InkWell(
          child: Icon(
            Icons.favorite,
            color: Theme.of(context).colorScheme.onBackground,
          ),
          onTap: () {
            Navigator.pushNamed(context, FavoriteScreen.routeName);
          },
        ),
        const SizedBox(width: 12),
        InkWell(
          child: Icon(
            Icons.settings,
            color: Theme.of(context).colorScheme.onBackground,
          ),
          onTap: () {
            Navigator.pushNamed(context, SettingScreen.routeName);
          },
        ),
      ],
    );
  }
}
