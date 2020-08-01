import 'package:alchemy/main.dart';
import 'package:alchemy/src/bloc/game_bloc/bloc.dart';
import 'package:alchemy/src/bloc/game_bloc/game_bloc.dart';
import 'package:alchemy/src/repository/user_model.dart';
import 'package:alchemy/src/repository/user_repository.dart';
import 'package:alchemy/src/util/colors.dart';
import 'package:alchemy/src/util/signaling.dart';
import 'package:animated_background/animated_background.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:alchemy/src/providers/messages_provider.dart';
import 'package:alchemy/src/repository/message_model.dart';

//Mis Widgets
import 'package:alchemy/src/ui/widgets/active_widget.dart';
import 'package:alchemy/src/ui/widgets/avatar_widget.dart';

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

  MessagesProvider messagesProvider;
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
    messagesProvider = new MessagesProvider();
  }

  bool isFollower(List<dynamic> follows) {
    final result = follows.where((item) => item == _user.uid).toList();
    if (result.length == 0) {
      return false;
    } else {
      return true;
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
                      padding: EdgeInsets.all(1.0),
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
                                            color: isFollower(snapshot
                                                        .data.documents[index]
                                                    ['follows'])
                                                ? Colors.tealAccent
                                                : Colors.transparent)
                                      ],
                                    ),
                                    child: FlatButton(
                                      shape: new RoundedRectangleBorder(
                                          borderRadius:
                                              new BorderRadius.circular(10.0)),
                                      padding: EdgeInsets.all(10),
                                      color: Colors.transparent,
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: <Widget>[
                                          Stack(
                                            alignment: Alignment.bottomLeft,
                                            children: <Widget>[
                                              AvatarWidget(
                                                  photoUrl: snapshot
                                                          .data.documents[index]
                                                      ['photoUrl']),
                                              ActiveWidget(
                                                  active: snapshot
                                                          .data.documents[index]
                                                      ['isActive'])
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
                                                        style: GoogleFonts
                                                            .openSans(),
                                                      ),
                                                      Text(
                                                        'Potions: ${snapshot.data.documents[index]['wins']}',
                                                        style: GoogleFonts
                                                            .openSans(),
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
                                                    ],
                                                  )),
                                                  snapshot.data.documents[index]
                                                          ['isActive']
                                                      ? snapshot.data.documents[
                                                                      index]
                                                                  ['player'] ==
                                                              ''
                                                          ? RaisedButton(
                                                              shape: RoundedRectangleBorder(
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .circular(
                                                                              18.0),
                                                                  side: BorderSide(
                                                                      color: Colors
                                                                          .red)),
                                                              onPressed: () {
                                                                if (snapshot.data
                                                                            .documents[index]
                                                                        [
                                                                        'isActive'] &&
                                                                    snapshot.data.documents[index]
                                                                            [
                                                                            'player'] ==
                                                                        '') {
                                                                  _user
                                                                      .adversary = snapshot
                                                                          .data
                                                                          .documents[index]
                                                                      [
                                                                      'displayName'];
                                                                  _signaling.emit(
                                                                      'request',
                                                                      snapshot
                                                                          .data
                                                                          .documents[index]['displayName']);
                                                                  BlocProvider.of<
                                                                              GameBloc>(
                                                                          context)
                                                                      .add(
                                                                          EWait());
                                                                }
                                                              },
                                                              color: Colors.red,
                                                              textColor:
                                                                  Colors.white,
                                                              child: Text(
                                                                  "Invitar",
                                                                  style: TextStyle(
                                                                      fontSize:
                                                                          12)),
                                                            )
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
                                                      : RaisedButton(
                                                              shape: RoundedRectangleBorder(
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .circular(
                                                                              18.0),
                                                                  side: BorderSide(
                                                                      color: Colors
                                                                          .blue)),
                                                              onPressed: () {
                                                                Message msg = new Message(
                                                                    idFrom: _user.uid,
                                                                    idTo: snapshot
                                                                          .data
                                                                          .documents[index]['uid'],
                                                                    timestamp: DateTime.now().millisecondsSinceEpoch.toString(),
                                                                    content: '¿Quieres jugar?',
                                                                    type: 0
                                                                );

                                                                messagesProvider.sendMessage(msg);
                                            
                                                              },
                                                              color: Colors.blue,
                                                              textColor:
                                                                  Colors.white,
                                                              child: Text(
                                                                  "Avisar",
                                                                  style: TextStyle(
                                                                      fontSize:
                                                                          12)),
                                                            ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                      onPressed: () {},
                                      onLongPress: () {
                                        isFollower(snapshot.data
                                                .documents[index]['follows'])
                                            ? widget._userRepository.unfollowTo(
                                                snapshot.data.documents[index]
                                                    ['displayName'])
                                            : widget._userRepository.followTo(
                                                snapshot.data.documents[index]
                                                    ['displayName']);
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
