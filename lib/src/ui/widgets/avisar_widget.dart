import 'package:alchemy/src/models/message_model.dart';
import 'package:flutter/material.dart';
import 'package:alchemy/src/services/wizard.dart';

class AvisarWidget extends StatelessWidget {

  final AsyncSnapshot<dynamic> snapshot;
  final int index;
  final Wizard wizard;
  final bool follows;

  const AvisarWidget({@required this.snapshot, @required this.index, @required this.wizard , @required this.follows});

  @override
  Widget build(BuildContext context) {
    return RaisedButton(
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(18.0),
          side: BorderSide(color: Colors.blue)),
      onPressed: () {
        Message msg = new Message(
            idFrom: wizard.user.uid,
            idTo: snapshot.data.documents[index]['uid'],
            timestamp: DateTime.now().millisecondsSinceEpoch.toString(),
            content: '¿Quieres jugar?',
            type: 0);

        wizard.messagesProvider.sendMessage(msg);

        wizard.userRepository
            .avisar(snapshot.data.documents[index]['displayName'], follows);
      },
      color: Colors.blue,
      textColor: Colors.white,
      child: Text("Avisar", style: TextStyle(fontSize: 12)),
    );
  }
}
