import 'package:alchemy/src/bloc/authentication_bloc/bloc.dart';
import 'package:alchemy/src/ui/users/friends_page.dart';
import 'package:alchemy/src/ui/users/people_page.dart';
import 'package:bubble_bottom_bar/bubble_bottom_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:simple_search_bar/simple_search_bar.dart';
import 'package:alchemy/src/services/wizard.dart';
import 'package:alchemy/src/ui/widgets/widgets.dart';

class UsersPage extends StatefulWidget {
  final String name;
  final Wizard wizard;

  UsersPage(
      {Key key, @required this.name, @required this.wizard});
  @override
  _UsersPageState createState() => _UsersPageState();
}

class _UsersPageState extends State<UsersPage> {

  int _currentIndex;
  final List<Widget> _children = [];
  final AppBarController appBarController = AppBarController();

  Wizard blink(){
    return widget.wizard;
  }

  @override
  void initState() {
    super.initState();
    blink().userRepository.setActive(true);
    _currentIndex = 0;
    _children.add(PeoplePage(
      name: widget.name,
      wizard: blink(),
    ));
    _children.add(
        FriendsPage(name: widget.name, wizard: blink()));
  }

  void logOut() {
    blink().signaling.emit('logout', blink().user.displayName);
    BlocProvider.of<AuthenticationBloc>(context).add(LoggedOut());
  }

  void changePage(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: SearchAppBarWidget(appBarController: appBarController,wizard: widget.wizard),
      body: _children[_currentIndex],
      floatingActionButton: Container(
          decoration: BoxDecoration(
            boxShadow: [
              BoxShadow(
                offset: const Offset(0.4, 0.4),
                blurRadius: 25,
                spreadRadius: 2,
                color: Theme.of(context).accentColor,
              )
            ],
          ),
          child: FloatingActionButton(
            onPressed: () {
              logOut();
            },
            backgroundColor: Theme.of(context).primaryColor,
            child: Icon(
              Icons.exit_to_app,
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
                15)), //border radius doesn't work when the notch is enabled.
        elevation: 3,
        items: <BubbleBottomBarItem>[
          BubbleBottomBarItem(
              backgroundColor: Colors.transparent,
              icon: Icon(
                Icons.supervised_user_circle,
                color: Colors.white,
              ),
              activeIcon: Icon(
                Icons.supervised_user_circle,
                color: Colors.white
              ),
              title: Text(
                "Usuarios",
                style: GoogleFonts.openSans(color: Colors.white),
                textScaleFactor: 1.2,
              )),
          BubbleBottomBarItem(
              backgroundColor: Colors.transparent,
              icon: Icon(
                Icons.favorite_border,
                color: Colors.tealAccent,
              ),
              activeIcon: Icon(
                Icons.favorite_border,
                color: Colors.tealAccent,
              ),
              title: Text(
                "Favoritos",
                style: GoogleFonts.openSans(color: Colors.tealAccent),
                textScaleFactor: 1.2,
              )),
        ],
      ),
    );
  }
}
