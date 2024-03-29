import 'package:smartizen/Redux/action.dart';
import 'package:smartizen/Redux/app_state.dart';

AppState appReducer(state, action) {
  return AppState(
      user: userReducer(state.user, action),
      houses: housesReducer(state.houses, action),
      defaultHouse: defaultHousesReducer(state.defaultHouse, action),
      roomDetail: roomDetailReducer(state.roomDetail, action),
      currentDevice: currentDeviceReducer(state.currentDevice, action),
      members: membersReducer(state.members, action),
      notifications: notificationReducer(state.notifications, action));
}

userReducer(user, action) {
  if (action is GetUserAction) {
    return action.user;
  }
  return user;
}

housesReducer(houses, action) {
  if (action is GetHousesAction) {
    return action.houses;
  }
  return houses;
}

defaultHousesReducer(defaultHouse, action) {
  if (action is GetDefaultHouseAction) {
    return action.defaultHouse;
  }
  return defaultHouse;
}

roomDetailReducer(roomDetail, action) {
  if (action is GetRoomDetailAction) {
    return action.roomDetail;
  }
  return roomDetail;
}

currentDeviceReducer(currentDevice, action) {
  if (action is GetCurrentDeviceAction) {
    return action.currentDevice;
  }
  return currentDevice;
}

membersReducer(members, action) {
  if (action is GetMembersAction) {
    return action.members;
  }
  return members;
}

notificationReducer(notifications, action) {
  if (action is GetNotificationsAction) {
    return action.notifications;
  }
  return notifications;
}
