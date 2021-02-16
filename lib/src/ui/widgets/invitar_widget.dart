import 'package:alchemy/src/bloc/game_bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:alchemy/src/services/wizard.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class InvitarWidget extends StatelessWidget {
  final AsyncSnapshot<dynamic> snapshot;
  final int index;
  final Wizard wizard;

  const InvitarWidget(
      {@required this.snapshot, @required this.index, @required this.wizard});

  @override
  Widget build(BuildContext context) {
    return RaisedButton(
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(18.0),
          side: BorderSide(color: Colors.red)),
      onPressed: () {
        if (snapshot.data.documents[index]['isActive'] &&
            snapshot.data.documents[index]['player'] == '') {
          wizard.user.adversary = snapshot.data.documents[index]['displayName'];
          wizard.signaling
              .emit('request', snapshot.data.documents[index]['displayName']);
          BlocProvider.of<GameBloc>(context).add(EWait());
        }
      },
      color: Theme.of(context).primaryColor,
      textColor: Colors.white,
      child: Text("Invitar", style: TextStyle(fontSize: 12)),
    );
  }
}
