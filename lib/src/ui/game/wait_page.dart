import 'package:alchemy/src/bloc/game_bloc/bloc.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:alchemy/src/services/wizard.dart';

class WaitPage extends StatefulWidget {

  final Wizard wizard;
  const WaitPage({Key key, @required this.wizard });

  @override
  _WaitPageState createState() => _WaitPageState();
}

class _WaitPageState extends State<WaitPage> {

  String _photoUrl;

  Wizard blink(){
    return widget.wizard;
  }

  getPhoto() async {
    _photoUrl = await blink().userRepository.getPhotoUrl(blink().user.adversary);
    setState(() {});
  }
  


  @override
  void initState() {
    super.initState();
    getPhoto();

    blink().signaling.onFinishGame = () {

      blink().user.player = '';
      blink().user.adversary = '';
      blink().userRepository.updateUser();
      blink().signaling.emit('exit-game', true);

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
            'Esperando Respuesta...',
            style: GoogleFonts.griffy(
              color: Colors.amber,
            ),
            textScaleFactor: 2,
          ),
          SizedBox(
            height: 30,
          ),
          FloatingActionButton(
            onPressed: () {
              blink().user.player = '';
                blink().user.adversary = '';
                blink().userRepository.updateUser();
                blink().signaling.emit('finish', true);
                BlocProvider.of<GameBloc>(context).add(EHome());
            },
            backgroundColor: Colors.redAccent,
            child: Icon(Icons.call_end),
          ),
        ],
      )),
    );
  }
}
