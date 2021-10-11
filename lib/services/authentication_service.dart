import 'package:fsproj/locator.dart';
import 'package:fsproj/models/user.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:fsproj/services/firestore_service.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter_facebook_login/flutter_facebook_login.dart';
import 'package:twitter_login/twitter_login.dart';

class AuthenticationService {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final FirestoreService _firestoreService = locator<FirestoreService>();

  AUser _currentUser;
  AUser get currentUser => _currentUser;

  Future loginWithEmail({
    @required String email,
    @required String password,
  }) async {
    try {
      var authResult = await _firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      await _populateCurrentUser(authResult.user);
      return authResult.user != null;
    } catch (e) {
      return e.message;
    }
  }

  Future signInWithGoogle() async {
    final GoogleSignIn googleSignIn = GoogleSignIn();
    final GoogleSignInAccount googleUser = await googleSignIn.signIn();

    if (googleUser != null) {
      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;
      if (googleAuth.accessToken != null && googleAuth.idToken != null) {
        final UserCredential authResult = await _firebaseAuth
            .signInWithCredential(GoogleAuthProvider.credential(
          idToken: googleAuth.idToken,
          accessToken: googleAuth.accessToken,
        ));

        await _populateCurrentUser(authResult.user);
        return authResult.user != null;

        //return _userFromFirebase(authResult.user);
      } else {
        throw PlatformException(
            code: 'ERROR_MISSING_GOOGLE_AUTH_TOKEN',
            message: 'Missing Google Auth Token');
      }
    } else {
      throw PlatformException(
          code: 'ERROR_ABORTED_BY_USER', message: 'Sign in aborted by user');
    }
  }

  Future signInWithFacebook() async {
    final FacebookLogin facebookLogin = FacebookLogin();

    facebookLogin.loginBehavior = FacebookLoginBehavior.webViewOnly;
    final FacebookLoginResult result =
        await facebookLogin.logIn(<String>['email']);
    if (result.accessToken != null) {
      final UserCredential authResult =
          await _firebaseAuth.signInWithCredential(
        FacebookAuthProvider.credential(result.accessToken.token),
      );

      await _populateCurrentUser(authResult.user);
      return authResult.user != null;
    } else {
      throw PlatformException(
          code: 'ERROR_ABORTED_BY_USER', message: 'Sign in aborted by user');
    }
  }

  Future signInWithTwitter() async {
    final TwitterLogin _twitterLogin = TwitterLogin(
        apiKey: "5Xpe4zA2fCGjJkwEy3ARl3YRK",
        apiSecretKey: "CLAQtqzfQ8veBXM9QFcLk9bLSj2gutnhlXjsp1ZpPm5eI98Atm",
        redirectURI: "twitter-firebase-auth://");

    final result = await _twitterLogin.login();
    print("Twitter authorized ${result.status}");

    switch (result.status) {
      case TwitterLoginStatus.loggedIn:
        var session = result;
        final AuthCredential credential = TwitterAuthProvider.credential(
            accessToken: session.authToken, secret: session.authTokenSecret);
        final UserCredential authResult =
            await _firebaseAuth.signInWithCredential(credential);
        print('Twitter signed in');

        await _populateCurrentUser(authResult.user);
        return authResult.user != null;

        break;
      case TwitterLoginStatus.cancelledByUser:
        throw PlatformException(
          code: 'ERROR_ABORTED_BY_USER',
          message: 'Sign in cancelled by user',
        );
        break;
      case TwitterLoginStatus.error:
        //print(TwitterLoginStatus.error.toString());
        throw PlatformException(
          code: 'ERROR_AUTHORIZATION_DENIED',
          message: 'Sign in failure for Twitter',
        );
        break;
    }
    return null;
  }

  Future SaveProfile({
    @required String useruid,
    @required String email,
    @required String fullname,
    @required String team,
    @required String photoUrl,
  }) async {
    try {
      // create a new user profile on firestore
      _currentUser = AUser(
        id: useruid,
        email: email,
        fullname: fullname,
        team: team,
        photoUrl: photoUrl,
      );

      await _firestoreService.createUser(_currentUser);

      return true;
    } catch (e) {
      return e.message;
    }
  }

  Future signUpWithEmail({
    @required String email,
    @required String password,
    @required String fullname,
    @required String role,
    @required String team,
  }) async {
    try {
      var authResult = await _firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      // create a new user profile on firestore
      _currentUser = AUser(
        id: authResult.user.uid,
        email: email,
        fullname: fullname,
        userRole: role,
        team: team,
      );

      await _firestoreService.createUser(_currentUser);

      return authResult.user != null;
    } catch (e) {
      return e.message;
    }
  }

  Future<bool> isUserLoggedIn() async {
    var user = await _firebaseAuth.currentUser;
    await _populateCurrentUser(user);
    return user != null;
  }

  Future _populateCurrentUser(User user) async {
    if (user != null) {
      _currentUser = await _firestoreService.getUser(user.uid);
      print(_currentUser.email);
      if (_currentUser.id == null) {
        _currentUser = AUser(
            email: user.email,
            fullname: user.displayName,
            id: user.uid,
            photoUrl: user.photoURL);

        await _firestoreService.createUser(_currentUser);
      }
    }
  }

  Future<void> signOut() async {
    final GoogleSignIn googleSignIn = GoogleSignIn();
    await googleSignIn.signOut();
    final FacebookLogin facebookLogin = FacebookLogin();
    await facebookLogin.logOut();
    return _firebaseAuth.signOut();
  }
}
