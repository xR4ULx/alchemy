import 'dart:ui';
import 'package:animated_background/animated_background.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:alchemy/src/services/wizard.dart';

//Mis Widgets
import 'package:alchemy/src/ui/widgets/widgets.dart';

class FriendsPage extends StatefulWidget {
  final String name;
  final Wizard wizard;

  FriendsPage({Key key, @required this.name, @required this.wizard});

  @override
  _FriendsPageState createState() => _FriendsPageState();
}

class _FriendsPageState extends State<FriendsPage> {
  Wizard blink() {
    return widget.wizard;
  }

  @override
  void initState() {
    super.initState();
    blink().userRepository.getFollows();
    blink().user.player = '';
    blink().user.adversary = '';
    blink().user.avisos = [""];
    blink().userRepository.updateUser();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: <Widget>[
          // List
          Container(
            child: StreamBuilder(
              stream: blink().userRepository.usersStream,
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return Center(
                    child: CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.purple),
                    ),
                  );
                } else {
                  return ListView.builder(
                    padding: EdgeInsets.all(0.5),
                    itemBuilder: (context, index) =>
                        (snapshot.data.documents[index]['uid'] ==
                                blink().user.uid)
                            ? Container()
                            : UserWidget(
                                snapshot: snapshot,
                                index: index,
                                wizard: blink(),
                                follows: true,
                              ),
                    itemCount: snapshot.data.documents.length,
                  );
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
