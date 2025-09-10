import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mentivisor/Mentee/Models/DailySlotsModel.dart';
import 'package:mentivisor/Mentee/data/cubits/AddCommunityPost/add_communitypost_cubit.dart';
import 'package:mentivisor/Mentee/data/cubits/AddECC/add_ecc_cubit.dart';
import 'package:mentivisor/Mentee/data/cubits/AddResource/add_resource_cubit.dart';
import 'package:mentivisor/Mentee/data/cubits/AddResource/add_resource_repository.dart';
import 'package:mentivisor/Mentee/data/cubits/BookSession/book_session_cubit.dart';
import 'package:mentivisor/Mentee/data/cubits/BookSession/session_repository.dart';
import 'package:mentivisor/Mentee/data/cubits/Campuses/campuses_cubit.dart';
import 'package:mentivisor/Mentee/data/cubits/Campuses/campuses_repository.dart';
import 'package:mentivisor/Mentee/data/cubits/ChatMessages/ChatMessagesCubit.dart';
import 'package:mentivisor/Mentee/data/cubits/ChatMessages/ChatMessagesRepository.dart';
import 'package:mentivisor/Mentee/data/cubits/CoinsPack/coins_pack_cubit.dart';
import 'package:mentivisor/Mentee/data/cubits/CoinsPack/coins_pack_repo.dart';
import 'package:mentivisor/Mentee/data/cubits/Comments/CommentsRepo.dart';
import 'package:mentivisor/Mentee/data/cubits/Comments/FetchCommentsCubit.dart';
import 'package:mentivisor/Mentee/data/cubits/CommunityPosts/CommunityPostsCubit.dart';
import 'package:mentivisor/Mentee/data/cubits/CommunityPosts/CommunityPostsRepository.dart';
import 'package:mentivisor/Mentee/data/cubits/CommunityTags/community_tags_cubit.dart';
import 'package:mentivisor/Mentee/data/cubits/CustomerSupport/Mentee_Customersupport_Cubit.dart';
import 'package:mentivisor/Mentee/data/cubits/CustomerSupport/Mentee_Customersupport_Repo.dart';
import 'package:mentivisor/Mentee/data/cubits/Downloads/downloads_cubit.dart';
import 'package:mentivisor/Mentee/data/cubits/Downloads/downloads_repository.dart';
import 'package:mentivisor/Mentee/data/cubits/Downloads/downloads_states.dart';
import 'package:mentivisor/Mentee/data/cubits/ECC/ecc_cubit.dart';
import 'package:mentivisor/Mentee/data/cubits/ECC/ecc_repository.dart';
import 'package:mentivisor/Mentee/data/cubits/ExclusiveServicesList/ExclusiveServiceList_cubit.dart';
import 'package:mentivisor/Mentee/data/cubits/ExclusiveServicesList/ExclusiveServicesList_repo.dart';
import 'package:mentivisor/Mentee/data/cubits/ForgotPassword/forgot_passsword_cubit.dart';
import 'package:mentivisor/Mentee/data/cubits/ForgotPassword/forgot_passsword_repository.dart';
import 'package:mentivisor/Mentee/data/cubits/GroupChatMessages/GroupChatMessagesCubit.dart';
import 'package:mentivisor/Mentee/data/cubits/GroupChatMessages/GroupMessagesRepo.dart';
import 'package:mentivisor/Mentee/data/cubits/GuestMentors/guest_mentors_cubit.dart';
import 'package:mentivisor/Mentee/data/cubits/GuestMentors/guest_mentors_repository.dart';
import 'package:mentivisor/Mentee/data/cubits/HighlightedCoins/highlighted_coins_cubit.dart';
import 'package:mentivisor/Mentee/data/cubits/HighlightedCoins/highlighted_coins_repository.dart';
import 'package:mentivisor/Mentee/data/cubits/MenteeDashBoard/mentee_dashboard_cubit.dart';
import 'package:mentivisor/Mentee/data/cubits/MenteeProfile/MenteeProfileUpdate/MenteeProfileCubit.dart';
import 'package:mentivisor/Mentee/data/cubits/Payment/payment_cubit.dart';
import 'package:mentivisor/Mentee/data/cubits/PostComment/post_comment_cubit.dart';
import 'package:mentivisor/Mentee/data/cubits/PostComment/post_comment_repository.dart';
import 'package:mentivisor/Mentee/data/cubits/SelectSlot/select_slot_cubit.dart';
import 'package:mentivisor/Mentee/data/cubits/UpComingSessions/up_coming_session_cubit.dart';
import 'package:mentivisor/Mentee/data/cubits/UpComingSessions/up_coming_session_repo.dart';
import 'package:mentivisor/Mentee/data/cubits/UploadFileInChat/UploadFileInChatCubit.dart';
import 'package:mentivisor/Mentee/data/cubits/UploadFileInChat/UploadFileInChatRepo.dart';
import 'package:mentivisor/Mentee/data/cubits/WalletMoney/WalletMoney_Cubit.dart';
import 'package:mentivisor/Mentee/data/cubits/WalletMoney/Walletmoney_Repository.dart';
import 'package:mentivisor/Mentee/data/cubits/StudyZoneReport/StudyZoneReportRepo.dart';
import 'package:mentivisor/Mentee/data/cubits/WeeklySlots/weekly_slots_cubit.dart';
import 'package:mentivisor/Mentee/data/cubits/Years/years_cubit.dart';
import 'package:mentivisor/Mentee/data/cubits/Years/years_repository.dart';
import 'package:mentivisor/Mentor/data/Cubits/AvailabilitySlots/AvailabilitySlotsCubit.dart';
import 'package:mentivisor/Mentor/data/Cubits/CoinsHistory/coin_history_cubit.dart';
import 'package:mentivisor/Mentor/data/Cubits/ExpertiseDetails/expertise_details_cubit.dart';
import 'package:mentivisor/Mentor/data/Cubits/Expertises/ApprovedExpertiseCubit.dart';
import 'package:mentivisor/Mentor/data/Cubits/Expertises/ExpertiseRepo.dart';
import 'package:mentivisor/Mentor/data/Cubits/Expertises/PendingExpertiseCubit.dart';
import 'package:mentivisor/Mentor/data/Cubits/Expertises/RejectedExpertiseCubit.dart';
import 'package:mentivisor/Mentor/data/Cubits/FeedBack/feedback_repository.dart';
import 'package:mentivisor/Mentor/data/Cubits/MentorAvailability/MentorAvailabilityCubit.dart';
import 'package:mentivisor/Mentor/data/Cubits/MentorAvailability/MentorAvailabilityRepo.dart';
import 'package:mentivisor/Mentor/data/Cubits/MentorDashboardCubit/mentor_dashboard_cubit.dart';
import 'package:mentivisor/Mentor/data/Cubits/MentorSessionCancel/mentor_session_cancel_cubit.dart';
import 'package:mentivisor/Mentor/data/Cubits/MyMentees/mymentees_cubit.dart';
import 'package:mentivisor/Mentor/data/Cubits/MyMentees/mymentees_repository.dart';
import 'package:mentivisor/Mentor/data/Cubits/NewExpertiseRequest/NewExpertiseRequestCubit.dart';
import 'package:mentivisor/Mentor/data/Cubits/NonAttachedExpertises/NonAttachedExpertisesCubit.dart';
import 'package:mentivisor/Mentor/data/Cubits/ReportMentee/report_mentee_cubit.dart';
import 'package:mentivisor/Mentor/data/Cubits/Reviews/ReviewsCubit.dart';
import 'package:mentivisor/Mentor/data/Cubits/Reviews/ReviewsRepo.dart';
import 'package:mentivisor/Mentor/data/Cubits/Sessions/SessionsCubit.dart';
import 'package:mentivisor/Mentor/data/Cubits/Sessions/SessionsRepository.dart';
import 'package:mentivisor/Mentor/data/Cubits/UpdateExpertise/UpdateExpertiseCubit.dart';
import '../bloc/internet_status/internet_status_bloc.dart';
import 'Mentee/data/cubits/BecomeMentor/become_mentor_cubit.dart';
import 'Mentee/data/cubits/BecomeMentor/become_mentor_repository.dart';
import 'Mentee/data/cubits/CampusMentorList/campus_mentor_list_cubit.dart';
import 'Mentee/data/cubits/CampusMentorList/campus_mentor_list_repo.dart';
import 'Mentee/data/cubits/CommunityDetails/CommunityDetailsCubit.dart';
import 'Mentee/data/cubits/CommunityPostReport/CommunityZoneReportCubit.dart';
import 'Mentee/data/cubits/DailySlots/daily_slots_cubit.dart';
import 'Mentee/data/cubits/EccTags/TagsSearch/tags_search_cubit.dart';
import 'Mentee/data/cubits/EccTags/tags_cubit.dart';
import 'Mentee/data/cubits/EccTags/tags_repository.dart';
import 'Mentee/data/cubits/ExclusiveServiceDetails/ExclusiveServiceDetails_Cubit.dart';
import 'Mentee/data/cubits/ExclusiveServiceDetails/ExclusiveServiceDetails_Repository.dart';
import 'Mentee/data/cubits/Expertise/ExpertiseCategory/expertise_category_cubit.dart';
import 'Mentee/data/cubits/Expertise/ExpertiseSubCategory/expertise_sub_category_cubit.dart';
import 'Mentee/data/cubits/Expertise/expertise_repository.dart';
import 'Mentee/data/cubits/GetBanners/GetBannersCubit.dart';
import 'Mentee/data/cubits/GetBanners/GetBannersRepository.dart';
import 'Mentee/data/cubits/Login/LoginCubit.dart';
import 'Mentee/data/cubits/Login/LoginRepository.dart';
import 'Mentee/data/cubits/MenteeProfile/GetMenteeProfile/MenteeProfileCubit.dart';
import 'Mentee/data/cubits/MenteeProfile/MenteeProfileRepository.dart';
import 'Mentee/data/cubits/MentorProfile/MentorProfileCubit.dart';
import 'Mentee/data/cubits/MentorProfile/MentorProfileRepository.dart';
import 'Mentee/data/cubits/Notifications/notifications_cubit.dart';
import 'Mentee/data/cubits/Notifications/notifications_repo.dart';
import 'Mentee/data/cubits/Payment/payment_repository.dart';
import 'Mentee/data/cubits/ProductTools/TaskByDate/task_by_date_cubit.dart';
import 'Mentee/data/cubits/ProductTools/TaskByStates/task_by_states_cubit.dart';
import 'Mentee/data/cubits/ProductTools/TaskUpdate/task_update_cubit.dart';
import 'Mentee/data/cubits/ProductTools/product_tools_repository.dart';
import 'Mentee/data/cubits/Register/Register_Cubit.dart';
import 'Mentee/data/cubits/Register/Register_Repository.dart';
import 'Mentee/data/cubits/ResourceDetails/ResourceDetailsCubit.dart';
import 'Mentee/data/cubits/SessionCompleted/session_completed_cubit.dart';
import 'Mentee/data/cubits/SessionCompleted/session_completed_repo.dart';
import 'Mentee/data/cubits/StudyZoneCampus/StudyZoneCampusCubit.dart';
import 'Mentee/data/cubits/StudyZoneCampus/StudyZoneCampusRepository.dart';
import 'Mentee/data/cubits/StudyZoneReport/StudyZoneReportCubit.dart';
import 'Mentee/data/cubits/StudyZoneTags/StudyZoneTagsCubit.dart';
import 'Mentee/data/cubits/StudyZoneTags/StudyZoneTagsRepository.dart';
import 'Mentee/data/cubits/SubmitReview/submit_review_cubit.dart';
import 'Mentee/data/cubits/Tags/TagsSearch/tags_search_cubit.dart';
import 'Mentee/data/cubits/Tags/tags_cubit.dart';
import 'Mentee/data/cubits/Tags/tags_repository.dart';
import 'Mentee/data/cubits/Verify_Otp/Verify_Otp_Cubit.dart';
import 'Mentee/data/cubits/Verify_Otp/Verify_Otp_Repository.dart';
import 'Mentee/data/cubits/ViewEccEventDetails/ViewEventDetailsCubit.dart';
import 'Mentee/data/remote_data_source.dart';
import 'Mentor/data/Cubits/CoinsHistory/coin_history_repo.dart';
import 'Mentor/data/Cubits/FeedBack/feedback_cubit.dart';
import 'Mentor/data/Cubits/MentorInfo/Mentor_Info_cubit.dart';
import 'Mentor/data/Cubits/MentorInfo/Mentor_info_repo.dart';
import 'Mentor/data/Cubits/MentorProfile/MentorProfileUpdate/MentorProfileCubit.dart';
import 'Mentor/data/Cubits/MentorProfile/mentor_profile_cubit.dart';
import 'Mentor/data/Cubits/MentorProfile/mentor_profile_repo.dart';
import 'Mentor/data/Cubits/MentorSessionCancel/mentor_Session_cancel_repo.dart';
import 'Mentor/data/Cubits/PendingSubExpertise/PendingSubExpertiseCubit.dart';
import 'Mentor/data/Cubits/ReportMentor/report_mentor_cubit.dart';
import 'Mentor/data/Cubits/ReportMentor/report_repository.dart';
import 'Mentor/data/Cubits/SessionComplete/session_complete_cubit.dart';
import 'Mentor/data/Cubits/SessionComplete/session_complete_repo.dart';
import 'Mentor/data/Cubits/SessionDetails/SessionsDetailsCubit.dart';
import 'Mentor/data/Cubits/SessionDetails/SessionsDetailsRepository.dart';
import 'Mentor/data/Cubits/NonAttachedExpertiseDetails/NonAttachedExpertiseDetailsCubit.dart';
import 'Mentor/data/MentorRemoteDataSource.dart';

