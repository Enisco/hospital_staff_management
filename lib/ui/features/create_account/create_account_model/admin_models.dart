import 'dart:convert';

AdminAccountModel adminAccountModelFromJson(String str) =>
    AdminAccountModel.fromJson(json.decode(str));

String adminAccountModelToJson(AdminAccountModel data) =>
    json.encode(data.toJson());

class AdminAccountModel {
  final String? username;
  final String? password;
  final String? fullName;

  AdminAccountModel({
    this.username,
    this.password,
    this.fullName,
  });

  AdminAccountModel copyWith({
    String? username,
    String? password,
    String? fullName,
  }) =>
      AdminAccountModel(
        username: username ?? this.username,
        password: password ?? this.password,
        fullName: fullName ?? this.fullName,
      );

  factory AdminAccountModel.fromJson(Map<String, dynamic> json) =>
      AdminAccountModel(
        username: json["username"],
        password: json["password"],
        fullName: json["full_name"],
      );

  Map<String, dynamic> toJson() => {
        "username": username,
        "password": password,
        "full_name": fullName,
      };
}
