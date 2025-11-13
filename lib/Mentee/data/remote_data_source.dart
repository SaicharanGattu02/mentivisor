import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:mentivisor/Mentee/Models/DownloadsModel.dart';
import 'package:mentivisor/Mentee/Models/ExclusiveServicesModel.dart';
import 'package:mentivisor/Mentee/Models/ExclusiveservicedetailsModel.dart';
import 'package:mentivisor/Mentee/Models/GetBannersRespModel.dart';
import 'package:mentivisor/Mentee/Models/LoginResponseModel.dart';
import 'package:mentivisor/Mentee/Models/MenteeCustmor_supportModel.dart';
import 'package:mentivisor/Mentee/Models/MilestonesModel.dart';
import 'package:mentivisor/Mentee/Models/WalletModel.dart';
import 'package:mentivisor/Mentee/Models/YearsModel.dart';
import 'package:mentivisor/core/network/api_config.dart';
import 'package:mentivisor/services/AuthService.dart';
import 'package:mentivisor/utils/AppLogger.dart';
import '../../Mentor/Models/CoinsAchievementModel.dart';
import '../../Mentor/Models/FeedbackModel.dart';
import '../Models/BecomeMentorSuccessModel.dart';
import '../Models/CampusesModel.dart';
import '../Models/ChatMessagesModel.dart';
import '../Models/CoinsPackRespModel.dart';
import '../Models/CommonProfileModel.dart';
import '../Models/CommunityDetailsModel.dart';
import '../Models/CommunityPostsModel.dart';
import '../Models/CommunityZoneTagsModel.dart';
import '../Models/CompletedSessionModel.dart';
import '../Models/CreatePaymentModel.dart';
import '../Models/DailySlotsModel.dart';
import '../Models/GetExpertiseModel.dart';
import '../Models/GetHomeDilogModel.dart';
import '../Models/GroupChatMessagesModel.dart';
import '../Models/GuestMentorsModel.dart';
import '../Models/HighlatedCoinsModel.dart';
import '../Models/LeaderBoardModel.dart';
import '../Models/MenteeProfileModel.dart';
import '../Models/NotificationModel.dart';
import '../Models/ProductToolTaskByDateModel.dart';
import '../Models/ResourceDetailsModel.dart';
import '../Models/ReviewSubmitModel.dart';
import '../Models/SelectSlotModel.dart';
import '../Models/SessionBookingModel.dart';
import '../Models/StudyZoneCampusModel.dart';
import '../../core/network/mentee_endpoints.dart';
import '../Models/CompusMentorListModel.dart';
import '../Models/ECCModel.dart';
import '../Models/MentorProfileModel.dart';
import '../Models/SuccessModel.dart';
import '../Models/StudyZoneTagsModel.dart';
import '../Models/OtpVerifyModel.dart';
import '../Models/RegisterModel.dart';
import '../../services/ApiClient.dart';
import '../Models/TagsModel.dart';
import '../Models/TaskStatesModel.dart';
import '../Models/UpComingSessionModel.dart';
import '../Models/UploadFileInChatModel.dart';
import '../Models/ViewEccDetailsModel.dart';
import '../Models/WeeklySlotsModel.dart';
import '../Models/checkInModel.dart';

