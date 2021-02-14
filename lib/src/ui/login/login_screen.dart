//imports: 
import 'package:alchemy/src/bloc/login_bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:alchemy/src/services/wizard.dart';

import 'login_form.dart';

class LoginScreen extends StatelessWidget {
  final Wizard wizard;

  LoginScreen({Key key, @required this.wizard});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      body: BlocProvider<LoginBloc>(
        create: (context) => LoginBloc(wizard: wizard),
        child: LoginForm(),
      ),
    );
  }
}