import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:mentivisor/core/network/mentor_endpoints.dart';
import 'package:mentivisor/utils/AppLogger.dart';
import '../../Mentee/Models/SuccessModel.dart';
import '../../services/ApiClient.dart';
import '../Models/AvailableSlotsModel.dart';
import '../Models/MentorCoinHistoryModel.dart';
import '../Models/ExpertisesModel.dart';
import '../Models/FeedbackModel.dart';
import '../Models/MentorExpertiseModel.dart';
import '../Models/MentorProfileModel.dart';
import '../Models/MentorinfoResponseModel.dart';
import '../Models/MyMenteesModel.dart';
import '../Models/SessionDetailsModel.dart';
import '../Models/NonAttachedExpertiseDetailsModel.dart';
import '../Models/NonAttachedExpertisesModel.dart';
import '../Models/SessionsModel.dart';

abstract class MentorRemoteDataSource {
  Future<SessionsModel?> getSessions(String sessionType);
  Future<MentorprofileModel?> getMentorProfile();
  Future<SuccessModel?> updateMentorProfile(Map<String, dynamic> data);
  Future<FeedbackModel?> getFeedback(int user_id);
  Future<MyMenteesModel?> getMyMentees(int page);
  Future<SuccessModel?> reportMentee(Map<String, dynamic> data);
  Future<MentorinfoResponseModel?> mentorinfo();
  Future<SuccessModel?> addMentorAvailability(Map<String, dynamic> data);
  Future<AvailableSlotsModel?> getMentorAvailability();
  Future<SuccessModel?> mentorSessionCanceled( Map<String, dynamic> data);
  Future<MentorCoinHistoryModel?> CoinsHistory(String filter);


  Future<SessionDetailsModel?> getSessionsDetails(int sessionId);
  Future<ExpertisesModel?> fetchApproved();
  Future<ExpertisesModel?> fetchPending();
  Future<ExpertisesModel?> fetchRejected();
  Future<MentorExpertiseModel?> getExpertiseDetails(int id);
  Future<SuccessModel?> updateExpertise(Map<String, dynamic> data);
  Future<NonAttachedExpertisesModel?> getNonAttachedExpertises();
  Future<NonAttachedExpertiseDetailsModel?> getNonAttachedExpertiseDetails(
    int id,
  );
  Future<SuccessModel?> mentorReport(Map<String, dynamic> data);
  Future<SuccessModel?> newExpertiseRequest(Map<String, dynamic> data);
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
  Future<SuccessModel?> updateExpertise(Map<String, dynamic> data) async {
    try {
      // Build FormData manually to match: sub_expertise_ids[]=32&sub_expertise_ids[]=25&mode=add
      final form = FormData();

      // mode
      final mode = (data['mode'] ?? '').toString();
      if (mode.isNotEmpty) {
        form.fields.add(MapEntry('mode', mode));
      }

      // sub_expertise_ids[]
      final ids =
          (data['sub_expertise_ids'] as Iterable?)
              ?.map((e) => e.toString())
              .toList() ??
          [];
      for (final id in ids) {
        form.fields.add(
          const MapEntry('sub_expertise_ids[]', ''),
        ); // placeholder to keep type
        form.fields.removeLast();
        form.fields.add(MapEntry('sub_expertise_ids[]', id)); // actual value
      }

      final res = await ApiClient.post(
        MentorEndpointsUrls.update_expertises,
        data: form,
        // ensure ApiClient sets multipart automatically, or:
        // options: Options(contentType: 'multipart/form-data'),
      );

      AppLogger.log('updateExpertise: ${res.data}');
      return SuccessModel.fromJson(res.data);
    } catch (e) {
      AppLogger.error('updateExpertise: $e');
      return null;
    }
  }

  @override
  Future<SuccessModel?> newExpertiseRequest(Map<String, dynamic> data) async {
    try {
      // Build FormData to match the cURL shape
      final formData = await _buildNewExpertiseFormData(data);

      final res = await ApiClient.post(
        MentorEndpointsUrls.new_expertise_request,
        data: formData,
      );

      AppLogger.log('newExpertiseRequest : ${res.data}');
      return SuccessModel.fromJson(res.data);
    } catch (e) {
      AppLogger.error('newExpertiseRequest : $e');
      return null;
    }
  }

  /// Accepts your existing `data` and emits FormData like the given cURL
  /// - expertise_id (List<int>)      -> expertise_id[]
  /// - sub_expertise_ids (List<int>) -> sub_expertise_ids[]
  /// - proof_link (String)           -> proof_link
  /// - proof_file / proof_file_path  -> proof_doc (MultipartFile)
  Future<FormData> _buildNewExpertiseFormData(Map<String, dynamic> data) async {
    final map = <String, dynamic>{};

    // 1) Arrays -> append [] in key
    void addArray(String key, dynamic v) {
      if (v == null) return;
      final list = (v is List) ? v : [v];
      map["$key[]"] = list;
    }

    addArray('expertise_id', data['expertise_id']);
    addArray('sub_expertise_ids', data['sub_expertise_ids']);

    // 2) proof_link
    final link = data['proof_link'];
    if (link is String && link.trim().isNotEmpty) {
      map['proof_link'] = link.trim();
    }

    Future<MultipartFile?> asMultipart(dynamic v) async {
      if (v == null) return null;
      if (v is MultipartFile) return v;
      if (v is File) {
        final name = v.path.split('/').last;
        return MultipartFile.fromFile(v.path, filename: name);
      }
      if (v is String && v.contains('/')) {
        final name = v.split('/').last;
        return MultipartFile.fromFile(v, filename: name);
      }
      return null;
    }

    final mf =
    await asMultipart(data['proof_doc'] ?? data['proof_file'] ?? data['proof_file_path']);
    if (mf != null) {
      map['proof_doc'] = mf;
    }

    // Optional: log for debug
    map.forEach((k, v) => AppLogger.log('🔹 $k -> $v'));

    return FormData.fromMap(map);
  }


