// Imports
import 'dart:async';
import 'package:alchemy/src/repository/user_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get_it/get_it.dart';
import 'package:google_sign_in/google_sign_in.dart';

class UserRepository {
  final FirebaseAuth _firebaseAuth;
  final GoogleSignIn _googleSignIn;
  //FirebaseUser _firebaseUser;
  User _user = GetIt.I.get<User>();

  //PROVIDER
  QuerySnapshot users;
  final _usersStreamController = StreamController<QuerySnapshot>.broadcast();

  Function(QuerySnapshot) get _usersSink => _usersStreamController.sink.add;
  Stream<QuerySnapshot> get usersStream => _usersStreamController.stream;

  void disposeStream() {
    _usersStreamController?.close();
  }

  void getAllUsers() async {
    await for (QuerySnapshot snap in Firestore.instance
        .collection('users')
        .orderBy('isActive', descending: true)
        .snapshots()) {
      _usersSink(snap);
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

  // Constructor
  UserRepository({FirebaseAuth firebaseAuth, GoogleSignIn googleSignIn})
      : _firebaseAuth = firebaseAuth ?? FirebaseAuth.instance,
        _googleSignIn = googleSignIn ?? GoogleSignIn();

  // SignInWithGoogle
  Future<FirebaseUser> signInWithGoogle() async {
    final GoogleSignInAccount googleUser = await _googleSignIn.signIn();
    final GoogleSignInAuthentication googleAuth =
        await googleUser.authentication;
    final AuthCredential credential = GoogleAuthProvider.getCredential(
        accessToken: googleAuth.accessToken, idToken: googleAuth.idToken);

    return (await _firebaseAuth.signInWithCredential(credential)).user;
  }

  // SignOut
  Future<void> signOut() async {
    setActive(false);
    return Future.wait([_firebaseAuth.signOut(), _googleSignIn.signOut()]);
  }

  // Esta logueado?
  Future<bool> isSignedIn() async {
    final currentUser = await _firebaseAuth.currentUser();
    setActive(true);
    return currentUser != null;
  }

  Future<void> setActive(bool active) async {
    if (active) {
      FirebaseUser _firebaseUser = await _firebaseAuth.currentUser();

      if (_firebaseUser != null) {
        final QuerySnapshot result = await Firestore.instance
            .collection('users')
            .where('uid', isEqualTo: _firebaseUser.uid)
            .getDocuments();
        final List<DocumentSnapshot> documents = result.documents;

        if (documents.length == 0) {
          _user.displayName = _firebaseUser.displayName;
          _user.photoUrl = _firebaseUser.photoUrl;
          _user.uid = _firebaseUser.uid;
          _user.player = '';
          _user.adversary = '';
          _user.wins = 0;
          _user.isActive = true;

          // Update data to server if new user
          Firestore.instance
              .collection('users')
              .document(_firebaseUser.uid)
              .setData(_user.toJson());
        } else {
          _user.displayName = documents[0]['displayName'];
          _user.photoUrl = documents[0]['photoUrl'];
          _user.uid = documents[0]['uid'];
          _user.player = documents[0]['player'];
          _user.adversary = documents[0]['adversary'];
          _user.wins = documents[0]['wins'];
          _user.isActive = documents[0]['isActive'];
        }
      }
    } else {
      Firestore.instance
          .collection('users')
          .document(_user.uid)
          .updateData({'isActive': active});
    }
  }

  // Obtener usuario
  Future<String> getUser() async {
    return (await _firebaseAuth.currentUser()).email;
  }
}
