

import 'dart:async';

import 'package:alchemy/utils/fire_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get_it/get_it.dart';

class UsersProvider{
  
  FirebaseService _fs = GetIt.I.get<FirebaseService>();

  QuerySnapshot users;
  final _usersStreamController = StreamController<QuerySnapshot>.broadcast();

  Function(QuerySnapshot) get _usersSink => _usersStreamController.sink.add;
  Stream<QuerySnapshot> get usersStream => _usersStreamController.stream;
  
  void disposeStream(){
    _usersStreamController?.close();
  }

  void getAllUsers() async{
    
    await for(QuerySnapshot snap in Firestore.instance.collection('users').orderBy('isActive', descending: true).snapshots()){
      _usersSink(snap);
    }
  }

  void sarchUsers(String query) async{
    
    await for(QuerySnapshot snap in Firestore.instance.collection('users').where('indexes',arrayContains: query.toLowerCase() ).orderBy('isActive', descending: true).snapshots()){
      _usersSink(snap);
    }
  }

  void updateUser(){
    // Update data to server if new user
    Firestore.instance.collection('users').document(_fs.user.id).setData(_fs.user.toJson());
  }

}
