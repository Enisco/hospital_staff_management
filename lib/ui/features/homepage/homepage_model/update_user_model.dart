import 'dart:convert';

UpdateDeviceTokenModel updateDeviceTokenModelFromJson(String str) =>
    UpdateDeviceTokenModel.fromJson(json.decode(str));

String updateDeviceTokenModelToJson(UpdateDeviceTokenModel data) =>
    json.encode(data.toJson());

class UpdateDeviceTokenModel {
  final String? deviceToken;

  UpdateDeviceTokenModel({
    this.deviceToken,
  });

  UpdateDeviceTokenModel copyWith({
    String? deviceToken,
  }) =>
      UpdateDeviceTokenModel(
        deviceToken: deviceToken ?? this.deviceToken,
      );

  factory UpdateDeviceTokenModel.fromJson(Map<String, dynamic> json) =>
      UpdateDeviceTokenModel(
        deviceToken: json["device_token"],
      );

  Map<String, dynamic> toJson() => {
        "device_token": deviceToken,
      };
}
