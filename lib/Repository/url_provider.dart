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
    return '$base/farm';
  }

  static String get getHouses {
    return '$base/farm/myFarm';
  }

  static String getHouseDetail(String id) {
    return '$base/farm/$id';
  }

  /// url rooms
  static String get createNewRoom {
    return '$base/crop';
  }

  static String getRoomDetail(String id) {
    return '$base/crop/$id';
  }

  /// Device
  static String get addDevice {
    return '$base/device-belong';
  }

  static String getAllDevice(String id) {
    return '$base/device-belong/$id';
  }
}
