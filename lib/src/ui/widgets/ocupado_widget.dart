import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class OcupadoWidget extends StatelessWidget {
  const OcupadoWidget({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              offset: const Offset(0.0, .0),
              blurRadius: 26.0,
              spreadRadius: 0.2,
              color: Colors.redAccent,
            )
          ],
        ),
        child: Text(
          'Ocupado',
          style: GoogleFonts.griffy(),
          textScaleFactor: 1,
        ));
  }
}
