import 'package:alchemy/src/bloc/game_bloc/bloc.dart';
import 'package:alchemy/src/repository/user_repository.dart';
import 'package:alchemy/src/ui/game/game_page.dart';
import 'package:alchemy/src/ui/game/home_page.dart';
import 'package:alchemy/src/ui/game/request_page.dart';
import 'package:alchemy/src/ui/game/wait_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class RootPage extends StatelessWidget {
  final String name;
  final UserRepository _userRepository;

  const RootPage(
      {Key key, @required this.name, @required UserRepository userRepository})
      : assert(userRepository != null),
        _userRepository = userRepository,
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: BlocProvider<GameBloc>(
          create: (context) => GameBloc(),
          child: BlocBuilder<GameBloc, GameState>(
            builder: (context, state) {
              if (state is SHome) {
                return HomePage(name: name, userRepository: _userRepository);
              }
              if (state is SWait) {
                return WaitPage();
              }
              if (state is SRequest) {
                return RequestPage();
              }
              if (state is SGame) {
                return Game();
              }
            },
          ),
        ));
  }
}
