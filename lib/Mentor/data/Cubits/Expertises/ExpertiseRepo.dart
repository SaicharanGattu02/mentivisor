import 'package:mentivisor/Mentee/Models/SuccessModel.dart';
import 'package:mentivisor/Mentor/Models/NonAttachedExpertiseDetailsModel.dart';
import 'package:mentivisor/Mentor/Models/NonAttachedExpertisesModel.dart';
import 'package:mentivisor/Mentor/data/MentorRemoteDataSource.dart';

import '../../../Models/ExpertisesModel.dart';
import '../../../Models/MentorExpertiseModel.dart';

abstract class ExpertisesRepo {
  Future<ExpertisesModel?> fetchApproved();
  Future<ExpertisesModel?> fetchPending();
  Future<ExpertisesModel?> fetchRejected();
  Future<MentorExpertiseModel?> getExpertiseDetails(int id);
  Future<SuccessModel?> updateExpertise(Map<String, dynamic> data);
  Future<NonAttachedExpertisesModel?> getNonAttachedExpertises();
  Future<NonAttachedExpertiseDetailsModel?> getNonAttachedExpertiseDetails(
    int id,
  );
}

// Example stub – replace with your Dio/HTTP layer
class ExpertisesRepoImpl implements ExpertisesRepo {
  MentorRemoteDataSource mentorRemoteDataSource;
  ExpertisesRepoImpl({required this.mentorRemoteDataSource});

  @override
  Future<ExpertisesModel?> fetchApproved() async {
    return await mentorRemoteDataSource.fetchApproved();
  }

  @override
  Future<ExpertisesModel?> fetchPending() async {
    return await mentorRemoteDataSource.fetchPending();
  }

  @override
  Future<ExpertisesModel?> fetchRejected() async {
    return await mentorRemoteDataSource.fetchRejected();
  }

  @override
  Future<MentorExpertiseModel?> getExpertiseDetails(int id) async {
    return await mentorRemoteDataSource.getExpertiseDetails(id);
  }

  @override
  Future<SuccessModel?> updateExpertise(Map<String, dynamic> data) async {
    return await mentorRemoteDataSource.updateExpertise(data);
  }

  @override
  Future<NonAttachedExpertisesModel?> getNonAttachedExpertises() async {
    return await mentorRemoteDataSource.getNonAttachedExpertises();
  }

  @override
  Future<NonAttachedExpertiseDetailsModel?> getNonAttachedExpertiseDetails(
    int id,
  ) async {
    return await mentorRemoteDataSource.getNonAttachedExpertiseDetails(id);
  }
}
