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
  User _user = GetIt.I.get<User>();

  //PROVIDER
  QuerySnapshot users;
  final _usersStreamController = StreamController<QuerySnapshot>.broadcast();

  Function(QuerySnapshot) get _usersSink => _usersStreamController.sink.add;
  Stream<QuerySnapshot> get usersStream => _usersStreamController.stream;

    void disposeStream(){
    _usersStreamController?.close();
  }

  void getAllUsers() async{
    
    await for(QuerySnapshot snap in Firestore.instance.collection('users').orderBy('isActive', descending: true).snapshots()){
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
    final AuthCredential credential =
      GoogleAuthProvider.getCredential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken
      );
    
    await _firebaseAuth.signInWithCredential(credential);
    return _firebaseAuth.currentUser();
  }

  // SignOut
  Future<void> signOut() async {
    await desactiveUser();
    return Future.wait([
      _firebaseAuth.signOut(),
      _googleSignIn.signOut()
    ]);
  }

  // Esta logueado?
  Future<bool> isSignedIn() async {
    final currentUser = await _firebaseAuth.currentUser();
    activeUser(currentUser);
    return currentUser != null;
  }

  Future<void> activeUser(FirebaseUser user) async{

    _user.displayName = user.displayName;
    _user.photoUrl = user.photoUrl;
    _user.uid = user.uid;
    _user.isActive = true;

      // Update data to server if new user
    Firestore.instance.collection('users').document(user.uid).setData(_user.toJson());
  }

  Future<void> desactiveUser() async{

    _user.isActive = false;

      // Update data to server if new user
    Firestore.instance.collection('users').document(_user.uid).setData(_user.toJson());
  }
  



  // Obtener usuario
  Future<String> getUser() async {
    return (await _firebaseAuth.currentUser()).email;
  }
}
