// Imports
import 'dart:async';
import 'package:alchemy/src/models/user_model.dart';
import 'package:alchemy/src/util/signaling.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:meta/meta.dart';

class UserRepository {
  User user;
  Signaling signaling;
  final FirebaseAuth _firebaseAuth;
  final GoogleSignIn _googleSignIn;
  FirebaseUser _firebaseUser;

  // Constructor
  UserRepository(
      {FirebaseAuth firebaseAuth,
      GoogleSignIn googleSignIn,
      @required this.user,
      @required this.signaling})
      : _firebaseAuth = firebaseAuth ?? FirebaseAuth.instance,
        _googleSignIn = googleSignIn ?? GoogleSignIn();

  //PROVIDER
  QuerySnapshot users;

  final _usersStreamController = StreamController<QuerySnapshot>.broadcast();
  Function(QuerySnapshot) get _usersSink => _usersStreamController.sink.add;
  Stream<QuerySnapshot> get usersStream => _usersStreamController.stream;

  void disposeStream() {
    _usersStreamController?.close();
  }

  // SignInWithGoogle
  Future<FirebaseUser> signInWithGoogle() async {
    final GoogleSignInAccount googleUser = await _googleSignIn.signIn();
    final GoogleSignInAuthentication googleAuth =
    await googleUser.authentication;
    final AuthCredential credential = GoogleAuthProvider.getCredential(
        accessToken: googleAuth.accessToken, idToken: googleAuth.idToken);

    await _firebaseAuth.signInWithCredential(credential);
    _firebaseUser = await _firebaseAuth.currentUser();
    return _firebaseUser;
  }

  // SignOut
  Future<void> signOut() async {
    Future.wait([
      setActive(false),
      _firebaseAuth.signOut(),
      _googleSignIn.signOut(),
      _googleSignIn.disconnect(),
    ]);
  }

  // Esta logueado?
  Future<bool> isSignedIn() async {
    return await _googleSignIn.isSignedIn();
  }

  Future<bool> setActive(bool active) async {
    if (active) {
      if (_firebaseUser != null) {
        final QuerySnapshot result = await Firestore.instance
            .collection('users')
            .where('uid', isEqualTo: _firebaseUser.uid)
            .getDocuments();
        final List<DocumentSnapshot> documents = result.documents;

        signaling.emit('login', _firebaseUser.displayName);

        if (documents.length == 0) {
          user.displayName = _firebaseUser.displayName;
          user.photoUrl = _firebaseUser.photoUrl;
          user.uid = _firebaseUser.uid;
          user.player = '';
          user.adversary = '';
          user.follows = [""];
          user.avisos = [""];
          user.wins = 0;
          user.isActive = true;

          // Update data to server if new user
          Firestore.instance
              .collection('users')
              .document(_firebaseUser.uid)
              .setData(user.toJson());
        } else {
          Firestore.instance
              .collection('users')
              .document(_firebaseUser.uid)
              .updateData({'isActive': active});

          user.displayName = documents[0]['displayName'];
          user.photoUrl = documents[0]['photoUrl'];
          user.uid = documents[0]['uid'];
          user.player = documents[0]['player'];
          user.adversary = documents[0]['adversary'];
          user.wins = documents[0]['wins'];
          user.isActive = documents[0]['isActive'];
          user.follows = documents[0]['follows'];
          user.avisos = [""];
        }
      }
    } else {
      Firestore.instance
          .collection('users')
          .document(user.uid)
          .updateData({'isActive': active});
    }

    return true;
  }

  // Obtener usuario
  Future<String> getUser() async {
    return _firebaseUser.displayName;
  }

  bool userIsActive(){
    return user.isActive;
  }

  // DATOS DE LISTA DE USUARIOS

  void getAllUsers() async {
    QuerySnapshot initSnap;
    _usersSink(initSnap);
    await for (QuerySnapshot snap in Firestore.instance
        .collection('users')
        .orderBy('isActive', descending: true)
        .snapshots()) {
      _usersSink(snap);
    }
  }

