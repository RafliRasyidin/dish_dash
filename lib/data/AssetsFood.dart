import 'dart:math';

import 'package:dish_dash/generated/assets.dart';

class AssetsFood {
  AssetsFood._();

  static List<String> imagesFood = [
    Assets.assetsFood1,
    Assets.assetsFood2,
    Assets.assetsFood3,
    Assets.assetsFood4,
    Assets.assetsFood5
  ];

  static String getRandomAssetFood() {
    int randomIndex = Random().nextInt(imagesFood.length);
    return imagesFood[randomIndex];
  }
}