abstract class RemoteDataSource {
  Future<LogInModel?> login(Map<String, dynamic> data);
  Future<RegisterModel?> Register(Map<String, dynamic> data);
  Future<RegisterModel?> finalRegister(Map<String, dynamic> data);
  Future<Otpverifymodel?> Verifyotp(Map<String, dynamic> data);
  Future<GetBannersRespModel?> getbanners();
  Future<WalletModel?> getWallet(int id, int page);
  Future<CompusMentorListModel?> getCampusMentorList(
    String scope,
    String search,
  );
  Future<GuestMentorsModel?> getGuestMentorsList();
  Future<MentorProfileModel?> getMentorProfile(int id);
  Future<CommonProfileModel?> commonProfile(int id);
  Future<ECCModel?> getEcc(
    String scope,
    String updates,
    String search,
    int page,
  );
  Future<SuccessModel?> addEcc(Map<String, dynamic> data);
  Future<StudyZoneCampusModel?> getStudyZoneCampus(
    String scope,
    String tag,
    String search,
    int page,
  );
  Future<CommunityPostsModel?> getCommunityPosts(
    String scope,
    String post,
    int page,
  );
  Future<DownloadsModel?> getDownloads(int page);
  Future<SuccessModel?> postStudyZoneReport(Map<String, dynamic> data);
  Future<SuccessModel?> postComment(Map<String, dynamic> data);
  Future<TaskStatesModel?> getTaskByStates();
  Future<ProductToolTaskByDateModel?> getTaskByDate(String date);
  Future<SuccessModel?> putTaskComplete(int taskId);
  Future<SuccessModel?> TaskDelete(int taskId);
  Future<CommunityZoneTagsModel?> getCommunityZoneTags();
  Future<SuccessModel?> addCommunityPost(Map<String, dynamic> data);
  Future<SuccessModel?> addTask(final Map<String, dynamic> data);
  Future<SuccessModel?> addResource(Map<String, dynamic> data);
  Future<CampusesModel?> getCampuses(int page);
  Future<YearsModel?> getYears();
  Future<CoinsPackRespModel?> getcoinspack();
  Future<GetExpertiseModel?> getExpertiseSubCategory(int id);
  Future<GetExpertiseModel?> getExpertiseCategory(String search, int page);
  Future<BecomeMentorSuccessModel?> becomeMentor(
    final Map<String, dynamic> data,
  );
  Future<MenteeProfileModel?> getMenteeProfile();
  Future<ExclusiveServicesModel?> exclusiveServiceList(String search, int page);
  Future<WeeklySlotsModel?> getWeeklySlots(int mentorId, {String week = ''});
  Future<DailySlotsModel?> getDailySlots(int mentor_id, String date);
  Future<SuccessModel?> menteeProfileUpdate(final Map<String, dynamic> data);
  Future<ExclusiveservicedetailsModel?> exclusiveServiceDetails(int id);
  Future<SelectSlotModel?> selectSlot(int mentor_id, int slot_id);
  Future<SessionBookingModel?> sessionBooking(Map<String, dynamic> data);
  Future<CreatePaymentModel?> createPayment(Map<String, dynamic> data);
  Future<SuccessModel?> verifyPayment(Map<String, dynamic> data);
  Future<UpComingSessionModel?> upComingSessions();
  Future<CompletedSessionModel?> sessionsComplete();
  Future<ReviewSubmitModel?> sessionSubmitReview(
    Map<String, dynamic> data,
    int id,
  );
  Future<SuccessModel?> postSessionReport(Map<String, dynamic> data);
  Future<MenteeCustmor_supportModel?> getcustomersupport();
  Future<SuccessModel?> postToggleLike(Map<String, dynamic> data);
  Future<SuccessModel?> commentLike(int id);
  Future<SuccessModel?> resourceDownload(String id);
  Future<HighlightedCoinsModel?> highlihtedCoins(String catgory);
  Future<NotificationModel?> notifications(
    String role,
    String filter,
    int page,
  );
  Future<SuccessModel?> forgotPassword(Map<String, dynamic> data);
  Future<SuccessModel?> resetPassword(Map<String, dynamic> data);
  Future<SuccessModel?> forgotVerify(Map<String, dynamic> data);
  Future<SuccessModel?> communityZoneReport(Map<String, dynamic> data);
  Future<ResourceDetailsModel?> getResourceDetails(
    int resourceId,
    String scope,
  );
  Future<CommunityDetailsModel?> communityPostsDetails(
    int communityId,
    String scope,
  );
  Future<ChatMessagesModel?> getChatMessages(
    String user_id,
    int page,
    String sessionId,
  );
  Future<GroupChatMessagesModel?> getGroupChatMessages(int page, String Scope);
  Future<UploadFileInChatModel?> uploadFileInChat(
    Map<String, dynamic> data,
    String user_id,
    String session_id,
  );
  Future<ViewEccDetailsModel?> viewEccDetails(int eventId, String scope);
  Future<TagsModel?> getEccTags(String searchQuery);
  Future<StudyZoneTagsModel?> getStudyZoneTags(String searchQuery);
  Future<CoinsAchievementModel?> getcoinsAchievements(int page);
  Future<checkInModel?> dailyCheckins();
  Future<GetHomeDilogModel?> homeDiolog();
  Future<LeaderBoardModel?> getLeaderBoard();
  Future<MilestonesModel?> getMilestones();
  Future<SuccessModel?> groupChatReport(Map<String, dynamic> data);
  Future<SuccessModel?> privateChatReport(Map<String, dynamic> data);
}

class RemoteDataSourceImpl implements RemoteDataSource {
  final Dio dio = Dio();
  Future<FormData> buildFormData(Map<String, dynamic> data) async {
    final formMap = <String, dynamic>{};
    for (final entry in data.entries) {
      final key = entry.key;
      final value = entry.value;

      if (value == null) continue;
      final isFile =
          value is String &&
          value.contains('/') &&
          (key.contains('image') ||
              key.contains('file') ||
              key.contains('uploaded_file') ||
              key.contains('picture') ||
              key.contains('profile_pic') ||
              key.contains('resume') ||
              key.contains('attachment') ||
              key.contains('payment_screenshot'));

      if (isFile) {
        final file = await MultipartFile.fromFile(
          value,
          filename: value.split('/').last,
        );
        formMap[key] = file;
      } else {
        formMap[key] = value;
      }
    }

    formMap.forEach((key, value) {
      AppLogger.log('$key -> $value');
    });

    return FormData.fromMap(formMap);
  }

  @override
  Future<MilestonesModel?> getMilestones() async {
    try {
      Response res = await ApiClient.get("${APIEndpointUrls.mile_stone}");
      AppLogger.log('getMilestones: ${res.data}');
      return MilestonesModel.fromJson(res.data);
    } catch (e) {
      AppLogger.error('getMilestones:${e}');
      return null;
    }
  }

  @override
  Future<LeaderBoardModel?> getLeaderBoard() async {
    try {
      Response res = await ApiClient.get("${APIEndpointUrls.leader_board}");
      AppLogger.log('getLeaderBoard: ${res.data}');
      return LeaderBoardModel.fromJson(res.data);
    } catch (e) {
      AppLogger.error('getLeaderBoard:${e}');
      return null;
    }
  }

