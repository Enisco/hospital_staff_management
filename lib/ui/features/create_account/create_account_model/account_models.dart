import 'dart:convert';

StaffAccountModel staffAccountModelFromJson(String str) => StaffAccountModel.fromJson(json.decode(str));

String staffAccountModelToJson(StaffAccountModel data) => json.encode(data.toJson());

class StaffAccountModel {
    final String? username;
    final String? password;
    final String? fullName;
    final String? department;
    final String? offPeriod;
    final String? currentShift;

    StaffAccountModel({
        this.username,
        this.password,
        this.fullName,
        this.department,
        this.offPeriod,
        this.currentShift,
    });

    StaffAccountModel copyWith({
        String? username,
        String? password,
        String? fullName,
        String? department,
        String? offPeriod,
        String? currentShift,
    }) => 
        StaffAccountModel(
            username: username ?? this.username,
            password: password ?? this.password,
            fullName: fullName ?? this.fullName,
            department: department ?? this.department,
            offPeriod: offPeriod ?? this.offPeriod,
            currentShift: currentShift ?? this.currentShift,
        );

    factory StaffAccountModel.fromJson(Map<String, dynamic> json) => StaffAccountModel(
        username: json["username"],
        password: json["password"],
        fullName: json["full_name"],
        department: json["department"],
        offPeriod: json["off_period"],
        currentShift: json["current_shift"],
    );

    Map<String, dynamic> toJson() => {
        "username": username,
        "password": password,
        "full_name": fullName,
        "department": department,
        "off_period": offPeriod,
        "current_shift": currentShift,
    };
}

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
