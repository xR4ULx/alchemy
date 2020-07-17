import 'package:alchemy/src/repository/potion_model.dart';
import 'package:alchemy/src/repository/user_model.dart';
import 'package:alchemy/src/util/check_win.dart';
import 'package:alchemy/src/util/colors.dart';
import 'package:alchemy/src/util/signaling.dart';
import 'package:animated_background/animated_background.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:google_fonts/google_fonts.dart';

//final potions = new Potions();
Potions gridState = new Potions();

class Game extends StatefulWidget {
  Game({Key key}) : super(key: key);

  @override
  _GameState createState() => _GameState();
}

class _GameState extends State<Game> with TickerProviderStateMixin {
  Signaling _signaling = GetIt.I.get<Signaling>();
  User _user = GetIt.I.get<User>();

  AnimationController _controller;
  Animation _colorAnimation;

  RandomParticleBehaviour _particleBehaviour = new RandomParticleBehaviour();
  ParticleOptions _particleOptions =
      new ParticleOptions(baseColor: myAccentColor);

  String player;
  int alchemyP1;
  int alchemyP2;

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

    _signaling.onChangeTurn = (data) {
      setState(() {
        _paintAdversary(data["x"], data["y"]);
        player = data["player"];
      });
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
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            gridState.clearPotions();
            _signaling.emit('finish', true);
          },
          backgroundColor: Colors.redAccent,
          child: Icon(Icons.close),
        ),
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
                child: SizedBox(
                    height: MediaQuery.of(context).size.height * 0.01)),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Column(
                  children: <Widget>[
                    Image(
                      image: AssetImage("assets/p1.png"),
                      width: 60,
                    ),
                    Text(
                      _user.player == 'p1'
                          ? _user.displayName
                          : _user.adversary,
                      style: GoogleFonts.griffy(color: Colors.amber),
                      textScaleFactor: 2,
                    ),
                    Text('Alchemys $alchemyP1',
                        style: GoogleFonts.griffy(color: Colors.amber),
                        textScaleFactor: 1)
                  ],
                ),
                Column(
                  children: <Widget>[
                    Image(
                      image: AssetImage("assets/p2.png"),
                      width: 60,
                    ),
                    Text(
                      _user.player == 'p2'
                          ? _user.displayName
                          : _user.adversary,
                      style: GoogleFonts.griffy(color: Colors.amber),
                      textScaleFactor: 2,
                    ),
                    Text('Alchemys $alchemyP2',
                        style: GoogleFonts.griffy(color: Colors.amber),
                        textScaleFactor: 1),
                  ],
                ),
              ],
            ),
            SizedBox(
              height: 3,
            ),
            Text(
              _user.player == player
                  ? 'Turno de ${_user.displayName}'
                  : 'Turno de ${_user.adversary}',
              style: GoogleFonts.griffy(color: Theme.of(context).accentColor),
              textScaleFactor: 2,
              textAlign: TextAlign.start,
            ),
            AspectRatio(
              aspectRatio: 0.80,
              child: Container(
                padding: const EdgeInsets.all(2.0),
                margin: const EdgeInsets.all(2.0),
                child: GridView.builder(
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: gridStateLength,
                  ),
                  itemBuilder: _buildGridItems,
                  itemCount: gridStateLength * gridStateLength,
                ),
              ),
            ),
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
    alchemyP2 = check.winsPlayer;

    if (gridState.fullPotions()) {
      _user.player = '';
      _user.adversary = '';
      gridState.clearPotions();
      _signaling.emit('finish', true);
    }

    setState(() {});
  }

  _gridItemTapped(int x, int y) async {
    //_timer.cancel();
    if (player == _user.player) {
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
        alchemyP1 = check.winsPlayer;
      }

      _signaling.emit('changeTurn', {"player": player, "x": x, "y": y});

      if (gridState.fullPotions()) {
        _user.player = '';
        _user.adversary = '';
        gridState.clearPotions();
        _signaling.emit('finish', true);
      }
    }

    setState(() {});
  }
}
