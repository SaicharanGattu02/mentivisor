import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:mentivisor/Models/GetBannersRespModel.dart';
import 'package:mentivisor/Models/GetBooksRespModel.dart';
import 'package:mentivisor/Models/LoginResponseModel.dart';
import 'package:mentivisor/Models/OnCampouseRespModel.dart';
import 'package:mentivisor/Models/TopMentersResponseModel.dart';
import 'package:mentivisor/Models/Years_ResponseModel.dart';

import '../Models/ExpertiseRespModel.dart';
import '../Models/GetCompusModel.dart';
import '../Models/OtpVerifyModel.dart';
import '../Models/RegisterModel.dart';
import 'ApiClient.dart';
import 'api_endpoint_urls.dart';

abstract class RemoteDataSource {
  Future<LogInModel?> login(Map<String, dynamic> data);
  Future<GetCompusModel?> getCampuses();
  Future<YearsResponsemodel?> getyears();
  Future<RegisterModel?> Register(Map<String, dynamic> data);
  Future<Otpverifymodel?> Verifyotp(Map<String, dynamic> data);
  Future<GetBannersRespModel?> getbanners();
  Future<GetBooksRespModel?> getbooks();
  Future<ExpertiseRespModel?> getexpertise();
  Future<MentorOnCamposeRespModel?> mentoroncampose();
  Future<Topmentersresponsemodel?> topmentors();
}

class RemoteDataSourceImpl implements RemoteDataSource {
  Future<FormData> buildFormData(Map<String, dynamic> data) async {
    final formMap = <String, dynamic>{};
    for (final entry in data.entries) {
      final key = entry.key;
      final value = entry.value;

      if (value == null) continue;

      if (value is File &&
          (key.contains('image') ||
              key.contains('file') ||
              key.contains('picture') ||
              key.contains('payment_screenshot'))) {
        formMap[key] = await MultipartFile.fromFile(
          value.path,
          filename: value.path.split('/').last,
        );
      } else {
        formMap[key] = value.toString();
      }
    }
    return FormData.fromMap(formMap);
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
      debugPrint('Error Register::$res');
      return RegisterModel.fromJson(res.data);
    } catch (e) {
      debugPrint('Error Register::$e');
      return null;
    }
  }

  @override
  Future<GetCompusModel?> getCampuses() async {
    try {
      Response res = await ApiClient.get("${APIEndpointUrls.get_compuses}");
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
      debugPrint('get on campose::${res.data}');
      return Topmentersresponsemodel.fromJson(res.data);
    } catch (e) {
      debugPrint('Error get on campose::$e');
      return null;
    }

  }

}
