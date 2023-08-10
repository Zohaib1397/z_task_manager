// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
// import 'package:google_sign_in/google_sign_in.dart';
//
// class GoogleSignInProvider extends ChangeNotifier{
//   final googleSignIn = GoogleSignIn();
//
//   GoogleSignInAccount? _user;
//
//   GoogleSignInAccount get user => _user!;
//
//   Future googleLogin() async {
//     final googleUser = await googleSignIn.signIn();
//     if(googleUser!=null){
//       try{
//         _user = googleUser;
//         final googleAuth = await googleUser.authentication;
//         //it is GoogleSignIn().signIn().authentication.accessToken
//         //and GoogleSignIn().signIn().authentication.idToken
//         final credential = GoogleAuthProvider.credential(
//           accessToken: googleAuth.accessToken,
//           idToken: googleAuth.idToken,
//         );
//         await FirebaseAuth.instance.signInWithCredential(credential);
//         notifyListeners();
//       }catch(e){
//         print(e.toString());
//       }
//     }else{
//       return;
//     }
//
//   }
//
// }