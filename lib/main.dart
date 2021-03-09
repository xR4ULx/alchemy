import 'package:alchemy/src/bloc/authentication_bloc/authentication_bloc.dart';
import 'package:alchemy/src/bloc/authentication_bloc/authentication_event.dart';
import 'package:alchemy/src/bloc/authentication_bloc/authentication_state.dart';
import 'package:alchemy/src/bloc/simple_bloc_delegate.dart';
import 'package:alchemy/src/ui/login/login_screen.dart';
import 'package:alchemy/src/ui/root_page.dart';
import 'package:alchemy/src/ui/splash_screen.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';

import 'package:alchemy/src/services/wizard.dart';

//import 'generated_plugin_registrant.dart';

GetIt getIt = GetIt.instance;

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  BlocSupervisor.delegate = SimpleBlocDelegate();
  getIt.registerLazySingleton<Wizard>(() => Wizard());

  runApp(BlocProvider(
    create: (context) => AuthenticationBloc(wizard: GetIt.I.get<Wizard>())..add(AppStarted()),
    child: App(wizard: GetIt.I.get<Wizard>()),
  ));
}

class App extends StatefulWidget {

  final Wizard wizard;

  App({Key key, @required this.wizard});

  @override
  _AppState createState() => _AppState();
}

class _AppState extends State<App> with WidgetsBindingObserver {
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
        if (widget.wizard.user != null) {
          widget.wizard.userRepository.setActive(true);
        }
        break;
      case AppLifecycleState.detached:
        print('#### DETACHED ####');
        if (widget.wizard.user != null) {
          widget.wizard.userRepository.setActive(false);
        }
        break;
      case AppLifecycleState.inactive:
        print('#### INACTIVE ####');
        if (widget.wizard.user != null) {
          widget.wizard.userRepository.setActive(false);
        }
        break;
      case AppLifecycleState.paused:
        print('#### PAUSED ####');
        if (widget.wizard.user != null) {
          widget.wizard.userRepository.setActive(false);
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
          primaryColor: Color(0xFF1D1E33),
          accentColor: Color(0xFF70DCA9),
          primaryColorLight: Color(0xffCD7A2F),
      ),
      home: BlocBuilder<AuthenticationBloc, AuthenticationState>(
        builder: (context, state) {

          if (state is Authenticated) {
            return RootPage(name: state.displayName, wizard: widget.wizard);
          }else if (state is Unauthenticated) {
            return LoginScreen(wizard: widget.wizard,);
          }else{
            return SplashScreen();
          }
        },
      ),
    );
  }
}
