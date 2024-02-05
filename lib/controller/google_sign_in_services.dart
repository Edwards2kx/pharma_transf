import 'package:google_sign_in/google_sign_in.dart';

class GoogleSignInService {
  static GoogleSignIn _googleSignIn = GoogleSignIn(scopes: <String>['email']);

  static Future<GoogleSignInAccount?> signInWithGoogle() async {
    return await _googleSignIn.signIn();
  }

  static Future<GoogleSignInAccount?> signInSilenty() async {
    return await _googleSignIn.signInSilently();
  }

  static Future signOut() async {
    await _googleSignIn.signOut();
  }

  static Future<bool> isSignedIn() async {
    return await _googleSignIn.isSignedIn();
  }

  static GoogleSignInAccount? currentUser() {
    return _googleSignIn.currentUser;
  }
}
