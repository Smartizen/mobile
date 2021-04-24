import 'package:flutter_dotenv/flutter_dotenv.dart';

class UrlProvider {
  static String base = DotEnv().env['API_URL'];

  /// url auth
  static String get auth {
    return '$base/auth';
  }

  static String get login {
    return '$base/auth/login';
  }

  static String get signup {
    return '$base/auth/signup';
  }

  /// url house
  static String get createNewHouse {
    return '$base/house';
  }

  static String get getHouses {
    return '$base/house/myHouse';
  }

  static String getHouseDetail(String id) {
    return '$base/house/$id';
  }

  /// url rooms
  static String get createNewRoom {
    return '$base/room';
  }

  static String getRoomDetail(String id) {
    return '$base/room/$id';
  }

  /// Device
  static String get addDevice {
    return '$base/active';
  }

  static String getAllDevice(String id) {
    return '$base/active/$id';
  }
}