  @override
  Future<UploadFileInChatModel?> uploadFileInChat(
      Map<String, dynamic> data,
      String user_id,
      String session_id,
      ) async {
    try {
      final url = "${ApiConfig.socket_url}/api/upload-file";
      MultipartFile? filePart;
      final fileVal = data['file'];

      if (fileVal != null) {
        if (fileVal is String) {
          filePart = await MultipartFile.fromFile(
            fileVal,
            filename: fileVal.split('/').last,
          );
        } else if (fileVal is File) {
          filePart = await MultipartFile.fromFile(
            fileVal.path,
            filename: fileVal.path.split('/').last,
          );
        }
      }

      // Build a new map for FormData (don’t mutate the original)
      final Map<String, dynamic> payload = {
        ...data,
        if (filePart != null) 'file': filePart,
      };

      final formData = FormData.fromMap(payload);

      final response = await dio.post(
        url,
        data: formData,
        queryParameters: {
          "session_id": session_id,
          "user_id": user_id,
        },
        options: Options(
          contentType: 'multipart/form-data',
          // 👇 this ensures Dio never throws for non-2xx responses
          validateStatus: (_) => true,
        ),
      );

      // 👇 now you can handle all response statuses manually
      if (response.statusCode == 200 || response.statusCode == 201) {
        return UploadFileInChatModel.fromJson(response.data);
      } else {
        print("Upload failed with status ${response.statusCode}: ${response.data}");
        return UploadFileInChatModel.fromJson(response.data);
      }
    } catch (e, st) {
      print("Upload error: $e");
      print(st);
      return null;
    }
  }


  @override
  Future<GroupChatMessagesModel?> getGroupChatMessages(
    int page,
    String scope,
  ) async {
    try {
      // Base URL
      String url = "${APIEndpointUrls.get_group_messages}";

      // Build query parameters dynamically
      List<String> queryParams = [];

      if (scope.isNotEmpty) {
        queryParams.add("scope=$scope");
      }

      // Always add page parameter
      queryParams.add("page=$page");

      // Append query params to URL
      if (queryParams.isNotEmpty) {
        url += "?${queryParams.join("&")}";
      }

      AppLogger.log('getGroupChatMessages → Request URL: $url');

      // Make GET request
      Response res = await ApiClient.get(url);

      AppLogger.log('getGroupChatMessages → Response: ${res.data}');
      return GroupChatMessagesModel.fromJson(res.data);
    } catch (e, st) {
      AppLogger.error('getGroupChatMessages → Error: $e\n$st');
      return null;
    }
  }

  @override
  Future<ChatMessagesModel?> getChatMessages(
    String user_id,
    int page,
    String sessionId,
  ) async {
    try {
      Response res = await ApiClient.get(
        "${APIEndpointUrls.get_messages}/$user_id?session_id=${sessionId}&page=${page}",
      );
      AppLogger.log('getChatMessages: ${res.data}');
      return ChatMessagesModel.fromJson(res.data);
    } catch (e) {
      AppLogger.error('getChatMessages:${e}');
      return null;
    }
  }

  @override
  Future<SuccessModel?> resourceDownload(String id) async {
    try {
      Response res = await ApiClient.get(
        "${APIEndpointUrls.resource_download}/$id",
      );
      AppLogger.log('resourceDownload: ${res.data}');
      return SuccessModel.fromJson(res.data);
    } catch (e) {
      AppLogger.error('resourceDownload:${e}');
      return null;
    }
  }

  @override
  Future<HighlightedCoinsModel?> highlihtedCoins(String catgory) async {
    try {
      Response res = await ApiClient.get(
        "${APIEndpointUrls.highlated_coins}?category=${catgory}",
      );
      AppLogger.log('highlated Coins: ${res.data}');
      return HighlightedCoinsModel.fromJson(res.data);
    } catch (e) {
      AppLogger.error('highlated Coins :${e}');
      return null;
    }
  }

  @override
  Future<NotificationModel?> notifications(
    String role,
    String filter,
    int page,
  ) async {
    try {
      Response res = await ApiClient.get(
        "${APIEndpointUrls.notification}?role=${role}&filter=${filter}&page=${page}",
      );
      AppLogger.log('notifications : ${res.data}');
      return NotificationModel.fromJson(res.data);
    } catch (e) {
      AppLogger.error('notifications :${e}');
      return null;
    }
  }

  @override
  Future<SessionBookingModel?> sessionBooking(Map<String, dynamic> data) async {
    try {
      final formdata = await buildFormData(data);
      Response res = await ApiClient.post(
        "${APIEndpointUrls.book_slot}",
        data: formdata,
      );
      AppLogger.log('sessionBooking: ${res.data}');
      return SessionBookingModel.fromJson(res.data);
    } catch (e) {
      AppLogger.error('sessionBooking:${e}');
      return null;
    }
  }

  @override
  Future<SelectSlotModel?> selectSlot(int mentor_id, int slot_id) async {
    try {
      Response res = await ApiClient.get(
        "${APIEndpointUrls.select_slot}/${mentor_id}?slot_id=${slot_id}",
      );
      AppLogger.log('selectSlot: ${res.data}');
      return SelectSlotModel.fromJson(res.data);
    } catch (e) {
      AppLogger.error('selectSlot:${e}');
      return null;
    }
  }

  @override
  Future<DailySlotsModel?> getDailySlots(int mentor_id, String date) async {
    try {
      Response res = await ApiClient.get(
        "${APIEndpointUrls.daily_slots}/${mentor_id}?date=${date}",
      );
      AppLogger.log('getDailySlots: ${res.data}');
      return DailySlotsModel.fromJson(res.data);
    } catch (e) {
      AppLogger.error('getDailySlots:${e}');
      return null;
    }
  }

