import 'dart:convert';

import 'package:alchemy/src/models/request_push_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:alchemy/src/models/message_model.dart';
import 'package:http/http.dart' as http;

class MessagesProvider {
  String _groupChatId;
  String _idFrom;
  String _idTo;

  String get id => _idFrom;
  String get groupChatId => _groupChatId;
  
  MessagesProvider(idTo, idFrom){
    this._idTo = idTo;
    this._idFrom = idFrom;
    if (_idFrom.hashCode <= _idTo.hashCode) {
      _groupChatId = '$_idFrom-$_idTo';
    } else {
      _groupChatId = '$_idTo-$_idFrom';
    }
    Firestore.instance.collection('users').document(_idFrom).updateData({'chattingWith': _idTo});
  }

  void sendMessage(Message message, String token, String nameFrom) {
    _idFrom = message.idFrom;
    _idTo = message.idTo;
    if (_idFrom.hashCode <= _idTo.hashCode) {
      _groupChatId = '$_idFrom-$_idTo';
    } else {
      _groupChatId = '$_idTo-$_idFrom';
    }
    var documentReference = Firestore.instance
        .collection('message')
        .document(_groupChatId)
        .collection('messages')
        .document(DateTime.now().millisecondsSinceEpoch.toString());

    message.uid = documentReference.documentID;
    message.status = false;

    Firestore.instance.runTransaction((transaction) async {
      await transaction.set(
        documentReference,
        message.toJson(),
      );
    });

    if(token != ""){
      sendPushNotification(token, Notification(title: nameFrom ,body: message.content ));
    }
  }

  void sendPushNotification(String token, Notification notification) async{

    http.post(
      Uri.https('fcm.googleapis.com', 'fcm/send'),
      headers: <String, String>{
        'Authorization': 'key=AAAAkWZPQoM:APA91bFGUnqNNsM3eQjmR-8K75Xk4olovQD8ithk5FNErqmTOXP3SPodU_bd3kBbql0U_Tx6sUe9bvEnhrMr23Hmmq4OOdf1LTcvRW_TNaduN3Vq6gcOSLKPjn4klnBiE08cjoHW0tlL',
        'Content-Type': 'application/json',
      },
      body: jsonEncode(RequestPush(to: token, notification: notification).toJson()),
    );

  }

  void readMessage(String uid){

    Firestore.instance
        .collection('message')
        .document(_groupChatId)
        .collection('messages')
        .document(uid).updateData({"status": true});

  }

  Stream<QuerySnapshot> getSnapshotMessage() {

    return Firestore.instance
        .collection('message')
        .document(_groupChatId)
        .collection('messages')
        .orderBy('timestamp', descending: true)
        .snapshots();
  }
}
