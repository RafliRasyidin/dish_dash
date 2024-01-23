import 'package:dish_dash/data/remote/api/ApiService.dart';
import 'package:dish_dash/data/repository/FavoriteRepository.dart';
import 'package:dish_dash/model/AssetsFood.dart';
import 'package:dish_dash/model/DetailRestaurant.dart';
import 'package:dish_dash/model/Restaurant.dart';
import 'package:dish_dash/ui/screen/detail/DetailState.dart';
import 'package:dish_dash/ui/screen/detail/DetailViewModel.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:palette_generator/palette_generator.dart';
import 'package:provider/provider.dart';

import '../../../data/repository/RestaurantRepository.dart';
import '../../../di/Locator.dart';
import '../../../generated/assets.dart';
import '../../component/NegativeState.dart';

//ignore: must_be_immutable
class DetailRestaurantScreen extends StatefulWidget {
  static const routeName = "detail_restaurant";
  DetailRestaurant restaurant;

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
  final _nameController = TextEditingController();
  final _reviewController = TextEditingController();

  @override
  void initState() {
    _viewModel = DetailViewModel(
      locator<RestaurantRepositoryImpl>(),
      locator<FavoriteRepositoryImpl>()
    );
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
              return Container(
                color: Theme.of(context).colorScheme.background,
                child: const Center(child: CircularProgressIndicator())
              );
            case Status.hasData:
              widget.restaurant = vm.resultState.data!;
              return _buildContent(widget.restaurant);
            case Status.noConnection:
              if (vm.isPostReview) {
                Fluttertoast.showToast(
                    msg: "No Internet Connection",
                    toastLength: Toast.LENGTH_SHORT,
                    gravity: ToastGravity.BOTTOM,
                    timeInSecForIosWeb: 1,
                    backgroundColor: Theme.of(context).colorScheme.errorContainer,
                    textColor: Theme.of(context).colorScheme.onErrorContainer,
                    fontSize: 16.0
                );
                vm.setStatePostReview(false);
                return _buildContent(widget.restaurant);
              } else {
                vm.setStatePostReview(false);
                return NegativeState(
                    image: Assets.assetsImgNoInternet,
                    description: "No Internet Connection",
                    onClick: () { _viewModel.getDetailRestaurant(widget.restaurant.id); },
                    button: const Text("Try Again")
                );
              }
            case Status.empty:
              return NegativeState(
                  image: Assets.assetsImgNoInternet,
                  description: "Data Not Found",
                  onClick: () { _viewModel.getDetailRestaurant(widget.restaurant.id); },
                  button: const Text("Try Again")
              );
            case Status.failure:
              if (vm.isPostReview) {
                Fluttertoast.showToast(
                    msg: vm.resultState.message!,
                    toastLength: Toast.LENGTH_SHORT,
                    gravity: ToastGravity.BOTTOM,
                    timeInSecForIosWeb: 1,
                    backgroundColor: Theme.of(context).colorScheme.errorContainer,
                    textColor: Theme.of(context).colorScheme.onErrorContainer,
                    fontSize: 16.0
                );
                vm.setStatePostReview(false);
                return _buildContent(widget.restaurant);
              } else {
                vm.setStatePostReview(false);
                return NegativeState(
                    image: Assets.assetsImgNoInternet,
                    description: vm.resultState.message!,
                    onClick: () { _viewModel.getDetailRestaurant(widget.restaurant.id); },
                    button: const Text("Try Again")
                );
              }
            case Status.success:
              if (vm.isPostReview) {
                Fluttertoast.showToast(
                    msg: "Success post review!",
                    toastLength: Toast.LENGTH_SHORT,
                    gravity: ToastGravity.BOTTOM,
                    timeInSecForIosWeb: 1,
                    backgroundColor: Theme.of(context).colorScheme.primaryContainer,
                    textColor: Theme.of(context).colorScheme.onPrimaryContainer,
                    fontSize: 16.0
                );
              }
              vm.setStatePostReview(false);
              return _buildContent(widget.restaurant);
            default: return Container();
          }
        },
      ),
    );
  }

  Widget _buildContent(DetailRestaurant restaurant) {
    final heightImageRestaurant = MediaQuery.of(context).size.height * 0.3;
    final foods = restaurant.menus.foods;
    final drinks = restaurant.menus.drinks;
    return FutureBuilder(
      future: _getColorPalette(restaurant),
      builder: (context, snapshot) {
        final dominantColor = snapshot.data?.dominantColor?.color ?? Theme.of(context).colorScheme.background;
        return Scaffold(
          backgroundColor: Theme.of(context).colorScheme.background,
          body: Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
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
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
                width: double.maxFinite,
                child: Row(
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Theme.of(context).colorScheme.primary
                        ),
                        onPressed: () {
                          showModalBottomSheet<void>(
                            context: context,
                            isScrollControlled: true,
                            builder: (BuildContext context) {
                              return _buildBottomSheetReview(restaurant);
                          });
                        },
                        child: const Text("Add Review")
                      ),
                    ),
                    const SizedBox(width: 8),
                    InkWell(
                      child: Container(
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Theme.of(context).colorScheme.primary
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(8),
                          child: Icon(
                            restaurant.isFavorite ? Icons.favorite : Icons.favorite_border,
                            size: 24,
                            color: Theme.of(context).colorScheme.onPrimary,
                          ),
                        ),
                      ),
                      onTap: () {
                        _viewModel.setFavorite(restaurant);
                      },
                    ),
                  ],
                ),
              )
            ],
          ),
        );
      },
    );
  }

  Widget _buildBottomSheetReview(DetailRestaurant restaurant) {
    return Padding(
      padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
      child: SizedBox(
        width: double.maxFinite,
        height: MediaQuery.of(context).size.height * 0.5,
        child: Column(
          children: [
            Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 24, left: 12, right: 12),
                      child: Text(
                        "Review ${restaurant.name}",
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Divider(
                      height: 1,
                      thickness: 2,
                      color: Theme.of(context).colorScheme.onBackground,
                    ),
                    const SizedBox(height: 16),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      child: TextField(
                        controller: _nameController,
                        style: Theme.of(context).textTheme.bodyMedium,
                        decoration: const InputDecoration(
                            hintText: "Write your name here...",
                            label: Text("Your Name")
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      child: TextField(
                        controller: _reviewController,
                        style: Theme.of(context).textTheme.bodyMedium,
                        decoration: const InputDecoration(
                            hintText: "Write your review here...",
                            label: Text("Review")
                        ),
                      ),
                    )
                  ],
                )
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
              width: double.maxFinite,
              child: ElevatedButton(
                  onPressed: () {
                    final name = _nameController.text;
                    final review = _reviewController.text;
                    if (name.isEmpty || review.isEmpty) {
                      Fluttertoast.showToast(
                          msg: "Name or review can't be empty!",
                          toastLength: Toast.LENGTH_SHORT,
                          gravity: ToastGravity.BOTTOM,
                          timeInSecForIosWeb: 1,
                          backgroundColor: Theme.of(context).colorScheme.errorContainer,
                          textColor: Theme.of(context).colorScheme.onErrorContainer,
                          fontSize: 16.0
                      );
                    } else {
                      _viewModel.postReview(
                          restaurant.id,
                          _nameController.text,
                          _reviewController.text
                      );
                      _viewModel.setStatePostReview(true);
                      _nameController.clear();
                      _reviewController.clear();
                      Navigator.pop(context);
                    }
                  },
                  child: const Text("Send")
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildContentFoods(
    BuildContext context,
    List<Category> foods,
    String title,
    DetailRestaurant restaurant
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

  Widget _buildListFoods(List<Category> foods, DetailRestaurant restaurant) {
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
      DetailRestaurant restaurant
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

  Widget _buildContentRestaurant(BuildContext context, DetailRestaurant restaurant) {
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
      DetailRestaurant restaurant
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

  Future<PaletteGenerator?> _getColorPalette(DetailRestaurant restaurant) async {
    final imageRestaurant = Image.network("$urlImageMedium/${restaurant.pictureId}");
    paletteGenerator = await PaletteGenerator.fromImageProvider(
      imageRestaurant.image,
      size: Size(imageRestaurant.width ?? 100, imageRestaurant.height ?? 100)
    );
    return paletteGenerator;
  }
}
