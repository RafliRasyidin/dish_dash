import 'package:dish_dash/data/remote/response/ListRestaurantResponse.dart';
import 'package:dish_dash/model/Restaurant.dart';

final dummyRestaurants = [
  RestaurantItemResponse(
      id: 'fnfn8mytkpmkfw1e867',
      name: 'Makan Mudah',
      description: "Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it",
      pictureId: '22',
      city: 'Medan',
      rating: 3.7,
  ),
  RestaurantItemResponse(
    id: 'rqdv5juczeskfw1e867',
    name: 'Melting Pot',
    description: "Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it",
    pictureId: '14',
    city: 'Medan',
    rating: 4.2,
  ),
  RestaurantItemResponse(
      id: 's1knt6za9kkfw1e867',
      name: 'Kafe Kita',
      description: "Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it",
      pictureId: '25',
      city: 'Gorontalo',
      rating: 4,
  ),
  RestaurantItemResponse(
      id: 'w9pga3s2tubkfw1e867',
      name: 'Bring Your Phone Cafe',
      description: "Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it",
      pictureId: '03',
      city: 'Surabaya',
      rating: 4.2,
  ),
  RestaurantItemResponse(
      id: 'uewq1zg2zlskfw1e867',
      name: 'Kafein',
      description: "Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it",
      pictureId: '15',
      city: 'Aceh',
      rating: 4.6,
  ),
];

final dummyRestaurantsResponse = ListRestaurantsResponse(
  error: false,
  message: "",
  count: 5,
  restaurants: dummyRestaurants,
);

final dummySearchRestaurantsEmptyResponse = ListRestaurantsResponse(
  error: false,
  message: "",
  count: 5,
  restaurants: []
);

final dummySearchRestaurantsResponse = ListRestaurantsResponse(
    error: false,
    message: "",
    count: 5,
    restaurants: [
      RestaurantItemResponse(
        id: 'w9pga3s2tubkfw1e867',
        name: 'Bring Your Phone Cafe',
        description: "Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it",
        pictureId: '03',
        city: 'Surabaya',
        rating: 4.2,
      ),
    ]
);
