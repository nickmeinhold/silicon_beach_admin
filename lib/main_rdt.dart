import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:redux/redux.dart';
import 'package:redux_remote_devtools/redux_remote_devtools.dart';
import 'package:silicon_beach_admin/redux/middleware.dart';
import 'package:silicon_beach_admin/redux/reducers.dart';
import 'package:silicon_beach_admin/services/firestore_service.dart';
import 'package:silicon_beach_admin/util/mocks.dart';
import 'package:silicon_beach_admin/widgets/app.dart';

import 'models/app_state.dart';
import 'services/auth_service.dart';

void main() async {
  final remoteDevtools = RemoteDevToolsMiddleware(imac22);

  final store = Store<AppState>(
    appReducer,
    initialState: AppState.init(),
    middleware: [
      remoteDevtools,
      ...createMiddleware(
        AuthService(
            FirebaseAuth.instance, GoogleSignIn(scopes: <String>['email'])),
        FirestoreService(),
      ),
    ],
  );

  remoteDevtools.store = store;

  try {
    await remoteDevtools.connect();
  } on Exception catch (e) {
    print(e);
  }

  runApp(SpaceApp(injectedStore: store));
}
