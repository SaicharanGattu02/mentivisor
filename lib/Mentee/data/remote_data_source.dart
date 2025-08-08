import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:mentivisor/Mentee/Models/DownloadsModel.dart';
import 'package:mentivisor/Models/CoinsPackRespModel.dart';
import 'package:mentivisor/Models/CommunityGuest_Model.dart';
import 'package:mentivisor/Models/GetBannersRespModel.dart';
import 'package:mentivisor/Models/GetBooksRespModel.dart';
import 'package:mentivisor/Models/LoginResponseModel.dart';
import 'package:mentivisor/Mentee/Models/WalletModel.dart';
import 'package:mentivisor/Models/OnCampouseRespModel.dart';
import 'package:mentivisor/Models/StudyZoneDownloadModel_wo_log.dart';
import 'package:mentivisor/Models/TopMentersResponseModel.dart';
import 'package:mentivisor/Models/Years_ResponseModel.dart';
import 'package:mentivisor/utils/AppLogger.dart';
import '../../Models/EccGuestlist_Model.dart';
import '../../Models/ExpertiseRespModel.dart';
import '../../Models/GetCompusModel.dart';
import '../Models/CommunityPostsModel.dart';
import '../Models/CommunityZoneTagsModel.dart';
import '../Models/ProductToolTaskByDateModel.dart';
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
import '../Models/TaskStatesModel.dart';

abstract class RemoteDataSource {
  Future<LogInModel?> login(Map<String, dynamic> data);
  Future<GetCompusModel?> getCampuses(String Scope);
  Future<YearsResponsemodel?> getyears();
  Future<RegisterModel?> Register(Map<String, dynamic> data);
  Future<Otpverifymodel?> Verifyotp(Map<String, dynamic> data);
  Future<GetBannersRespModel?> getbanners();
  Future<GetBooksRespModel?> getbooks();
  Future<ExpertiseRespModel?> getexpertise();
  Future<MentorOnCamposeRespModel?> mentoroncampose();
  Future<Topmentersresponsemodel?> topmentors();
  Future<StudyZoneDownloadModel_wo_log?> studtzonedownloadwithoutlogin();
  Future<EccGuestlist_Model?> eccguestlist();
  Future<CommunityGuest_Model?> guestcommunitytags();
  Future<WalletModel?> getWallet();
  Future<CoinsPackRespModel?> getcoinspack();
  Future<CompusMentorListModel?> getCampusMentorList(String name, String scope);
  Future<StudyZoneTagsModel?> getStudyZoneTags();
  Future<MentorProfileModel?> getMentorProfile(int id);
  Future<ECCModel?> getEcc(int page);
  Future<SuccessModel?> addEcc(Map<String, dynamic> data);
  Future<StudyZoneCampusModel?> getStudyZoneCampus(
    String scope,
    String tag,
    int page,
  );
  Future<CommunityPostsModel?> getCommunityPosts(int page);
  Future<DownloadsModel?> getDownloads(int page);
  Future<SuccessModel?> postStudyZoneReport(Map<String, dynamic> data);
  Future<SuccessModel?> postComment(Map<String, dynamic> data);
  Future<TaskStatesModel?> getTaskByStates();
  Future<ProductToolTaskByDateModel?> getTaskByDate(String date);
  Future<SuccessModel?> putTaskComplete(int taskId);
  Future<SuccessModel?> TaskDelete(int taskId);
  Future<CommunityZoneTagsModel?> getCommunityZoneTags();
  Future<SuccessModel?> addCommunityPost(Map<String, dynamic> data);
  Future<SuccessModel?> addTask(final Map<String,dynamic>data);
  Future<SuccessModel?> addResource(Map<String, dynamic> data);
}

class RemoteDataSourceImpl implements RemoteDataSource {
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

    // 🔥 Print the data before returning
    formMap.forEach((key, value) {
      AppLogger.log('$key -> $value');
    });

    return FormData.fromMap(formMap);
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
  Future<CommunityPostsModel?> getCommunityPosts(int page) async {
    try {
      Response res = await ApiClient.get(
        "${APIEndpointUrls.list_ecc}?page=${page}",
      );
      debugPrint('getCommunityPosts::$res');
      return CommunityPostsModel.fromJson(res.data);
    } catch (e) {
      debugPrint('Error getCommunityPosts::$e');
      return null;
    }
  }

