import 'dart:convert';

RequestLeaveModel requestLeaveModelFromJson(String str) => RequestLeaveModel.fromJson(json.decode(str));

String requestLeaveModelToJson(RequestLeaveModel data) => json.encode(data.toJson());

class RequestLeaveModel {
    final String? username;
    final String? fullname;
    final DateTime? leaveStart;
    final DateTime? leaveEnd;

    RequestLeaveModel({
        this.username,
        this.fullname,
        this.leaveStart,
        this.leaveEnd,
    });

    factory RequestLeaveModel.fromJson(Map<String, dynamic> json) => RequestLeaveModel(
        username: json["username"],
        fullname: json["fullname"],
        leaveStart: json["leave_start"] == null ? null : DateTime.parse(json["leave_start"]),
        leaveEnd: json["leave_end"] == null ? null : DateTime.parse(json["leave_end"]),
    );

    Map<String, dynamic> toJson() => {
        "username": username,
        "fullname": fullname,
        "leave_start": leaveStart?.toIso8601String(),
        "leave_end": leaveEnd?.toIso8601String(),
    };
}
