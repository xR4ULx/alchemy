import 'package:alchemy/src/bloc/authentication_bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:simple_search_bar/simple_search_bar.dart';
import 'package:alchemy/src/services/wizard.dart';
import 'package:alchemy/src/ui/widgets/widgets.dart';

class UsersPage extends StatefulWidget {
  final String name;
  final Wizard wizard;

  UsersPage({Key key, @required this.name, @required this.wizard});
  @override
  _UsersPageState createState() => _UsersPageState();
}

class _UsersPageState extends State<UsersPage> {

  final AppBarController appBarController = AppBarController();

  Wizard blink() {
    return widget.wizard;
  }

  @override
  void initState() {
    super.initState();
    if(!widget.wizard.userRepository.userIsActive()){
      blink().userRepository.setActive(true);
    }
    blink().userRepository.getAllUsers();
    blink().user.player = '';
    blink().user.adversary = '';
    blink().user.avisos = [""];
    blink().userRepository.updateUser();
  }

  void logOut() {
    blink().signaling.emit('logout', blink().user.displayName);
    BlocProvider.of<AuthenticationBloc>(context).add(LoggedOut());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      appBar: SearchAppBarWidget(
          appBarController: appBarController, wizard: widget.wizard),
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