  @override
  Future<WeeklySlotsModel?> getWeeklySlots(
    int mentorId, {
    String week = '',
  }) async {
    try {
      Response res = await ApiClient.get(
        "${APIEndpointUrls.weekly_slots}/${mentorId}?week=${week}",
      );
      AppLogger.log('getWeeklySlots: ${res.data}');
      return WeeklySlotsModel.fromJson(res.data);
    } catch (e) {
      AppLogger.error('getWeeklySlots:${e}');
      return null;
    }
  }

  @override
  Future<CoinsPackRespModel?> getcoinspack() async {
    try {
      Response res = await ApiClient.get("${APIEndpointUrls.coins_pack}");
      AppLogger.log('get coins pack::${res.data}');
      return CoinsPackRespModel.fromJson(res.data);
    } catch (e) {
      AppLogger.error('coins pack::${e}');

      return null;
    }
  }

  @override
  Future<CoinsAchievementModel?> getcoinsAchievements(int page) async {
    try {
      Response res = await ApiClient.get(
        "${APIEndpointUrls.coins_achievements}",
      );
      AppLogger.log('get coins pack::${res.data}');
      return CoinsAchievementModel.fromJson(res.data);
    } catch (e) {
      AppLogger.error('coins pack::${e}');

      return null;
    }
  }

  @override
  Future<YearsModel?> getYears() async {
    try {
      Response res = await ApiClient.get("${APIEndpointUrls.get_years}");
      debugPrint('getYears::$res');
      return YearsModel.fromJson(res.data);
    } catch (e) {
      debugPrint('Error getYears::$e');
      return null;
    }
  }

  @override
  Future<checkInModel?> dailyCheckins() async {
    try {
      Response res = await ApiClient.post("${APIEndpointUrls.daily_checkins}");
      debugPrint('daily CheckIns::$res');
      return checkInModel.fromJson(res.data);
    } catch (e) {
      debugPrint('Error daily CheckIns::$e');
      return null;
    }
  }

  @override
  Future<CampusesModel?> getCampuses(int page) async {
    try {
      Response res = await ApiClient.get("${APIEndpointUrls.get_campuses}?page=$page");
      debugPrint('getCampuses::$res');
      return CampusesModel.fromJson(res.data);
    } catch (e) {
      debugPrint('Error getCampuses::$e');
      return null;
    }
  }

  @override
  Future<SuccessModel?> addResource(Map<String, dynamic> data) async {
    try {
      final formdata = await buildFormData(data);
      Response res = await ApiClient.post(
        "${APIEndpointUrls.add_book}",
        data: formdata,
      );
      debugPrint('addResource::$res');
      return SuccessModel.fromJson(res.data);
    } catch (e) {
      debugPrint('Error addResource::$e');
      return null;
    }
  }

  @override
  Future<CommunityZoneTagsModel?> getCommunityZoneTags() async {
    try {
      Response res = await ApiClient.get(
        "${APIEndpointUrls.community_zone_tags}",
      );
      debugPrint('getCommunityZoneTags::$res');
      return CommunityZoneTagsModel.fromJson(res.data);
    } catch (e) {
      debugPrint('Error getCommunityZoneTags::$e');
      return null;
    }
  }

  @override
  Future<GetExpertiseModel?> getExpertiseCategory(
    String search,
    int page,
  ) async {
    try {
      Response res = await ApiClient.get(
        "${APIEndpointUrls.get_expertise}?search=${search}&page=${page}",
      );
      debugPrint('get Expertise Category::$res');
      return GetExpertiseModel.fromJson(res.data);
    } catch (e) {
      debugPrint('Error Expertise Category ::$e');
      return null;
    }
  }

  @override
  Future<GetExpertiseModel?> getExpertiseSubCategory(int id) async {
    try {
      Response res = await ApiClient.get(
        "${APIEndpointUrls.get_expertise}/${id}",
      );
      debugPrint('get Expertise Sub Category::$res');
      return GetExpertiseModel.fromJson(res.data);
    } catch (e) {
      debugPrint('Error Expertise Sub Category ::$e');
      return null;
    }
  }

  @override
  Future<SuccessModel?> addCommunityPost(Map<String, dynamic> data) async {
    try {
      final formdata = await buildFormData(data);
      Response res = await ApiClient.post(
        "${APIEndpointUrls.add_community}",
        data: formdata,
      );
      debugPrint('addCommunityPost::$res');
      return SuccessModel.fromJson(res.data);
    } catch (e) {
      debugPrint('Error addCommunityPost::$e');
      return null;
    }
  }

  @override
  Future<SuccessModel?> postComment(Map<String, dynamic> data) async {
    try {
      final formdata = await buildFormData(data);
      Response res = await ApiClient.post(
        "${APIEndpointUrls.add_comment}",
        data: formdata,
      );
      debugPrint('postComment::$res');
      return SuccessModel.fromJson(res.data);
    } catch (e) {
      debugPrint('Error postComment::$e');
      return null;
    }
  }

  @override
  Future<SuccessModel?> addEcc(Map<String, dynamic> data) async {
    try {
      final formdata = await buildFormData(data);
      Response res = await ApiClient.post(
        "${APIEndpointUrls.add_ecc}",
        data: formdata,
      );
      debugPrint('addEcc::$res');
      return SuccessModel.fromJson(res.data);
    } catch (e) {
      debugPrint('Error addEcc::$e');
      return null;
    }
  }

