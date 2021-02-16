import 'package:alchemy/src/ui/widgets/widgets.dart';
import 'package:alchemy/src/util/const.dart';
import 'package:flutter/material.dart';
import 'package:alchemy/src/services/wizard.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../bloc/game_bloc/bloc.dart';

class UserWidget extends StatelessWidget {
  final AsyncSnapshot<dynamic> snapshot;
  final int index;
  final Wizard wizard;
  final bool follows;

  const UserWidget(
      {@required this.snapshot,
      @required this.index,
      @required this.wizard,
      @required this.follows});

  bool isFollower(List<dynamic> follows) {
    final result = follows.where((item) => item == wizard.user.uid).toList();
    if (result.length == 0) {
      return false;
    } else {
      return true;
    }
  }

  bool isAvisar(List<dynamic> avisos) {
    final result = avisos.where((item) => item == wizard.user.uid).toList();
    if (result.length == 0) {
      return true;
    } else {
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        margin: EdgeInsets.all(2),
        padding: EdgeInsets.all(3),
        child: Column(
          children: <Widget>[
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                gradient: LinearGradient(colors: [
                  Theme.of(context).primaryColor,
                  Theme.of(context).accentColor
                ]),
                boxShadow: [
                  BoxShadow(
                      offset: const Offset(0.2, 0.2),
                      blurRadius: 5,
                      spreadRadius: 1.5,
                      color:
                          isFollower(snapshot.data.documents[index]['follows'])
                              ? Colors.amber
                              : Colors.transparent)
                ],
              ),
              child: FlatButton(
                shape: new RoundedRectangleBorder(
                    borderRadius: new BorderRadius.circular(8.0)),
                padding: EdgeInsets.all(12),
                color: Theme.of(context).primaryColor.withOpacity(0.1),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Stack(
                      alignment: Alignment.bottomLeft,
                      children: <Widget>[
                        AvatarWidget(
                            photoUrl: snapshot.data.documents[index]
                                ['photoUrl']),
                        ActiveWidget(
                            active: snapshot.data.documents[index]['isActive'])
                      ],
                    ),
                    Expanded(
                      child: Container(
                        padding: EdgeInsets.symmetric(horizontal: 10),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: <Widget>[
                            NameWidget(
                              displayName: snapshot.data.documents[index]
                                  ['displayName'],
                              wins: snapshot.data.documents[index]['wins'],
                            ),
                            Expanded(
                                child: Column(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: <Widget>[
                                SizedBox(
                                  width: 10,
                                ),
                              ],
                            )),
                            snapshot.data.documents[index]['isActive']
                                ? snapshot.data.documents[index]['player'] == ''
                                    ? InvitarWidget(
                                        snapshot: snapshot,
                                        index: index,
                                        wizard: wizard)
                                    : OcupadoWidget()
                                : Container(),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                onPressed: () {
                  BlocProvider.of<GameBloc>(context).add(EChat(
                    peerId: snapshot.data.documents[index]['uid'],
                    peerAvatar: snapshot.data.documents[index]['photoUrl'],
                  ));
                },
                onLongPress: () {
                  isFollower(snapshot.data.documents[index]['follows'])
                      ? wizard.userRepository.unfollowTo(
                          snapshot.data.documents[index]['displayName'],
                          follows)
                      : wizard.userRepository.followTo(
                          snapshot.data.documents[index]['displayName'],
                          follows);
                },
              ),
            ),
          ],
        ));
  }
}
