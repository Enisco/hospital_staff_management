import 'dart:convert';

RequestLeaveModel requestLeaveModelFromJson(String str) => RequestLeaveModel.fromJson(json.decode(str));

String requestLeaveModelToJson(RequestLeaveModel data) => json.encode(data.toJson());

class RequestLeaveModel {
    final String? username;
    final String? fullname;
    final DateTime? leaveStart;
    final DateTime? leaveEnd;
    final DateTime? created;
    final bool? seen;
    final bool? granted;

    RequestLeaveModel({
        this.username,
        this.fullname,
        this.leaveStart,
        this.leaveEnd,
        this.created,
        this.seen,
        this.granted,
    });

    factory RequestLeaveModel.fromJson(Map<String, dynamic> json) => RequestLeaveModel(
        username: json["username"],
        fullname: json["fullname"],
        leaveStart: json["leave_start"] == null ? null : DateTime.parse(json["leave_start"]),
        leaveEnd: json["leave_end"] == null ? null : DateTime.parse(json["leave_end"]),
        created: json["created"] == null ? null : DateTime.parse(json["created"]),
        seen: json["seen"],
        granted: json["granted"],
    );

    Map<String, dynamic> toJson() => {
        "username": username,
        "fullname": fullname,
        "leave_start": leaveStart?.toIso8601String(),
        "leave_end": leaveEnd?.toIso8601String(),
        "created": created?.toIso8601String(),
        "seen": seen,
        "granted": granted,
    };
}
