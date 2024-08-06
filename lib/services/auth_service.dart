// ignore_for_file: avoid_print

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:intl/intl.dart';

class AuthService {
  //?

  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  final storageBox = GetStorage();
  final photoUrl =
      "https://firebasestorage.googleapis.com/v0/b/chati-1f244.appspot.com/o/user_image.png?alt=media&token=71b372a3-53fd-495d-ba87-38569f8eb434";

  Future<UserCredential?> signInWithGoogle() async {
    ///
    final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();

    if (googleUser != null) {
      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );
      return await _firebaseAuth.signInWithCredential(credential);
    } else {
      return null;
    }
  }

  Future<void> signOut() async {
    await _firebaseAuth.signOut();
    await _googleSignIn.signOut();
  }

  ///
  Future addGoogleUSerToFireStore(user1) async {
    ///
    DateTime now = DateTime.now();
    DateFormat formatter = DateFormat('yyyy-MM-dd');
    var todate = formatter.format(now);

    // var tmpList = getUserSearchIndex(user1.user!);

    var tmpUser = {
      "fullName": user1.user!.displayName,
      "email": user1.user!.email,
      "photoUrl": photoUrl,
      "uid": user1.user!.uid,
      "password": "google",
      "regiDate": todate,
      "verified": false,
      "loginMode": "google",
      "pushId": "",
      "pushSwitch": true,
      "emailSwitch": true,
      "searchIndex": [],
    };

    return await FirebaseFirestore.instance
        .collection("users")
        .doc(user1.user.uid)
        .set(tmpUser)
        .whenComplete(
      () {
        storageBox.write("userProfile", tmpUser);
        print("Wenn Completed");
      },
    );
  }
}
