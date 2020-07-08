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
  String _displayName;
  String _photoUrl;
  String _uid;
  String _player;
  String _adversary;
  bool _isActive;
  int _wins;

  User();

  String get displayName {
    return _displayName;
  }

  void set displayName(String displayName) {
    _displayName = displayName;
  }

  String get photoUrl {
    return _photoUrl;
  }

  void set photoUrl(String photoUrl) {
    _photoUrl = photoUrl;
  }

  String get uid {
    return _uid;
  }

  void set uid(String uid) {
    _uid = uid;
  }

  String get player {
    return _player;
  }

  void set player(String player) {
    _player = player;
  }

  String get adversary {
    return _adversary;
  }

  void set adversary(String adversary) {
    _adversary = adversary;
  }

  bool get isActive {
    return _isActive;
  }

  void set isActive(bool isActive) {
    _isActive = isActive;
  }

  int get wins {
    return _wins;
  }

  void set wins(int wins) {
    _wins = wins;
  }

  incrementWins() {
    _wins = _wins + 1;
    Firestore.instance.collection('users').document(_uid).setData(toJson());
  }

  User.fromJson(Map<String, dynamic> json) {
    _displayName = json["displayName"];
    _photoUrl = json["photoUrl"];
    _uid = json["uid"];
    _player = json["player"];
    _adversary = json["adversary"];
    _isActive = json["isActive"];
    _wins = json["wins"];
  }

  Map<String, dynamic> toJson() => {
        "displayName": _displayName,
        "photoUrl": _photoUrl,
        "uid": _uid,
        "player": _player,
        "adversary": _adversary,
        "isActive": _isActive,
        "wins": _wins,
      };
}
