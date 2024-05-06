
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

import 'package:new_app/Service/database.dart';
import 'package:new_app/components/loading_dialog.dart';
import 'package:new_app/drewer/drawerhome.dart';
import 'package:the_apple_sign_in/the_apple_sign_in.dart';

class AuthMathods {
  final FirebaseAuth auth = FirebaseAuth.instance;

  get firebaseUser => null;
  
 

  getCurrentUser() async {
    return auth.currentUser;
  }

  signInWithGoogle(BuildContext context) async {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) =>
          LoadingDialog(messageText: "Allowing you to Login..."),
    );
    final FirebaseAuth firebaseAuth = FirebaseAuth.instance;
    final GoogleSignIn googleSignIn = GoogleSignIn();
    final GoogleSignInAccount? googleSignInAccount =
        await googleSignIn.signIn();

    final GoogleSignInAuthentication? googleSignInAuthentication =
        await googleSignInAccount?.authentication;
    final AuthCredential credential = GoogleAuthProvider.credential(
        idToken: googleSignInAuthentication?.idToken,
        accessToken: googleSignInAuthentication?.accessToken);
    UserCredential result = await firebaseAuth.signInWithCredential(credential);
    User? userDetails = result.user;
    Navigator.pop(context);
    // ignore: unnecessary_null_comparison
    if (result != null) {
      Map<String, dynamic> userInfoMap = {
        "email": userDetails!.email,
        "NAME": userDetails.displayName,
        "imgUrl": userDetails.photoURL,
        "id": userDetails.uid,
        
      };
      await DatabaseMathords()
          .addUser(userDetails.uid, userInfoMap)
          .then((value) {
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => const Drewer()));
      });
    }
  }

  Future<User> singInWithApple({List<Scope> scopes = const []}) async {
    final result = await TheAppleSignIn.performRequests(
        [AppleIdRequest(requestedScopes: scopes)]);
    switch (result.status) {
      case AuthorizationStatus.authorized:

        // ignore: non_constant_identifier_names
        final AppleIdCredential = result.credential!;
        final oAuthProvider = OAuthProvider('Apple.com');
        // ignore: non_constant_identifier_names
        final Credential = oAuthProvider.credential(
            idToken: String.fromCharCodes(AppleIdCredential.identityToken!));
        // ignore: non_constant_identifier_names
        final UserCredential = await auth.signInWithCredential(Credential);

        final firebaseUser = UserCredential.user!;

        if (scopes.contains(Scope.fullName)) {
          final fulName = AppleIdCredential.fullName;
          if (fulName != null &&
              fulName.givenName != null &&
              fulName.familyName != null) {}
          final displayName = '${fulName?.givenName} ${fulName?.familyName}';
          await firebaseUser.updateDisplayName(displayName);
        }

        return firebaseUser;
      case AuthorizationStatus.error:
        throw PlatformException(
          code: "ERROR_AUTHORIZATION_dRNIED",
          message: result.error.toString(),
        );

      case AuthorizationStatus.cancelled:
        throw PlatformException(
          code: "ERROR_AB0PRTED_BY_uSER",
          message: "Sign in aborted by user",
        );
      default:
        throw UnimplementedError();
    }
  }

  Future<void> loginWithFacebook() async {
    try {
      final LoginResult result = await FacebookAuth.instance.login();

      if (result.status == LoginStatus.success) {
        final OAuthCredential facebookAuthCredential =
            FacebookAuthProvider.credential(result.accessToken!.token);
        final UserCredential userCredential =
            await auth.signInWithCredential(facebookAuthCredential);
        debugPrint(
            'Login successful. Firebase UID: ${userCredential.user!.uid}');
      }
    } catch (e) {
      debugPrint('Facebook sign-in failed: $e');
    }
  }
}
