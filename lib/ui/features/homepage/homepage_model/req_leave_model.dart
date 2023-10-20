import 'dart:convert';

RequestLeaveModel requestLeaveModelFromJson(String str) => RequestLeaveModel.fromJson(json.decode(str));

String requestLeaveModelToJson(RequestLeaveModel data) => json.encode(data.toJson());

class RequestLeaveModel {
    final String? username;
    final String? fullname;
    final DateTime? leaveStart;
    final DateTime? leaveEnd;
    final DateTime? created;
    bool? seen;
    final bool? granted;
    final String? imageUrl;

    RequestLeaveModel({
        this.username,
        this.fullname,
        this.leaveStart,
        this.leaveEnd,
        this.created,
        this.seen,
        this.granted,
        this.imageUrl,
    });

    factory RequestLeaveModel.fromJson(Map<String, dynamic> json) => RequestLeaveModel(
        username: json["username"],
        fullname: json["fullname"],
        leaveStart: json["leave_start"] == null ? null : DateTime.parse(json["leave_start"]),
        leaveEnd: json["leave_end"] == null ? null : DateTime.parse(json["leave_end"]),
        created: json["created"] == null ? null : DateTime.parse(json["created"]),
        seen: json["seen"],
        granted: json["granted"],
        imageUrl: json["imageUrl"],
    );

    Map<String, dynamic> toJson() => {
        "username": username,
        "fullname": fullname,
        "leave_start": leaveStart?.toIso8601String(),
        "leave_end": leaveEnd?.toIso8601String(),
        "created": created?.toIso8601String(),
        "seen": seen,
        "granted": granted,
        "imageUrl": imageUrl,
    };
}

UpdateNotificationModel updateNotificationModelFromJson(String str) => UpdateNotificationModel.fromJson(json.decode(str));

String updateNotificationModelToJson(UpdateNotificationModel data) => json.encode(data.toJson());

class UpdateNotificationModel {
    bool? seen;

    UpdateNotificationModel({
        this.seen,
    });

    UpdateNotificationModel copyWith({
        bool? seen,
    }) => 
        UpdateNotificationModel(
            seen: seen ?? this.seen,
        );

    factory UpdateNotificationModel.fromJson(Map<String, dynamic> json) => UpdateNotificationModel(
        seen: json["seen"],
    );

    Map<String, dynamic> toJson() => {
        "seen": seen,
    };
}
