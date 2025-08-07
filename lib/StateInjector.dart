import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mentivisor/Mentee/data/cubits/ECC/ecc_cubit.dart';
import 'package:mentivisor/Mentee/data/cubits/ECC/ecc_repository.dart';
import '../bloc/internet_status/internet_status_bloc.dart';
import 'Mentee/data/cubits/CampusMentorList/campus_mentor_list_cubit.dart';
import 'Mentee/data/cubits/CampusMentorList/campus_mentor_list_repo.dart';
import 'Mentee/data/cubits/GetBanners/GetBannersCubit.dart';
import 'Mentee/data/cubits/GetBanners/GetBannersRepository.dart';
import 'Mentee/data/cubits/Login/LoginCubit.dart';
import 'Mentee/data/cubits/Login/LoginRepository.dart';
import 'Mentee/data/cubits/MentorProfile/MentorProfileCubit.dart';
import 'Mentee/data/cubits/MentorProfile/MentorProfileRepository.dart';
import 'Mentee/data/cubits/Register/Register_Cubit.dart';
import 'Mentee/data/cubits/Register/Register_Repository.dart';
import 'Mentee/data/cubits/StudyZoneCampus/StudyZoneCampusCubit.dart';
import 'Mentee/data/cubits/StudyZoneCampus/StudyZoneCampusRepository.dart';
import 'Mentee/data/cubits/StudyZoneTags/StudyZoneTagsCubit.dart';
import 'Mentee/data/cubits/StudyZoneTags/StudyZoneTagsRepository.dart';
import 'Mentee/data/cubits/Verify_Otp/Verify_Otp_Cubit.dart';
import 'Mentee/data/cubits/Verify_Otp/Verify_Otp_Repository.dart';
import 'Mentee/data/remote_data_source.dart';

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
    RepositoryProvider<StudyZoneCampusRepository>(
      create: (context) => StudyZoneCampusRepositoryImpl(
        remoteDataSource: context.read<RemoteDataSource>(),
      ),
    ),
    RepositoryProvider<ECCRepository>(
      create: (context) =>
          ECCRepositoryImpl(remoteDataSource: context.read<RemoteDataSource>()),
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
    BlocProvider<ECCCubit>(
      create: (context) => ECCCubit(context.read<ECCRepository>()),
    ),
    BlocProvider<StudyZoneCampusCubit>(
      create: (context) =>
          StudyZoneCampusCubit(context.read<StudyZoneCampusRepository>()),
    ),
  ];
}
