import 'dart:async';

import 'package:alchemy/models/potion_model.dart';
import 'package:animated_background/animated_background.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

final potions = new Potions();
List<List<Potion>> gridState;

class Game extends StatefulWidget {
  Game({Key key}) : super(key: key);

  @override
  _GameState createState() => _GameState();
}

class _GameState extends State<Game> with TickerProviderStateMixin {
  String player;
  int p1win;
  int p2win;
  Timer _timer;
  int _start;

  void startTimer() {
    _start = 10;
    const oneSec = const Duration(seconds: 1);
    _timer = new Timer.periodic(
      oneSec,
      (Timer timer) => setState(
        () {
          if (_start < 1) {
            timer.cancel();
            player == 'p1' ? player = 'p2' : player = 'p1';
            setState(() {
              _start = 10;
            });
          } else {
            _start = _start - 1;
          }
        },
      ),
    );
  }

  @override
  void initState() {
    player = 'p1';
    p1win = 0;
    p2win = 0;
    gridState = potions.getPotions();
    super.initState();
    startTimer();
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
                    ' WINS: ${p1win}',
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
                    ' WINS: ${p2win}',
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
            'TURNO DE: ${player}',
            style: GoogleFonts.griffy(),
            textScaleFactor: 2,
          ),
          Text(
            '${_start}',
            style: GoogleFonts.griffy(color: Colors.redAccent),
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

  _gridItemTapped(int x, int y) {
    _timer.cancel();
    print('X:[${x}] Y:[${y}');

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
          title: 'GANADOR ${win}',
          desc: '${win}',
          //btnCancelOnPress: () {},
          btnOkOnPress: () {
            setState(() {
              win == 'p1' ? p1win++ : p2win++;
              potions.clearPotions();
              gridState.clear();
              gridState = potions.getPotions();
            });
          })
        ..show();
    }

    startTimer();
  }
}
