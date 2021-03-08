import 'package:alchemy/src/ui/widgets/widgets.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:alchemy/src/services/wizard.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../bloc/game_bloc/bloc.dart';

class UserWidget extends StatefulWidget {
  final AsyncSnapshot<dynamic> snapshot;
  final int index;
  final Wizard wizard;
  final bool follows;
  final Stream<QuerySnapshot> notRead;

  const UserWidget(
      {@required this.snapshot,
      @required this.index,
      @required this.wizard,
      @required this.follows,
      @required this.notRead});

  @override
  _UserWidgetState createState() => _UserWidgetState();
}

class _UserWidgetState extends State<UserWidget> {

  bool isFollower(List<dynamic> follows) {
    final result = follows.where((item) => item == widget.wizard.user.uid).toList();
    if (result.length == 0) {
      return false;
    } else {
      return true;
    }
  }

  bool isAvisar(List<dynamic> avisos) {
    final result = avisos.where((item) => item == widget.wizard.user.uid).toList();
    if (result.length == 0) {
      return true;
    } else {
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        margin: EdgeInsets.all(1),
        padding: EdgeInsets.all(3),
        child: Column(
          children: <Widget>[
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                gradient: LinearGradient(colors: [
                  Theme.of(context).accentColor,
                  Theme.of(context).primaryColor
                ]),
                boxShadow: [
                  BoxShadow(
                      offset: const Offset(0, 0),
                      blurRadius: 12,
                      spreadRadius: 2,
                      color:
                          isFollower(widget.snapshot.data.documents[widget.index]['follows'])
                              ? Colors.amberAccent
                              : Colors.transparent)
                ],
              ),
              child: MaterialButton(
                shape: new RoundedRectangleBorder(
                    borderRadius: new BorderRadius.circular(8)),
                padding: EdgeInsets.all(8),
                color: Theme.of(context).primaryColor.withOpacity(0.5),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Stack(
                      alignment: Alignment.bottomLeft,
                      children: <Widget>[
                        AvatarWidget(
                            photoUrl: widget.snapshot.data.documents[widget.index]
                                ['photoUrl']),
                        ActiveWidget(
                            active: widget.snapshot.data.documents[widget.index]['isActive'])


                      ],
                    ),
                    Expanded(
                      child: Container(
                        padding: EdgeInsets.symmetric(horizontal: 10),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: <Widget>[
                            NameWidget(
                              displayName: widget.snapshot.data.documents[widget.index]
                                  ['displayName'],
                              wins: widget.snapshot.data.documents[widget.index]['wins'],
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
                            widget.snapshot.data.documents[widget.index]['isActive']
                                ? widget.snapshot.data.documents[widget.index]['player'] == ''
                                    ? InvitarWidget(
                                        snapshot: widget.snapshot,
                                        index: widget.index,
                                        wizard: widget.wizard)
                                    : OcupadoWidget()
                                : Container(height: 0, width: 0,),
                            StreamBuilder(
                              stream: widget.notRead,
                              builder: (context, snapshot) {
                                if(!snapshot.hasData){
                                  return Container(width: 0,height: 0,);
                                }else{
                                  QuerySnapshot values = snapshot.data;
                                  if(values.documents.length > 0){
                                    return NotReadWidget(notread: values.documents.length.toString());
                                  }else{
                                    return Container(width: 30,height: 0,);
                                  }
                                }

                              },
                            )
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                onPressed: () {
                  BlocProvider.of<GameBloc>(context).add(EChat(
                    peerId: widget.snapshot.data.documents[widget.index]['uid'],
                    peerAvatar: widget.snapshot.data.documents[widget.index]['photoUrl'],
                    peerToken: widget.snapshot.data.documents[widget.index]['pushToken']
                  ));
                },
                onLongPress: () {
                  isFollower(widget.snapshot.data.documents[widget.index]['follows'])
                      ? widget.wizard.userRepository.unfollowTo(
                          widget.snapshot.data.documents[widget.index]['displayName'],
                          widget.follows)
                      : widget.wizard.userRepository.followTo(
                          widget.snapshot.data.documents[widget.index]['displayName'],
                          widget.follows);
                },
              ),
            ),
          ],
        ));
  }
}
