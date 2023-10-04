// To parse this JSON data, do
//
//     final FeedModel = FeedModelFromJson(jsonString);

// ignore_for_file: override_on_non_overriding_member

import 'dart:convert';

FeedModel feedModelFromJson(String str) => FeedModel.fromJson(json.decode(str));

String feedModelToJson(FeedModel data) => json.encode(data.toJson());

class FeedModel {
  FeedModel({
    required this.username,
    required this.thumbsUp,
    required this.feedCoverPictureLink,
    required this.feedName,
    required this.feedDescription,
    required this.userProfilePicsLink,
    required this.dateCreated,
    required this.toponymType,
  });

  String username;
  int thumbsUp;
  List<String> feedCoverPictureLink;
  String feedName;
  String feedDescription;
  String userProfilePicsLink;
  String dateCreated;
  String toponymType;

  FeedModel copyWith({
    String? username,
    int? thumbsUp,
    List<String>? feedCoverPictureLink,
    String? feedName,
    String? feedDescription,
    String? userProfilePicsLink,
    String? dateCreated,
    String? toponymType,
  }) =>
      FeedModel(
        username: username ?? this.username,
        thumbsUp: thumbsUp ?? this.thumbsUp,
        feedCoverPictureLink: feedCoverPictureLink ?? this.feedCoverPictureLink,
        feedName: feedName ?? this.feedName,
        feedDescription: feedDescription ?? this.feedDescription,
        userProfilePicsLink: userProfilePicsLink ?? this.userProfilePicsLink,
        dateCreated: dateCreated ?? this.dateCreated,
        toponymType: toponymType ?? this.toponymType,
      );

  factory FeedModel.fromJson(Map<String, dynamic> json) => FeedModel(
        username: json["username"],
        thumbsUp: json["thumbsUp"],
        feedCoverPictureLink:
            List<String>.from(json["feedCoverPictureLink"].map((x) => x)),
        feedName: json["feedName"],
        feedDescription: json["feedDescription"],
        userProfilePicsLink: json["userProfilePicsLink"],
        dateCreated: json["dateCreated"],
        toponymType: json["toponymType"],
      );

  Map<String, dynamic> toJson() => {
        "username": username,
        "thumbsUp": thumbsUp,
        "feedCoverPictureLink":
            List<dynamic>.from(feedCoverPictureLink.map((x) => x)),
        "feedName": feedName,
        "feedDescription": feedDescription,
        "userProfilePicsLink": userProfilePicsLink,
        "dateCreated": dateCreated,
        "toponymType": toponymType,
      };

  @override
  List<Object?> get props => [
        username,
        userProfilePicsLink,
        feedName,
        feedDescription,
        feedCoverPictureLink,
        thumbsUp,
        toponymType,
        dateCreated,
      ];
}
