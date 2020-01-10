import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:silicon_beach_admin/models/actions.dart';
import 'package:silicon_beach_admin/models/user.dart';
import 'package:silicon_beach_admin/services/auth_service.dart';

class AltAuthService extends AuthService {
  @override
  final FirebaseAuth _fireAuth;

  @override
  final GoogleSignIn _googleSignIn;

  AltAuthService(this._fireAuth, this._googleSignIn)
      : super(_fireAuth, _googleSignIn);

  @override
  Stream<Action> get streamOfStateChanges {
    return Stream.value(Action.StoreUser(
      user: User((b) => b
        ..displayName = 'Nick'
        ..email = 'nick.meinhold@gmail.com'
        ..photoUrl =
            'https://lh3.googleusercontent.com/-q5LxfJgDNZU/AAAAAAAAAAI/AAAAAAAAAAA/ACHi3rcQQ5y0EMkiDgC2JcKNJwFQHMM7TQ/photo.jpg'
        ..uid = 'uid'),
    ));
  }
}
