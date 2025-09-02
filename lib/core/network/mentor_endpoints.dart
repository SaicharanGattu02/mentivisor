class MentorEndpointsUrls {
  static const String apiUrl = 'api/';
  static const String userUrl = '${apiUrl}users/';

  /// Mentor
  static const String get_banners = "${apiUrl}banners";
  static const String get_sessions = "${userUrl}sessions/upcoming";
  static const String sessions_cancelled = "${userUrl}session/cancel";
  static const String mentor_profile = "${userUrl}mentor/profile";
  static const String mentor_profile_update = "${userUrl}mentor/profile/update";
  static const String feedback = "${userUrl}mentors/feedback-ui";
  static const String mentees = "${userUrl}mentees-with-sessions";
  static const String report_mentee = "${userUrl}mentor-reports";
  static const String mymenteelist = "${userUrl}my-mentees";
  static const String mentorinfo = "${userUrl}/info";
  static const String add_mentor_availability =
      "${userUrl}/add-mentor-availability";
  static const String mentor_availability_slots =
      "${userUrl}mentor/recent-slots";
}
