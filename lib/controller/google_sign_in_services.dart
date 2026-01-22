import 'package:google_sign_in/google_sign_in.dart';

class GoogleSignInService {
  static GoogleSignIn _googleSignIn = GoogleSignIn(
      serverClientId:
          "47710456414-c222nbhod52o4nvekrlicdm47avq3gig.apps.googleusercontent.com",
      scopes: <String>['email']);

  static Future<GoogleSignInAccount?> signInWithGoogle() async {
    try {
      return await _googleSignIn.signIn();
    } catch (e) {
      print('Error en Google SignIn: $e');
      return null;
    }
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
