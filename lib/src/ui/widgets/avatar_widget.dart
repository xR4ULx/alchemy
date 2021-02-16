import 'package:flutter/material.dart';

class AvatarWidget extends StatelessWidget {
  final String photoUrl;
  const AvatarWidget({@required this.photoUrl});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(color: Colors.white, shape: BoxShape.circle),
      padding: EdgeInsets.all(2.5),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(25),
        child: Image.network(
          photoUrl,
          width: 45,
        ),
      ),
    );
  }
}
