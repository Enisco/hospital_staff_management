// To parse this JSON data, do
//
//     final UserAccountModel = UserAccountModelFromJson(jsonString);

// ignore_for_file: must_be_immutable

import 'dart:convert';

import 'package:equatable/equatable.dart';

UserAccountModel userAccountModelFromJson(String str) =>
    UserAccountModel.fromJson(json.decode(str));

String userAccountModelToJson(UserAccountModel data) =>
    json.encode(data.toJson());

class UserAccountModel extends Equatable {
  UserAccountModel({
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

  UserAccountModel copyWith({
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
      UserAccountModel(
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

  factory UserAccountModel.fromJson(Map<String, dynamic> json) =>
      UserAccountModel(
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


AdminLoginModel adminLoginModelFromJson(String str) => AdminLoginModel.fromJson(json.decode(str));

String adminLoginModelToJson(AdminLoginModel data) => json.encode(data.toJson());

class AdminLoginModel {
    final String? username;
    final String? password;

    AdminLoginModel({
        this.username,
        this.password,
    });

    AdminLoginModel copyWith({
        String? username,
        String? password,
    }) => 
        AdminLoginModel(
            username: username ?? this.username,
            password: password ?? this.password,
        );

    factory AdminLoginModel.fromJson(Map<String, dynamic> json) => AdminLoginModel(
        username: json["username"],
        password: json["password"],
    );

    Map<String, dynamic> toJson() => {
        "username": username,
        "password": password,
    };
}
