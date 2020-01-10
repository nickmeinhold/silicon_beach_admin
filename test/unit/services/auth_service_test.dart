import 'package:silicon_beach_admin/models/actions.dart';
import 'package:silicon_beach_admin/models/problem.dart';
import 'package:silicon_beach_admin/services/auth_service.dart';
import 'package:test/test.dart';

import '../../mocks/all_mocks.dart';

void main() {
  group('Auth Service', () {
    // has a method that returns a stream that emits user

    test('provides a stream of user objects', () {
      final service =
          AuthService(Mocks.fakeFirebaseAuth1(), Mocks.fakeGoogleSignIn());

      service.streamOfStateChanges.listen(expectAsync1((action) {
        expect(action is StoreUser, true);
      }, count: 2));
    });

    test('googleSignInStream resets auth steps on cancel', () {
      final service = AuthService(
          Mocks.fakeFirebaseAuth1(), Mocks.fakeGoogleSignInCancels());

      // the service should set auth step to 1 (signing in with google)
      // then due to user cancel (which means google sign in returns null)
      // the service should reset the auth step to 0
      final expectedAuthSteps = [1, 0];

      service.googleSignInStream.listen(expectAsync1((action) {
        expect((action as StoreAuthStep).step, expectedAuthSteps.removeAt(0));
      }, count: 2));
    });

    test('googleSignInStream emits StoreAuthStep actions at each stage', () {
      final service =
          AuthService(Mocks.fakeFirebaseAuth1(), Mocks.fakeGoogleSignIn());

      // the service should set auth step to 1 (signing in with google)
      // then 2 (signing in with Firebase) then reset to 0
      final expectedAuthSteps = [1, 2, 0];

      service.googleSignInStream.listen(expectAsync1((action) {
        expect((action as StoreAuthStep).step, expectedAuthSteps.removeAt(0));
      }, count: 3));
    });

    // test that errors are handled by being passed to the store
    test('googleSignInStream catches errors and emits StoreProblem actions',
        () async {
      final service = AuthService(
          Mocks.fakeFirebaseAuth1(), Mocks.fakeGoogleSignInThrows());

      // the service will emit step 1 indicating google signin is occuring
      // the google signin throws and the service catches the exception then
      // emits an action to reset the auth step then emits a problem with info
      // about the exception
      expect(
          service.googleSignInStream,
          emitsInOrder([
            TypeMatcher<StoreAuthStep>()..having((a) => a.step, 'step', 1),
            TypeMatcher<StoreAuthStep>()..having((a) => a.step, 'step', 0),
            TypeMatcher<AddProblem>()
              ..having((p) => p.problem.type, 'type', ProblemTypeEnum.signin)
              ..having((p) => p.problem.message, 'message',
                  equals('Exception: GoogleSignIn.signIn')),
            emitsDone,
          ]));
    });
  });
}
