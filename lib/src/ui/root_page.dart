import 'package:alchemy/src/bloc/game_bloc/bloc.dart';
import 'package:alchemy/src/services/wizard.dart';
import 'package:alchemy/src/ui/game/game_page.dart';
import 'package:alchemy/src/ui/game/request_page.dart';
import 'package:alchemy/src/ui/game/wait_page.dart';
import 'package:alchemy/src/ui/messages/messages_page.dart';
import 'package:alchemy/src/ui/users/users_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/game_bloc/bloc.dart';

class RootPage extends StatefulWidget {
  final String name;
  final Wizard wizard;

  const RootPage({Key key, @required this.name, @required this.wizard});

  @override
  _RootPageState createState() => _RootPageState();
}

class _RootPageState extends State<RootPage> {
  Wizard blink() {
    return widget.wizard;
  }

  @override
  void initState() {
    super.initState();
    blink().notifications.registerNotification();
    blink().notifications.configLocalNotification();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocProvider<GameBloc>(
        create: (context) => GameBloc(),
        child: BlocBuilder<GameBloc, GameState>(
          // ignore: missing_return
          builder: (context, state) {
            if (state is SHome) {
              return UsersPage(name: widget.name, wizard: blink());
            }
            if (state is SWait) {
              return WaitPage(wizard: blink());
            }
            if (state is SRequest) {
              return RequestPage(wizard: blink());
            }
            if (state is SGame) {
              return Game(wizard: blink());
            }
            if (state is SChat) {
              return Messages(
                  peerId: state.peerId,
                  peerAvatar: state.peerAvatar,
                  wizard: blink());
            }
          },
        ),
      ),
    );
  }
}
