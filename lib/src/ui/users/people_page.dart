import 'package:alchemy/main.dart';
import 'package:alchemy/src/bloc/game_bloc/bloc.dart';
import 'package:alchemy/src/bloc/game_bloc/game_bloc.dart';
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

class PeoplePage extends StatefulWidget {
  final String name;
  final UserRepository _userRepository;

  PeoplePage(
      {Key key, @required this.name, @required UserRepository userRepository})
      : assert(userRepository != null),
        _userRepository = userRepository,
        super(key: key);

  @override
  _PeoplePageState createState() => _PeoplePageState();
}

class _PeoplePageState extends State<PeoplePage> with TickerProviderStateMixin {
  User _user = GetIt.I.get<User>();
  Signaling _signaling = GetIt.I.get<Signaling>();
  RandomParticleBehaviour _particleBehaviour = new RandomParticleBehaviour();
  ParticleOptions _particleOptions =
      new ParticleOptions(baseColor: myAccentColor);

  @override
  void initState() {
    super.initState();
    widget._userRepository.getAllUsers();
    _user.player = '';
    _user.adversary = '';
    _particleBehaviour.options = _particleOptions;
  }

  bool isFollower(List<dynamic> follows) {
    final result = follows.where((item) => item == _user.uid).toList();
    if (result.length == 0) {
      return true;
    } else {
      return false;
    }
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
                          ? Container()
                          : Container(
                              margin: EdgeInsets.all(2),
                              padding: EdgeInsets.all(3),
                              child: Column(
                                children: <Widget>[
                                  Container(
                                    decoration: BoxDecoration(
                                      boxShadow: [
                                        BoxShadow(
                                          offset: const Offset(0.0, .0),
                                          blurRadius: 26.0,
                                          spreadRadius: 0.2,
                                          color: myAccentColor,
                                        )
                                      ],
                                    ),
                                    child: FlatButton(
                                      shape: new RoundedRectangleBorder(
                                          borderRadius:
                                              new BorderRadius.circular(10.0)),
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
                                                    color: myAccentColor,
                                                    shape: BoxShape.circle),
                                                padding: EdgeInsets.all(1),
                                                child: ClipRRect(
                                                  borderRadius:
                                                      BorderRadius.circular(25),
                                                  child: Image.network(
                                                    snapshot.data
                                                            .documents[index]
                                                        ['photoUrl'],
                                                    width: 45,
                                                  ),
                                                ),
                                              ),
                                              snapshot.data.documents[index]
                                                      ['isActive']
                                                  ? Container(
                                                      decoration: BoxDecoration(
                                                          color: myAccentColor,
                                                          shape:
                                                              BoxShape.circle),
                                                      padding:
                                                          EdgeInsets.all(1),
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
                                                  : SizedBox.shrink(),
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
                                                      onPressed: () => {
                                                        widget._userRepository.followTo(
                                                          snapshot.data
                                                                      .documents[
                                                                  index]
                                                              ['displayName'])
                                                      },
                                                      padding:
                                                          EdgeInsets.all(0),
                                                      child: (isFollower(snapshot
                                                                  .data
                                                                  .documents[
                                                              index]['follows']))
                                                          ? Icon(
                                                              Icons
                                                                  .add_circle_outline,
                                                              color:
                                                                  Colors.green,
                                                              size: 30,
                                                            )
                                                            :SizedBox(
                                                              width: 0,
                                                              height: 0,
                                                            ))
                                                          ,
                                                  SizedBox(
                                                              width: 10,
                                                              height: 0,
                                                            ),
                                                  Column(

                                                    mainAxisAlignment:
                                                        MainAxisAlignment.end,
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
                                                                color: Colors.blue,
                                                                fontSize: 16),
                                                      )
                                                    ],
                                                  ),
                                                  Expanded(
                                                    child: Column(
                                                    mainAxisAlignment:
                                                    MainAxisAlignment.end,
                                                    children: <Widget>[
                                                    SizedBox(
                                                    width: 40,
                                                  ),
                                                  ],)),
                                                  snapshot.data.documents[index]
                                                          ['isActive']
                                                      ? snapshot.data.documents[
                                                                      index]
                                                                  ['player'] ==
                                                              ''
                                                          ? Container(
                                                              decoration:
                                                                  BoxDecoration(
                                                                boxShadow: [
                                                                  BoxShadow(
                                                                    offset:
                                                                        const Offset(
                                                                            0.0,
                                                                            .0),
                                                                    blurRadius:
                                                                        26.0,
                                                                    spreadRadius:
                                                                        0.2,
                                                                    color: Colors
                                                                        .blue,
                                                                  )
                                                                ],
                                                              ),
                                                              child: Image(
                                                                image: AssetImage(
                                                                    "assets/boton-de-play.png"),
                                                                width: 45,
                                                              ))
                                                          : Container(
                                                              decoration:
                                                                  BoxDecoration(
                                                                boxShadow: [
                                                                  BoxShadow(
                                                                    offset:
                                                                        const Offset(
                                                                            0.0,
                                                                            .0),
                                                                    blurRadius:
                                                                        26.0,
                                                                    spreadRadius:
                                                                        0.2,
                                                                    color: Colors
                                                                        .red,
                                                                  )
                                                                ],
                                                              ),
                                                              child: Column(
                                                              children: <
                                                                  Widget>[
                                                                Image(
                                                                  image: AssetImage(
                                                                      "assets/magia.png"),
                                                                  width: 45,
                                                                ),
                                                                Text(
                                                                  'Ocupado',
                                                                  style: GoogleFonts
                                                                      .griffy(),
                                                                  textScaleFactor:
                                                                      1,
                                                                )
                                                              ],
                                                            ))
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
