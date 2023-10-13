import 'dart:convert';

InsightsFeedModel insightsFeedModelFromJson(String str) =>
    InsightsFeedModel.fromJson(json.decode(str));

String insightsFeedModelToJson(InsightsFeedModel data) =>
    json.encode(data.toJson());

class InsightsFeedModel {
  InsightsFeedModel({
    required this.username,
    required this.thumbsUp,
    required this.feedCoverPictureLink,
    required this.feedName,
    required this.feedDescription,
    required this.userProfilePicsLink,
    required this.dateCreated,
  });

  String username;
  int thumbsUp;
  List<String> feedCoverPictureLink;
  String feedName;
  String feedDescription;
  String userProfilePicsLink;
  String dateCreated;

  InsightsFeedModel copyWith({
    String? username,
    int? thumbsUp,
    List<String>? feedCoverPictureLink,
    String? feedName,
    String? feedDescription,
    String? userProfilePicsLink,
    String? dateCreated,
  }) =>
      InsightsFeedModel(
        username: username ?? this.username,
        thumbsUp: thumbsUp ?? this.thumbsUp,
        feedCoverPictureLink: feedCoverPictureLink ?? this.feedCoverPictureLink,
        feedName: feedName ?? this.feedName,
        feedDescription: feedDescription ?? this.feedDescription,
        userProfilePicsLink: userProfilePicsLink ?? this.userProfilePicsLink,
        dateCreated: dateCreated ?? this.dateCreated,
      );

  factory InsightsFeedModel.fromJson(Map<String, dynamic> json) =>
      InsightsFeedModel(
        username: json["username"],
        thumbsUp: json["thumbsUp"],
        feedCoverPictureLink:
            List<String>.from(json["feedCoverPictureLink"].map((x) => x)),
        feedName: json["feedName"],
        feedDescription: json["feedDescription"],
        userProfilePicsLink: json["userProfilePicsLink"],
        dateCreated: json["dateCreated"],
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
      };
}
