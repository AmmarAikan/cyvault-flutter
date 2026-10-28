import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:google_sign_in/google_sign_in.dart';

enum CloudIdentityStatus { signedOut, signingIn, signedIn, unavailable }

@immutable
final class CloudAccount {
  const CloudAccount({
    required this.uid,
    required this.email,
    this.displayName,
  });

  final String uid;
  final String email;
  final String? displayName;
}

/// Google identity is deliberately separate from the local vault session.
/// It may authorize encrypted sync, but it never exposes or unwraps the DEK.
abstract base class CloudIdentity extends ChangeNotifier {
  CloudIdentityStatus get status;
  CloudAccount? get account;
  bool get lastOperationFailed;

  Future<bool> signInWithGoogle();
  Future<void> signOut();
}

final class FirebaseCloudIdentity extends CloudIdentity {
  FirebaseCloudIdentity({
    FirebaseAuth? firebaseAuth,
    GoogleSignIn? googleSignIn,
  }) : _firebaseAuth = firebaseAuth ?? FirebaseAuth.instance,
       _googleSignIn = googleSignIn ?? GoogleSignIn.instance;

  final FirebaseAuth _firebaseAuth;
  final GoogleSignIn _googleSignIn;
  StreamSubscription<User?>? _authSubscription;
  CloudIdentityStatus _status = CloudIdentityStatus.signedOut;
  CloudAccount? _account;
  bool _lastOperationFailed = false;

  @override
  CloudIdentityStatus get status => _status;

  @override
  CloudAccount? get account => _account;

  @override
  bool get lastOperationFailed => _lastOperationFailed;

  Future<void> initialize() async {
    await _googleSignIn.initialize();
    _applyUser(_firebaseAuth.currentUser);
    _authSubscription = _firebaseAuth.authStateChanges().listen(_applyUser);
  }

  @override
  Future<bool> signInWithGoogle() async {
    if (_status == CloudIdentityStatus.signingIn) return false;
    _lastOperationFailed = false;
    _status = CloudIdentityStatus.signingIn;
    notifyListeners();
    try {
      final googleUser = await _googleSignIn.authenticate();
      final googleAuth = googleUser.authentication;
      final idToken = googleAuth.idToken;
      if (idToken == null || idToken.isEmpty) {
        throw StateError('Google Sign-In returned no ID token.');
      }
      final credential = GoogleAuthProvider.credential(idToken: idToken);
      final result = await _firebaseAuth.signInWithCredential(credential);
      _applyUser(result.user);
      return result.user != null;
    } catch (_) {
      _lastOperationFailed = true;
      _applyUser(_firebaseAuth.currentUser);
      return false;
    }
  }

  @override
  Future<void> signOut() async {
    _lastOperationFailed = false;
    try {
      await _googleSignIn.signOut();
      await _firebaseAuth.signOut();
      _applyUser(null);
    } catch (_) {
      _lastOperationFailed = true;
      notifyListeners();
    }
  }

  void _applyUser(User? user) {
    _account = user == null
        ? null
        : CloudAccount(
            uid: user.uid,
            email: user.email ?? '',
            displayName: user.displayName,
          );
    _status = user == null
        ? CloudIdentityStatus.signedOut
        : CloudIdentityStatus.signedIn;
    notifyListeners();
  }

  @override
  void dispose() {
    unawaited(_authSubscription?.cancel());
    super.dispose();
  }
}

final class UnavailableCloudIdentity extends CloudIdentity {
  @override
  CloudIdentityStatus get status => CloudIdentityStatus.unavailable;

  @override
  CloudAccount? get account => null;

  @override
  bool get lastOperationFailed => false;

  @override
  Future<bool> signInWithGoogle() async => false;

  @override
  Future<void> signOut() async {}
}
