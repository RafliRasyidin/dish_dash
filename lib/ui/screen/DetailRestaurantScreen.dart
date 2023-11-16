import 'package:dish_dash/data/Restaurant.dart';
import 'package:dish_dash/generated/assets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

//ignore: must_be_immutable
class DetailRestaurantScreen extends StatelessWidget {
  static const routeName = "detail_restaurant";
  Restaurant restaurant;

  DetailRestaurantScreen({
    super.key,
    required this.restaurant
  });

  @override
  Widget build(BuildContext context) {
    final heightImageRestaurant = MediaQuery.of(context).size.height * 0.3;
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      body: SingleChildScrollView(
        child: Column(
          children: [
            Stack(
              children: [
                Hero(
                  tag: restaurant.pictureId,
                  child: Image.network(
                    restaurant.pictureId,
                    width: double.infinity,
                    height: heightImageRestaurant,
                    fit: BoxFit.cover,
                  )
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
                          
                        },
                      )
                    ],
                  )
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}