  @override
  Future<DownloadsModel?> getDownloads(int page) async {
    try {
      Response res = await ApiClient.get(
        "${APIEndpointUrls.my_downloads}?page=${page}",
      );
      debugPrint('getDownloads::$res');
      return DownloadsModel.fromJson(res.data);
    } catch (e) {
      debugPrint('Error getDownloads::$e');
      return null;
    }
  }

  @override
  Future<CommunityPostsModel?> getCommunityPosts(
    String scope,
    String post,
    int page,
  ) async {
    try {
      final token = await AuthService.getAccessToken();
      Response res;
      if (token != null) {
        res = await ApiClient.get(
          "${APIEndpointUrls.community_zone_post}?scope=${scope}&${post}=true&page=${page}",
        );
      } else {
        res = await ApiClient.get(
          "${APIEndpointUrls.guest_community_post}?page=${page}&${post}=true",
        );
      }
      debugPrint('getCommunityPosts::$res');
      return CommunityPostsModel.fromJson(res.data);
    } catch (e) {
      debugPrint('Error getCommunityPosts::$e');
      return null;
    }
  }

  @override
  Future<CommunityDetailsModel?> communityPostsDetails(
    int communityId,
    String scope,
  ) async {
    try {
      Response res = await ApiClient.get(
        "${APIEndpointUrls.community_zone_post_details}/${communityId}?scope=${scope}",
      );

      debugPrint('Community Details::$res');
      return CommunityDetailsModel.fromJson(res.data);
    } catch (e) {
      debugPrint('Error getCommunity Details::$e');
      return null;
    }
  }

  @override
  Future<ECCModel?> getEcc(
    String scope,
    String updates,
    String search,
    int page,
  ) async {
    try {
      Response res;
      final token = await AuthService.getAccessToken();
      if (token != null) {
        res = await ApiClient.get(
          "${APIEndpointUrls.list_ecc}?scope=${scope}&tag=${updates}&search=${search}&page=${page}",
        );
      } else {
        res = await ApiClient.get(
          "${APIEndpointUrls.guest_list_ecc}?scope=${scope}&tag=${updates}&search=${search}&page=${page}",
        );
      }
      debugPrint('getEcc::$res');
      return ECCModel.fromJson(res.data);
    } catch (e) {
      debugPrint('Error getEcc::$e');
      return null;
    }
  }

  @override
  Future<ViewEccDetailsModel?> viewEccDetails(int eventId, String scope) async {
    try {
      Response res = await ApiClient.get(
        "${APIEndpointUrls.view_ecc_details}/${eventId}?scope=${scope}",
      );
      debugPrint('getEcc::$res');
      return ViewEccDetailsModel.fromJson(res.data);
    } catch (e) {
      debugPrint('Error getEcc::$e');
      return null;
    }
  }

  @override
  Future<LogInModel?> login(Map<String, dynamic> data) async {
    final formdata = await buildFormData(data);
    try {
      Response res = await ApiClient.post(
        "${APIEndpointUrls.login}",
        data: formdata,
      );
      return LogInModel.fromJson(res.data);
    } catch (e) {
      debugPrint('Error loginOtp::$e');
      return null;
    }
  }

  @override
  Future<RegisterModel?> finalRegister(Map<String, dynamic> data) async {
    final formdata = await buildFormData(data);
    try {
      Response res = await ApiClient.post(
        "${APIEndpointUrls.final_registeration}",
        data: formdata,
      );
      debugPrint('finalRegister::$res');
      return RegisterModel.fromJson(res.data);
    } catch (e) {
      debugPrint('Error finalRegister::$e');
      return null;
    }
  }

  @override
  Future<RegisterModel?> Register(Map<String, dynamic> data) async {
    final formdata = await buildFormData(data);
    try {
      Response res = await ApiClient.post(
        "${APIEndpointUrls.registerscreen}",
        data: formdata,
      );
      debugPrint('Register::$res');
      return RegisterModel.fromJson(res.data);
    } catch (e) {
      debugPrint('Error Register::$e');
      return null;
    }
  }

  @override
  Future<Otpverifymodel?> Verifyotp(Map<String, dynamic> data) async {
    final formdata = await buildFormData(data);
    try {
      Response res = await ApiClient.post(
        "${APIEndpointUrls.verifyotp}",
        data: formdata,
      );
      debugPrint('Error Register::$res');
      return Otpverifymodel.fromJson(res.data);
    } catch (e) {
      debugPrint('Error Register::$e');
      return null;
    }
  }

  @override
  Future<GetBannersRespModel?> getbanners() async {
    try {
      Response res = await ApiClient.get("${APIEndpointUrls.get_banners}");
      debugPrint('getbanners::${res.data}');
      return GetBannersRespModel.fromJson(res.data);
    } catch (e) {
      debugPrint('Error getbanners::$e');
      return null;
    }
  }

  @override
  Future<GuestMentorsModel?> getGuestMentorsList() async {
    try {
      Response res = await ApiClient.get("${APIEndpointUrls.guest_mentors}");
      AppLogger.log('getGuestMentorsList::${res.data}');
      return GuestMentorsModel.fromJson(res.data);
    } catch (e) {
      AppLogger.error('getGuestMentorsList::${e}');

      return null;
    }
  }