  @override
  Future<ECCModel?> getEcc(int page) async {
    try {
      Response res = await ApiClient.get(
        "${APIEndpointUrls.list_ecc}?page=${page}",
      );
      debugPrint('getEcc::$res');
      return ECCModel.fromJson(res.data);
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
  Future<GetCompusModel?> getCampuses(String scope) async {
    try {
      Response res = await ApiClient.get(
        "${APIEndpointUrls.get_compuses}?scope=${scope}",
      );
      debugPrint('getCampuses::${res.data}');
      return GetCompusModel.fromJson(res.data);
    } catch (e) {
      debugPrint('Error getCampuses::$e');
      return null;
    }
  }

  @override
  Future<YearsResponsemodel?> getyears() async {
    try {
      Response res = await ApiClient.get("${APIEndpointUrls.get_years}");
      debugPrint('getyears::${res.data}');
      return YearsResponsemodel.fromJson(res.data);
    } catch (e) {
      debugPrint('Error getyears::$e');
      return null;
    }
  }

  @override
  Future<Otpverifymodel?> Verifyotp(Map<String, dynamic> data) async {
    final formdata = await buildFormData(data);
    try {
      Response res = await ApiClient.post(
        "${APIEndpointUrls.registerscreen}",
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
  Future<GetBooksRespModel?> getbooks() async {
    try {
      Response res = await ApiClient.get("${APIEndpointUrls.get_books}");
      debugPrint('getbooks::${res.data}');
      return GetBooksRespModel.fromJson(res.data);
    } catch (e) {
      debugPrint('Error getbooks::$e');
      return null;
    }
  }

  @override
  Future<ExpertiseRespModel?> getexpertise() async {
    try {
      Response res = await ApiClient.get("${APIEndpointUrls.get_expertise}");
      debugPrint('getExpertise::${res.data}');
      return ExpertiseRespModel.fromJson(res.data);
    } catch (e) {
      debugPrint('Error Expertise::$e');
      return null;
    }
  }

  @override
  Future<MentorOnCamposeRespModel?> mentoroncampose() async {
    try {
      Response res = await ApiClient.get("${APIEndpointUrls.getoncampose}");
      debugPrint('get on campose::${res.data}');
      return MentorOnCamposeRespModel.fromJson(res.data);
    } catch (e) {
      debugPrint('Error get on campose::$e');
      return null;
    }
  }

  @override
  Future<Topmentersresponsemodel?> topmentors() async {
    try {
      Response res = await ApiClient.get("${APIEndpointUrls.gettopmentors}");
      debugPrint('get on topmentors::${res.data}');
      return Topmentersresponsemodel.fromJson(res.data);
    } catch (e) {
      debugPrint('Error get on topmentors::$e');
      return null;
    }
  }

  @override
  Future<StudyZoneDownloadModel_wo_log?> studtzonedownloadwithoutlogin() async {
    try {
      Response res = await ApiClient.get(
        "${APIEndpointUrls.studyzonedownloads_wol}",
      );
      debugPrint('get on download::${res.data}');
      return StudyZoneDownloadModel_wo_log.fromJson(res.data);
    } catch (e) {
      debugPrint('Error get on download::$e');
      return null;
    }
  }

  @override
  Future<EccGuestlist_Model?> eccguestlist() async {
    try {
      Response res = await ApiClient.get("${APIEndpointUrls.eccguestlist}");
      debugPrint('get on Ecclist::${res.data}');
      return EccGuestlist_Model.fromJson(res.data);
    } catch (e) {
      debugPrint('Error get on Ecclist::$e');
      return null;
    }
  }

  @override
  Future<CommunityGuest_Model?> guestcommunitytags() async {
    try {
      Response res = await ApiClient.get(
        "${APIEndpointUrls.guestcommunitytags_wol}",
      );
      debugPrint('get on communitytagslist::${res.data}');
      return CommunityGuest_Model.fromJson(res.data);
    } catch (e) {
      debugPrint('Error get on communitytags::$e');
      return null;
    }
  }

  ///Mentee

  @override
  Future<CompusMentorListModel?> getCampusMentorList(
    String name,
    String scope,
  ) async {
    try {
      Response res = await ApiClient.get(
        "${APIEndpointUrls.get_campus_mentors}/?name=${name}&scope=${scope}",
      );
      AppLogger.log('get CampusMentorList::${res.data}');
      return CompusMentorListModel.fromJson(res.data);
    } catch (e) {
      AppLogger.error('CampusMentorList::${e}');

      return null;
    }
  }

  @override
  Future<StudyZoneTagsModel?> getStudyZoneTags() async {
    try {
      Response res = await ApiClient.get("${APIEndpointUrls.study_zone_tags}");
      AppLogger.log('get StudyZoneTags::${res.data}');
      return StudyZoneTagsModel.fromJson(res.data);
    } catch (e) {
      AppLogger.error('StudyZoneTags::${e}');

      return null;
    }
  }

  @override
  Future<MentorProfileModel?> getMentorProfile(int id) async {
    try {
      Response res = await ApiClient.get("${APIEndpointUrls.mentor_profile}");
      AppLogger.log('get MentorProfile::${res.data}/${id}');
      return MentorProfileModel.fromJson(res.data);
    } catch (e) {
      AppLogger.error('MentorProfile::${e}');
      return null;
    }
  }

  @override
  Future<StudyZoneCampusModel?> getStudyZoneCampus(
    String scope,
    String tag,
    int page,
  ) async {
    try {
      Response res = await ApiClient.get(
        "${APIEndpointUrls.study_zone_campus}?scope=${scope}&tag=${tag}&page=${page}",
      );
      AppLogger.log('get StudyZoneCampus::${res.data}');
      return StudyZoneCampusModel.fromJson(res.data);
    } catch (e) {
      AppLogger.error('StudyZoneCampus::${e}');
      return null;
    }
  }

  @override
  Future<WalletModel?> getWallet() async {
    try {
      Response res = await ApiClient.get("${APIEndpointUrls.wallet_money}");
      AppLogger.log('get walletmoney::${res.data}');
      return WalletModel.fromJson(res.data);
    } catch (e) {
      AppLogger.error('walletmoney::${e}');

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
  Future<SuccessModel?> addTask(final Map<String,dynamic>data) async {
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
}
