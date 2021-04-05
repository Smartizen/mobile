import 'package:smartizen/Redux/action.dart';
import 'package:smartizen/Redux/app_state.dart';

AppState appReducer(state, action) {
  return AppState(user: userReducer(state.user, action));
}

userReducer(user, action) {
  if (action is GetUserAction) {
    return action.user;
  }
  return user;
}