  @override
  Future<NonAttachedExpertiseDetailsModel?> getNonAttachedExpertiseDetails(
    int id,
  ) async {
    try {
      Response res = await ApiClient.get(
        "${MentorEndpointsUrls.non_attached_expertises}/${id}",
      );
      AppLogger.log('getNonAttachedExpertiseDetails : ${res.data}');
      return NonAttachedExpertiseDetailsModel.fromJson(res.data);
    } catch (e) {
      AppLogger.error('getNonAttachedExpertiseDetails :${e}');
      return null;
    }
  }

  @override
  Future<NonAttachedExpertisesModel?> getNonAttachedExpertises() async {
    try {
      Response res = await ApiClient.get(
        "${MentorEndpointsUrls.non_attached_expertises}",
      );
      AppLogger.log('getNonAttachedExpertises: ${res.data}');
      return NonAttachedExpertisesModel.fromJson(res.data);
    } catch (e) {
      AppLogger.error('getNonAttachedExpertises:${e}');
      return null;
    }
  }

  @override
  Future<MentorExpertiseModel?> getExpertiseDetails(int id) async {
    try {
      Response res = await ApiClient.get(
        "${MentorEndpointsUrls.approved_expertises}/$id",
      );
      AppLogger.log('getExpertiseDetails: ${res.data}');
      return MentorExpertiseModel.fromJson(res.data);
    } catch (e) {
      AppLogger.error('getExpertiseDetails:${e}');
      return null;
    }
  }

  @override
  Future<ExpertisesModel?> fetchApproved() async {
    try {
      Response res = await ApiClient.get(
        "${MentorEndpointsUrls.approved_expertises}",
      );
      AppLogger.log('fetchApproved: ${res.data}');
      return ExpertisesModel.fromJson(res.data);
    } catch (e) {
      AppLogger.error('fetchApproved:${e}');
      return null;
    }
  }

  @override
  Future<ExpertisesModel?> fetchPending() async {
    try {
      Response res = await ApiClient.get(
        "${MentorEndpointsUrls.approved_expertises}",
      );
      AppLogger.log('fetchPending: ${res.data}');
      return ExpertisesModel.fromJson(res.data);
    } catch (e) {
      AppLogger.error('fetchPending:${e}');
      return null;
    }
  }

  @override
  Future<ExpertisesModel?> fetchRejected() async {
    try {
      Response res = await ApiClient.get(
        "${MentorEndpointsUrls.approved_expertises}",
      );
      AppLogger.log('fetchRejected: ${res.data}');
      return ExpertisesModel.fromJson(res.data);
    } catch (e) {
      AppLogger.error('fetchRejected:${e}');
      return null;
    }
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
  Future<SessionsModel?> getSessions(String sessionType) async {
    try {
      Response res = await ApiClient.get(
        "${MentorEndpointsUrls.get_sessions}?role=mentor&filter=${sessionType}",
      );
      AppLogger.log('getSessions: ${res.data}');
      return SessionsModel.fromJson(res.data);
    } catch (e) {
      AppLogger.error('getSessions:${e}');
      return null;
    }
  }

  @override
  Future<SessionDetailsModel?> getSessionsDetails(int sessionId) async {
    try {
      Response res = await ApiClient.get(
        "${MentorEndpointsUrls.get_sessions_details}/${sessionId}",
      );
      AppLogger.log('getSessions: ${res.data}');
      return SessionDetailsModel.fromJson(res.data);
    } catch (e) {
      AppLogger.error('getSessions:${e}');
      return null;
    }
  }

  @override
  Future<SuccessModel?> mentorSessionCanceled(Map<String, dynamic> data) async {
    final formdata = await buildFormData(data);
    try {
      Response res = await ApiClient.post(
        "${MentorEndpointsUrls.sessions_cancelled}",
        data: formdata,
      );
      AppLogger.log('getSession: ${res.data}');
      return SuccessModel.fromJson(res.data);
    } catch (e) {
      AppLogger.error('getSession:${e}');
      return null;
    }
  }

  @override
  Future<SuccessModel?> mentorReport(Map<String, dynamic> data) async {
    final formData = await buildFormData(data);
    try {
      Response res = await ApiClient.post(
        "${MentorEndpointsUrls.mentor_reports}",
        data: formData,
      );
      AppLogger.log('mentor Report::${res.data}');
      return SuccessModel.fromJson(res.data);
    } catch (e) {
      AppLogger.error('mentor Report ::${e}');

      return null;
    }
  }
  @override
  Future<MentorCoinHistoryModel?> CoinsHistory(String filter) async {
    try {
      Response res = await ApiClient.get(
        "${MentorEndpointsUrls.get_coinshistory}?filter=${filter}",
      );
      AppLogger.log('Coins History: ${res.data}');
      return MentorCoinHistoryModel.fromJson(res.data);
    } catch (e) {
      AppLogger.error('Coins History:${e}');
      return null;
    }
  }
}
