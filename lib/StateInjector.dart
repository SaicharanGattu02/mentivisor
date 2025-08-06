import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mentivisor/bloc/GetBanners/GetBannersCubit.dart';
import 'package:mentivisor/bloc/Login/LoginCubit.dart';
import 'package:mentivisor/bloc/Mentee/MentorProfile/MentorProfileCubit.dart';
import 'package:mentivisor/bloc/Mentee/MentorProfile/MentorProfileRepository.dart';
import 'package:mentivisor/bloc/On_Campouse/OnCampus_Repository.dart';
import 'package:mentivisor/bloc/Register/Register_Cubit.dart';
import 'package:mentivisor/bloc/Register/Register_Repository.dart';
import 'package:mentivisor/bloc/Verify_Otp/Verify_Otp_Cubit.dart';
import 'package:mentivisor/bloc/Verify_Otp/Verify_Otp_Repository.dart';
import '../bloc/internet_status/internet_status_bloc.dart';
import '../services/remote_data_source.dart';
import 'bloc/GetBanners/GetBannersRepository.dart';
import 'bloc/Login/LoginRepository.dart';
import 'bloc/Mentee/CampusMentorList/campus_mentor_list_cubit.dart';
import 'bloc/Mentee/CampusMentorList/campus_mentor_list_repo.dart';
import 'bloc/Mentee/StudyZoneTags/StudyZoneTagsCubit.dart';
import 'bloc/Mentee/StudyZoneTags/StudyZoneTagsRepository.dart';

class StateInjector {
  static final repositoryProviders = <RepositoryProvider>[
    RepositoryProvider<RemoteDataSource>(
      create: (context) => RemoteDataSourceImpl(),
    ),
    RepositoryProvider<LoginRepository>(
      create: (context) => LogInRepositoryImpl(
        remoteDataSource: context.read<RemoteDataSource>(),
      ),
    ),
    RepositoryProvider<RegisterRepository>(
      create: (context) =>
          RegisterImpl(remoteDataSource: context.read<RemoteDataSource>()),
    ),
    RepositoryProvider<VerifyOtpRepository>(
      create: (context) =>
          verifyotpImpl(remoteDataSource: context.read<RemoteDataSource>()),
    ),
    RepositoryProvider<Getbannersrepository>(
      create: (context) =>
          BannersImpl(remoteDataSource: context.read<RemoteDataSource>()),
    ),

    RepositoryProvider<CampusMentorListRepository>(
      create: (context) => CampusMentorListRepositoryImpl(
        remoteDataSource: context.read<RemoteDataSource>(),
      ),
    ),

    RepositoryProvider<StudyZoneTagsRepository>(
      create: (context) => StudyZoneTagsRepositoryImpl(
        remoteDataSource: context.read<RemoteDataSource>(),
      ),
    ),
    RepositoryProvider<MentorProfileRepository>(
      create: (context) => MentorProfileRepositoryImpl(
        remoteDataSource: context.read<RemoteDataSource>(),
      ),
    ),
  ];

  static final blocProviders = <BlocProvider>[
    BlocProvider<InternetStatusBloc>(create: (context) => InternetStatusBloc()),
    BlocProvider<LoginCubit>(
      create: (context) => LoginCubit(context.read<LoginRepository>()),
    ),
    BlocProvider<RegisterCubit>(
      create: (context) => RegisterCubit(context.read<RegisterRepository>()),
    ),
    BlocProvider<VerifyOtpCubit>(
      create: (context) => VerifyOtpCubit(context.read<VerifyOtpRepository>()),
    ),
    BlocProvider<Getbannerscubit>(
      create: (context) =>
          Getbannerscubit(context.read<Getbannersrepository>()),
    ),
    BlocProvider<CampusMentorListCubit>(
      create: (context) =>
          CampusMentorListCubit(context.read<CampusMentorListRepository>()),
    ),
    BlocProvider<StudyZoneTagsCubit>(
      create: (context) =>
          StudyZoneTagsCubit(context.read<StudyZoneTagsRepository>()),
    ),
    BlocProvider<MentorProfileCubit>(
      create: (context) =>
          MentorProfileCubit(context.read<MentorProfileRepository>()),
    ),
  ];
}
