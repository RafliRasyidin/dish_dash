import 'package:dish_dash/data/remote/api/ApiService.dart';
import 'package:dish_dash/model/AssetsFood.dart';
import 'package:dish_dash/model/Restaurant.dart';
import 'package:dish_dash/ui/screen/detail/DetailViewModel.dart';
import 'package:flutter/material.dart';
import 'package:palette_generator/palette_generator.dart';
import 'package:provider/provider.dart';

import '../../../model/ResultState.dart';

//ignore: must_be_immutable
class DetailRestaurantScreen extends StatefulWidget {
  static const routeName = "detail_restaurant";
  Restaurant restaurant;

  DetailRestaurantScreen({
    super.key,
    required this.restaurant
  });

  @override
  State<DetailRestaurantScreen> createState() => _DetailRestaurantScreenState();
}

class _DetailRestaurantScreenState extends State<DetailRestaurantScreen> {
  PaletteGenerator? paletteGenerator;
  bool isExpanded = false;
  late DetailViewModel _viewModel;

  @override
  void initState() {
    _viewModel = DetailViewModel();
    _viewModel.getDetailRestaurant(widget.restaurant.id);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => _viewModel,
      child: Consumer<DetailViewModel>(
        builder: (context, vm, _) {
          switch (vm.resultState.status) {
            case Status.loading:
              return const Center(child: CircularProgressIndicator());
            case Status.success: return _buildContent(vm.resultState.data!);
            case Status.noConnection:
              return Container(
                color: Theme.of(context).colorScheme.background,
                child: Center(
                  child: Text(
                    "No Internet Connection",
                    style: Theme.of(context).textTheme.displayLarge,
                  ),
                ),
              );
            case Status.empty:
              return Container(
                color: Theme.of(context).colorScheme.background,
                child: Center(
                  child: Text(
                    "Data Not Found",
                    style: Theme.of(context).textTheme.displayLarge,
                  ),
                ),
              );
            case Status.failure:
              return Container(
                color: Theme.of(context).colorScheme.background,
                child: Center(
                  child: Text(
                    vm.resultState.message!,
                    style: Theme.of(context).textTheme.displayLarge,
                  ),
                ),
              );
            default: return Container();
          }
        },
      ),
    );
  }

  Widget _buildContent(Restaurant restaurant) {
    final heightImageRestaurant = MediaQuery.of(context).size.height * 0.3;
    final foods = restaurant.menus.foods;
    final drinks = restaurant.menus.drinks;
    return FutureBuilder(
      future: _getColorPalette(restaurant),
      builder: (context, snapshot) {
        final dominantColor = snapshot.data?.dominantColor?.color ?? Theme.of(context).colorScheme.background;
        return Scaffold(
          backgroundColor: Theme.of(context).colorScheme.background,
          body: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildHeader(heightImageRestaurant, dominantColor, context, restaurant),
                const SizedBox(height: 16,),
                _buildContentRestaurant(context, restaurant),
                const SizedBox(height: 16,),
                _buildContentFoods(context, foods, "For You!", restaurant),
                const SizedBox(height: 16,),
                _buildContentFoods(context, drinks, "Recommended", restaurant)
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildContentFoods(
    BuildContext context,
    List<Category> foods,
    String title,
    Restaurant restaurant
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
              color: Theme.of(context).colorScheme.onBackground
            ),
          ),
          _buildListFoods(foods, restaurant)
        ],
      ),
    );
  }

  Widget _buildListFoods(List<Category> foods, Restaurant restaurant) {
    return ListView.builder(
      itemCount: foods.length,
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemBuilder: (context, index) {
        final item = foods[index];
        final isLastIndex = index == foods.length - 1;
        return _buildItemFood(item, context, isLastIndex, restaurant);
      }
    );
  }

  Widget _buildItemFood(
      Category item,
      BuildContext context,
      bool isLastIndex,
      Restaurant restaurant
  ) {
    return Column(
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(right: 12.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item.name,
                      style: Theme.of(context).textTheme.titleSmall?.copyWith(
                          color: Theme.of(context).colorScheme.onBackground
                      ),
                    ),
                    Text(
                      restaurant.description,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: Theme.of(context).colorScheme.outline
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    )
                  ],
                ),
              ),
            ),
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.asset(
                AssetsFood.getRandomAssetFood(),
                width: 120,
                height: 90,
                fit: BoxFit.fill,
              ),
            )
          ],
        ),
        const SizedBox(height: 16,),
        Divider(
          height: 1,
          thickness: .5,
          color: Theme.of(context).colorScheme.surfaceVariant,
        ),
        SizedBox(height: isLastIndex ? 0 : 16,)
      ],
    );
  }

  Widget _buildContentRestaurant(BuildContext context, Restaurant restaurant) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  restaurant.name,
                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    fontStyle: FontStyle.normal
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              Row(
                children: [
                  const Icon(
                    Icons.star,
                    color: Colors.amber,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    restaurant.rating.toString(),
                    style: Theme.of(context).textTheme.titleLarge,
                  )
                ],
              )
            ],
          ),
          Text(
            restaurant.city,
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
              color: Theme.of(context).colorScheme.outline,
            ),
            textAlign: TextAlign.start,
          ),
          const SizedBox(height: 12,),
          Text(
            restaurant.description,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Theme.of(context).colorScheme.outline
            ),
            maxLines: isExpanded ? null : 3,
            overflow: isExpanded ? null : TextOverflow.ellipsis,
            textAlign: TextAlign.justify,
          ),
          const SizedBox(height: 8,),
          Align(
            alignment: Alignment.centerRight,
            child: InkWell(
              child: Text(
                isExpanded ? "Show Less" : "Show More",
                style: Theme.of(context).textTheme.labelMedium?.copyWith(
                  color: Theme.of(context).colorScheme.primary,
                  decoration: TextDecoration.underline
                ),
              ),
              onTap: () {
                setState(() {
                  isExpanded = !isExpanded;
                });
              },
            ),
          )
        ],
      ),
    );
  }

  Widget _buildHeader(
      double heightImageRestaurant,
      Color dominantColor,
      BuildContext context,
      Restaurant restaurant
  ) {
    return Stack(
      children: [
        Hero(
            tag: restaurant.pictureId,
            child: Image.network(
              "$urlImageMedium/${restaurant.pictureId}",
              width: double.infinity,
              height: heightImageRestaurant,
              fit: BoxFit.cover,
            )
        ),
        Container(
          height: heightImageRestaurant * 0.4,
          decoration: BoxDecoration(
              gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    dominantColor,
                    Colors.transparent
                  ]
              )
          ),
        ),
        Positioned(
          left: 16,
          top: 32,
          right: 16,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              InkWell(
                child: Icon(
                  Icons.arrow_back,
                  color: Theme.of(context).colorScheme.background,
                ),
                onTap: () {
                  Navigator.pop(context);
                },
              ),
            ],
          )
        )
      ],
    );
  }

  Future<PaletteGenerator?> _getColorPalette(Restaurant restaurant) async {
    final imageRestaurant = Image.network(restaurant.pictureId);
    paletteGenerator = await PaletteGenerator.fromImageProvider(
      imageRestaurant.image,
      size: Size(imageRestaurant.width ?? 100, imageRestaurant.height ?? 100)
    );
    return paletteGenerator;
  }
}
