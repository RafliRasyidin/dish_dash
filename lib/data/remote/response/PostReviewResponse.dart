// To parse this JSON data, do
//
//     final postReviewResponse = postReviewResponseFromJson(jsonString);

import 'dart:convert';

import 'package:dish_dash/data/remote/response/DetailRestaurantResponse.dart';

PostReviewResponse postReviewResponseFromJson(String str) => PostReviewResponse.fromJson(json.decode(str));

class PostReviewResponse {
  bool? error;
  String? message;
  List<CustomerReviewsResponse>? customerReviews;

  PostReviewResponse({
    this.error,
    this.message,
    this.customerReviews,
  });

  PostReviewResponse copyWith({
    bool? error,
    String? message,
    List<CustomerReviewsResponse>? customerReviews,
  }) =>
      PostReviewResponse(
        error: error ?? this.error,
        message: message ?? this.message,
        customerReviews: customerReviews ?? this.customerReviews,
      );

  factory PostReviewResponse.fromJson(Map<String, dynamic> json) => PostReviewResponse(
    error: json["error"],
    message: json["message"],
    customerReviews: json["customerReviews"] == null ? [] : List<CustomerReviewsResponse>.from(json["customerReviews"]!.map((x) => CustomerReviewsResponse.fromJson(x))),
  );
}
