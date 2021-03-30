import 'package:alchemy/src/bloc/login_bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_auth_buttons/flutter_auth_buttons.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class GoogleLoginButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {

    return ElevatedButton.icon(
      label: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Text(
          'SIGN IN WITH GOOGLE',
          style: TextStyle(fontSize: 18),
        ),
      ),
      style: ElevatedButton.styleFrom(
        primary: Theme.of(context).primaryColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30.0),
        ),
      ),
      icon: const Icon(FontAwesomeIcons.google,
          color: Colors.white),
      onPressed: () {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text('Loggin in...'),
                CircularProgressIndicator(),
              ],
            )));
        BlocProvider.of<LoginBloc>(context).add(LoginWithGooglePressed());
      }
    );
  }
}
