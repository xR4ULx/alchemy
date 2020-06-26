
import 'package:alchemy/pages/login_page.dart';
import 'package:alchemy/pages/root_page.dart';
import 'package:alchemy/utils/fire_service.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

GetIt locator = GetIt.instance;

void setupSingletons() async {
  locator.registerLazySingleton<FirebaseService>(() => FirebaseService());
}

void main() {
  setupSingletons();
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  // This widget is the root of your application.
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {

  FirebaseService _fs;
  Widget _defaultRoute = new LoginPage();

  @override
  void initState() {
    super.initState();
    WidgetsFlutterBinding.ensureInitialized();
    _fs = GetIt.I.get<FirebaseService>();
    _fs.initPreferences();
    isSignedIn();
  }

  void isSignedIn() async {
    final isLoggedIn = await _fs.isSignIn();
    if (isLoggedIn) {
      _defaultRoute = new RootPage();
      _fs.handleSignIn();
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'alchemy',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      routes: {
        '/signUp': (BuildContext context) => LoginPage(),
        '/root': (BuildContext context) => RootPage(),
      },
      home: _defaultRoute,
    );
  }
}


