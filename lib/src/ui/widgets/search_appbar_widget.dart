
import 'package:alchemy/src/services/wizard.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:simple_search_bar/simple_search_bar.dart';
import 'package:alchemy/src/ui/widgets/widgets.dart';

class SearchAppBarWidget extends StatefulWidget implements PreferredSizeWidget{

  final AppBarController appBarController;
  final Wizard wizard;

  const SearchAppBarWidget({@required this.appBarController, @required this.wizard});

  @override
  _SearchAppBarWidgetState createState() => _SearchAppBarWidgetState();

  @override
  // TODO: implement preferredSize
  Size get preferredSize => const Size(double.infinity, kToolbarHeight);
}

class _SearchAppBarWidgetState extends State<SearchAppBarWidget> {
  
  Wizard blink(){
    return widget.wizard;
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }
  
  @override
  Widget build(BuildContext context) {
    return SearchAppBar(
        primary: Theme.of(context).primaryColor,
        appBarController: widget.appBarController,
        // You could load the bar with search already active
        autoSelected: false,
        searchHint: "Indique usuario...",
        mainTextColor: Colors.white,
        onChange: (String value) {
          //Your function to filter list. It should interact with
          //the Stream that generate the final list
          //setState(() {
            blink().userRepository.searchUsers(value);
          //});
        },
        //Will show when SEARCH MODE wasn't active
        mainAppBar: AppBar(
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Image(
                  alignment: Alignment.centerLeft,
                  color: Colors.white,
                  image: AssetImage("assets/textamber.png"),
                  width: MediaQuery.of(context).size.width / 6,
                ),
              AvatarWidget(photoUrl: blink().user.photoUrl),
              Row(children: <Widget>[
                Image(
                      image: AssetImage("assets/p1.png"),
                      width: 30,
                    ),
            Text(
            blink().user.wins == null ? "x0" : "x${blink().user.wins}",
            style: GoogleFonts.griffy(color: Colors.white),
            textScaleFactor: 1.2,
          ),
              ],),
            ],),
          
        
          actions: <Widget>[
            InkWell(
              child: Icon(
                Icons.search,
              ),
              onTap: () {
                //This is where You change to SEARCH MODE. To hide, just
                //add FALSE as value on the stream
                widget.appBarController.stream.add(true);
              },
            ),
          ],
        ));
  }
}