  void getFollows() async {
    QuerySnapshot initSnap;
    _usersSink(initSnap);
    await for (QuerySnapshot snap in Firestore.instance
        .collection('users')
        .where('follows', arrayContains: user.uid)
        .orderBy('isActive', descending: true)
        .snapshots()) {
      _usersSink(snap);
    }
  }

  Stream<QuerySnapshot> getNotRead(String idFrom, String idTo) {

    String _groupChatId;
    if (idFrom.hashCode <= idTo.hashCode) {
      _groupChatId = '$idFrom-$idTo';
    } else {
      _groupChatId = '$idTo-$idFrom';
    }

    return Firestore.instance
        .collection('message')
        .document(_groupChatId)
        .collection('messages')
        .where('status', isEqualTo: false)
        .where('idFrom', isEqualTo: idTo)
        .snapshots();
  }

  Future<String> getPhotoUrl(String playerRequest) async {


    await for (QuerySnapshot snap in Firestore.instance
        .collection('users')
        .where('displayName', isEqualTo: playerRequest)
        .snapshots()) {

      return snap.documents[0]['photoUrl'];
    }

    /*
    final QuerySnapshot docs = await Firestore.instance
        .collection('users')
        .where('displayName', isEqualTo: playerRequest)
        .getDocuments();
    final List<DocumentSnapshot> documents = docs.documents;

    return documents[0]['photoUrl'];
    */

  }

  void updateUser() async {
    final QuerySnapshot docs = await Firestore.instance
        .collection('users')
        .where('displayName', isEqualTo: user.displayName)
        .getDocuments();
    final List<DocumentSnapshot> documents = docs.documents;

    String _userid = documents[0]['uid'];

    Firestore.instance.collection('users').document(_userid).updateData({
      'player': user.player,
      'adversary': user.adversary,
      'avisos': user.avisos
    });
  }

  void followTo(String name, bool isfollow) async {
    final QuerySnapshot docs = await Firestore.instance
        .collection('users')
        .where('displayName', isEqualTo: name)
        .getDocuments();
    final List<DocumentSnapshot> documents = docs.documents;

    String followid = documents[0]['uid'];
    List<dynamic> follows = documents[0]['follows'];
    final result = follows.where((item) => item == user.uid).toList();
    if (result.length == 0) {
      follows.add(user.uid);

      Firestore.instance
          .collection('users')
          .document(followid)
          .updateData({'follows': follows});
    }
    if (isfollow) {
      getFollows();
    } else {
      getAllUsers();
    }
  }

  void unfollowTo(String name, bool isfollow) async {
    final QuerySnapshot docs = await Firestore.instance
        .collection('users')
        .where('displayName', isEqualTo: name)
        .getDocuments();
    final List<DocumentSnapshot> documents = docs.documents;

    String followid = documents[0]['uid'];
    List<dynamic> follows = documents[0]['follows'];
    final result = follows.where((item) => item == user.uid).toList();
    if (result.length != 0) {
      follows.remove(user.uid);

      Firestore.instance
          .collection('users')
          .document(followid)
          .updateData({'follows': follows});
    }
    if (isfollow) {
      getFollows();
    } else {
      getAllUsers();
    }
  }

  void avisar(String name, bool isfollow) async {
    final QuerySnapshot docs = await Firestore.instance
        .collection('users')
        .where('displayName', isEqualTo: name)
        .getDocuments();
    final List<DocumentSnapshot> documents = docs.documents;

    String avisoid = documents[0]['uid'];
    List<dynamic> avisos = documents[0]['avisos'];
    final result = avisos.where((item) => item == user.uid).toList();
    if (result.length == 0) {
      avisos.add(user.uid);

      Firestore.instance
          .collection('users')
          .document(avisoid)
          .updateData({'avisos': avisos});
    }
    if (isfollow) {
      getFollows();
    } else {
      getAllUsers();
    }
  }

  void searchUsers(String query) async {
    QuerySnapshot initSnap;
    _usersSink(initSnap);

    await for (QuerySnapshot snap in Firestore.instance
        .collection('users')
        .where('indexes', arrayContains: query.toLowerCase())
        .orderBy('isActive', descending: true)
        .snapshots()) {
      _usersSink(snap);
    }
  }


}
