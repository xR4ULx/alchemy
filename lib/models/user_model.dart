

import 'dart:convert';

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

class User{

  String _displayName;
  String _photoUrl;
  String _uid;
  bool _isActive;

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

  bool get isActive {
    return _isActive;
  }

  void set isActive(bool isActive) {
    _isActive = isActive;
  }



  User.fromJson(Map<String, dynamic> json){
    _displayName = json["displayName"];
    _photoUrl = json["photoUrl"];
    _uid= json["uid"];
    _isActive = json["isActive"];
  }

  Map<String, dynamic> toJson() => {
    "displayName": _displayName,
    "photoUrl": _photoUrl,
    "uid": _uid,
    "isActive": _isActive,
  };

}
