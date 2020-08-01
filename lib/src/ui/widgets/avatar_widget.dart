import 'package:flutter/material.dart';

class AvatarWidget extends StatelessWidget {
  const AvatarWidget({@required this.photoUrl});
  final String photoUrl;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(color: Theme.of(context).accentColor, shape: BoxShape.circle),
      padding: EdgeInsets.all(1),
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
