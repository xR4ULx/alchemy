import 'package:alchemy/providers/users_provider.dart';
import 'package:alchemy/utils/fire_service.dart';
import 'package:alchemy/widgets/user_widget.dart';
import 'package:animated_background/animated_background.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get_it/get_it.dart';


class RootPage extends StatefulWidget {

  RootPage({Key key}) : super(key: key);

  @override
  _RootPageState createState() => _RootPageState();
}

class _RootPageState extends State<RootPage> with TickerProviderStateMixin{

  FirebaseService _fs;
  final _usersProvider = new UsersProvider();

  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    _fs = GetIt.I.get<FirebaseService>();
    _usersProvider.getAllUsers();
  }

  Future<bool> onBackPress() {

     AwesomeDialog(
          context: context,
          headerAnimationLoop: false,
          dialogType: DialogType.INFO,
          animType: AnimType.SCALE,
          title: 'Hey ${_fs.user.displayName}',
          desc: '¿Desea salir de 4lchemy?',
          btnCancelOnPress: () {
            Navigator.pop(context, false);
            return Future.value(false);
          },
          btnOkOnPress: () {
            _fs.handleSignOut(context);
            SystemChannels.platform.invokeMethod('SystemNavigator.pop');
            return Future.value(true);
          })
        ..show();

    
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.exit_to_app),
            onPressed: () {
              onBackPress();
              /*
              showSearch(
                context: context,
                delegate: UserSearch(),
              );
              */
            },
          )
        ],
      ),
      body: WillPopScope(
        child: Stack(
          children: <Widget>[
            // List
            AnimatedBackground(
              behaviour: RandomParticleBehaviour(),
              vsync: this,
                child: Container(
                child: StreamBuilder(
                  stream: _usersProvider.usersStream,
                  //Firestore.instance.collection('users').snapshots(),
                  builder: (context, snapshot) {
                    if (!snapshot.hasData) {
                      return Center(
                        child: CircularProgressIndicator(
                          valueColor: AlwaysStoppedAnimation<Color>(Colors.purple),
                        ),
                      );
                    } else {
                      return ListView.builder(
                        padding: EdgeInsets.all(10.0),
                        itemBuilder: (context, index) =>
                            buildUser(context, snapshot.data.documents[index]),
                        itemCount: snapshot.data.documents.length,
                      );
                    }
                  },
                ),
              ),
            ),
            // Loading
            Positioned(
              child: isLoading
                  ? Container(
                child: Center(
                  child: CircularProgressIndicator(
                      valueColor:
                      AlwaysStoppedAnimation<Color>(Colors.deepPurple)),
                ),
                color: Colors.white.withOpacity(0.8),
              )
                  : Container(),
            )
          ],
        ),
        onWillPop: onBackPress,
      ),
    );
  }


}
