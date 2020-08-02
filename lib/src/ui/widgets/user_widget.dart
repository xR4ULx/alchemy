import 'package:alchemy/src/ui/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:alchemy/src/services/wizard.dart';

class UserWidget extends StatelessWidget {
  final AsyncSnapshot<dynamic> snapshot;
  final int index;
  final Wizard wizard;
  final bool follows;

  const UserWidget(
      {@required this.snapshot, @required this.index, @required this.wizard, @required this.follows});

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
                boxShadow: [
                  BoxShadow(
                      offset: const Offset(0.0, .0),
                      blurRadius: 26.0,
                      spreadRadius: 0.2,
                      color:
                          isFollower(snapshot.data.documents[index]['follows'])
                              ? Colors.tealAccent
                              : Colors.transparent)
                ],
              ),
              child: FlatButton(
                shape: new RoundedRectangleBorder(
                    borderRadius: new BorderRadius.circular(10.0)),
                padding: EdgeInsets.all(5),
                color: Colors.transparent,
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
                                    ? InvitarWidget(snapshot: snapshot, index: index, wizard: wizard)
                                    : OcupadoWidget()
                                : isAvisar(snapshot.data.documents[index]
                                        ['avisos'])
                                    ? AvisarWidget(snapshot: snapshot, index: index, wizard: wizard, follows: follows)
                                    : Container(),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                onPressed: () {},
                onLongPress: () {
                  isFollower(snapshot.data.documents[index]['follows'])
                      ? wizard.userRepository.unfollowTo(
                          snapshot.data.documents[index]['displayName'], follows)
                      : wizard.userRepository.followTo(
                          snapshot.data.documents[index]['displayName'], follows);
                },
              ),
            ),
          ],
        ));
  }
}
