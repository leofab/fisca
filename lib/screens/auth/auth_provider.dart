import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:logger/logger.dart';

class AuthProvider extends ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  User? _user;
  bool _isLoading = false;
  Map<String, dynamic>? _userData;

  User? get user => _user;
  bool get isLoading => _isLoading;
  Map<String, dynamic>? get userData => _userData;

  AuthProvider() {
    _initialize();
  }

  Future<void> _initialize() async {
    try {
      _isLoading = true;
      _auth.authStateChanges().listen((User? user) async {
        _user = user;
        if (user != null) {
          await _fetchUserData(user.uid);
          Logger().d('User state changed: ${user.uid}');
        }
        _isLoading = false;
        notifyListeners();
      });
    } catch (e) {
      Logger().e(e);
    }
  }

  Future<void> _fetchUserData(String uid) async {
    try {
      final doc = await _firestore.collection('users').doc(uid).get();
      if (doc.exists) {
        _userData = doc.data();
        Logger().d('User data fetched: $_userData');
      } else {
        _userData = null;
        Logger().d('User data does not exist in Firestore');
      }
    } catch (e) {
      Logger().e(e);
    }
  }

  Future<void> signInWithGoogle() async {
    try {
      _isLoading = true;
      notifyListeners();

      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      if (googleUser == null) return;

      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;

      final OAuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      final UserCredential userCredential =
          await _auth.signInWithCredential(credential);
      _user = userCredential.user;

      if (_user != null) {
        await FirebaseFirestore.instance
            .collection('users')
            .doc(_user!.uid)
            .set({
          'uid': _user!.uid,
          'name': _user!.displayName,
          'email': _user!.email,
          'photoUrl': _user!.photoURL,
          'createdAt': FieldValue.serverTimestamp(),
        });

        await _fetchUserData(_user!.uid);
      }

      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _isLoading = false;
      notifyListeners();
      Logger().e(e);
      rethrow;
    }
  }

  Future<void> signOut() async {
    await _googleSignIn.signOut();
    await _auth.signOut();
    _user = null;
    _userData = null;
    notifyListeners();
  }
}
