// To parse this JSON data, do
//
//     final recordToponymModel = recordToponymModelFromJson(jsonString);

// ignore_for_file: override_on_non_overriding_member

import 'dart:convert';

RecordToponymModel recordToponymModelFromJson(String str) =>
    RecordToponymModel.fromJson(json.decode(str));

String recordToponymModelToJson(RecordToponymModel data) =>
    json.encode(data.toJson());

class RecordToponymModel {
  RecordToponymModel({
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

  RecordToponymModel copyWith({
    String? username,
    int? thumbsUp,
    List<String>? feedCoverPictureLink,
    String? feedName,
    String? feedDescription,
    String? userProfilePicsLink,
    String? dateCreated,
    String? toponymType,
  }) =>
      RecordToponymModel(
        username: username ?? this.username,
        thumbsUp: thumbsUp ?? this.thumbsUp,
        feedCoverPictureLink: feedCoverPictureLink ?? this.feedCoverPictureLink,
        feedName: feedName ?? this.feedName,
        feedDescription: feedDescription ?? this.feedDescription,
        userProfilePicsLink: userProfilePicsLink ?? this.userProfilePicsLink,
        dateCreated: dateCreated ?? this.dateCreated,
        toponymType: toponymType ?? this.toponymType,
      );

  factory RecordToponymModel.fromJson(Map<String, dynamic> json) =>
      RecordToponymModel(
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
