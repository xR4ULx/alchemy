import 'package:alchemy/src/bloc/authentication_bloc/bloc.dart';
import 'package:alchemy/src/bloc/game_bloc/bloc.dart';
import 'package:alchemy/src/repository/user_model.dart';
import 'package:alchemy/src/repository/user_repository.dart';
import 'package:alchemy/src/ui/game/friends_page.dart';
import 'package:alchemy/src/ui/game/game_page.dart';
import 'package:alchemy/src/ui/game/home_page.dart';
import 'package:alchemy/src/ui/game/request_page.dart';
import 'package:alchemy/src/ui/game/wait_page.dart';
import 'package:alchemy/src/util/signaling.dart';
import 'package:bubble_bottom_bar/bubble_bottom_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:simple_search_bar/simple_search_bar.dart';

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
  int _currentIndex;
  final AppBarController appBarController = AppBarController();
  User _user = GetIt.I.get<User>();
  Signaling _signaling = GetIt.I.get<Signaling>();

  @override
  void initState() {
    super.initState();
    _currentIndex = 1;
  }

  void logOut() {
    _signaling.emit('logout', _user.displayName);
    BlocProvider.of<AuthenticationBloc>(context).add(LoggedOut());
  }

  void changePage(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  Widget searchBar() {
    return SearchAppBar(
        primary: Theme.of(context).primaryColor,
        appBarController: appBarController,
        // You could load the bar with search already active
        autoSelected: false,
        searchHint: "Indique usuario...",
        mainTextColor: Colors.white,
        onChange: (String value) {
          //Your function to filter list. It should interact with
          //the Stream that generate the final list
          setState(() {
            widget._userRepository.searchUsers(value);
          });
        },
        //Will show when SEARCH MODE wasn't active
        mainAppBar: AppBar(
          title: Text("4lchemy"),
          actions: <Widget>[
            InkWell(
              child: Icon(
                Icons.search,
              ),
              onTap: () {
                //This is where You change to SEARCH MODE. To hide, just
                //add FALSE as value on the stream
                appBarController.stream.add(true);
              },
            ),
          ],
        ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: searchBar(),
      body: BlocProvider<GameBloc>(
        create: (context) => GameBloc(),
        child: BlocBuilder<GameBloc, GameState>(
          builder: (context, state) {
            if (state is SHome) {
              if (_currentIndex == 0) {
                return HomePage(
                    name: widget.name, userRepository: widget._userRepository);
              } else {
                return FriendsPage(
                    name: widget.name, userRepository: widget._userRepository);
              }
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
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          logOut();
        },
        backgroundColor: Colors.redAccent,
        child: Icon(Icons.cloud_off),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
      bottomNavigationBar: BubbleBottomBar(
        hasNotch: true,
        fabLocation: BubbleBottomBarFabLocation.end,
        opacity: .2,
        currentIndex: _currentIndex,
        onTap: changePage,
        borderRadius: BorderRadius.vertical(
            top: Radius.circular(
                16)), //border radius doesn't work when the notch is enabled.
        elevation: 8,
        items: <BubbleBottomBarItem>[
          BubbleBottomBarItem(
              backgroundColor: Colors.blueAccent,
              icon: Icon(
                Icons.supervised_user_circle,
                color: Colors.black,
              ),
              activeIcon: Icon(
                Icons.supervised_user_circle,
                color: Colors.blueAccent,
              ),
              title: Text("All")),
          BubbleBottomBarItem(
              backgroundColor: Colors.blueAccent,
              icon: Icon(
                Icons.face,
                color: Colors.black,
              ),
              activeIcon: Icon(
                Icons.face,
                color: Colors.blueAccent,
              ),
              title: Text("Friends")),
        ],
      ),
    );
  }
}
