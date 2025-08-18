class APIEndpointUrls {
  static const String apiUrl = 'api/';
  static const String userUrl = '${apiUrl}users/';

  /// Auth URls
  static const String login = '${apiUrl}user-login';

  /// auth get register
  static const String get_compuses = "${apiUrl}Campuses";
  static const String registerscreen = "${apiUrl}registration-step-1";
  static const String verifyotp = "${apiUrl}registration-verify-step-2";
  static const String final_registeration = "${apiUrl}final-registration";
  static const String get_books = "${apiUrl}users/study-zones";
  static const String getoncampose = "${apiUrl}list-mentor-own-campus";
  static const String gettopmentors = "${apiUrl}top-mentors";
  static const String studyzonedownload_wl =
      "${apiUrl}users/study-zone/download";
  static const String eccguestlist = "${apiUrl}guest-list-ecc";
  static const String guestcommunitytags_wol =
      "${apiUrl}community-zone-tags-without-login";
  static const String wallet_money = "${apiUrl}users/my-wallet";

  /// Mentee
  static const String get_mentors = "${userUrl}mentors";
  static const String study_zone_tags = "${userUrl}study-zone/tags";
  static const String mentor_profile = "${userUrl}mentors";
  static const String list_ecc = "${userUrl}list-ecc";
  static const String study_zone_campus = "${userUrl}/study-zones";
  static const String coins_pack = "${userUrl}/coin-packs";
  static const String community_zone_post = "${userUrl}/community-zone-post";
  static const String study_zone_report_resource = "${userUrl}/study-zone-report";
  static const String my_downloads = "${userUrl}/my-downloads";
  static const String add_ecc = "${userUrl}/add-ecc";
  static const String add_comment = "${userUrl}community/add-comment";
  static const String community_zone_tags = "${userUrl}community-zone-tags";
  static const String add_community = "${userUrl}add-community";
  static const String task_by_date = "${userUrl}/tasks";
  static const String task_by_states = "${userUrl}/tasks/stats";
  static const String task_update = "${userUrl}/tasks/";
  static const String task_delete = "${userUrl}/tasks/";
  static const String add_task = "${userUrl}/tasks/";
  static const String add_book = "${userUrl}add-book";
  static const String get_campuses = "${apiUrl}campuses";
  static const String get_years = "${apiUrl}years";
  static const String get_expertise = "${userUrl}expertise";
  static const String become_mentor = "${userUrl}become-mentor";
  static const String mentee_profile = "${userUrl}user-profile";
  static const String mentee_profile_update = "${userUrl}profile/update";
  static const String get_Exclusive_services = "${userUrl}services";
  static const String get_Exclusive_services_details = "${userUrl}services";
  static const String weekly_slots = "${userUrl}mentor/weekly-slots";
  static const String daily_slots = "${userUrl}mentor/daily-slots";
  static const String select_slot = "${userUrl}select-slot";
  static const String book_slot = "${userUrl}session/book-slot";
  static const String create_paymenet = "${userUrl}razorpay/order";
  static const String verify_paymenet = "${userUrl}razorpay/verify";
  static const String upcoming_session = "${userUrl}sessions/upcoming";
  static const String session_completed = "${userUrl}sessions/complete";
  static const String completed_sessions_submit_review  = "${userUrl}sessions/feedback";
  static const String sessions_report_submit = "${userUrl}session-report'";

  ///Guest urls
  static const String guest_study_zone_tags = "${apiUrl}study-zone/tags";
  static const String guest_mentors = "${apiUrl}top-mentors";
  static const String guest_study_zone = "${apiUrl}study-zone/top-downloads";
  static const String guest_list_ecc = "${apiUrl}guest-list-ecc?upcoming=true";
  static const String guest_community_post =
      "${apiUrl}community-zone-post-without-login";
  static const String get_banners = "${apiUrl}banners";
}
