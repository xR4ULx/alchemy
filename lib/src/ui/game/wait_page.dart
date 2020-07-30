import 'package:alchemy/src/bloc/game_bloc/bloc.dart';
import 'package:alchemy/src/repository/user_model.dart';
import 'package:alchemy/src/repository/user_repository.dart';
import 'package:alchemy/src/util/signaling.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:google_fonts/google_fonts.dart';

class WaitPage extends StatefulWidget {
  const WaitPage({Key key}) : super(key: key);

  @override
  _WaitPageState createState() => _WaitPageState();
}

class _WaitPageState extends State<WaitPage> {
  Signaling _signaling = GetIt.I.get<Signaling>();
  User _user = GetIt.I.get<User>();
  UserRepository _userRepository = GetIt.I.get<UserRepository>();
  String _photoUrl;

  getPhoto() async {
    _photoUrl = await _userRepository.getPhotoUrl(_user.adversary);
    setState(() {});
  }
  
  @override
  void initState() {
    super.initState();
    getPhoto();

    _signaling.onFinishGame = () {

      _user.player = '';
      _user.adversary = '';
      _userRepository.updateUser();
      _signaling.emit('exit-game', true);

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
              _user.player = '';
                _user.adversary = '';
                _userRepository.updateUser();
                _signaling.emit('finish', true);
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
