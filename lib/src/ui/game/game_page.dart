import 'package:alchemy/src/bloc/game_bloc/bloc.dart';
import 'package:alchemy/src/bloc/game_bloc/game_event.dart';
import 'package:alchemy/src/models/potion_model.dart';
import 'package:alchemy/src/util/check_win.dart';
import 'package:animated_background/animated_background.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:alchemy/src/services/wizard.dart';

//final potions = new Potions();
Potions gridState = new Potions();

class Game extends StatefulWidget {
  final Wizard wizard;
  const Game({Key key, @required this.wizard});

  @override
  _GameState createState() => _GameState();
}

class _GameState extends State<Game> with TickerProviderStateMixin {
  AnimationController _controller;
  Animation _colorAnimation;

  RandomParticleBehaviour _particleBehaviour = new RandomParticleBehaviour();
  ParticleOptions _particleOptions =
      new ParticleOptions(baseColor: Color(0xFF70DCA9));

  String player;
  int alchemyP1;
  int alchemyP2;

  Wizard blink() {
    return widget.wizard;
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  void initState() {
    player = 'p1';
    alchemyP1 = 0;
    alchemyP2 = 0;

    blink().userRepository.updateUser();

    //Animation
    _controller =
        AnimationController(vsync: this, duration: Duration(seconds: 2));
    _colorAnimation =
        ColorTween(begin: Colors.blue, end: Colors.yellow).animate(_controller);

    _controller.addListener(() {
      setState(() {});
    });

    _controller.repeat();

    //Fin Animation

    _particleBehaviour.options = _particleOptions;

    blink().signaling.onChangeTurn = (data) {
      setState(() {
        _paintAdversary(data["x"], data["y"]);
        player = data["player"];
      });
    };

    blink().signaling.onFinishGame = () {
      AwesomeDialog(
        context: context,
        animType: AnimType.SCALE,
        dialogType: DialogType.INFO,
        body: Center(
          child: Text('${blink().user.adversary} abandono la partida',
              style: GoogleFonts.griffy(color: Theme.of(context).primaryColor),
              textScaleFactor: 1.2),
        ),
        title: 'Resultado',
        //desc:   'Resultado de la partida',
        btnOkOnPress: () {
          blink().user.player = '';
          blink().user.adversary = '';
          blink().userRepository.updateUser();
          gridState.clearPotions();
          blink().user.incrementWins();
          blink().signaling.emit('exit-game', true);
        },
      )..show();
    };

    super.initState();
  }

  Future<bool> willPop() async {
    //Navigator.of(context).popAndPushNamed('/root');
    //_signaling.emit('finish', true);
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () => willPop(),
      child: Scaffold(
        backgroundColor: Theme.of(context).primaryColor,
        body: Center(child: _buildGameBody()),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        floatingActionButton: Container(
            decoration: BoxDecoration(
              boxShadow: [
                BoxShadow(
                  offset: const Offset(0.0, .0),
                  blurRadius: 26.0,
                  spreadRadius: 3.2,
                  color: Colors.redAccent,
                )
              ],
            ),
            child: FloatingActionButton(
              onPressed: () {
                blink().user.player = '';
                blink().user.adversary = '';
                blink().userRepository.updateUser();
                gridState.clearPotions();
                blink().signaling.emit('finish', true);
                BlocProvider.of<GameBloc>(context).add(EHome());
              },
              backgroundColor: Colors.redAccent,
              child: Icon(
                Icons.close,
                color: Colors.white,
              ),
            )),
      ),
    );
  }

