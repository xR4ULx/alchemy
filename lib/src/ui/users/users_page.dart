import 'package:alchemy/src/bloc/authentication_bloc/bloc.dart';
import 'package:alchemy/src/repository/user_model.dart';
import 'package:alchemy/src/repository/user_repository.dart';
import 'package:alchemy/src/ui/users/friends_page.dart';
import 'package:alchemy/src/ui/users/people_page.dart';
import 'package:alchemy/src/util/signaling.dart';
import 'package:bubble_bottom_bar/bubble_bottom_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:simple_search_bar/simple_search_bar.dart';
import 'package:alchemy/src/util/colors.dart';

class UsersPage extends StatefulWidget {
  final String name;
  final UserRepository _userRepository;

  UsersPage(
      {Key key, @required this.name, @required UserRepository userRepository})
      : assert(userRepository != null),
        _userRepository = userRepository,
        super(key: key);
  @override
  _UsersPageState createState() => _UsersPageState();
}

class _UsersPageState extends State<UsersPage> {
  int _currentIndex;
  final List<Widget> _children = [];
  final AppBarController appBarController = AppBarController();
  User _user = GetIt.I.get<User>();
  Signaling _signaling = GetIt.I.get<Signaling>();

  @override
  void initState() {
    super.initState();
    widget._userRepository.setActive(true);
    _currentIndex = 1;
    _children.add(PeoplePage(
      name: widget.name,
      userRepository: widget._userRepository,
    ));
    _children.add(
        FriendsPage(name: widget.name, userRepository: widget._userRepository));
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
          title: Text(
            "4lchemy",
            style: GoogleFonts.griffy(color: Colors.amber),
            textScaleFactor: 1.5,
          ),
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
      body: _children[_currentIndex],
      floatingActionButton: Container(
          decoration: BoxDecoration(
            boxShadow: [
              BoxShadow(
                offset: const Offset(0.0, .0),
                blurRadius: 26.0,
                spreadRadius: 3.2,
                color: Colors.redAccent,
              )
            ],
          ),
          child: FloatingActionButton(
            onPressed: () {
              logOut();
            },
            backgroundColor: Colors.redAccent,
            child: Icon(
              Icons.cloud_off,
              color: Colors.white,
            ),
          )),
      floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
      bottomNavigationBar: BubbleBottomBar(
        backgroundColor: Theme.of(context).primaryColor,
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
              backgroundColor: Colors.amber,
              icon: Icon(
                Icons.home,
                color: Colors.amber,
              ),
              activeIcon: Icon(
                Icons.home,
                color: Colors.amber,
              ),
              title: Text(
                "Home",
                style: GoogleFonts.griffy(color: Colors.amber),
                textScaleFactor: 1.1,
              )),
          BubbleBottomBarItem(
              backgroundColor: Colors.redAccent,
              icon: Icon(
                Icons.favorite,
                color: Colors.redAccent,
              ),
              activeIcon: Icon(
                Icons.favorite_border,
                color: Colors.redAccent,
              ),
              title: Text(
                "Favorite",
                style: GoogleFonts.griffy(color: Colors.redAccent),
                textScaleFactor: 1.1,
              )),
        ],
      ),
    );
  }
}
