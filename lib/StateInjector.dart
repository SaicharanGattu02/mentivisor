import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mentivisor/bloc/GetBanners/GetBannersCubit.dart';
import 'package:mentivisor/bloc/Login/LoginCubit.dart';
import 'package:mentivisor/bloc/On_Campouse/OnCampus_Repository.dart';
import 'package:mentivisor/bloc/Register/Register_Cubit.dart';
import 'package:mentivisor/bloc/Register/Register_Repository.dart';
import 'package:mentivisor/bloc/TopMentors/TopMentors_Cubit.dart';
import 'package:mentivisor/bloc/TopMentors/TopMentors_Repository.dart';
import 'package:mentivisor/bloc/Verify_Otp/Verify_Otp_Cubit.dart';
import 'package:mentivisor/bloc/Verify_Otp/Verify_Otp_Repository.dart';
import '../bloc/internet_status/internet_status_bloc.dart';
import '../services/remote_data_source.dart';
import 'bloc/GetBanners/GetBannersRepository.dart';
import 'bloc/Login/LoginRepository.dart';

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

    RepositoryProvider<TopmentorsRepository>(
      create: (context) =>
          TopmentersImpl(remoteDataSource: context.read<RemoteDataSource>()),
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
    BlocProvider<TopmentorsCubit>(
      create: (context) =>
          TopmentorsCubit(context.read<TopmentorsRepository>()),
    ),

  ];
}
