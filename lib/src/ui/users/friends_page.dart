import 'package:alchemy/main.dart';
import 'package:alchemy/src/bloc/game_bloc/bloc.dart';
import 'package:alchemy/src/bloc/game_bloc/game_bloc.dart';
import 'package:alchemy/src/bloc/authentication_bloc/bloc.dart';
import 'package:alchemy/src/repository/user_model.dart';
import 'package:alchemy/src/repository/user_repository.dart';
import 'package:alchemy/src/util/colors.dart';
import 'package:alchemy/src/util/signaling.dart';
import 'package:animated_background/animated_background.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:simple_search_bar/simple_search_bar.dart';

class FriendsPage extends StatefulWidget {
  final String name;
  final UserRepository _userRepository;

  FriendsPage(
      {Key key, @required this.name, @required UserRepository userRepository})
      : assert(userRepository != null),
        _userRepository = userRepository,
        super(key: key);

  @override
  _FriendsPageState createState() => _FriendsPageState();
}

class _FriendsPageState extends State<FriendsPage>
    with TickerProviderStateMixin {
  User _user = GetIt.I.get<User>();
  Signaling _signaling = GetIt.I.get<Signaling>();
  final AppBarController appBarController = AppBarController();
  RandomParticleBehaviour _particleBehaviour = new RandomParticleBehaviour();
  ParticleOptions _particleOptions =
      new ParticleOptions(baseColor: myAccentColor);

  @override
  void initState() {
    super.initState();
    widget._userRepository.getFollows();
    _user.player = '';
    _user.adversary = '';
    _particleBehaviour.options = _particleOptions;
  }

  Future<void> unFollow(String name) async {
    widget._userRepository.unfollowTo(name);
  }

  bool isFollower(List<dynamic> follows) {
    final result = follows.where((item) => item == _user.uid).toList();
    if (result.length == 0) {
      return true;
    } else {
      return false;
    }
  }

  void logOut() {
    _signaling.emit('logout', _user.displayName);
    BlocProvider.of<AuthenticationBloc>(context).add(LoggedOut());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: <Widget>[
          // List
          AnimatedBackground(
            behaviour: _particleBehaviour,
            vsync: this,
            child: Container(
              child: StreamBuilder(
                stream: widget._userRepository.usersStream,
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return Center(
                      child: CircularProgressIndicator(
                        valueColor:
                            AlwaysStoppedAnimation<Color>(Colors.purple),
                      ),
                    );
                  } else {
                    return ListView.builder(
                      padding: EdgeInsets.all(7.0),
                      itemBuilder: (context, index) => (snapshot
                                  .data.documents[index]['uid'] ==
                              _user.uid)
                          ? SizedBox.shrink()
                          : Container(
                              margin: EdgeInsets.all(2),
                              padding: EdgeInsets.all(3),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: <Widget>[
                                  Container(
                                    decoration: BoxDecoration(
                                      boxShadow: [
                                        BoxShadow(
                                          offset: const Offset(0.0, 0.0),
                                          blurRadius: 50.0,
                                          spreadRadius: 1.0,
                                          color: myAccentColor,
                                        )
                                      ],
                                    ),
                                    child: FlatButton(
                                      shape: new RoundedRectangleBorder(
                                          borderRadius:
                                              new BorderRadius.circular(70.0)),
                                      padding: EdgeInsets.all(10),
                                      color: Colors.white,
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: <Widget>[
                                          Stack(
                                            alignment: Alignment.bottomLeft,
                                            children: <Widget>[
                                              Container(
                                                decoration: BoxDecoration(
                                                    color: myPrimaryColor,
                                                    shape: BoxShape.circle),
                                                padding: EdgeInsets.all(3),
                                                child: ClipRRect(
                                                  borderRadius:
                                                      BorderRadius.circular(25),
                                                  child: Image.network(
                                                    snapshot.data
                                                            .documents[index]
                                                        ['photoUrl'],
                                                    width: 50,
                                                  ),
                                                ),
                                              ),
                                              snapshot.data.documents[index]
                                                      ['isActive']
                                                  ? Container(
                                                      decoration: BoxDecoration(
                                                          color: Colors.white,
                                                          shape:
                                                              BoxShape.circle),
                                                      padding:
                                                          EdgeInsets.all(3),
                                                      child: Container(
                                                        decoration:
                                                            BoxDecoration(
                                                                color: Colors
                                                                    .greenAccent,
                                                                shape: BoxShape
                                                                    .circle),
                                                        width: 25 / 2,
                                                        height: 25 / 2,
                                                      ),
                                                    )
                                                  : Container(
                                                      width: 0.0,
                                                      height: 0.0,
                                                    ),
                                            ],
                                          ),
                                          Expanded(
                                            child: Container(
                                              padding: EdgeInsets.symmetric(
                                                  horizontal: 10),
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.start,
                                                children: <Widget>[
                                                  CupertinoButton(
                                                      onPressed: () => unFollow(
                                                          snapshot.data
                                                                      .documents[
                                                                  index]
                                                              ['displayName']),
                                                      padding:
                                                          EdgeInsets.all(0),
                                                      child: (isFollower(snapshot
                                                                  .data
                                                                  .documents[
                                                              index]['follows']))
                                                          ? SizedBox(
                                                              width: 0,
                                                              height: 0,
                                                            )
                                                          : Icon(
                                                              Icons
                                                                  .remove_circle_outline,
                                                              color: Colors.red,
                                                              size: 30,
                                                            )),
                                                  Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: <Widget>[
                                                      Text(
                                                        snapshot.data.documents[
                                                                index]
                                                            ['displayName'],
                                                        style: GoogleFonts.griffy(
                                                            color:
                                                                myPrimaryColor,
                                                            fontSize: 18),
                                                      ),
                                                      Text(
                                                        'Potions: ${snapshot.data.documents[index]['wins']}',
                                                        style:
                                                            GoogleFonts.griffy(
                                                                color: Theme.of(
                                                                        context)
                                                                    .accentColor,
                                                                fontSize: 16),
                                                      )
                                                    ],
                                                  ),
                                                  SizedBox(
                                                    width: 40,
                                                  ),
                                                  snapshot.data.documents[index]
                                                          ['isActive']
                                                      ? snapshot.data.documents[
                                                                      index]
                                                                  ['player'] ==
                                                              ''
                                                          ? Image(
                                                              image: AssetImage(
                                                                  "assets/boton-de-play.png"),
                                                              width: 35,
                                                            )
                                                          : Column(
                                                              children: <
                                                                  Widget>[
                                                                Image(
                                                                  image: AssetImage(
                                                                      "assets/magia.png"),
                                                                  width: 35,
                                                                ),
                                                                Text(
                                                                  'Ocupado',
                                                                  style: GoogleFonts
                                                                      .griffy(),
                                                                  textScaleFactor:
                                                                      1,
                                                                )
                                                              ],
                                                            )
                                                      : Container(
                                                          width: 0.0,
                                                          height: 0.0,
                                                        ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                      onPressed: () {
                                        if (snapshot.data.documents[index]
                                                ['isActive'] &&
                                            snapshot.data.documents[index]
                                                    ['player'] ==
                                                '') {
                                          _user.adversary = snapshot.data
                                              .documents[index]['displayName'];
                                          _signaling.emit(
                                              'request',
                                              snapshot.data.documents[index]
                                                  ['displayName']);
                                          BlocProvider.of<GameBloc>(context)
                                              .add(EWait());
                                        }
                                      },
                                    ),
                                  ),
                                ],
                              )),
                      itemCount: snapshot.data.documents.length,
                    );
                  }
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}