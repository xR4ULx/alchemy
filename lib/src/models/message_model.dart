import 'dart:convert';

Message messageFromJson(String str) => Message.fromJson(json.decode(str));

String messageToJson(Message data) => json.encode(data.toJson());

class Message {
    String uid;
    String idFrom;
    String idTo;
    String timestamp;
    String content;
    bool status;
    int type;

    Message({
        this.uid,
        this.idFrom,
        this.idTo,
        this.timestamp,
        this.content,
        this.status,
        this.type,
    });

    factory Message.fromJson(Map<String, dynamic> json) => Message(
        uid: json["uid"],
        idFrom: json["idFrom"],
        idTo: json["idTo"],
        timestamp: json["timestamp"],
        content: json["content"],
        status: json["status"],
        type: json["type"],
    );

    Map<String, dynamic> toJson() => {
        "uid": uid,
        "idFrom": idFrom,
        "idTo": idTo,
        "timestamp": timestamp,
        "content": content,
        "status": status,
        "type": type,
    };
}