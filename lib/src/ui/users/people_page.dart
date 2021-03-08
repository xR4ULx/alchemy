
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:alchemy/src/services/wizard.dart';

//Mis Widgets
import 'package:alchemy/src/ui/widgets/widgets.dart';

class PeoplePage extends StatefulWidget {
  final String name;
  final Wizard wizard;

  PeoplePage({Key key, @required this.name, @required this.wizard});

  @override
  _PeoplePageState createState() => _PeoplePageState();
}

class _PeoplePageState extends State<PeoplePage> {
  Wizard blink() {
    return widget.wizard;
  }

  @override
  void initState() {
    super.initState();
    blink().userRepository.getAllUsers();
    blink().user.player = '';
    blink().user.adversary = '';
    blink().user.avisos = [""];
    blink().userRepository.updateUser();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
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
                      valueColor: AlwaysStoppedAnimation<Color>(Theme.of(context).accentColor),
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
                                follows: false,
                                notRead: blink().userRepository.getNotRead(blink().user.uid, snapshot.data.documents[index]['uid']),
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
