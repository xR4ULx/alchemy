import 'package:alchemy/src/bloc/authentication_bloc/bloc.dart';
import 'package:alchemy/src/ui/users/people_page.dart';
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
    blink().userRepository.setActive(true);
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
      body: PeoplePage(
        name: widget.name,
        wizard: blink(),
      ),
    );
  }
}
