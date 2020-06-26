
import 'package:alchemy/utils/fire_service.dart';
import 'package:animated_background/animated_background.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:google_fonts/google_fonts.dart';

class LoginPage extends StatefulWidget {
  LoginPage({Key key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> with TickerProviderStateMixin{

  bool isLoading = false;
  bool isLoggedIn = false;
  bool loginCorrect = false;
  FirebaseService _fs;
  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _fs = GetIt.I.get<FirebaseService>();
    isSignedIn();
  }

  void isSignedIn() async {
    this.setState(() {
      isLoading = true;
    });

    isLoggedIn = await _fs.isSignIn();

    if (isLoggedIn) {
      Navigator.of(context).pushReplacementNamed('/root');
    }

    this.setState(() {
      isLoading = false;
    });
  }

    void showSnack(
      GlobalKey<ScaffoldState> key, BuildContext context, String mensaje) {
    final snackbar = SnackBar(
      content: Text(mensaje),
      backgroundColor: Theme.of(context).primaryColorLight,
      duration: Duration(milliseconds: 1500),
    );

    key.currentState.showSnackBar(snackbar);
  }

    Future<Null> handleSignIn() async {
    this.setState(() {
      isLoading = true;
    });

    loginCorrect = await _fs.handleSignIn();

    if (loginCorrect) {
      showSnack(scaffoldKey, context, "Sign in correcto");

      this.setState(() {
        isLoading = false;
      });

      Navigator.of(context).pushReplacementNamed('/root');
    } else {
      showSnack(scaffoldKey, context, "Sign in falló");

      this.setState(() {
        isLoading = false;
      });
    }
  }

  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: AnimatedBackground(
            behaviour: RandomParticleBehaviour(),
            vsync: this,
            child: Center(
                child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Image(
                  image: AssetImage("assets/pocion.png"),
                  width: MediaQuery.of(context).size.width / 1.7,
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.02,
                ),
                Text(
                  '4lchemy',
                  style: GoogleFonts.griffy(),
                  textScaleFactor: 5,
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.05,
                ),
                OutlineButton(
                  shape: StadiumBorder(
                      side: BorderSide(
                          color: Colors.black,
                          width: 2,
                          style: BorderStyle.solid)),
                  child: Text(
                    'Sign in with Google',
                    style: GoogleFonts.griffy(color: Colors.black),
                    textScaleFactor: 2,
                  ),
                  onPressed: () {
                    handleSignIn();
                  },
                )
              ],
            ))) // This trailing comma makes auto-formatting nicer for build methods.
        );
  }
}