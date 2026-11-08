import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';

import '../config/error_handler.dart';

class FirebaseAuthService {
  String tag = "firebase_auth_service";
  FirebaseAuthService._() {
    // isEmulator ? _auth.useAuthEmulator(firebaseEmulatorId, 9099) : null;
  }
  static final instance = FirebaseAuthService._();
  FirebaseAuth get _auth => FirebaseAuth.instanceFor(app: Firebase.app('OApp'));
  // ────────────── Auth stream & helpers ──────────────
  Stream<User?> get authStateChanges => _auth.authStateChanges();
  User? get currentUser => _auth.currentUser;
  Future<bool> get isLoggedIn async => _auth.currentUser != null;

  // ────────────── Email / password flow ──────────────
  Future<UserCredential> signUpWithEmail(String email, String password) async {
    final cred = await _auth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );

    try {
      await cred.user?.sendEmailVerification();
      debugPrint("✅ Email verification sent to ${cred.user?.email}");
    } on FirebaseAuthException catch (e, s) {
      handleError(tag: tag, error: e.toString(), stack: s.toString());
    } catch (e, s) {
      handleError(tag: tag, error: e.toString(), stack: s.toString());
    }
    return cred;
  }

  Future<void> ensureFirebaseSignedIn() async {
    try {
      if (_auth.currentUser == null) {
        await _auth.signInAnonymously();
      }
    } catch (e, s) {
      handleError(tag: tag, error: e.toString(), stack: s.toString());
    }
  }

  Future<UserCredential> signInWithEmail(String email, String password) =>
      _auth.signInWithEmailAndPassword(email: email, password: password);

  Future<void> signOut() {
    // _glob.clearglobaldata();
    return _auth.signOut();
  }

  // ────────────── Account management ──────────────
  Future<bool> sendPasswordResetEmail(String email) async {
    try {
      await _auth.sendPasswordResetEmail(email: email.trim());
      return true;
    } on FirebaseAuthException catch (e, s) {
      handleError(
        tag: 'auth_service',
        error: e.message ?? '',
        stack: s.toString(),
      );
      rethrow;
    }
  }

  Future<UserCredential?> signInWithApple() async {
    try {
      // Request Apple credential
      final appleCredential = await SignInWithApple.getAppleIDCredential(
        scopes: [
          AppleIDAuthorizationScopes.email,
          AppleIDAuthorizationScopes.fullName,
        ],
      );

      // Create OAuth credential for Firebase
      final oauthCredential = OAuthProvider("apple.com").credential(
        idToken: appleCredential.identityToken,
        accessToken: appleCredential.authorizationCode,
      );

      // Sign in with Firebase
      return await _auth.signInWithCredential(oauthCredential);
    } on FirebaseAuthException catch (e, s) {
      handleError(tag: tag, error: e.message ?? '', stack: s.toString());
      return null;
    } catch (e, s) {
      handleError(tag: tag, error: e.toString(), stack: s.toString());
      return null;
    }
  }

  Future<UserCredential?> signInWithFacebook() async {
    try {
      // Trigger Facebook login
      final LoginResult result = await FacebookAuth.instance.login(
        permissions: ['email', 'public_profile'],
        // loginBehavior: LoginBehavior.webOnly,
      );

      if (result.status == LoginStatus.success) {
        final AccessToken accessToken = result.accessToken!;

        // Create Firebase credential
        final OAuthCredential credential = FacebookAuthProvider.credential(
          accessToken.tokenString,
        );

        // Sign in with Firebase
        return await _auth.signInWithCredential(credential);
      } else if (result.status == LoginStatus.cancelled) {
        debugPrint("User cancelled Facebook login");
        return null;
      } else {
        throw Exception(result.message);
      }
    } on FirebaseAuthException catch (e, s) {
      handleError(tag: tag, error: e.message ?? '', stack: s.toString());
      return null;
    } catch (e, s) {
      handleError(tag: tag, error: e.toString(), stack: s.toString());
      return null;
    }
  }

  /* ── EDIT: return success flag ── */
  Future<bool> changePassword(String newPassword) async {
    try {
      await _auth.currentUser!.updatePassword(newPassword.trim());
      return true;
    } on FirebaseAuthException catch (e, s) {
      handleError(
        tag: 'auth_service',
        error: e.message ?? '',
        stack: s.toString(),
      );
      return false;
    }
  }

  Future<void> sendEmailVerification() async {
    final user = _auth.currentUser;
    if (user != null && !user.emailVerified) {
      await user.sendEmailVerification();
    }
  }

  Future<bool> checkEmailVerfication() async {
    try {
      final user = _auth.currentUser;
      if (user != null) {
        await user.reload();
        bool res = user.emailVerified;
        if (!res) {
          unawaited(sendEmailVerification());
        }

        debugPrint(
          "✅ Email verification  ${user.email} is Verified: ${user.emailVerified}",
        );
        return res;
      }
      return false;
    } catch (e, s) {
      handleError(
        tag: 'auth_service',
        error: e.toString(),
        stack: s.toString(),
      );
      return false;
    }
  }

  Future<UserCredential?> signInWithGoogle() async {
    try {
      await GoogleSignIn.instance.initialize();

      final GoogleSignInAccount googleUser = await GoogleSignIn.instance
          .authenticate();

      if (googleUser == null) {
        debugPrint("User cancelled manually");
        return null;
      }

      final googleAuth = googleUser.authentication;

      if (googleAuth.idToken == null) {
        throw Exception("ID Token is null");
      }

      final credential = GoogleAuthProvider.credential(
        idToken: googleAuth.idToken,
      );

      return await _auth.signInWithCredential(credential);
    } catch (e, s) {
      handleError(tag: tag, error: e.toString(), stack: s.toString());
      return null;
    }
  }
}