  Widget _buildGameBody() {
    int gridStateLength = gridState.potions.length;
    return AnimatedBackground(
      behaviour: _particleBehaviour,
      vsync: this,
      child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            SafeArea(
              child: SizedBox(),
            ),
            Text(
              blink().user.player == player
                  ? 'Turno de ${blink().user.displayName}'
                  : 'Turno de ${blink().user.adversary}',
              style: GoogleFonts.griffy(color: Colors.white),
              textScaleFactor: 2,
              textAlign: TextAlign.center,
            ),
            AspectRatio(
              aspectRatio: 0.8,
              child: Container(
                child: GridView.builder(
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: gridStateLength,
                  ),
                  itemBuilder: _buildGridItems,
                  itemCount: gridStateLength * gridStateLength,
                ),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Column(
                  children: <Widget>[
                    Text(
                      blink().user.player == 'p1'
                          ? blink().user.displayName
                          : blink().user.adversary,
                      style: GoogleFonts.griffy(color: Colors.amber),
                      textScaleFactor: 2,
                    ),
                    Text('Alchemys $alchemyP1',
                        style: GoogleFonts.griffy(color: Colors.amber),
                        textScaleFactor: 1.2),
                    Image(
                      image: AssetImage("assets/p1.png"),
                      width: 60,
                    ),
                  ],
                ),
                Column(
                  children: <Widget>[
                    Text(
                      blink().user.player == 'p2'
                          ? blink().user.displayName
                          : blink().user.adversary,
                      style: GoogleFonts.griffy(color: Colors.amber),
                      textScaleFactor: 2,
                    ),
                    Text('Alchemys $alchemyP2',
                        style: GoogleFonts.griffy(color: Colors.amber),
                        textScaleFactor: 1.2),
                    Image(
                      image: AssetImage("assets/p2.png"),
                      width: 60,
                    ),
                  ],
                ),
              ],
            ),
            SizedBox(
              height: 2,
            )
          ]),
    );
  }

  Widget _buildGridItems(BuildContext context, int index) {
    int gridStateLength = gridState.potions.length;
    int x, y = 0;
    x = (index / gridStateLength).floor();
    y = (index % gridStateLength);
    return GestureDetector(
      onTap: () => _gridItemTapped(x, y),
      child: GridTile(
        child: Container(
          decoration: BoxDecoration(
              boxShadow: [
                BoxShadow(
                    offset: const Offset(0.0, 20.0),
                    blurRadius: 11.0,
                    spreadRadius: 22.0,
                    color: Colors.transparent)
              ],
              border:
                  Border.all(color: Theme.of(context).accentColor, width: 3.5),
              borderRadius: new BorderRadius.all(Radius.circular(10.0))),
          child: Center(
            child: _buildGridItem(x, y),
          ),
        ),
      ),
    );
  }

  Widget _buildGridItem(int x, int y) {
    Potion potion = gridState.getPotion(x, y);
    Widget _widget = potion.getPosition();
    return _widget;
  }

  _paintAdversary(int x, int y) async {
    Potion potion = gridState.getPotion(x, y);

    if (potion.setPosition(player)) {
      potion.getPosition();
    }

    CheckWin check = new CheckWin(player, gridState, _colorAnimation);
    await check.comprobarWin();
    if (blink().user.player == 'p1') {
      alchemyP2 = check.winsPlayer;
    } else {
      alchemyP1 = check.winsPlayer;
    }

    if (gridState.fullPotions()) {
      String winner = '';

      if (alchemyP1 > alchemyP2) {
        //GANA P1
        if (blink().user.player == 'p1') {
          blink().user.incrementWins();
          winner = blink().user.displayName;
        } else {
          winner = blink().user.adversary;
        }
      } else if (alchemyP1 == alchemyP2) {
        blink().user.incrementWins();
      } else {
        // GANA P2
        if (blink().user.player == 'p1') {
          winner = blink().user.adversary;
        } else {
          winner = blink().user.displayName;
        }
      }

      AwesomeDialog(
        context: context,
        animType: AnimType.SCALE,
        dialogType: DialogType.INFO,
        body: Center(
          child: Text(winner != '' ? 'Ganó $winner' : 'Empate',
              style: GoogleFonts.griffy(color: Theme.of(context).primaryColor),
              textScaleFactor: 1.2),
        ),
        title: 'Resultado',
        //desc:   'Resultado de la partida',
        btnOkOnPress: () {
          blink().user.player = '';
          blink().user.adversary = '';
          blink().userRepository.updateUser();
          gridState.clearPotions();
          blink().signaling.emit('exit-game', true);
        },
      )..show();
    }

    setState(() {});
  }

  _gridItemTapped(int x, int y) async {
    //_timer.cancel();
    if (player == blink().user.player) {
      Potion potion = gridState.getPotion(x, y);
      String antPlayer;

      antPlayer = player;
      if (potion.setPosition(player)) {
        potion.getPosition();
        player == 'p1' ? player = 'p2' : player = 'p1';
      }

      if (antPlayer != null) {
        CheckWin check = new CheckWin(antPlayer, gridState, _colorAnimation);
        await check.comprobarWin();
        if (blink().user.player == 'p1') {
          alchemyP1 = check.winsPlayer;
        } else {
          alchemyP2 = check.winsPlayer;
        }
      }

      blink().signaling.emit('changeTurn', {"player": player, "x": x, "y": y});

      if (gridState.fullPotions()) {
        String winner = '';

        if (alchemyP1 > alchemyP2) {
          //GANA P1
          if (blink().user.player == 'p1') {
            blink().user.incrementWins();
            winner = blink().user.displayName;
          } else {
            winner = blink().user.adversary;
          }
        } else if (alchemyP1 == alchemyP2) {
          blink().user.incrementWins();
        } else {
          // GANA P2
          if (blink().user.player == 'p1') {
            winner = blink().user.adversary;
          } else {
            winner = blink().user.displayName;
          }
        }

        AwesomeDialog(
          context: context,
          animType: AnimType.SCALE,
          dialogType: DialogType.INFO,
          body: Center(
            child: Text(winner != '' ? 'Ganó $winner' : 'Empate',
                style:
                    GoogleFonts.griffy(color: Theme.of(context).primaryColor),
                textScaleFactor: 1.2),
          ),
          title: 'Resultado',
          //desc:   'Resultado de la partida',
          btnOkOnPress: () {
            blink().user.player = '';
            blink().user.adversary = '';
            blink().userRepository.updateUser();
            gridState.clearPotions();
            blink().signaling.emit('exit-game', true);
          },
        )..show();
      }
    }

    setState(() {});
  }
}
