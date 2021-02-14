import 'package:alchemy/src/bloc/authentication_bloc/bloc.dart';
import 'package:alchemy/src/bloc/login_bloc/bloc.dart';
import 'package:animated_background/animated_background.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';

import 'google_login_button.dart';

class LoginForm extends StatefulWidget {
  LoginForm({Key key, y});

  @override
  _LoginFormState createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm>
    with SingleTickerProviderStateMixin {
  RandomParticleBehaviour _particleBehaviour = new RandomParticleBehaviour();
  ParticleOptions _particleOptions =
      new ParticleOptions(baseColor: Color(0xFF70DCA9));

  @override
  void initState() {
    super.initState();
    _particleBehaviour.options = _particleOptions;
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<LoginBloc, LoginState>(listener: (context, state) {
      // tres casos, tres if:
      if (state.isFailure) {
        Scaffold.of(context)
          ..hideCurrentSnackBar()
          ..showSnackBar(
            SnackBar(
              content: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [Text('Login Failure'), Icon(Icons.error)],
              ),
              backgroundColor: Colors.red,
            ),
          );
      }
      if (state.isSubmitting) {
        Scaffold.of(context)
          ..hideCurrentSnackBar()
          ..showSnackBar(SnackBar(
            content: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text('Logging in... '),
                CircularProgressIndicator(),
              ],
            ),
          ));
      }
      if (state.isSuccess) {
        BlocProvider.of<AuthenticationBloc>(context).add(LoggedIn());
      }
    }, child: BlocBuilder<LoginBloc, LoginState>(
      builder: (context, state) {
        return AnimatedBackground(
            behaviour: _particleBehaviour,
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
                  style: GoogleFonts.griffy(color: Colors.white),
                  textScaleFactor: 5,
                ),
                Padding(
                  padding: const EdgeInsets.all(18.0),
                  child: GoogleLoginButton(),
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.05,
                ),
                Image(
                  alignment: Alignment.centerLeft,
                  image: AssetImage("assets/text.png"),
                  width: MediaQuery.of(context).size.width / 2.7,
                ),
              ],
            )));
      },
    ));
  }

  @override
  void dispose() {
    super.dispose();
  }
}
