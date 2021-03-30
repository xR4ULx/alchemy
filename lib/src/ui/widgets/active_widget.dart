import 'package:flutter/material.dart';

class ActiveWidget extends StatelessWidget {
  const ActiveWidget({ @required this.active});
  final bool active;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(color: active ? Colors.greenAccent : Colors.redAccent, shape: BoxShape.circle),
      padding: EdgeInsets.all(1),
      child: Container(
        decoration:
            BoxDecoration(color: active ? Colors.greenAccent : Colors.redAccent, shape: BoxShape.circle),
        width: 25 / 2,
        height: 25 / 2,
      ),
    );
  }
}
