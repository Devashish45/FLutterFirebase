import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../home/home_screen.dart';
import 'OtpScreen.dart';
import 'LoginScreen.dart';

String logTag = 'AppLogs';

class AuthRepo {
  static String verId = "";
  static final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  static void verifyPhoneNumber(BuildContext context, String number) async {
    await _firebaseAuth.verifyPhoneNumber(
      phoneNumber: '+91 $number',
      verificationCompleted: (PhoneAuthCredential credential) {
        signInWithPhoneNumber(
          context,
          credential.verificationId!,
          credential.smsCode!,
        );
      },
      verificationFailed: (FirebaseAuthException e) {
        if (e.code == 'invalid-phone-number') {
          debugPrint('$logTag The provided phone number is not valid.');
        }
      },
      codeSent: (String verificationId, int? resendToken) {
        verId = verificationId;
        debugPrint("$logTag verficationId $verId");
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (ctx) {
              return OtpScreen();
            },
          ),
        );
        debugPrint("$logTag code sent");
      },
      codeAutoRetrievalTimeout: (String verificationId) {},
    );
  }

  static void logoutApp(BuildContext context) async {
    await _firebaseAuth.signOut();
    // ignore: use_build_context_synchronously
    Navigator.push(context, MaterialPageRoute(builder: (ctx) => LoginScreen()));
  }

  static void submitOtp(BuildContext context, String otp) {
    signInWithPhoneNumber(context, verId, otp);
  }

  static bool checkIfLoggedIn() {
    User? user = _firebaseAuth.currentUser;
    if (user != null) {
      debugPrint('$logTag User ${user.uid} is logged in with phone: ${user
          .phoneNumber}');
      return true;
    } else {
      debugPrint('$logTag User not logged in');
      return false;
    }
  }

  static Future<void> signInWithPhoneNumber(
    BuildContext context,
    String verificationId,
    String smsCode,
  ) async {
    try {
      final AuthCredential credential = PhoneAuthProvider.credential(
        verificationId: verificationId,
        smsCode: smsCode,
      );
      final UserCredential userCredential = await _firebaseAuth
          .signInWithCredential(credential);
      debugPrint(userCredential.user!.phoneNumber);
      debugPrint("$logTag Login successful");
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) {
            return const Homescreen();
          },
        ),
      );
    } catch (e) {
      debugPrint('$logTag Error signing in with phone number: $e');
    }
  }
}
