import 'dart:async';

import 'package:alchemy/src/bloc/game_bloc/bloc.dart';
import 'package:alchemy/src/repository/potion_model.dart';
import 'package:alchemy/src/repository/user_model.dart';
import 'package:alchemy/src/util/signaling.dart';
import 'package:animated_background/animated_background.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:google_fonts/google_fonts.dart';

final potions = new Potions();
List<List<Potion>> gridState;

class Game extends StatefulWidget {
  Game({Key key}) : super(key: key);

  @override
  _GameState createState() => _GameState();
}

class _GameState extends State<Game> with TickerProviderStateMixin {
  Signaling _signaling = GetIt.I.get<Signaling>();
  User _user = GetIt.I.get<User>();

  String player;
  int p1win;
  int p2win;

  @override
  void initState() {
    player = 'p1';
    p1win = 0;
    p2win = 0;
    gridState = potions.getPotions();

    _signaling.onChangeTurn = (data) {
      setState(() {
        _paintAdversary(data["x"], data["y"]);
        player = data["player"];
      });
    };

    super.initState();

    //startTimer();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () => Navigator.of(context).popAndPushNamed('/root'),
      child: Scaffold(
        body: AnimatedBackground(
            behaviour: RandomParticleBehaviour(),
            vsync: this,
            child: _buildGameBody()),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            _signaling.finishGame();
            BlocProvider.of<GameBloc>(context).add(EHome());
          },
          backgroundColor: Colors.redAccent,
          child: Icon(Icons.cancel),
        ),
      ),
    );
  }

  Widget _buildGameBody() {
    int gridStateLength = gridState.length;
    return Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: <Widget>[
          SafeArea(
              child:
                  SizedBox(height: MediaQuery.of(context).size.height * 0.01)),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Column(
                children: <Widget>[
                  Image(
                    image: AssetImage("assets/p1.png"),
                    width: 50,
                  ),
                  Text(
                    _user.player == 'p1' ? _user.displayName : _user.adversary,
                    style: GoogleFonts.griffy(color: Colors.deepPurple),
                    textScaleFactor: 2,
                  ),
                ],
              ),
              Column(
                children: <Widget>[
                  Image(
                    image: AssetImage("assets/p2.png"),
                    width: 50,
                  ),
                  Text(
                    _user.player == 'p2' ? _user.displayName : _user.adversary,
                    style: GoogleFonts.griffy(color: Colors.redAccent),
                    textScaleFactor: 2,
                  ),
                ],
              ),
            ],
          ),
          AspectRatio(
            aspectRatio: 0.85,
            child: Container(
              padding: const EdgeInsets.all(7.0),
              margin: const EdgeInsets.all(7.0),
              decoration: new BoxDecoration(
                  border: Border.all(color: Colors.white, width: 8.0),
                  //new Color.fromRGBO(255, 0, 0, 0.0),
                  borderRadius: new BorderRadius.all(Radius.circular(20.0))),
              child: GridView.builder(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: gridStateLength,
                ),
                itemBuilder: _buildGridItems,
                itemCount: gridStateLength * gridStateLength,
              ),
            ),
          ),
          Text(
            _user.player == player ? _user.displayName : _user.adversary,
            style: GoogleFonts.griffy(),
            textScaleFactor: 2,
          ),
        ]);
  }

  Widget _buildGridItems(BuildContext context, int index) {
    int gridStateLength = gridState.length;
    int x, y = 0;
    x = (index / gridStateLength).floor();
    y = (index % gridStateLength);
    return GestureDetector(
      onTap: () => _gridItemTapped(x, y),
      child: GridTile(
        child: Container(
          decoration: BoxDecoration(
              border: Border.all(color: Colors.white, width: 0.5)),
          child: Center(
            child: _buildGridItem(x, y),
          ),
        ),
      ),
    );
  }

  Widget _buildGridItem(int x, int y) {
    Potion potion = gridState[x][y];
    return potion.getPosition();
  }

  _paintAdversary(int x, int y) {
    String win;
    Potion potion = gridState[x][y];

    setState(() {
      if (potion.setPosition(player)) {
        potion.getPosition();
      }
    });

    win = potions.comprobarWin(player);

    if (win != null) {
      AwesomeDialog(
          context: context,
          headerAnimationLoop: false,
          dialogType: DialogType.SUCCES,
          animType: AnimType.SCALE,
          title: 'GANADOR',
          desc: _user.player == win ? _user.displayName : _user.adversary,
          //btnCancelOnPress: () {},
          btnOkOnPress: () {
            setState(() {
              win == 'p1' ? p1win++ : p2win++;
              potions.clearPotions();
              gridState.clear();
              gridState = potions.getPotions();
              //Finalizamos el Juego
              _user.incrementWins();
              _signaling.finishGame();
              BlocProvider.of<GameBloc>(context).add(EHome());
            });
          })
        ..show();
    }

    if (potions.fullPotions()) {
      _signaling.finishGame();
      BlocProvider.of<GameBloc>(context).add(EHome());
    }
  }

  _gridItemTapped(int x, int y) {
    //_timer.cancel();
    if (player == _user.player) {
      Potion potion = gridState[x][y];
      String win;
      String antPlayer;

      setState(() {
        antPlayer = player;
        if (potion.setPosition(player)) {
          potion.getPosition();
          player == 'p1' ? player = 'p2' : player = 'p1';
        }
      });

      if (antPlayer != null) {
        win = potions.comprobarWin(antPlayer);
      }

      if (win != null) {
        AwesomeDialog(
            context: context,
            headerAnimationLoop: false,
            dialogType: DialogType.SUCCES,
            animType: AnimType.SCALE,
            title: 'GANADOR',
            desc: _user.player == win ? _user.displayName : _user.adversary,
            //btnCancelOnPress: () {},
            btnOkOnPress: () {
              setState(() {
                win == 'p1' ? p1win++ : p2win++;
                potions.clearPotions();
                gridState.clear();
                gridState = potions.getPotions();
                //Finalizamos el Juego
                _signaling.finishGame();
                BlocProvider.of<GameBloc>(context).add(EHome());
              });
            })
          ..show();
      }

      _signaling.emit('changeTurn', {"player": player, "x": x, "y": y});

      if (potions.fullPotions()) {
        _signaling.finishGame();
        BlocProvider.of<GameBloc>(context).add(EHome());
      }
    }
  }
}
