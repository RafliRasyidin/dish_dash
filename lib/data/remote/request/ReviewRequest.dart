import 'dart:convert';

ReviewRequest reviewRequestFromJson(String str) => ReviewRequest.fromJson(json.decode(str));

String reviewRequestToJson(ReviewRequest data) => json.encode(data.toJson());

class ReviewRequest {
  String id;
  String name;
  String review;

  ReviewRequest({
    required this.id,
    required this.name,
    required this.review,
  });

  ReviewRequest copyWith({
    String? id,
    String? name,
    String? review,
  }) =>
      ReviewRequest(
        id: id ?? this.id,
        name: name ?? this.name,
        review: review ?? this.review,
      );

  factory ReviewRequest.fromJson(Map<String, dynamic> json) => ReviewRequest(
    id: json["id"],
    name: json["name"],
    review: json["review"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "review": review,
  };
}
