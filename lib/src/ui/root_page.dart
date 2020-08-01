import 'package:alchemy/src/bloc/game_bloc/bloc.dart';
import 'package:alchemy/src/repository/user_model.dart';
import 'package:alchemy/src/repository/user_repository.dart';
import 'package:alchemy/src/ui/game/game_page.dart';
import 'package:alchemy/src/ui/game/request_page.dart';
import 'package:alchemy/src/ui/game/wait_page.dart';
import 'package:alchemy/src/ui/users/users_page.dart';
import 'package:alchemy/src/util/signaling.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';

class RootPage extends StatefulWidget {
  final String name;
  final UserRepository _userRepository;

  const RootPage(
      {Key key, @required this.name, @required UserRepository userRepository})
      : assert(userRepository != null),
        _userRepository = userRepository,
        super(key: key);

  @override
  _RootPageState createState() => _RootPageState();
}

class _RootPageState extends State<RootPage> {
  
  User _user = GetIt.I.get<User>();
  
  
  @override
  void initState() {
    super.initState();
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
              return UsersPage(
                  name: widget.name, userRepository: widget._userRepository);
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
      ),
    );
  }
}
