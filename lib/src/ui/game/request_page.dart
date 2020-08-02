import 'package:alchemy/src/bloc/game_bloc/bloc.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:alchemy/src/services/wizard.dart';

class RequestPage extends StatefulWidget {
  
  final Wizard wizard;

  const RequestPage({Key key, @required this.wizard});

  @override
  _RequestPageState createState() => _RequestPageState();
}

class _RequestPageState extends State<RequestPage> {

  String _photoUrl;

  Wizard blink(){
    return widget.wizard;
  }

  getPhoto() async {
    _photoUrl = await blink().userRepository.getPhotoUrl(widget.wizard.user.adversary);
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    getPhoto();

    widget.wizard.signaling.onFinishGame = () {

      widget.wizard.user.player = '';
      widget.wizard.user.adversary = '';
      widget.wizard.userRepository.updateUser();
      widget.wizard.signaling.emit('exit-game', true);

    };
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Container(
            padding: EdgeInsets.all(5),
            decoration: BoxDecoration(
                color: Colors.amber,
                shape: BoxShape.circle,
                border: Border.all(width: 2)),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(50),
              child: CachedNetworkImage(
        imageUrl: _photoUrl,
        placeholder: (context, url) => CircularProgressIndicator(),
        errorWidget: (context, url, error) => Icon(Icons.error),
     ),
            ),
          ),
          SizedBox(
            height: 10,
          ),
            Text(
              widget.wizard.user.adversary,
              style: GoogleFonts.griffy(
                color: Colors.amber,
              ),
              textScaleFactor: 3,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                FloatingActionButton(
                  onPressed: () {
                    widget.wizard.signaling.acceptOrDecline(true, widget.wizard.user.adversary);
                    widget.wizard.user.player = 'p2';
                    BlocProvider.of<GameBloc>(context).add(EGame());
                  },
                  backgroundColor: Colors.greenAccent,
                  child: Icon(Icons.call),
                ),
                SizedBox(width: 80),
                FloatingActionButton(
                  onPressed: () {
                    widget.wizard.user.player = '';
                    widget.wizard.user.adversary = '';
                    widget.wizard.userRepository.updateUser();
                    widget.wizard.signaling.emit('finish', true);
                    BlocProvider.of<GameBloc>(context).add(EHome());
                  },
                  backgroundColor: Colors.redAccent,
                  child: Icon(Icons.call_end),
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}
