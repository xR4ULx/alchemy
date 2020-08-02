import 'dart:convert';

Message messageFromJson(String str) => Message.fromJson(json.decode(str));

String messageToJson(Message data) => json.encode(data.toJson());

class Message {
    String idFrom;
    String idTo;
    String timestamp;
    String content;
    int type;

    Message({
        this.idFrom,
        this.idTo,
        this.timestamp,
        this.content,
        this.type,
    });

    factory Message.fromJson(Map<String, dynamic> json) => Message(
        idFrom: json["idFrom"],
        idTo: json["idTo"],
        timestamp: json["timestamp"],
        content: json["content"],
        type: json["type"],
    );

    Map<String, dynamic> toJson() => {
        "idFrom": idFrom,
        "idTo": idTo,
        "timestamp": timestamp,
        "content": content,
        "type": type,
    };
}