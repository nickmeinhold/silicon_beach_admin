import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:redux/redux.dart';
import 'package:silicon_beach_admin/models/app_state.dart';
import 'package:silicon_beach_admin/redux/middleware.dart';
import 'package:silicon_beach_admin/redux/reducers.dart';
import 'package:silicon_beach_admin/services/auth_service.dart';
import 'package:silicon_beach_admin/widgets/auth_page.dart';

import '../mocks/all_mocks.dart';

void main() {
  group('AuthPage', () {
    testWidgets('displays sign in button', (WidgetTester tester) async {
      // create a basic store with middleware, services and reducers
      final store = Store<AppState>(
        appReducer,
        initialState: AppState.init(),
        middleware: [
          ...createMiddleware(
              AuthService(Mocks.fakeFirebaseAuth1(), Mocks.fakeGoogleSignIn()),
              null),
        ],
      );

      final authPageFinder = find.text('SIGN IN');

      // build our app and trigger a frame
      await tester.pumpWidget(
        // create a StoreProvider to wrap widget
        StoreProvider<AppState>(
          store: store,
          child: MaterialApp(home: AuthPage()),
        ),
      );

      // check that the Text with the expected String is in the widget tree
      expect(authPageFinder, findsOneWidget);
    });

    testWidgets('dispatches SigninWithGoogle on tap',
        (WidgetTester tester) async {
      final signinButtonFinder = find.text('SIGN IN');

      // create a basic store with middleware, services and reducers
      final store = Store<AppState>(
        appReducer,
        initialState: AppState.init(),
        middleware: [
          ...createMiddleware(
              AuthService(
                  Mocks.fakeFirebaseAuth1(), Mocks.fakeGoogleSignInCancels()),
              null),
        ],
      );

      // build our app and trigger a frame
      await tester.pumpWidget(
        // create a StoreProvider to wrap widget
        StoreProvider<AppState>(
          store: store,
          child: MaterialApp(home: AuthPage()),
        ),
      );

      await tester.tap(signinButtonFinder);

      // the fake google sign in we created returns null, as when the
      // user cancels, so the steps should have been reset to 0
      expect(store.state.authStep, 0);
    });
  });
}
