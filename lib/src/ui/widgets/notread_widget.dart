import 'package:flutter/material.dart';

class NotReadWidget extends StatelessWidget {
  const NotReadWidget({ @required this.notread});
  final String notread;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 5.0, bottom: 3.0),
      child: Container(
        decoration: BoxDecoration(color: Colors.greenAccent, shape: BoxShape.circle),
        padding: EdgeInsets.all(2),
        child: Container(
          decoration:
              BoxDecoration(color: Colors.teal, shape: BoxShape.circle),
          width: 20,
          height: 20,
          child: Center(child: Text(this.notread, style: TextStyle(color: Colors.white),textAlign: TextAlign.center,)),
        ),
      ),
    );
  }
}
