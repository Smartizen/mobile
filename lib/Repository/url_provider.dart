import 'package:flutter_dotenv/flutter_dotenv.dart';

class UrlProvider {
  static String base = DotEnv().env['API_URL'];

  static String get auth {
    return '$base/auth';
  }

  static String get login {
    return '$base/auth/login';
  }

  static String get signup {
    return '$base/auth/signup';
  }

  // static String ticket(String id) {
  //   return '$base/tickets/$id';
  // }

  // static String ticketBookmark(String id) {
  //   return '$base/tickets/$id/bookmark';
  // }
}
