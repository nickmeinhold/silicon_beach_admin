import 'package:meta/meta.dart';
import 'package:silicon_beach_admin/models/problem.dart';
import 'package:silicon_beach_admin/models/user.dart';

class Action {
  const Action(this.propsMap);
  Action.fromJson(Map<String, dynamic> json) : propsMap = json;
  final Map<String, dynamic> propsMap;
  Map<String, dynamic> toJson() => propsMap;

  factory Action.ObserveAuthState() => ObserveAuthState();
  factory Action.StoreUser({@required User user}) => StoreUser(user: user);
  factory Action.SigninWithGoogle() => SigninWithGoogle();
  factory Action.StoreAuthStep({@required int step}) =>
      StoreAuthStep(step: step);
  factory Action.AddProblem({@required Problem problem}) =>
      AddProblem(problem: problem);
  factory Action.StoreMainPageIndex({@required int index}) =>
      StoreMainPageIndex(index: index);
}

class ObserveAuthState extends Action {
  const ObserveAuthState() : super(const <String, Object>{});
}

class StoreUser extends Action {
  StoreUser({@required this.user}) : super(<String, Object>{'user': user});
  final User user;
}

class SigninWithGoogle extends Action {
  SigninWithGoogle() : super(<String, Object>{});
}

class StoreAuthStep extends Action {
  StoreAuthStep({@required this.step}) : super(<String, Object>{'step': step});
  final int step;
}

class AddProblem extends Action {
  AddProblem({@required this.problem})
      : super(<String, Object>{'problem': problem});
  final Problem problem;
}

class StoreMainPageIndex extends Action {
  StoreMainPageIndex({@required this.index})
      : super(<String, Object>{'index': index});
  final int index;
}
