import 'dart:convert';

StaffAccountModel staffAccountModelFromJson(String str) =>
    StaffAccountModel.fromJson(json.decode(str));

String staffAccountModelToJson(StaffAccountModel data) =>
    json.encode(data.toJson());

class StaffAccountModel {
  String? username;
  String? password;
  String? fullName;
  String? gender;
  String? yearOfBirth;
  String? phone;
  String? email;
  String? image;
  String? department;
  String? deviceToken;
  OffPeriod? offPeriod;
  CurrentShift? currentShift;

  StaffAccountModel({
    this.username,
    this.password,
    this.fullName,
    this.gender,
    this.yearOfBirth,
    this.phone,
    this.email,
    this.image,
    this.department,
    this.deviceToken,
    this.offPeriod,
    this.currentShift,
  });

  StaffAccountModel copyWith({
    String? username,
    String? password,
    String? fullName,
    String? gender,
    String? yearOfBirth,
    String? phone,
    String? email,
    String? image,
    String? department,
    String? deviceToken,
    OffPeriod? offPeriod,
    CurrentShift? currentShift,
  }) =>
      StaffAccountModel(
        username: username ?? this.username,
        password: password ?? this.password,
        fullName: fullName ?? this.fullName,
        gender: gender ?? this.gender,
        yearOfBirth: yearOfBirth ?? this.yearOfBirth,
        phone: phone ?? this.phone,
        email: email ?? this.email,
        image: image ?? this.image,
        department: department ?? this.department,
        deviceToken: deviceToken ?? this.deviceToken,
        offPeriod: offPeriod ?? this.offPeriod,
        currentShift: currentShift ?? this.currentShift,
      );

  factory StaffAccountModel.fromJson(Map<String, dynamic> json) =>
      StaffAccountModel(
        username: json["username"],
        password: json["password"],
        fullName: json["full_name"],
        gender: json["gender"],
        yearOfBirth: json["year_of_birth"],
        phone: json["phone"],
        email: json["email"],
        image: json["image"],
        department: json["department"],
        deviceToken: json["device_token"],
        offPeriod: json["off_period"] == null
            ? null
            : OffPeriod.fromJson(json["off_period"]),
        currentShift: json["current_shift"] == null
            ? null
            : CurrentShift.fromJson(json["current_shift"]),
      );

  Map<String, dynamic> toJson() => {
        "username": username,
        "password": password,
        "full_name": fullName,
        "gender": gender,
        "year_of_birth": yearOfBirth,
        "phone": phone,
        "email": email,
        "image": image,
        "department": department,
        "device_token": deviceToken,
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
        "start": start?.toIso8601String(),
        "end": end?.toIso8601String(),
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
        "start": start?.toIso8601String(),
        "end": end?.toIso8601String(),
      };
}
