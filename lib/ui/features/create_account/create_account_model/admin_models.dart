import 'dart:convert';

AdminAccountModel adminAccountModelFromJson(String str) => AdminAccountModel.fromJson(json.decode(str));

String adminAccountModelToJson(AdminAccountModel data) => json.encode(data.toJson());

class AdminAccountModel {
    final String? username;
    final String? password;

    AdminAccountModel({
        this.username,
        this.password,
    });

    AdminAccountModel copyWith({
        String? username,
        String? password,
    }) => 
        AdminAccountModel(
            username: username ?? this.username,
            password: password ?? this.password,
        );

    factory AdminAccountModel.fromJson(Map<String, dynamic> json) => AdminAccountModel(
        username: json["username"],
        password: json["password"],
    );

    Map<String, dynamic> toJson() => {
        "username": username,
        "password": password,
    };
}
