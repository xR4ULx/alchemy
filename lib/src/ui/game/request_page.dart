import 'package:alchemy/src/bloc/game_bloc/bloc.dart';
import 'package:alchemy/src/repository/user_model.dart';
import 'package:alchemy/src/util/signaling.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:google_fonts/google_fonts.dart';

class RequestPage extends StatefulWidget {
  const RequestPage({Key key}) : super(key: key);

  @override
  _RequestPageState createState() => _RequestPageState();
}

class _RequestPageState extends State<RequestPage> {
  Signaling _signaling = GetIt.I.get<Signaling>();
  User _user = GetIt.I.get<User>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            ClipRRect(
              borderRadius: BorderRadius.circular(50),
              child: Image.asset(
                'pocion.png',
                width: 100,
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Text(
              _user.adversary,
              style: GoogleFonts.griffy(
                color: Colors.amber,
              ),
              textScaleFactor: 3,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                FloatingActionButton(
                  onPressed: () {
                    _signaling.acceptOrDecline(true, _user.adversary);
                    _user.player = 'p2';
                    BlocProvider.of<GameBloc>(context).add(EGame());
                  },
                  backgroundColor: Colors.green,
                  child: Icon(Icons.photo_filter),
                ),
                SizedBox(width: 80),
                FloatingActionButton(
                  onPressed: () {
                    _signaling.emit('finish', true);
                  },
                  backgroundColor: Colors.redAccent,
                  child: Icon(Icons.cancel),
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}