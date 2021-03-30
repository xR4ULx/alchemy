import 'dart:convert';

RequestPush requestPushFromJson(String str) => RequestPush.fromJson(json.decode(str));

String requestPushToJson(RequestPush data) => json.encode(data.toJson());

class RequestPush {
  RequestPush({
    this.to,
    this.notification,
  });

  String to;
  Notification notification;

  factory RequestPush.fromJson(Map<String, dynamic> json) => RequestPush(
    to: json["to"],
    notification: Notification.fromJson(json["notification"]),
  );

  Map<String, dynamic> toJson() => {
    "to": to,
    "notification": notification.toJson(),
  };
}

class Notification {
  Notification({
    this.body,
    this.title,
  });

  String body;
  String title;

  factory Notification.fromJson(Map<String, dynamic> json) => Notification(
    body: json["body"],
    title: json["title"],
  );

  Map<String, dynamic> toJson() => {
    "body": body,
    "title": title,
  };
}
