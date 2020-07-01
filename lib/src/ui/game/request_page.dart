import 'package:alchemy/src/bloc/game_bloc/bloc.dart';
import 'package:alchemy/src/util/signaling.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';

class RequestPage extends StatefulWidget {
  const RequestPage({Key key}) : super(key: key);

  @override
  _RequestPageState createState() => _RequestPageState();
}

class _RequestPageState extends State<RequestPage> {
  Signaling _signaling = GetIt.I.get<Signaling>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Text('Request'),
            FlatButton(
              onPressed: () {
                _signaling
                    .emit('response', true);
                BlocProvider.of<GameBloc>(context).add(EGame());
              },
              child: Text('Aceptar'),
            )
          ],
        ),
      ),
    );
  }
}
