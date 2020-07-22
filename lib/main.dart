import 'package:alchemy/src/bloc/authentication_bloc/authentication_bloc.dart';
import 'package:alchemy/src/bloc/authentication_bloc/authentication_event.dart';
import 'package:alchemy/src/bloc/authentication_bloc/authentication_state.dart';
import 'package:alchemy/src/bloc/simple_bloc_delegate.dart';
import 'package:alchemy/src/repository/user_model.dart';
import 'package:alchemy/src/repository/user_repository.dart';
import 'package:alchemy/src/ui/login/login_screen.dart';
import 'package:alchemy/src/ui/root_page.dart';
import 'package:alchemy/src/ui/splash_screen.dart';
import 'package:alchemy/src/util/colors.dart';
import 'package:alchemy/src/util/signaling.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';

GetIt getIt = GetIt.instance;

void setupSingletons() async {
  getIt.registerLazySingleton<User>(() => User());
  getIt.registerLazySingleton<Signaling>(() => Signaling());
  getIt.registerLazySingleton<UserRepository>(() => UserRepository());
}

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  BlocSupervisor.delegate = SimpleBlocDelegate();

  setupSingletons();

  final UserRepository userRepository = GetIt.I.get<UserRepository>();

  runApp(BlocProvider(
    create: (context) =>
        AuthenticationBloc(userRepository: userRepository)..add(AppStarted()),
    child: App(userRepository: userRepository),
  ));
}

class App extends StatefulWidget {
  final UserRepository _userRepository;

  App({Key key, @required UserRepository userRepository})
      : assert(userRepository != null),
        _userRepository = userRepository,
        super(key: key);

  @override
  _AppState createState() => _AppState();
}

class _AppState extends State<App> with WidgetsBindingObserver {
  User _user = GetIt.I.get<User>();
  Signaling _signaling = GetIt.I.get<Signaling>();

  @override
  void initState() {
    super.initState();
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp,]);
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    switch (state) {
      case AppLifecycleState.resumed:
        print('##### RESUMED ####');
        if (_user != null) {
          widget._userRepository.setActive(true);
        }
        break;
      case AppLifecycleState.detached:
        print('#### DETACHED ####');
        if (_user != null) {
          widget._userRepository.setActive(false);
        }
        break;
      case AppLifecycleState.inactive:
        print('#### INACTIVE ####');
        if (_user != null) {
          widget._userRepository.setActive(false);
        }
        break;
      case AppLifecycleState.paused:
        print('#### PAUSED ####');
        if (_user != null) {
          widget._userRepository.setActive(false);
        }
        break;
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
          primaryColor: myPrimaryColor,
          accentColor: myAccentColor,
          primaryColorLight: Colors.amber),
      home: BlocBuilder<AuthenticationBloc, AuthenticationState>(
        builder: (context, state) {
          if (state is Uninitialized) {
            return SplashScreen();
          }
          if (state is Authenticated) {
            _signaling.emit('login', _user.displayName);
            return RootPage(
                name: state.displayName,
                userRepository: widget._userRepository);
          }
          if (state is Unauthenticated) {
            return LoginScreen(
              userRepository: widget._userRepository,
            );
          }
          return Container();
        },
      ),
    );
  }
}
