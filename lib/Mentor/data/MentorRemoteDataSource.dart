import 'package:dio/dio.dart';
import 'package:mentivisor/core/network/mentor_endpoints.dart';
import 'package:mentivisor/utils/AppLogger.dart';
import '../../Mentee/Models/SuccessModel.dart';
import '../../services/ApiClient.dart';
import '../Models/AvailableSlotsModel.dart';
import '../Models/FeedbackModel.dart';
import '../Models/MentorProfileModel.dart';
import '../Models/MentorinfoResponseModel.dart';
import '../Models/MyMenteesModel.dart';
import '../Models/SessionsModel.dart';

abstract class MentorRemoteDataSource {
  Future<SessionsModel?> getSessions(String type);
  Future<MentorprofileModel?> getMentorProfile();
  Future<SuccessModel?> updateMentorProfile(Map<String, dynamic> data);
  Future<FeedbackModel?> getFeedback(int user_id);
  Future<MyMenteesModel?> getMyMentees(int page);
  Future<SuccessModel?> reportMentee(Map<String, dynamic> data);
  Future<MentorinfoResponseModel?> mentorinfo();
  Future<SuccessModel?> addMentorAvailability(Map<String, dynamic> data);
  Future<AvailableSlotsModel?> getMentorAvailability();
}

class MentorRemoteDataSourceImpl implements MentorRemoteDataSource {
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
  Future<AvailableSlotsModel?> getMentorAvailability() async {
    try {
      Response res = await ApiClient.post(
        "${MentorEndpointsUrls.mentor_availability_slots}",
      );
      AppLogger.log('getMentorAvailability: ${res.data}');
      return AvailableSlotsModel.fromJson(res.data);
    } catch (e) {
      AppLogger.error('getMentorAvailability:${e}');
      return null;
    }
  }

  @override
  Future<SuccessModel?> addMentorAvailability(Map<String, dynamic> data) async {
    try {
      Response res = await ApiClient.post(
        "${MentorEndpointsUrls.add_mentor_availability}",
        data: data,
      );
      AppLogger.log('addMentorAvailability: ${res.data}');
      return SuccessModel.fromJson(res.data);
    } catch (e) {
      AppLogger.error('addMentorAvailability:${e}');
      return null;
    }
  }

  @override
  Future<SuccessModel?> reportMentee(Map<String, dynamic> data) async {
    try {
      Response res = await ApiClient.post(
        "${MentorEndpointsUrls.report_mentee}",
        data: data,
      );
      AppLogger.log('reportMentee: ${res.data}');
      return SuccessModel.fromJson(res.data);
    } catch (e) {
      AppLogger.error('reportMentee:${e}');
      return null;
    }
  }

  @override
  Future<MyMenteesModel?> getMyMentees(page) async {
    try {
      Response res = await ApiClient.get(
        "${MentorEndpointsUrls.mymenteelist}?page=${page}",
      );
      AppLogger.log('getMyMentees: ${res.data}');
      return MyMenteesModel.fromJson(res.data);
    } catch (e) {
      AppLogger.error('getMyMentees:${e}');
      return null;
    }
  }

  @override
  Future<MentorinfoResponseModel?> mentorinfo() async {
    try {
      Response res = await ApiClient.get("${MentorEndpointsUrls.mentorinfo}");
      AppLogger.log('get MentorInfo: ${res.data}');
      return MentorinfoResponseModel.fromJson(res.data);
    } catch (e) {
      AppLogger.error('get MentorInfo:${e}');
      return null;
    }
  }

  @override
  Future<FeedbackModel?> getFeedback(int user_id) async {
    try {
      Response res = await ApiClient.get(
        "${MentorEndpointsUrls.feedback}/${user_id}",
      );
      AppLogger.log('getFeedback: ${res.data}');
      return FeedbackModel.fromJson(res.data);
    } catch (e) {
      AppLogger.error('getFeedback:${e}');
      return null;
    }
  }

  @override
  Future<SuccessModel?> updateMentorProfile(Map<String, dynamic> data) async {
    final formdata = await buildFormData(data);
    try {
      Response res = await ApiClient.post(
        "${MentorEndpointsUrls.mentor_profile_update}",
        data: formdata,
      );
      AppLogger.log('update MentorProfile: ${res.data}');
      return SuccessModel.fromJson(res.data);
    } catch (e) {
      AppLogger.error('update MentorProfile:${e}');
      return null;
    }
  }

  @override
  Future<MentorprofileModel?> getMentorProfile() async {
    try {
      Response res = await ApiClient.get(
        "${MentorEndpointsUrls.mentor_profile}",
      );
      AppLogger.log('getMentorProfile: ${res.data}');
      return MentorprofileModel.fromJson(res.data);
    } catch (e) {
      AppLogger.error('getMentorProfile:${e}');
      return null;
    }
  }

  @override
  Future<SessionsModel?> getSessions(String type) async {
    try {
      Response res = await ApiClient.get(
        "${MentorEndpointsUrls.get_sessions}?role=${type}",
      );
      AppLogger.log('getSessions: ${res.data}');
      return SessionsModel.fromJson(res.data);
    } catch (e) {
      AppLogger.error('getSessions:${e}');
      return null;
    }
  }
}
