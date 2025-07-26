class APIEndpointUrls {
  static const String baseUrl = 'http://192.168.80.42:8000/';

  static const String apiUrl = 'api/';

  /// Auth URls
  static const String login = '${apiUrl}user-login';

  /// auth get register
  static const String get_compuses = "${apiUrl}campuses";
  static const String get_years = "${apiUrl}years";
  static const String registerscreen = "${apiUrl}registration-step-1";
  static const String verifyotp = "${apiUrl}verify-otp";
  static const String get_banners = "${apiUrl}banners";
  static const String get_books = "${apiUrl}users/study-zones";
  static const String get_expertise = "${apiUrl}users/expertise";
  static const String getoncampose = "${apiUrl}list-mentor-own-campus";
  static const String gettopmentors = "${apiUrl}top-mentors";
  static const String becomementor = "${apiUrl}users/become-mentor";


}