class StateInjector {
  static final repositoryProviders = <RepositoryProvider>[
    RepositoryProvider<RemoteDataSource>(
      create: (context) => RemoteDataSourceImpl(),
    ),
    RepositoryProvider<MentorRemoteDataSource>(
      create: (context) => MentorRemoteDataSourceImpl(),
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
    RepositoryProvider<MenteeCustomersupportRepo>(
      create: (context) => MenteecustomersupportImpl(
        remoteDataSource: context.read<RemoteDataSource>(),
      ),
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
    RepositoryProvider<EccTagsRepository>(
      create: (context) =>
          EccTagsImpl(remoteDataSource: context.read<RemoteDataSource>()),
    ),
    RepositoryProvider<ECCRepository>(
      create: (context) =>
          ECCRepositoryImpl(remoteDataSource: context.read<RemoteDataSource>()),
    ),
    RepositoryProvider<CoinsPackRepo>(
      create: (context) =>
          CoinspackImpl(remoteDataSource: context.read<RemoteDataSource>()),
    ),

    RepositoryProvider<WalletmoneyRepository>(
      create: (context) =>
          walletmoneyImpl(remoteDataSource: context.read<RemoteDataSource>()),
    ),

    RepositoryProvider<CommunityPostsRepo>(
      create: (context) => CommunityPostsRepoImpl(
        remoteDataSource: context.read<RemoteDataSource>(),
      ),
    ),
    RepositoryProvider<DownloadsRepository>(
      create: (context) => DownloadsRepositoryImpl(
        remoteDataSource: context.read<RemoteDataSource>(),
      ),
    ),
    RepositoryProvider<StudyZoneReportRepository>(
      create: (context) => StudyZoneReportImpl(
        remoteDataSource: context.read<RemoteDataSource>(),
      ),
    ),

    RepositoryProvider<PostCommentRepository>(
      create: (context) => PostCommentRepositoryImpl(
        remoteDataSource: context.read<RemoteDataSource>(),
      ),
    ),

    RepositoryProvider<ProductToolsRepository>(
      create: (context) =>
          ProductToolsImpl(remoteDataSource: context.read<RemoteDataSource>()),
    ),
    RepositoryProvider<AddResourceRepository>(
      create: (context) => AddResourceRepositoryImpl(
        remoteDataSource: context.read<RemoteDataSource>(),
      ),
    ),
    RepositoryProvider<YearsRepository>(
      create: (context) => YearsRepositoryImpl(
        remoteDataSource: context.read<RemoteDataSource>(),
      ),
    ),
    RepositoryProvider<CampusesRepository>(
      create: (context) => CampusesRepositoryImpl(
        remoteDataSource: context.read<RemoteDataSource>(),
      ),
    ),
    RepositoryProvider<ExclusiveserviceslistRepo>(
      create: (context) =>
          ExclusiveImpl(remoteDataSource: context.read<RemoteDataSource>()),
    ),
    RepositoryProvider<ExpertiseRepo>(
      create: (context) =>
          ExpertiseImpl(remoteDataSource: context.read<RemoteDataSource>()),
    ),
    RepositoryProvider<BecomeMentorRepository>(
      create: (context) =>
          BecomeMentorImpl(remoteDataSource: context.read<RemoteDataSource>()),
    ),
    RepositoryProvider<MenteeProfileRepository>(
      create: (context) =>
          MenteeProfileImpl(remoteDataSource: context.read<RemoteDataSource>()),
    ),
    RepositoryProvider<SessionBookingRepo>(
      create: (context) => SessionBookingRepoImpl(
        remoteDataSource: context.read<RemoteDataSource>(),
      ),
    ),
    RepositoryProvider<GuestMentorsRepository>(
      create: (context) => GuestMentorsRepositoryImpl(
        remoteDataSource: context.read<RemoteDataSource>(),
      ),
    ),
    RepositoryProvider<ExclusiveservicedetailsRepository>(
      create: (context) => ExclusivedetailsImpl(
        remoteDataSource: context.read<RemoteDataSource>(),
      ),
    ),
    RepositoryProvider<UpComingSessionRepository>(
      create: (context) => UpComingSessionImpl(
        remoteDataSource: context.read<RemoteDataSource>(),
      ),
    ),
    RepositoryProvider<SessionCompletedRepository>(
      create: (context) => SessionCompletedImpl(
        remoteDataSource: context.read<RemoteDataSource>(),
      ),
    ),
    RepositoryProvider<PaymentRepository>(
      create: (context) => PaymentRepositoryImpl(
        remoteDataSource: context.read<RemoteDataSource>(),
      ),
    ),
    RepositoryProvider<HighlightedCoinsRepository>(
      create: (context) => HighlightedCoinsImpl(
        remoteDataSource: context.read<RemoteDataSource>(),
      ),
    ),
    RepositoryProvider<NotificationsRepo>(
      create: (context) =>
          NotificationIml(remoteDataSource: context.read<RemoteDataSource>()),
    ),
    RepositoryProvider<TagsRepository>(
      create: (context) =>
          TagsImpl(remoteDataSource: context.read<RemoteDataSource>()),
    ),

    RepositoryProvider<ForgotPassswordRepository>(
      create: (context) => ForgotPassswordImpl(
        remoteDataSource: context.read<RemoteDataSource>(),
      ),
    ),

    RepositoryProvider<ChatMessagesRepository>(
      create: (context) => ChatMessagesRepositoryImpl(
        remoteDataSource: context.read<RemoteDataSource>(),
      ),
    ),

    RepositoryProvider<GroupMessagesRepository>(
      create: (context) => GroupMessagesRepositoryImpl(
        remoteDataSource: context.read<RemoteDataSource>(),
      ),
    ),

    RepositoryProvider<UploadFileInChatRepo>(
      create: (context) => UploadFileInChatRepoImpl(
        remoteDataSource: context.read<RemoteDataSource>(),
      ),
    ),
    RepositoryProvider<StudyZoneCampusRepository>(
      create: (context) => StudyZoneCampusRepositoryImpl(
        remoteDataSource: context.read<RemoteDataSource>(),
      ),
    ),

    ///Mentor Repositories
    RepositoryProvider<SessionSRepo>(
      create: (context) => SessionSRepoImpl(
        mentorRemoteDataSource: context.read<MentorRemoteDataSource>(),
      ),
    ),
    RepositoryProvider<FeedBackRepository>(
      create: (context) => FeedBackRepositoryImpl(
        mentorRemoteDataSource: context.read<MentorRemoteDataSource>(),
      ),
    ),
    RepositoryProvider<SessionCompleteRepo>(
      create: (context) => SessionCompleteImpl(
        mentorRemoteDataSource: context.read<MentorRemoteDataSource>(),
      ),
    ),
    RepositoryProvider<SessionCanceledRepo>(
      create: (context) => SessionCanceledImpl(
        mentorRemoteDataSource: context.read<MentorRemoteDataSource>(),
      ),
    ),
    RepositoryProvider<MentorProfileRepo1>(
      create: (context) => MentorProfile1Impl(
        mentorRemoteDataSource: context.read<MentorRemoteDataSource>(),
      ),
    ),

    RepositoryProvider<MyMenteesRepo>(
      create: (context) => MyMenteesRepoImpl(
        mentorRemoteDataSource: context.read<MentorRemoteDataSource>(),
      ),
    ),

    RepositoryProvider<MentorInfoRepo>(
      create: (context) => MentorProfileRepoImpl(
        mentorRemoteDataSource: context.read<MentorRemoteDataSource>(),
      ),
    ),
    RepositoryProvider<MentorProfileRepo1>(
      create: (context) => MentorProfile1Impl(
        mentorRemoteDataSource: context.read<MentorRemoteDataSource>(),
      ),
    ),
    RepositoryProvider<SessionsDetailsRepo>(
      create: (context) => SessionsDetailsRepoImpl(
        mentorRemoteDataSource: context.read<MentorRemoteDataSource>(),
      ),
    ),

    RepositoryProvider<CoinHistoryRepo>(
      create: (context) => CoinsHistoryImpl(
        mentorRemoteDataSource: context.read<MentorRemoteDataSource>(),
      ),
    ),

    RepositoryProvider<MentorAvailabilityRepo>(
      create: (context) => MentorAvailabilityImpl(
        mentorRemoteDataSource: context.read<MentorRemoteDataSource>(),
      ),
    ),

    RepositoryProvider<ReportMentorRepository>(
      create: (context) => MentorReportImpl(
        mentorRemoteDataSource: context.read<MentorRemoteDataSource>(),
      ),
    ),

    RepositoryProvider<ExpertisesRepo>(
      create: (context) => ExpertisesRepoImpl(
        mentorRemoteDataSource: context.read<MentorRemoteDataSource>(),
      ),
    ),

    RepositoryProvider<CommentsRepo>(
      create: (context) => CommentsRepoImpl(
        mentorRemoteDataSource: context.read<MentorRemoteDataSource>(),
      ),
    ),

    RepositoryProvider<ReviewsRepo>(
      create: (context) => ReviewsRepoImpl(
        mentorRemoteDataSource: context.read<MentorRemoteDataSource>(),
      ),
    ),
  ];

  static final blocProviders = <BlocProvider>[
    BlocProvider<InternetStatusBloc>(create: (context) => InternetStatusBloc()),
    BlocProvider<YearsCubit>(
      create: (context) => YearsCubit(context.read<YearsRepository>()),
    ),
    BlocProvider<GuestMentorsCubit>(
      create: (context) =>
          GuestMentorsCubit(context.read<GuestMentorsRepository>()),
    ),
    BlocProvider<CampusesCubit>(
      create: (context) => CampusesCubit(context.read<CampusesRepository>()),
    ),
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
    BlocProvider<EccTagsCubit>(
      create: (context) => EccTagsCubit(context.read<EccTagsRepository>()),
    ),
    BlocProvider<EccTagsSearchCubit>(
      create: (context) => EccTagsSearchCubit(context.read<EccTagsRepository>()),
    ),
    BlocProvider<MentorProfileCubit>(
      create: (context) =>
          MentorProfileCubit(context.read<MentorProfileRepository>()),
    ),
    BlocProvider<ECCCubit>(
      create: (context) => ECCCubit(context.read<ECCRepository>()),
    ),
    BlocProvider<ViewEventDetailsCubit>(
      create: (context) => ViewEventDetailsCubit(context.read<ECCRepository>()),
    ),
    BlocProvider<AddEccCubit>(
      create: (context) => AddEccCubit(context.read<ECCRepository>()),
    ),
    BlocProvider<StudyZoneCampusCubit>(
      create: (context) =>
          StudyZoneCampusCubit(context.read<StudyZoneCampusRepository>()),
    ),
    BlocProvider<Resourcedetailscubit>(
      create: (context) =>
          Resourcedetailscubit(context.read<StudyZoneCampusRepository>()),
    ),

    BlocProvider<CoinsPackCubit>(
      create: (context) => CoinsPackCubit(context.read<CoinsPackRepo>()),
    ),
    BlocProvider<WalletmoneyCubit>(
      create: (context) =>
          WalletmoneyCubit(context.read<WalletmoneyRepository>()),
    ),
    BlocProvider<CommunityPostsCubit>(
      create: (context) =>
          CommunityPostsCubit(context.read<CommunityPostsRepo>()),
    ),
    BlocProvider<CommunityDetailsCubit>(
      create: (context) =>
          CommunityDetailsCubit(context.read<CommunityPostsRepo>()),
    ),
    BlocProvider<AddCommunityPostCubit>(
      create: (context) =>
          AddCommunityPostCubit(context.read<CommunityPostsRepo>()),
    ),
    BlocProvider<CommunityTagsCubit>(
      create: (context) =>
          CommunityTagsCubit(context.read<CommunityPostsRepo>()),
    ),
    BlocProvider<DownloadsCubit>(
      create: (context) => DownloadsCubit(context.read<DownloadsRepository>()),
    ),
    BlocProvider<StudyZoneReportCubit>(
      create: (context) =>
          StudyZoneReportCubit(context.read<StudyZoneReportRepository>()),
    ),
    BlocProvider<PostCommentCubit>(
      create: (context) =>
          PostCommentCubit(context.read<PostCommentRepository>()),
    ),
    BlocProvider<TaskByDateCubit>(
      create: (context) =>
          TaskByDateCubit(context.read<ProductToolsRepository>()),
    ),
    BlocProvider<TaskByStatusCubit>(
      create: (context) =>
          TaskByStatusCubit(context.read<ProductToolsRepository>()),
    ),
    BlocProvider<TaskUpdateCubit>(
      create: (context) =>
          TaskUpdateCubit(context.read<ProductToolsRepository>()),
    ),
    BlocProvider<AddResourceCubit>(
      create: (context) =>
          AddResourceCubit(context.read<AddResourceRepository>()),
    ),
    BlocProvider<ExpertiseCategoryCubit>(
      create: (context) =>
          ExpertiseCategoryCubit(context.read<ExpertiseRepo>()),
    ),
    BlocProvider<ExpertiseSubCategoryCubit>(
      create: (context) =>
          ExpertiseSubCategoryCubit(context.read<ExpertiseRepo>()),
    ),
    BlocProvider<BecomeMentorCubit>(
      create: (context) =>
          BecomeMentorCubit(context.read<BecomeMentorRepository>()),
    ),
    BlocProvider<MenteeProfileCubit>(
      create: (context) =>
          MenteeProfileCubit(context.read<MenteeProfileRepository>()),
    ),
    BlocProvider<ExclusiveservicelistCubit>(
      create: (context) =>
          ExclusiveservicelistCubit(context.read<ExclusiveserviceslistRepo>()),
    ),
    BlocProvider<CommunityZoneReportCubit>(
      create: (context) =>
          CommunityZoneReportCubit(context.read<CommunityPostsRepo>()),
    ),
    BlocProvider<MenteeProfileUpdateCubit>(
      create: (context) =>
          MenteeProfileUpdateCubit(context.read<MenteeProfileRepository>()),
    ),
    BlocProvider<WeeklySlotsCubit>(
      create: (context) => WeeklySlotsCubit(context.read<SessionBookingRepo>()),
    ),
    BlocProvider<DailySlotsCubit>(
      create: (context) => DailySlotsCubit(context.read<SessionBookingRepo>()),
    ),
    BlocProvider<SelectSlotCubit>(
      create: (context) => SelectSlotCubit(context.read<SessionBookingRepo>()),
    ),
    BlocProvider<SessionBookingCubit>(
      create: (context) =>
          SessionBookingCubit(context.read<SessionBookingRepo>()),
    ),
    BlocProvider<ExclusiveservicedetailsCubit>(
      create: (context) => ExclusiveservicedetailsCubit(
        context.read<ExclusiveservicedetailsRepository>(),
      ),
    ),
    BlocProvider<UpComingSessionCubit>(
      create: (context) =>
          UpComingSessionCubit(context.read<UpComingSessionRepository>()),
    ),
    BlocProvider<SessionCompletedCubit>(
      create: (context) =>
          SessionCompletedCubit(context.read<SessionCompletedRepository>()),
    ),
    BlocProvider<SubmitReviewCubit>(
      create: (context) =>
          SubmitReviewCubit(context.read<SessionCompletedRepository>()),
    ),
    BlocProvider<PaymentCubit>(
      create: (context) => PaymentCubit(context.read<PaymentRepository>()),
    ),

    BlocProvider<MenteeCustomersupportCubit>(
      create: (context) =>
          MenteeCustomersupportCubit(context.read<MenteeCustomersupportRepo>()),
    ),
    BlocProvider<HighlightedCoinsCubit>(
      create: (context) =>
          HighlightedCoinsCubit(context.read<HighlightedCoinsRepository>()),
    ),
    BlocProvider<NotificationsCubit>(
      create: (context) =>
          NotificationsCubit(context.read<NotificationsRepo>()),
    ),
    BlocProvider<TagsCubit>(
      create: (context) => TagsCubit(context.read<TagsRepository>()),
    ),
    BlocProvider<TagsSearchCubit>(
      create: (context) => TagsSearchCubit(context.read<TagsRepository>()),
    ),
    BlocProvider<ForgotPassswordCubit>(
      create: (context) =>
          ForgotPassswordCubit(context.read<ForgotPassswordRepository>()),
    ),

    BlocProvider<MenteeDashboardCubit>(
      create: (context) => MenteeDashboardCubit(
        bannersCubit: Getbannerscubit(context.read<Getbannersrepository>()),
        profileCubit: MenteeProfileCubit(
          context.read<MenteeProfileRepository>(),
        ),
        campusMentorCubit: CampusMentorListCubit(
          context.read<CampusMentorListRepository>(),
        ),
        guestMentorsCubit: GuestMentorsCubit(
          context.read<GuestMentorsRepository>(),
        ),
      ),
    ),

    ///Mentor cubitsss
    BlocProvider<SessionCubit>(
      create: (context) => SessionCubit(context.read<SessionSRepo>()),
    ),
    BlocProvider<FeedbackCubit>(
      create: (context) => FeedbackCubit(context.read<FeedBackRepository>()),
    ),

    BlocProvider<ReportMenteeCubit>(
      create: (context) => ReportMenteeCubit(context.read<MyMenteesRepo>()),
    ),
    BlocProvider<MentorProfileCubit1>(
      create: (context) =>
          MentorProfileCubit1(context.read<MentorProfileRepo1>()),
    ),
    BlocProvider<MyMenteeCubit>(
      create: (context) => MyMenteeCubit(context.read<MyMenteesRepo>()),
    ),
    BlocProvider<MentorInfoCubit>(
      create: (context) => MentorInfoCubit(context.read<MentorInfoRepo>()),
    ),
    BlocProvider<MentorProfileUpdateCubit>(
      create: (context) =>
          MentorProfileUpdateCubit(context.read<MentorProfileRepo1>()),
    ),
    BlocProvider<MentorAvailabilityCubit>(
      create: (context) =>
          MentorAvailabilityCubit(context.read<MentorAvailabilityRepo>()),
    ),
    BlocProvider<AvailableSlotsCubit>(
      create: (context) =>
          AvailableSlotsCubit(context.read<MentorAvailabilityRepo>()),
    ),
    BlocProvider<MentorSessionCancelCubit>(
      create: (context) =>
          MentorSessionCancelCubit(context.read<SessionCanceledRepo>()),
    ),
    BlocProvider<SessionDetailsCubit>(
      create: (context) =>
          SessionDetailsCubit(context.read<SessionsDetailsRepo>()),
    ),
    BlocProvider<ApprovedExpertiseCubit>(
      create: (context) =>
          ApprovedExpertiseCubit(context.read<ExpertisesRepo>()),
    ),
    BlocProvider<PendingExpertiseCubit>(
      create: (context) =>
          PendingExpertiseCubit(context.read<ExpertisesRepo>()),
    ),
    BlocProvider<RejectedExpertiseCubit>(
      create: (context) =>
          RejectedExpertiseCubit(context.read<ExpertisesRepo>()),
    ),
    BlocProvider<MentorExpertiseCubit>(
      create: (context) => MentorExpertiseCubit(context.read<ExpertisesRepo>()),
    ),
    BlocProvider<UpdateExpertiseCubit>(
      create: (context) => UpdateExpertiseCubit(context.read<ExpertisesRepo>()),
    ),
    BlocProvider<NonAttachedExpertisesCubit>(
      create: (context) =>
          NonAttachedExpertisesCubit(context.read<ExpertisesRepo>()),
    ),
    BlocProvider<NonAttachedExpertiseDetailsCubit>(
      create: (context) =>
          NonAttachedExpertiseDetailsCubit(context.read<ExpertisesRepo>()),
    ),
    BlocProvider<NewExpertiseRequestCubit>(
      create: (context) =>
          NewExpertiseRequestCubit(context.read<ExpertisesRepo>()),
    ),
    BlocProvider<ReportMentorCubit>(
      create: (context) =>
          ReportMentorCubit(context.read<ReportMentorRepository>()),
    ),
    BlocProvider<PendingSubExpertisesCubit>(
      create: (context) =>
          PendingSubExpertisesCubit(context.read<ExpertisesRepo>()),
    ),
    BlocProvider<CoinHistoryCubit>(
      create: (context) => CoinHistoryCubit(context.read<CoinHistoryRepo>()),
    ),

    BlocProvider<FetchCommentsCubit>(
      create: (context) => FetchCommentsCubit(context.read<CommentsRepo>()),
    ),

    BlocProvider<SessionCompleteCubit>(
      create: (context) =>
          SessionCompleteCubit(context.read<SessionCompleteRepo>()),
    ),

    BlocProvider<ReviewsCubit>(
      create: (context) => ReviewsCubit(context.read<ReviewsRepo>()),
    ),
    BlocProvider<ChatMessagesCubit>(
      create: (context) =>
          ChatMessagesCubit(context.read<ChatMessagesRepository>()),
    ),
    BlocProvider<GroupChatMessagesCubit>(
      create: (context) =>
          GroupChatMessagesCubit(context.read<GroupMessagesRepository>()),
    ),

    BlocProvider<UploadFileInChatCubit>(
      create: (context) =>
          UploadFileInChatCubit(context.read<UploadFileInChatRepo>()),
    ),

    BlocProvider<MentorDashboardCubit>(
      create: (context) => MentorDashboardCubit(
        mentorProfileCubit1: MentorProfileCubit1(
          context.read<MentorProfileRepo1>(),
        ),
        getbannerscubit: Getbannerscubit(context.read<Getbannersrepository>()),
        sessionCubit: SessionCubit(context.read<SessionSRepo>()),
      ),
    ),
  ];
}
