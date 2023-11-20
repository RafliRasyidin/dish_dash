import 'dart:math';

import 'package:dish_dash/generated/assets.dart';

class AssetsFood {
  AssetsFood._();

  static List<String> imagesFood = [
    Assets.assetsImgFood1,
    Assets.assetsImgFood2,
    Assets.assetsImgFood3,
    Assets.assetsImgFood4,
    Assets.assetsImgFood5
  ];

  static String getRandomAssetFood() {
    int randomIndex = Random().nextInt(imagesFood.length);
    return imagesFood[randomIndex];
  }
}