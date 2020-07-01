

import 'package:alchemy/src/bloc/authentication_bloc/authentication_bloc.dart';
import 'package:alchemy/src/bloc/authentication_bloc/authentication_event.dart';
import 'package:alchemy/src/bloc/authentication_bloc/authentication_state.dart';
import 'package:alchemy/src/bloc/simple_bloc_delegate.dart';
import 'package:alchemy/src/repository/user_model.dart';
import 'package:alchemy/src/repository/user_repository.dart';
import 'package:alchemy/src/ui/home_screen.dart';
import 'package:alchemy/src/ui/login/login_screen.dart';
import 'package:alchemy/src/ui/splash_screen.dart';
import 'package:alchemy/src/util/signaling.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';

GetIt getIt = GetIt.instance;

void setupSingletons() async {
  getIt.registerLazySingleton<User>(() => User());
  getIt.registerLazySingleton<Signaling>(() => Signaling());
}
void main() {
  WidgetsFlutterBinding.ensureInitialized();
  BlocSupervisor.delegate = SimpleBlocDelegate();

  setupSingletons();

  final UserRepository userRepository = UserRepository();
  runApp(
    BlocProvider(
      create: (context) => AuthenticationBloc(userRepository: userRepository)
        ..add(AppStarted()),
      child: App(userRepository: userRepository),
    )
  );
}

class App extends StatelessWidget {
  final UserRepository _userRepository;

  App({Key key, @required UserRepository userRepository})
    : assert (userRepository != null),
      _userRepository = userRepository,
      super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: BlocBuilder<AuthenticationBloc, AuthenticationState>(
        builder: (context, state) {
          if (state is Uninitialized) {
            return SplashScreen();
          }
          if (state is Authenticated) {
            return HomeScreen(name: state.displayName, userRepository: _userRepository);
          }
          if (state is Unauthenticated) {
            return LoginScreen(userRepository: _userRepository,);
          }
          return Container();
        },
      ),
    );
  }
}