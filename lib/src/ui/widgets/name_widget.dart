import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class NameWidget extends StatelessWidget {
  final String displayName;
  final int wins;

  const NameWidget({@required this.displayName, @required this.wins});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          displayName.length > 15 ? displayName.substring(0, 15) : displayName,
          style: GoogleFonts.openSans(color: Colors.white),
        ),
        Row(
          children: <Widget>[
            Image(
              image: AssetImage("assets/p2.png"),
              width: 30,
            ),
            Text(
              wins == null ? "x0" : "x$wins",
              style: GoogleFonts.griffy(color: Colors.white),
              textScaleFactor: 1.2,
            ),
          ],
        ),
      ],
    );
  }
}
