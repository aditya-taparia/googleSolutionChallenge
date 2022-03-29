import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:googlesolutionchallenge/models/user.dart';
import 'package:googlesolutionchallenge/screens/auth/OTP.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Create user object based on FirebaseUser object
  Users? _userFromFirebase(User? user) {
    return user != null ? Users(userid: user.uid, email: user.email) : null;
  }

  // Auth change user stream
  Stream<Users?> get user {
    return _auth.authStateChanges().map(_userFromFirebase);
  }

  // Phone number verification
  Future<void> verifyPhoneNumber(String phoneNumber, BuildContext context) async {
    PhoneVerificationCompleted verificationCompleted;
    verificationCompleted = (PhoneAuthCredential phoneAuthCredential) async {
      showSnackBar(context, "Verification Completed");
    };
    PhoneVerificationFailed verificationFailed;
    verificationFailed = (FirebaseAuthException exception) {
      showSnackBar(context, exception.toString());
    };
    PhoneCodeSent codeSent;
    codeSent = (String verificationID, [int? forceResnedingtoken]) {
      showSnackBar(context, "Verification Code sent on the phone number");
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (builder) => Otp(
            number: phoneNumber,
            verificationIdFinal: verificationID,
          ),
        ),
      );
      if (kDebugMode) {
        print(verificationID);
      }
    };

    PhoneCodeAutoRetrievalTimeout codeAutoRetrievalTimeout;
    codeAutoRetrievalTimeout = (String verificationID) {
      showSnackBar(context, "Time out");
    };
    try {
      await _auth.verifyPhoneNumber(
          timeout: const Duration(seconds: 60),
          phoneNumber: phoneNumber,
          verificationCompleted: verificationCompleted,
          verificationFailed: verificationFailed,
          codeSent: codeSent,
          codeAutoRetrievalTimeout: codeAutoRetrievalTimeout);
    } catch (e) {
      showSnackBar(context, e.toString());
    }
  }

  // Sign in with phone number
  Future<Users?> signInwithPhoneNumber(String verificationId, String smsCode, BuildContext context) async {
    try {
      AuthCredential credential = PhoneAuthProvider.credential(verificationId: verificationId, smsCode: smsCode);
      UserCredential userCredential = await _auth.signInWithCredential(credential);
      // storeTokenAndData(userCredential);
      showSnackBar(context, "logged In");
      return _userFromFirebase(userCredential.user);
    } catch (e) {
      showSnackBar(context, e.toString());
      return null;
    }
  }

  void showSnackBar(BuildContext context, String text) {
    final snackBar = SnackBar(content: Text(text));
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  // SignIn with Google
  Future<Users?> signInWithGoogle() async {
    try {
      // trigger the authentication flow
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

      // Obtain auth details from the GoogleUser object
      final GoogleSignInAuthentication? googleAuth = await googleUser?.authentication;

      // Create a new credential
      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth?.accessToken,
        idToken: googleAuth?.idToken,
      );
      // Once signed in, return the User object
      UserCredential result = await _auth.signInWithCredential(credential);
      return _userFromFirebase(result.user);
    } catch (e) {
      if (kDebugMode) {
        print(e.toString());
      }
      return null;
    }
  }

  // SignOut
  Future signOut() async {
    try {
      return await _auth.signOut();
    } catch (e) {
      if (kDebugMode) {
        print(e.toString());
      }
      return null;
    }
  }
}
