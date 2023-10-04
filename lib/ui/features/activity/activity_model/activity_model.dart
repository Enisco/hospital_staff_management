// To parse this JSON data, do
//
//     final UserActivityModel = UserActivityModelFromJson(jsonString);

// ignore_for_file: must_be_immutable

import 'dart:convert';

import 'package:equatable/equatable.dart';

UserActivityModel userActivityModelFromJson(String str) =>
    UserActivityModel.fromJson(json.decode(str));

String userActivityModelToJson(UserActivityModel data) =>
    json.encode(data.toJson());

class UserActivityModel extends Equatable {
  UserActivityModel({
    this.username,
    this.password,
    this.totalPoints,
    this.totalToponymsRecorded,
    this.naturalToponymsRecorded,
    this.artificialToponymsRecorded,
    this.profileImageLink,
    this.city,
    this.country,
  });

  String? username;
  String? password;
  int? totalPoints;
  int? totalToponymsRecorded;
  int? naturalToponymsRecorded;
  int? artificialToponymsRecorded;
  String? profileImageLink;
  String? city;
  String? country;

  UserActivityModel copyWith({
    String? username,
    String? password,
    int? totalPoints,
    int? totalToponymsRecorded,
    int? naturalToponymsRecorded,
    int? artificialToponymsRecorded,
    String? profileImageLink,
    String? city,
    String? country,
  }) =>
      UserActivityModel(
        username: username ?? this.username,
        password: password ?? this.password,
        totalPoints: totalPoints ?? this.totalPoints,
        totalToponymsRecorded:
            totalToponymsRecorded ?? this.totalToponymsRecorded,
        naturalToponymsRecorded:
            naturalToponymsRecorded ?? this.naturalToponymsRecorded,
        artificialToponymsRecorded:
            artificialToponymsRecorded ?? this.artificialToponymsRecorded,
        profileImageLink: profileImageLink ?? this.profileImageLink,
        city: city ?? this.city,
        country: country ?? this.country,
      );

  factory UserActivityModel.fromJson(Map<String, dynamic> json) =>
      UserActivityModel(
        username: json["username"],
        password: json["password"],
        totalPoints: json["totalPoints"],
        totalToponymsRecorded: json["totalToponymsRecorded"],
        naturalToponymsRecorded: json["naturalToponymsRecorded"],
        artificialToponymsRecorded: json["artificialToponymsRecorded"],
        profileImageLink: json["profileImageLink"],
        city: json["city"],
        country: json["country"],
      );

  Map<String, dynamic> toJson() => {
        "username": username,
        "password": password,
        "totalPoints": totalPoints,
        "totalToponymsRecorded": totalToponymsRecorded,
        "naturalToponymsRecorded": naturalToponymsRecorded,
        "artificialToponymsRecorded": artificialToponymsRecorded,
        "profileImageLink": profileImageLink,
        "city": city,
        "country": country,
      };

  @override
  List<Object?> get props => [
        username,
        password,
        totalPoints,
        totalToponymsRecorded,
        naturalToponymsRecorded,
        artificialToponymsRecorded,
        profileImageLink,
        city,
        country,
      ];
}
