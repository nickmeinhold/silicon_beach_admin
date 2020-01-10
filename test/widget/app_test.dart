import 'package:flutter_test/flutter_test.dart';
import 'package:redux/redux.dart';
import 'package:silicon_beach_admin/models/app_state.dart';
import 'package:silicon_beach_admin/redux/middleware.dart';
import 'package:silicon_beach_admin/redux/reducers.dart';
import 'package:silicon_beach_admin/services/auth_service.dart';
import 'package:silicon_beach_admin/widgets/app.dart';

import '../mocks/all_mocks.dart';
import '../mocks/mock_firebase_auth.dart';

void main() {
  group('SpaceApp widget', () {
    testWidgets('observes auth state on load and navigates',
        (WidgetTester tester) async {
      final fakeFirebaseAuth = Mocks.fakeFirebaseAuthOpen();
      final fakeGoogleSignIn = Mocks.fakeGoogleSignIn();
      // create a basic store with middleware that uses the AuthService to
      // observe auth state and a reducer that saves the emitted auth state
      final store = Store<AppState>(
        appReducer,
        initialState: AppState.init(),
        middleware: [
          ...createMiddleware(
              AuthService(fakeFirebaseAuth, fakeGoogleSignIn), null),
        ],
      );

      fakeFirebaseAuth.add(FakeFirebaseUserNull());

      // build our app and trigger a frame
      await tester.pumpWidget(SpaceApp(injectedStore: store));

      // Create the Finders.
      final authPageFinder = find.text('SIGN IN');
      final mainPageFinder = find.text('More');

      // Use the `findsOneWidget` matcher to verify that a Text widget with the
      // expected String appears exactly once in the widget tree, indicating the
      // AuthPage widget is present, so the expected navigation has occured
      expect(authPageFinder, findsOneWidget);
      expect(mainPageFinder, findsNothing);

      // add a FirebaseUser
      fakeFirebaseAuth.add(FakeFirebaseUser());

      await tester.pump();

      // Check that the Main Page is now shown
      expect(mainPageFinder, findsOneWidget);
      expect(authPageFinder, findsNothing);

      //
    });
  });
}