  @override
  Future<CompusMentorListModel?> getCampusMentorList(
    String scope,
    String search,
  ) async {
    try {
      Response res = await ApiClient.get(
        "${APIEndpointUrls.get_mentors}?scope=${scope}&search=${search}",
      );
      AppLogger.log('get CampusMentorList::${res.data}');
      return CompusMentorListModel.fromJson(res.data);
    } catch (e) {
      AppLogger.error('CampusMentorList::${e}');

      return null;
    }
  }

  @override
  Future<MentorProfileModel?> getMentorProfile(int id) async {
    try {
      Response res = await ApiClient.get(
        "${APIEndpointUrls.mentor_profile}/${id}",
      );
      AppLogger.log('get MentorProfile::${res.data}/${id}');
      return MentorProfileModel.fromJson(res.data);
    } catch (e) {
      AppLogger.error('MentorProfile::${e}');
      return null;
    }
  }

  @override
  Future<CommonProfileModel?> commonProfile(int id) async {
    try {
      Response res = await ApiClient.get(
        "${APIEndpointUrls.common_profile}/${id}",
      );
      AppLogger.log('get commonProfile::${res.data}/${id}');
      return CommonProfileModel.fromJson(res.data);
    } catch (e) {
      AppLogger.error('commonProfile::${e}');
      return null;
    }
  }

  @override
  Future<GetHomeDilogModel?> homeDiolog() async {
    try {
      Response res = await ApiClient.get("${APIEndpointUrls.home_diolog}");
      AppLogger.log('get homeDiolog::${res.data}');
      return GetHomeDilogModel.fromJson(res.data);
    } catch (e) {
      AppLogger.error('homeDiolog::${e}');
      return null;
    }
  }

  @override
  Future<StudyZoneCampusModel?> getStudyZoneCampus(
    String scope,
    String tag,
    String search,
    int page,
  ) async {
    try {
      Response res;
      final token = await AuthService.getAccessToken();
      if (token != null) {
        res = await ApiClient.get(
          "${APIEndpointUrls.study_zone_campus}?scope=${scope}&tag=${tag}&search=${search}&page=${page}",
        );
      } else {
        res = await ApiClient.get(
          "${APIEndpointUrls.guest_study_zone}?page=${page}&tag=${tag}&search=${search}",
        );
      }
      AppLogger.log('get StudyZoneCampus::${res.data}');
      return StudyZoneCampusModel.fromJson(res.data);
    } catch (e) {
      AppLogger.error('StudyZoneCampus::${e}');
      return null;
    }
  }

  @override
  Future<ResourceDetailsModel?> getResourceDetails(
    int resourceId,
    String scope,
  ) async {
    AppLogger.log('resourceId::$resourceId');

    try {
      // Build the URL dynamically
      String url = "${APIEndpointUrls.study_zone_details}/$resourceId";
      if (scope.isNotEmpty) {
        url += "?scope=$scope";
      }

      Response res = await ApiClient.get(url);

      AppLogger.log('get StudyZoneDetails::${res.data}');
      return ResourceDetailsModel.fromJson(res.data);
    } catch (e) {
      AppLogger.error('StudyZoneDetails::${e}');
      return null;
    }
  }

  @override
  Future<WalletModel?> getWallet(int id, int page) async {
    try {
      Response res = await ApiClient.get(
        "${APIEndpointUrls.wallet_money}?achievements=${id}&page=${page}",
      );
      AppLogger.log('get walletmoney::${res.data}');
      return WalletModel.fromJson(res.data);
    } catch (e) {
      AppLogger.error('walletmoney::${e}');

      return null;
    }
  }

  @override
  Future<ProductToolTaskByDateModel?> getTaskByDate(String date) async {
    try {
      Response res = await ApiClient.get(
        "${APIEndpointUrls.task_by_date}?date=${date}",
      );
      AppLogger.log('get taskBy Date ::${res.data}');
      return ProductToolTaskByDateModel.fromJson(res.data);
    } catch (e) {
      AppLogger.error('taskBy Date::${e}');

      return null;
    }
  }

  @override
  Future<TaskStatesModel?> getTaskByStates() async {
    try {
      Response res = await ApiClient.get("${APIEndpointUrls.task_by_states}");
      AppLogger.log('get taskBy States ::${res.data}');
      return TaskStatesModel.fromJson(res.data);
    } catch (e) {
      AppLogger.error('taskBy States ::${e}');
      return null;
    }
  }

  @override
  Future<MenteeProfileModel?> getMenteeProfile() async {
    try {
      Response res = await ApiClient.get("${APIEndpointUrls.mentee_profile}");
      AppLogger.log('get Mentee Profile ::${res.data}');
      return MenteeProfileModel.fromJson(res.data);
    } catch (e) {
      AppLogger.error('get Mentee Profile ::${e}');
      return null;
    }
  }

  @override
  Future<SuccessModel?> menteeProfileUpdate(
    final Map<String, dynamic> data,
  ) async {
    final formData = await buildFormData(data);
    try {
      Response res = await ApiClient.post(
        APIEndpointUrls.mentee_profile_update,
        data: formData,
      );
      AppLogger.log('Mentee Profile Update ::${res.data}');
      return SuccessModel.fromJson(res.data);
    } catch (e) {
      AppLogger.error('Mentee Profile Update  ::${e}');
      return null;
    }
  }

  @override
  Future<SuccessModel?> putTaskComplete(int taskId) async {
    try {
      Response res = await ApiClient.put(
        "${APIEndpointUrls.task_update}/${taskId}/complete",
      );
      AppLogger.log('task Update ::${res.data}');
      return SuccessModel.fromJson(res.data);
    } catch (e) {
      AppLogger.error('task Update  ::${e}');
      return null;
    }
  }

