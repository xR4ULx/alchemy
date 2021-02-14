import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class NameWidget extends StatelessWidget {
  final String displayName;
  final int wins;

  const NameWidget({@required this.displayName, @required this.wins});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          displayName.length > 15 ? displayName.substring(0, 15) : displayName,
          style: GoogleFonts.openSans(),
        ),
        Text(
          'Potions: $wins',
          style: GoogleFonts.openSans(),
        )
      ],
    );
  }
}
