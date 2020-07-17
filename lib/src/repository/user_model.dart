import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';

User userFireFromJson(String str) => User.fromJson(json.decode(str));
String userFireToJson(User data) => json.encode(data.toJson());

class Users {
  List<User> items = new List();

  Users();

  Users.fromJsonList(List<dynamic> jsonList) {
    if (jsonList == null) return;

    for (var item in jsonList) {
      final user = new User.fromJson(item);
      items.add(user);
    }
  }
}

class User {
  String displayName;
  String photoUrl;
  String uid;
  String player;
  String adversary;
  bool isActive;
  int wins;
  List<dynamic> follows;

  _createIndexes(String name) {
    List<String> _indexes = [""];
    for (int i = 1; i <= displayName.length; i++) {
      String subString = displayName.substring(0, i).toLowerCase();
      _indexes.add(subString);
    }
    return _indexes;
  }

  User();

  String get indexes => _createIndexes(displayName);

  incrementWins() {
    wins = wins + 1;
    Firestore.instance.collection('users').document(uid).setData(toJson());
  }

  User.fromJson(Map<String, dynamic> json) {
    displayName = json["displayName"];
    photoUrl = json["photoUrl"];
    uid = json["uid"];
    player = json["player"];
    adversary = json["adversary"];
    isActive = json["isActive"];
    wins = json["wins"];
    follows = json["follows"];
  }

  Map<String, dynamic> toJson() => {
        "displayName": displayName,
        "photoUrl": photoUrl,
        "uid": uid,
        "player": player,
        "adversary": adversary,
        "isActive": isActive,
        "wins": wins,
        "indexes": _createIndexes(displayName),
        "follows": follows,
      };
}