  @override
  Future<SuccessModel?> TaskDelete(int taskId) async {
    try {
      Response res = await ApiClient.delete(
        "${APIEndpointUrls.task_delete}/${taskId}",
      );
      AppLogger.log('task delete ::${res.data}');
      return SuccessModel.fromJson(res.data);
    } catch (e) {
      AppLogger.error('task delete  ::${e}');
      return null;
    }
  }

  @override
  Future<SuccessModel?> addTask(final Map<String, dynamic> data) async {
    final formData = await buildFormData(data);
    try {
      Response res = await ApiClient.post(
        "${APIEndpointUrls.add_task}",
        data: formData,
      );
      AppLogger.log('task Add::${res.data}');
      return SuccessModel.fromJson(res.data);
    } catch (e) {
      AppLogger.error('task Add ::${e}');

      return null;
    }
  }

  @override
  Future<BecomeMentorSuccessModel?> becomeMentor(
    final Map<String, dynamic> data,
  ) async {
    final formData = await buildFormData(data);
    try {
      Response res = await ApiClient.post(
        "${APIEndpointUrls.become_mentor}",
        data: formData,
      );
      AppLogger.log('Become Mentor ::${res.data}');
      return BecomeMentorSuccessModel.fromJson(res.data);
    } catch (e) {
      AppLogger.error('Become Mentor ::${e}');
      return null;
    }
  }

  @override
  Future<SuccessModel?> postStudyZoneReport(Map<String, dynamic> data) async {
    final formData = await buildFormData(data);
    try {
      Response res = await ApiClient.post(
        "${APIEndpointUrls.study_zone_report_resource}",
        data: formData,
      );
      AppLogger.log('StudyZone Report::${res.data}');
      return SuccessModel.fromJson(res.data);
    } catch (e) {
      AppLogger.error('StudyZone Report ::${e}');

      return null;
    }
  }

  @override
  Future<SuccessModel?> communityZoneReport(Map<String, dynamic> data) async {
    final formData = await buildFormData(data);
    try {
      Response res = await ApiClient.post(
        "${APIEndpointUrls.community_zone_report}",
        data: formData,
      );
      AppLogger.log('Community Report::${res.data}');
      return SuccessModel.fromJson(res.data);
    } catch (e) {
      AppLogger.error('Community Report ::${e}');

      return null;
    }
  }

  @override
  Future<SuccessModel?> groupChatReport(Map<String, dynamic> data) async {
    final formData = await buildFormData(data);
    try {
      Response res = await ApiClient.post(
        "${APIEndpointUrls.group_chat_report}",
        data: formData,
      );
      AppLogger.log('Group Chat Report::${res.data}');
      return SuccessModel.fromJson(res.data);
    } catch (e) {
      AppLogger.error('Group Chat Report ::${e}');

      return null;
    }
  }

  @override
  Future<SuccessModel?> privateChatReport(Map<String, dynamic> data) async {
    final formData = await buildFormData(data);
    try {
      Response res = await ApiClient.post(
        "${APIEndpointUrls.private_chat_report}",
        data: formData,
      );
      AppLogger.log('private Chat Report::${res.data}');
      return SuccessModel.fromJson(res.data);
    } catch (e) {
      AppLogger.error('private Chat Report ::${e}');

      return null;
    }
  }

  @override
  Future<SuccessModel?> postSessionReport(Map<String, dynamic> data) async {
    final formData = await buildFormData(data);
    try {
      Response res = await ApiClient.post(
        "${APIEndpointUrls.sessions_report_submit}",
        data: formData,
      );
      AppLogger.log('Session Report::${res.data}');
      return SuccessModel.fromJson(res.data);
    } catch (e) {
      AppLogger.error('Session Report ::${e}');

      return null;
    }
  }

  @override
  Future<SuccessModel?> postToggleLike(Map<String, dynamic> data) async {
    final formData = await buildFormData(data);
    try {
      Response res = await ApiClient.post(
        "${APIEndpointUrls.community_toggle_like}",
        data: formData,
      );
      AppLogger.log('Post Toggle Like::${res.data}');
      return SuccessModel.fromJson(res.data);
    } catch (e) {
      AppLogger.error('Post Toggle Like ::${e}');

      return null;
    }
  }

  @override
  Future<SuccessModel?> commentLike(int id) async {
    try {
      Response res = await ApiClient.post(
        "${APIEndpointUrls.comment_like}/${id}/like",
      );
      AppLogger.log('Post comment Like ::${res.data}');
      return SuccessModel.fromJson(res.data);
    } catch (e) {
      AppLogger.error('Post comment Like ::${e}');

      return null;
    }
  }

  @override
  Future<CreatePaymentModel?> createPayment(Map<String, dynamic> data) async {
    final formData = await buildFormData(data);
    try {
      Response res = await ApiClient.post(
        "${APIEndpointUrls.create_paymenet}",
        data: formData,
      );
      AppLogger.log('create Payment ::${res.data}');
      return CreatePaymentModel.fromJson(res.data);
    } catch (e) {
      AppLogger.error('create Payment  ::${e}');

      return null;
    }
  }

