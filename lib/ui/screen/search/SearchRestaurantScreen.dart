import 'package:dish_dash/data/remote/api/ApiService.dart';
import 'package:dish_dash/generated/assets.dart';
import 'package:dish_dash/ui/component/NegativeState.dart';
import 'package:dish_dash/ui/screen/detail/DetailRestaurantScreen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../model/Restaurant.dart';
import '../../../model/ResultState.dart';
import '../../component/SearchBox.dart';
import 'SearchViewModel.dart';

//ignore: must_be_immutable
class SearchRestaurantScreen extends StatefulWidget {
  static const routeName = "search_restaurant";

  const SearchRestaurantScreen({
    super.key,
  });

  @override
  State<SearchRestaurantScreen> createState() => _SearchRestaurantScreenState();
}

class _SearchRestaurantScreenState extends State<SearchRestaurantScreen> {
  String _searchedText = "";
  late List<Restaurant> restaurants = [];
  late SearchViewModel viewModel;

  @override
  void initState() {
    viewModel = SearchViewModel();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
          backgroundColor: Theme.of(context).colorScheme.background,
          body: ChangeNotifierProvider(
            create: (_) => viewModel,
            child: Column(
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
                            _searchedText = newText;
                            viewModel.searchRestaurant(newText);
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
          ),
        )
    );
  }

  Widget _buildEmptyState() {
    return NegativeState(
        image: Assets.assetsEmptySearch,
        description: "Cafe Not Found",
        onClick: () { viewModel.searchRestaurant(_searchedText); },
        button: const Text("Try Again")
    );
  }

  Widget _buildListRestaurant() {
    return Consumer<SearchViewModel>(
      builder: (context, vm, _) {
        switch (vm.result.status) {
          case Status.idle:
            return NegativeState(
              image: Assets.assetsEmptySearch,
              description: "Search Fancy Restaurant",
              onClick: () { viewModel.searchRestaurant(_searchedText); },
            );
          case Status.loading:
            return const Center(child: CircularProgressIndicator());
          case Status.success:
            return Expanded(
              child: ListView.builder(
                itemCount: vm.result.data!.length,
                shrinkWrap: true,
                itemBuilder: (context, index) {
                  final item = vm.result.data![index];
                  final isLastIndex = index == vm.result.data!.length - 1;
                  return _buildItemRestaurant(item, context, isLastIndex);
                }
            ),
          );
          case Status.empty:
            return _buildEmptyState();
          case Status.failure:
            return NegativeState(
              image: Assets.assetsImgNoInternet,
              description: vm.result.message!,
              onClick: () { viewModel.searchRestaurant(_searchedText); },
              button: const Text("Try Again")
            );
          case Status.noConnection:
            return NegativeState(
                image: Assets.assetsImgNoInternet,
                description: "No Internet Connection",
                onClick: () { viewModel.searchRestaurant(_searchedText); },
                button: const Text("Try Again")
            );
          default: return Container();
        }
      },
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
                    "$urlImageSmall${item.pictureId}",
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
