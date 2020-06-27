
import 'package:alchemy/pages/game_page.dart';
import 'package:alchemy/utils/fire_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

FirebaseService _fs = GetIt.I.get<FirebaseService>();

Widget buildUser(BuildContext context, DocumentSnapshot document) {
  if (document['uid'] == _fs.user.uid) {
    return Container();
  } else {
    return Container(
      margin: EdgeInsets.all(2),
      padding: EdgeInsets.all(2),
      child: FlatButton(
        shape: new RoundedRectangleBorder(borderRadius: new BorderRadius.circular(30.0)),  
        padding: EdgeInsets.all(5),
        color: Colors.transparent,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Stack(
              alignment: Alignment.bottomLeft,
              children: <Widget>[
                CupertinoButton(
                  onPressed: () {},
                  padding: EdgeInsets.all(10),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(25),
                    child: Image.network(
                      document['photoUrl'],
                      width: 40,
                    ),
                  ),
                ),
                document['isActive']
                    ? Container(
                        decoration: BoxDecoration(
                            color: Colors.white, shape: BoxShape.circle),
                        padding: EdgeInsets.all(3),
                        child: Container(
                          decoration: BoxDecoration(
                              color: Colors.greenAccent, shape: BoxShape.circle),
                          width: 25 / 2,
                          height: 25 / 2,
                        ),
                      )
                    : Container(
                        width: 0.0,
                        height: 0.0,
                      ),
              ],
            ),
            Expanded(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text(
                  document['displayName'],
                  style: TextStyle(color: Colors.black, fontSize: 18),
                ),
                Image(
                    image: AssetImage("assets/boton-de-play.png"),
                    width: 50,
                  ),
              ],
            ),),
            
          ],
        ),
        onPressed: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => Game()
              )
          );
        },
      ),
    );
  }
}