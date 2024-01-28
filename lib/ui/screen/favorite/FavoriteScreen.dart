import 'package:dish_dash/data/repository/FavoriteRepository.dart';
import 'package:dish_dash/di/AppModule.dart';
import 'package:dish_dash/generated/assets.dart';
import 'package:dish_dash/model/Restaurant.dart';
import 'package:dish_dash/model/ResultState.dart';
import 'package:dish_dash/ui/component/NegativeState.dart';
import 'package:dish_dash/ui/component/Toolbar.dart';
import 'package:dish_dash/ui/screen/favorite/FavoriteViewModel.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../component/ItemRestaurant.dart';
import '../../component/SearchBox.dart';
import '../detail/DetailRestaurantScreen.dart';

class FavoriteScreen extends StatefulWidget {
  static const routeName = "favorite";

  const FavoriteScreen({super.key});

  @override
  State<FavoriteScreen> createState() => _FavoriteScreenState();
}

class _FavoriteScreenState extends State<FavoriteScreen> {
  late FavoriteViewModel _viewModel;

  @override
  void initState() {
    _viewModel = FavoriteViewModel(locator<FavoriteRepositoryImpl>());
    super.initState();
  }

  String _searchedText = "";
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Theme.of(context).colorScheme.background,
        body: ChangeNotifierProvider(
          create: (_) => _viewModel,
          child: Column(
            children: [
              const Toolbar(title: "Favorite"),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: SearchBox(
                  text: _searchedText,
                  autoFocus: true,
                  hint: "Search your favorite restaurant",
                  onTextChange: (newText) {
                    _searchedText = newText;
                    _viewModel.getFavoriteRestaurants(_searchedText);
                  },
                ),
              ),
              Consumer<FavoriteViewModel>(
                builder: (context, vm, _) {
                  switch (vm.result.status) {
                    case Status.success:
                      return Expanded(
                        child: Padding(
                          padding: const EdgeInsets.all(12),
                          child: ListView.builder(
                              itemCount: vm.result.data!.length,
                              shrinkWrap: true,
                              itemBuilder: (context, index) {
                                final item = vm.result.data![index];
                                final isLastIndex = index == vm.result.data!.length - 1;
                                return ItemRestaurant(
                                    restaurant: item,
                                    isLastIndex: isLastIndex,
                                    onItemClick: () {
                                      Navigator.pushNamed(
                                          context,
                                          DetailRestaurantScreen.routeName,
                                          arguments: item.toDetailRestaurant()
                                      ).then((_) => setState(() { _viewModel.getFavoriteRestaurants(""); }));
                                    }
                                );
                              }
                          ),
                        )
                      );
                    case Status.empty:
                      return Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: NegativeState(
                          image: Assets.assetsEmptySearch,
                          description: "Cafe Not Found",
                          onClick: () async {
                            _viewModel.getFavoriteRestaurants("");
                          },
                          button: const Text("Try Again"),
                        ),
                      );
                    default:
                      return Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: NegativeState(
                          image: Assets.assetsEmptySearch,
                          description: "Feeling hungry? 🍽️ Your list of favorite restaurants is like an empty plate right now. Let's fill it up!",
                          onClick: () async {
                            _viewModel.getFavoriteRestaurants("");
                          },
                          button: null,
                        ),
                      );
                  }
                },
              )
            ],
          ),
        ),
      )
    );
  }

}
