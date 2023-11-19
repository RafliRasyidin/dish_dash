import 'package:dish_dash/data/AssetsFood.dart';
import 'package:dish_dash/data/Restaurant.dart';
import 'package:dish_dash/generated/assets.dart';
import 'package:dish_dash/ui/screen/SearchRestaurantScreen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:palette_generator/palette_generator.dart';

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

  @override
  Widget build(BuildContext context) {
    final heightImageRestaurant = MediaQuery.of(context).size.height * 0.3;
    final foods = widget.restaurant.menus.foods;
    final drinks = widget.restaurant.menus.drinks;
    return FutureBuilder(
      future: _getColorPalette(),
      builder: (context, snapshot) {
        final dominantColor = snapshot.data?.dominantColor?.color ?? Theme.of(context).colorScheme.background;
        return Scaffold(
          backgroundColor: Theme.of(context).colorScheme.background,
          body: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildHeader(heightImageRestaurant, dominantColor, context),
                const SizedBox(height: 16,),
                _buildContentRestaurant(context),
                const SizedBox(height: 16,),
                _buildContentFoods(context, foods, "For You!"),
                const SizedBox(height: 16,),
                _buildContentFoods(context, drinks, "Recommended")
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildContentFoods(
    BuildContext context,
    List<Drink> foods,
    String title
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
          _buildListFoods(foods)
        ],
      ),
    );
  }

  Widget _buildListFoods(List<Drink> foods) {
    return ListView.builder(
      itemCount: foods.length,
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemBuilder: (context, index) {
        final item = foods[index];
        final isLastIndex = index == foods.length - 1;
        return _buildItemFood(item, context, isLastIndex);
      }
    );
  }

  Widget _buildItemFood(Drink item, BuildContext context, bool isLastIndex) {
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
                      widget.restaurant.description,
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

  Widget _buildContentRestaurant(BuildContext context) {
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
                  widget.restaurant.name,
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
                    widget.restaurant.rating.toString(),
                    style: Theme.of(context).textTheme.titleLarge,
                  )
                ],
              )
            ],
          ),
          Text(
            widget.restaurant.city,
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
              color: Theme.of(context).colorScheme.outline,
            ),
            textAlign: TextAlign.start,
          ),
          const SizedBox(height: 12,),
          Text(
            widget.restaurant.description,
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

  Widget _buildHeader(double heightImageRestaurant, Color dominantColor, BuildContext context) {
    return Stack(
      children: [
        Hero(
            tag: widget.restaurant.pictureId,
            child: Image.network(
              widget.restaurant.pictureId,
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
              InkWell(
                child: SvgPicture.asset(
                  Assets.assetsIcSearch,
                  colorFilter: ColorFilter.mode(
                      Theme.of(context).colorScheme.background,
                      BlendMode.srcIn
                  ),
                ),
                onTap: () {
                  Navigator.pushNamed(context, SearchRestaurantScreen.routeName);
                },
              )
            ],
          )
        )
      ],
    );
  }

  Future<PaletteGenerator?> _getColorPalette() async {
    final imageRestaurant = Image.network(widget.restaurant.pictureId);
    paletteGenerator = await PaletteGenerator.fromImageProvider(
      imageRestaurant.image,
      size: Size(imageRestaurant.width ?? 100, imageRestaurant.height ?? 100)
    );
    return paletteGenerator;
  }
}
