import 'package:dish_dash/model/Restaurant.dart';
import 'package:flutter/material.dart';

import '../../data/remote/api/ApiService.dart';

class ItemRestaurant extends StatelessWidget {
  final Restaurant restaurant;
  final VoidCallback onItemClick;
  final bool isLastIndex;

  const ItemRestaurant({
    super.key,
    required this.restaurant,
    required this.isLastIndex,
    required this.onItemClick
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onItemClick,
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Hero(
                tag: restaurant.pictureId,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Image.network(
                    "$urlImageSmall${restaurant.pictureId}",
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
                        restaurant.name,
                        style: Theme.of(context).textTheme.labelMedium?.copyWith(
                            color: Theme.of(context).colorScheme.onBackground
                        ),
                      ),
                      Text(
                        restaurant.city,
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
                            restaurant.rating.toString(),
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
    );;
  }
}
