
import 'dart:convert';

StaffAccountModel staffAccountModelFromJson(String str) => StaffAccountModel.fromJson(json.decode(str));

String staffAccountModelToJson(StaffAccountModel data) => json.encode(data.toJson());

class StaffAccountModel {
    String? username;
    String? password;
    String? fullName;
    String? gender;
    String? yearOfBirth;
    String? image;
    String? department;
    OffPeriod? offPeriod;
    CurrentShift? currentShift;

    StaffAccountModel({
        this.username,
        this.password,
        this.fullName,
        this.gender,
        this.yearOfBirth,
        this.image,
        this.department,
        this.offPeriod,
        this.currentShift,
    });

    StaffAccountModel copyWith({
        String? username,
        String? password,
        String? fullName,
        String? gender,
        String? yearOfBirth,
        String? image,
        String? department,
        OffPeriod? offPeriod,
        CurrentShift? currentShift,
    }) => 
        StaffAccountModel(
            username: username ?? this.username,
            password: password ?? this.password,
            fullName: fullName ?? this.fullName,
            gender: gender ?? this.gender,
            yearOfBirth: yearOfBirth ?? this.yearOfBirth,
            image: image ?? this.image,
            department: department ?? this.department,
            offPeriod: offPeriod ?? this.offPeriod,
            currentShift: currentShift ?? this.currentShift,
        );

    factory StaffAccountModel.fromJson(Map<String, dynamic> json) => StaffAccountModel(
        username: json["username"],
        password: json["password"],
        fullName: json["full_name"],
        gender: json["gender"],
        yearOfBirth: json["year_of_birth"],
        image: json["image"],
        department: json["department"],
        offPeriod: json["off_period"] == null ? null : OffPeriod.fromJson(json["off_period"]),
        currentShift: json["current_shift"] == null ? null : CurrentShift.fromJson(json["current_shift"]),
    );

    Map<String, dynamic> toJson() => {
        "username": username,
        "password": password,
        "full_name": fullName,
        "gender": gender,
        "year_of_birth": yearOfBirth,
        "image": image,
        "department": department,
        "off_period": offPeriod?.toJson(),
        "current_shift": currentShift?.toJson(),
    };
}

class CurrentShift {
    DateTime? start;
    DateTime? end;
    String? shift;

    CurrentShift({
        this.start,
        this.end,
        this.shift,
    });

    CurrentShift copyWith({
        DateTime? start,
        DateTime? end,
        String? shift,
    }) => 
        CurrentShift(
            start: start ?? this.start,
            end: end ?? this.end,
            shift: shift ?? this.shift,
        );

    factory CurrentShift.fromJson(Map<String, dynamic> json) => CurrentShift(
        start: json["start"] == null ? null : DateTime.parse(json["start"]),
        end: json["end"] == null ? null : DateTime.parse(json["end"]),
        shift: json["shift"],
    );

    Map<String, dynamic> toJson() => {
        "start": "${start!.year.toString().padLeft(4, '0')}-${start!.month.toString().padLeft(2, '0')}-${start!.day.toString().padLeft(2, '0')}",
        "end": "${end!.year.toString().padLeft(4, '0')}-${end!.month.toString().padLeft(2, '0')}-${end!.day.toString().padLeft(2, '0')}",
        "shift": shift,
    };
}

class OffPeriod {
    DateTime? start;
    DateTime? end;

    OffPeriod({
        this.start,
        this.end,
    });

    OffPeriod copyWith({
        DateTime? start,
        DateTime? end,
    }) => 
        OffPeriod(
            start: start ?? this.start,
            end: end ?? this.end,
        );

    factory OffPeriod.fromJson(Map<String, dynamic> json) => OffPeriod(
        start: json["start"] == null ? null : DateTime.parse(json["start"]),
        end: json["end"] == null ? null : DateTime.parse(json["end"]),
    );

    Map<String, dynamic> toJson() => {
        "start": "${start!.year.toString().padLeft(4, '0')}-${start!.month.toString().padLeft(2, '0')}-${start!.day.toString().padLeft(2, '0')}",
        "end": "${end!.year.toString().padLeft(4, '0')}-${end!.month.toString().padLeft(2, '0')}-${end!.day.toString().padLeft(2, '0')}",
    };
}
