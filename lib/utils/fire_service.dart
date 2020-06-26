
import 'package:alchemy/models/user_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FirebaseService{

  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  FirebaseUser _firebaseUser;
  User _user;

  final GoogleSignIn _googleSignIn = GoogleSignIn();
  GoogleSignInAccount _googleUser;
  GoogleSignInAuthentication _googleAuth;
  AuthCredential _credential;

  initPreferences() async{
    _user = new User();
  }

  get user {
    return _user;
  }

  dispose(){
    
  }


  Future<bool> isSignIn() async{
    return await _googleSignIn.isSignedIn();
  }

  Future<bool> handleSignIn() async {

    _googleUser = await _googleSignIn.signIn();
    _googleAuth = await _googleUser.authentication;

    _credential = GoogleAuthProvider.getCredential(
      accessToken: _googleAuth.accessToken,
      idToken: _googleAuth.idToken,
    );

    _firebaseUser = (await _firebaseAuth.signInWithCredential(_credential)).user;

    if (_firebaseUser != null) {

      user.displayName = _firebaseUser.displayName;
      user.photoUrl = _firebaseUser.photoUrl;
      user.uid = _firebaseUser.uid;
      user.isActive = true;

      // Update data to server if new user
      Firestore.instance.collection('users').document(_firebaseUser.uid).setData(user.toJson());
      

    } else {

      return false;

    }

  }

  Future<void> handleSignOut(BuildContext context) async {
    await _firebaseAuth.signOut();
    await _googleSignIn.disconnect();
    await _googleSignIn.signOut();
    //Navigator.popUntil(context, ModalRoute.withName("/"));
  }


}