  @override
  Future<SuccessModel?> verifyPayment(Map<String, dynamic> data) async {
    final formData = await buildFormData(data);
    try {
      Response res = await ApiClient.post(
        "${APIEndpointUrls.verify_paymenet}",
        data: formData,
      );
      AppLogger.log('verify Payment ::${res.data}');
      return SuccessModel.fromJson(res.data);
    } catch (e) {
      AppLogger.error('verify Payment  ::${e}');

      return null;
    }
  }

  @override
  Future<ReviewSubmitModel?> sessionSubmitReview(
    Map<String, dynamic> data,
    int id,
  ) async {
    final formData = await buildFormData(data);
    try {
      Response res = await ApiClient.post(
        "${APIEndpointUrls.completed_sessions_submit_review}/${id}",
        data: formData,
      );
      AppLogger.log('Submit Review ::${res.data}');
      return ReviewSubmitModel.fromJson(res.data);
    } catch (e) {
      AppLogger.error('Submit Review ::${e}');

      return null;
    }
  }

  @override
  Future<SuccessModel?> forgotPassword(Map<String, dynamic> data) async {
    final formData = await buildFormData(data);
    try {
      Response res = await ApiClient.post(
        "${APIEndpointUrls.forgot_password}",
        data: formData,
      );
      AppLogger.log('forgotPassword::${res.data}');
      return SuccessModel.fromJson(res.data);
    } catch (e) {
      AppLogger.error('forgotPassword ::${e}');

      return null;
    }
  }

  @override
  Future<SuccessModel?> forgotVerify(Map<String, dynamic> data) async {
    final formData = await buildFormData(data);
    try {
      Response res = await ApiClient.post(
        "${APIEndpointUrls.forgot_verify_otp}",
        data: formData,
      );
      AppLogger.log('forgot Verify::${res.data}');
      return SuccessModel.fromJson(res.data);
    } catch (e) {
      AppLogger.error('forgot Verify ::${e}');

      return null;
    }
  }

  @override
  Future<SuccessModel?> resetPassword(Map<String, dynamic> data) async {
    final formData = await buildFormData(data);
    try {
      Response res = await ApiClient.post(
        "${APIEndpointUrls.resetPassword}",
        data: formData,
      );
      AppLogger.log('reset Password::${res.data}');
      return SuccessModel.fromJson(res.data);
    } catch (e) {
      AppLogger.error('reset Password ::${e}');

      return null;
    }
  }

  @override
  Future<ExclusiveServicesModel?> exclusiveServiceList(
    String search,
    int page,
  ) async {
    try {
      Response res = await ApiClient.get(
        "${APIEndpointUrls.get_Exclusive_services}?search=${search}&page=${page}",
      );
      AppLogger.log('get exclusive service::${res.data}');
      return ExclusiveServicesModel.fromJson(res.data);
    } catch (e) {
      AppLogger.error('exclusive service::${e}');
      return null;
    }
  }

  @override
  Future<UpComingSessionModel?> upComingSessions() async {
    try {
      Response res = await ApiClient.get("${APIEndpointUrls.upcoming_session}");
      AppLogger.log('get upComing Session::${res.data}');
      return UpComingSessionModel.fromJson(res.data);
    } catch (e) {
      AppLogger.error('upComing Session::${e}');
      return null;
    }
  }

  @override
  Future<CompletedSessionModel?> sessionsComplete() async {
    try {
      Response res = await ApiClient.get(
        "${APIEndpointUrls.session_completed}",
      );
      AppLogger.log('get Session Completed ::${res.data}');
      return CompletedSessionModel.fromJson(res.data);
    } catch (e) {
      AppLogger.error('Session Completed ::${e}');
      return null;
    }
  }

  @override
  Future<ExclusiveservicedetailsModel?> exclusiveServiceDetails(int id) async {
    try {
      Response res = await ApiClient.get(
        "${APIEndpointUrls.get_Exclusive_services_details}/${id}",
      );
      AppLogger.log('get exclusive details::${res.data}');
      return ExclusiveservicedetailsModel.fromJson(res.data);
    } catch (e) {
      AppLogger.error('exclusive details::${e}');
      return null;
    }
  }

  @override
  Future<MenteeCustmor_supportModel?> getcustomersupport() async {
    try {
      Response res = await ApiClient.get(
        "${APIEndpointUrls.getmenteecustomersupport}",
      );
      AppLogger.log('get mentee Customer Support::${res.data}');
      return MenteeCustmor_supportModel.fromJson(res.data);
    } catch (e) {
      AppLogger.error('mentee Customer Support::${e}');
      return null;
    }
  }

  @override
  Future<StudyZoneTagsModel?> getStudyZoneTags(String searchQuery) async {
    try {
      Response res = await ApiClient.get(
        "${APIEndpointUrls.study_zone_tags}?search=${searchQuery}",
      );
      AppLogger.log('get Tags :: ${res.data}');
      return StudyZoneTagsModel.fromJson(res.data);
    } catch (e) {
      AppLogger.error('Tags :: $e');
      return null;
    }
  }

  @override
  Future<TagsModel?> getEccTags(String searchQuery) async {
    try {
      final isGuest = await AuthService.isGuest;
      final endpoint = isGuest
          ? APIEndpointUrls.guestTags
          : "${APIEndpointUrls.ecc_tags}?search=${searchQuery}";

      Response res = await ApiClient.get(endpoint);
      AppLogger.log('get Ecc Tags :: ${res.data}');
      return TagsModel.fromJson(res.data);
    } catch (e) {
      AppLogger.error('Ecc Tags :: $e');
      return null;
    }
  }
}
