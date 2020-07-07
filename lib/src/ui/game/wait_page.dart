import 'package:alchemy/src/bloc/game_bloc/bloc.dart';
import 'package:alchemy/src/util/signaling.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:google_fonts/google_fonts.dart';

class WaitPage extends StatefulWidget {
  const WaitPage({Key key}) : super(key: key);

  @override
  _WaitPageState createState() => _WaitPageState();
}

class _WaitPageState extends State<WaitPage> {
  Signaling _signaling = GetIt.I.get<Signaling>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
          child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          Container(
            padding: EdgeInsets.all(5),
            decoration:
                BoxDecoration(color: Colors.black12, shape: BoxShape.circle),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(50),
              child: Image.asset(
                'assets/pocion.png',
                width: 120,
              ),
            ),
          ),
          SizedBox(
            height: 10,
          ),
          Text(
            'Esperando Respuesta...',
            style: GoogleFonts.griffy(),
            textScaleFactor: 2,
          ),
          SizedBox(
            height: 30,
          ),
          FloatingActionButton(
            onPressed: () {
              _signaling.finishGame();
              BlocProvider.of<GameBloc>(context).add(EHome());
            },
            backgroundColor: Colors.deepPurple,
            child: Icon(Icons.cancel),
          ),
        ],
      )),
    );
  }
}
