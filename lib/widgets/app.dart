import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart' hide Action;
import 'package:flutter_redux/flutter_redux.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:redux/redux.dart';
import 'package:silicon_beach_admin/models/actions.dart';
import 'package:silicon_beach_admin/models/app_state.dart';
import 'package:silicon_beach_admin/models/user.dart';
import 'package:silicon_beach_admin/redux/middleware.dart';
import 'package:silicon_beach_admin/redux/reducers.dart';
import 'package:silicon_beach_admin/services/firestore_service.dart';
import 'package:silicon_beach_admin/util/alt_auth_service.dart';
import 'package:silicon_beach_admin/widgets/auth_page.dart';
import 'package:silicon_beach_admin/widgets/main_page.dart';

class SpaceApp extends StatefulWidget {
  SpaceApp({this.injectedStore});
  final Store<AppState> injectedStore;
  @override
  _SpaceAppState createState() => _SpaceAppState();
}

class _SpaceAppState extends State<SpaceApp> {
  Store<AppState> store;

  @override
  void initState() {
    super.initState();

    // use the injected store or create a new one
    store = widget.injectedStore ??
        Store<AppState>(
          appReducer,
          initialState: AppState.init(),
          middleware: [
            ...createMiddleware(
              AltAuthService(FirebaseAuth.instance,
                  GoogleSignIn(scopes: <String>['email'])),
              FirestoreService(),
            ),
          ],
        );

    store.dispatch(Action.ObserveAuthState());
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: StoreProvider<AppState>(
        store: store,
        child: StoreConnector<AppState, User>(
          distinct: true,
          converter: (store) => store.state.user,
          builder: (context, user) {
            return (user == null || user.uid == null) ? AuthPage() : MainPage();
          },
        ),
      ),
    );
  }
}
