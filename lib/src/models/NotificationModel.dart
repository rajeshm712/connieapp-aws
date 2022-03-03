import 'dart:convert';

NotificationModel notificationModelFromJson(String str) =>
    NotificationModel.fromJson(json.decode(str));

String notificationModelToJson(NotificationModel data) =>
    json.encode(data.toJson());

class NotificationModel {
  NotificationModel({
    this.priority,
    this.message,
    this.title,
    this.imageUrl,
    this.timestamp,
    this.navigateto,
    this.data,
  });

  String priority;
  String message;
  String title;
  String imageUrl;
  String timestamp;
  String navigateto;
  String data;

  factory NotificationModel.fromJson(Map<String, dynamic> json) =>
      NotificationModel(
        priority: json["priority"],
        message: json["message"],
        title: json["title"],
        imageUrl: json["imageUrl"],
        timestamp: json["timestamp"],
        navigateto: json["navigateto"],
        data: json["data"],
      );

  Map<String, dynamic> toJson() => {
        "priority": priority,
        "message": message,
        "title": title,
        "imageUrl": imageUrl,
        "timestamp": timestamp,
        "navigateto": navigateto,
        "data": data,
      };
}
