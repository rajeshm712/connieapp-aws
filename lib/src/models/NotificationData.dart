class NotificationData {
  NotificationData(
      {this.message,
      this.title,
      this.timestamp,
      this.appData,
      this.notificationType,
      this.silentNotification});

  String message;
  String title;
  String timestamp;
  String appData;
  String notificationType;
  String silentNotification;

  factory NotificationData.fromJson(Map<String, dynamic> json) =>
      NotificationData(
        message: json["message"],
        notificationType: json["notification_type"],
        silentNotification: json["silent_notification"],
        title: json["title"],
        timestamp: json["timestamp"],
        appData: json["app_data"],
      );

  Map<String, dynamic> toJson() => {
        "notification_type": notificationType,
        "silent_notification": silentNotification,
        "message": message,
        "title": title,
        "timestamp": timestamp,
        "app_data": appData,
      };
}
