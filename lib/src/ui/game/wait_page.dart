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
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          ClipRRect(
            borderRadius: BorderRadius.circular(50),
            child: Image.network(
              'https://image.freepik.com/vector-gratis/botella-pocion-roja-icono-juego-elixir-magico_70339-62.jpg',
              width: 100,
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
          FloatingActionButton(
          onPressed: () {
            _signaling.finishGame();
            BlocProvider.of<GameBloc>(context).add(EHome());
          },
          backgroundColor: Colors.redAccent,
          child: Icon(Icons.cancel),
        ),
        ],
      )),
    );
  }
}
