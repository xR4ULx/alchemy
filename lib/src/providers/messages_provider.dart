import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:alchemy/src/models/message_model.dart';

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

  void sendMessage(Message message) {
    _idFrom = message.idFrom;
    _idTo = message.idTo;
    if (_idFrom.hashCode <= _idTo.hashCode) {
      _groupChatId = '$_idFrom-$_idTo';
    } else {
      _groupChatId = '$_idTo-$_idFrom';
    }
    var documentReference = Firestore.instance
        .collection('messages')
        .document(_groupChatId)
        .collection(_groupChatId)
        .document(DateTime.now().millisecondsSinceEpoch.toString());

    Firestore.instance.runTransaction((transaction) async {
      await transaction.set(
        documentReference,
        message.toJson(),
      );
    });
  }

  Stream<QuerySnapshot> getSnapshotMessage() {
    return Firestore.instance
        .collection('messages')
        .document(_groupChatId)
        .collection(_groupChatId)
        .orderBy('timestamp', descending: true)
        .limit(20)
        .snapshots();
  }
}
