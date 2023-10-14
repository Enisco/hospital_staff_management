import 'dart:convert';

InsightsFeedModel insightsFeedModelFromJson(String str) =>
    InsightsFeedModel.fromJson(json.decode(str));

String insightsFeedModelToJson(InsightsFeedModel data) =>
    json.encode(data.toJson());

class InsightsFeedModel {
  InsightsFeedModel({
    required this.fullName,
    required this.thumbsUp,
    required this.feedCoverPictureLink,
    required this.feedName,
    required this.feedDescription,
    required this.userProfilePicsLink,
    required this.dateCreated,
  });

  String fullName;
  int thumbsUp;
  List<String> feedCoverPictureLink;
  String feedName;
  String feedDescription;
  String userProfilePicsLink;
  String dateCreated;

  InsightsFeedModel copyWith({
    String? fullName,
    int? thumbsUp,
    List<String>? feedCoverPictureLink,
    String? feedName,
    String? feedDescription,
    String? userProfilePicsLink,
    String? dateCreated,
  }) =>
      InsightsFeedModel(
        fullName: fullName ?? this.fullName,
        thumbsUp: thumbsUp ?? this.thumbsUp,
        feedCoverPictureLink: feedCoverPictureLink ?? this.feedCoverPictureLink,
        feedName: feedName ?? this.feedName,
        feedDescription: feedDescription ?? this.feedDescription,
        userProfilePicsLink: userProfilePicsLink ?? this.userProfilePicsLink,
        dateCreated: dateCreated ?? this.dateCreated,
      );

  factory InsightsFeedModel.fromJson(Map<String, dynamic> json) =>
      InsightsFeedModel(
        fullName: json["full_name"],
        thumbsUp: json["thumbsUp"],
        feedCoverPictureLink:
            List<String>.from(json["feedCoverPictureLink"].map((x) => x)),
        feedName: json["feedName"],
        feedDescription: json["feedDescription"],
        userProfilePicsLink: json["userProfilePicsLink"],
        dateCreated: json["dateCreated"],
      );

  Map<String, dynamic> toJson() => {
        "full_name": fullName,
        "thumbsUp": thumbsUp,
        "feedCoverPictureLink":
            List<dynamic>.from(feedCoverPictureLink.map((x) => x)),
        "feedName": feedName,
        "feedDescription": feedDescription,
        "userProfilePicsLink": userProfilePicsLink,
        "dateCreated": dateCreated,
      };
}
