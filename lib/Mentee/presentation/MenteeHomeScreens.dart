import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:go_router/go_router.dart';
import 'package:mentivisor/Components/CustomAppButton.dart';
import 'package:mentivisor/Mentee/data/cubits/CampusMentorList/campus_mentor_list_state.dart';
import 'package:mentivisor/Mentee/data/cubits/GetBanners/GetBannersState.dart';
import 'package:mentivisor/Mentee/data/cubits/GuestMentors/guest_mentors_states.dart';
import 'package:mentivisor/Mentee/data/cubits/HomeDialog/home_dialog_cubit.dart';
import 'package:mentivisor/Mentee/data/cubits/HomeDialog/home_dialog_states.dart';
import 'package:mentivisor/utils/AppLogger.dart';
import 'package:mentivisor/utils/media_query_helper.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../Components/CommonLoader.dart';
import '../../Components/Shimmers.dart';
import '../../Mentor/presentation/widgets/AppDrawer.dart';
import '../../services/AuthService.dart';
import '../../utils/color_constants.dart';
import '../../utils/constants.dart';
import '../../utils/spinkittsLoader.dart';
import '../data/cubits/CampusMentorList/campus_mentor_list_cubit.dart';
import '../data/cubits/DailyCheckIns/DailyCheckInsCubit.dart';
import '../data/cubits/GetBanners/GetBannersCubit.dart';
import '../data/cubits/GuestMentors/guest_mentors_cubit.dart';
import '../data/cubits/MenteeProfile/GetMenteeProfile/MenteeProfileCubit.dart';
import '../data/cubits/MenteeProfile/GetMenteeProfile/MenteeProfileState.dart';
import 'Widgets/FilterButton.dart';
import 'Widgets/MentorGridGuest.dart';

class MenteeHomeScreen extends StatefulWidget {
  const MenteeHomeScreen({Key? key}) : super(key: key);

  @override
  _MenteeHomeScreenState createState() => _MenteeHomeScreenState();
}

class _MenteeHomeScreenState extends State<MenteeHomeScreen> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  final ValueNotifier<bool> _isLoadingNotifier = ValueNotifier<bool>(false);
  final ValueNotifier<bool> _onCampusNotifier = ValueNotifier<bool>(true);
  final ValueNotifier<String> _selectedFilterNotifier = ValueNotifier<String>(
    'On Campus',
  );
  final ValueNotifier<bool> _isGuestNotifier = ValueNotifier<bool>(false);
  final ValueNotifier<int> _currentIndex = ValueNotifier<int>(0);

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadAll();
    });
  }

  Future<void> _loadAll() async {
    _isLoadingNotifier.value = true;

    try {
      final guest = await AuthService.isGuest;
      _isGuestNotifier.value = guest;

      final List<Future> futures = [
        context.read<Getbannerscubit>().getbanners(),
      ];

      // ---- Call only when NOT a guest ----
      if (!guest) {
        futures.addAll([
          context.read<MenteeProfileCubit>().fetchMenteeProfile(),
          context.read<DailyCheckInsCubit>().getDailyCheckIns(),
          context.read<HomeDialogCubit>().getHomeDialog(),
          context.read<CampusMentorListCubit>().fetchCampusMentorList("", ""),
        ]);
      }

      // ---- Call only when guest ----
      if (guest) {
        futures.add(
          context.read<GuestMentorsCubit>().fetchGuestMentorList(),
        );
      }

      await Future.wait(futures);
    } catch (e, st) {
      debugPrint("Error while loading dashboard data: $e");
    } finally {
      if (mounted) {
        _isLoadingNotifier.value = false;
      }
    }
  }


  void _navigateToScreen(String name) {
    switch (name) {
      case 'Wallet':
        context.push("/wallet_screen");
        break;
      case 'Downloads':
        context.push("/downloads");
        break;
      case 'Productivity Tools':
        context.push("/productivity_screen");
        break;
      case 'Session Completed':
        context.push("/session_completed");
        break;
      case 'Upcoming Sessions':
        context.push("/upcoming_session");
        break;
      case 'Milestones':
        context.push("/milestones");
        break;
      case 'Customer Services':
        context.push('/customersscreen');
        break;
      case 'Executive services':
        context.push('/executiveservices');
        break;
      case 'info':
        context.push('/info');
        break;
      case 'terms':
        context.push('/terms_conditions');
        break;
      case 'Logout':
        showLogoutDialog(context);
        break;
    }
  }

  Future<void> _launchUrl(String url) async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: AuthService.isGuest,
      builder: (context, snapshot) {
        final isGuest = snapshot.data ?? false;
        return ValueListenableBuilder<bool>(
          valueListenable: _isLoadingNotifier,
          builder: (context, isLoading, _) {
            if (isLoading) {
              return const Scaffold(body: MentorGridCampusShimmer());
            }
            return ValueListenableBuilder<bool>(
              valueListenable: _isGuestNotifier,
              builder: (context, isGuest, _) {
                return Scaffold(
                  drawerEnableOpenDragGesture: !isGuest,
                  key: _scaffoldKey,
                  appBar: AppBar(
                    backgroundColor: Colors.white,
                    elevation: 0,
                    automaticallyImplyLeading: false,
                    title: isGuest
                        ? Row(
                            spacing: 10,
                            children: [
                              Image.asset(
                                "assets/images/profile.png",
                                width: 48,
                                height: 48,
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: const [
                                  Text(
                                    'Hello!',
                                    style: TextStyle(
                                      color: Color(0xff666666),
                                      fontSize: 16,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                  Text(
                                    'Guest',
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          )
                        : Row(
                            children: [
                              IconButton(
                                icon: Icon(
                                  Icons.menu,
                                  color: Colors.black,
                                  size: 36,
                                ),
                                onPressed: () =>
                                    _scaffoldKey.currentState?.openDrawer(),
                              ),
                              BlocBuilder<
                                MenteeProfileCubit,
                                MenteeProfileState
                              >(
                                builder: (context, menteeProfilestate) {
                                  if (menteeProfilestate
                                      is MenteeProfileLoaded) {
                                    final menteeProfile = menteeProfilestate
                                        .menteeProfileModel
                                        .data;
                                    final coins =
                                        menteeProfile
                                            ?.user
                                            ?.availabilityCoins ??
                                        0;
                                    AuthService.saveCoins(coins);
                                    AuthService.saveRole(
                                      menteeProfile?.user?.role ?? "",
                                    );
                                    AuthService.saveCollegeID(
                                      menteeProfile?.user?.collegeId ?? 0,
                                    );
                                    AuthService.saveCollegeName(
                                      menteeProfile?.user?.college_name ?? "",
                                    );
                                    AppState.updateCoins(
                                      menteeProfile?.user?.availabilityCoins ??
                                          0,
                                    );
                                    return Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          'Hello!',
                                          style: TextStyle(
                                            color: Color(0xff666666),
                                            fontSize: 16,
                                            fontWeight: FontWeight.w700,
                                          ),
                                        ),
                                        SizedBox(
                                          width: SizeConfig.screenWidth * 0.3,
                                          child: Text(
                                            overflow: TextOverflow.ellipsis,
                                            capitalize(
                                              menteeProfile?.user?.name ??
                                                  "User",
                                            ),
                                            style: TextStyle(
                                              color: Colors.black,
                                              fontSize: 16,
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                        ),
                                      ],
                                    );
                                  }
                                  return SizedBox.shrink();
                                },
                              ),
                            ],
                          ),
                    actions: [
                      if (!isGuest)
                        IconButton(
                          style: IconButton.styleFrom(
                            padding: EdgeInsets.only(right: 0),
                          ),
                          onPressed: () {
                            context.push("/leaderboard");
                          },
                          icon: Image.asset(
                            "assets/icons/competition.png",
                            width: 30,
                            height: 30,
                            color: primarycolor,
                          ),
                        ),
                      if (isGuest)
                        Padding(
                          padding: const EdgeInsets.only(right: 16.0),
                          child: CustomAppButton1(
                            text: "Sign Up",
                            width: 105,
                            height: 35,
                            onPlusTap: () {
                              context.push('/auth_landing');
                            },
                          ),
                        ),
                      if (!isGuest) ...[
                        Padding(
                          padding: EdgeInsets.only(right: 8.0),
                          child: Row(
                            children: [
                              IconButton(
                                icon: Image.asset(
                                  "assets/images/crownonly.png",
                                  height: 21,
                                  width: 26,
                                ),
                                onPressed: () {
                                  context.push('/executiveservices');
                                },
                              ),
                              IconButton(
                                icon: Image.asset(
                                  "assets/icons/notifications.png",
                                  height: 21,
                                  width: 26,
                                ),
                                onPressed: () {
                                  context.push('/notifications');
                                },
                              ),
                            ],
                          ),
                        ),
                      ],
                    ],
                  ),
                  drawer: Drawer(
                    child: SafeArea(
                      child: Container(
                        color: const Color(0xFFF7F9FE),
                        child: ListView(
                          padding: EdgeInsets.zero,
                          children: [
                            Container(
                              padding: const EdgeInsets.all(16),
                              color: Colors.white,
                              child: Column(
                                children: [
                                  BlocBuilder<
                                    MenteeProfileCubit,
                                    MenteeProfileState
                                  >(
                                    builder: (context, state) {
                                      if (state is! MenteeProfileLoaded) {
                                        return SizedBox.shrink();
                                      }

                                      final user =
                                          state.menteeProfileModel.data?.user;
                                      final profileUrl =
                                          user?.profilePicUrl ?? "";
                                      final name = user?.name ?? "User";
                                      final initials = name.isNotEmpty
                                          ? name[0].toUpperCase()
                                          : "U";

                                      return GestureDetector(
                                        onTap: () {
                                          context.pop();
                                          context.push("/profile");
                                        },
                                        child: Row(
                                          children: [
                                            // PROFILE IMAGE
                                            profileUrl.isNotEmpty
                                                ? CachedNetworkImage(
                                                    imageUrl: profileUrl,
                                                    imageBuilder: (_, img) =>
                                                        CircleAvatar(
                                                          radius: 20,
                                                          backgroundImage: img,
                                                        ),
                                                    placeholder: (_, __) =>
                                                        CircleAvatar(
                                                          radius: 20,
                                                          backgroundColor:
                                                              Colors
                                                                  .grey
                                                                  .shade300,
                                                        ),
                                                    errorWidget: (_, __, ___) =>
                                                        CircleAvatar(
                                                          radius: 20,
                                                          backgroundImage:
                                                              AssetImage(
                                                                "assets/images/profile.png",
                                                              ),
                                                        ),
                                                  )
                                                : CircleAvatar(
                                                    radius: 20,
                                                    backgroundColor:
                                                        Colors.grey.shade300,
                                                    child: Text(
                                                      initials,
                                                      style: TextStyle(
                                                        fontSize: 16,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                      ),
                                                    ),
                                                  ),
                                            const SizedBox(width: 12),
                                            // NAME
                                            Expanded(
                                              child: Text(
                                                name,
                                                overflow: TextOverflow.ellipsis,
                                                maxLines: 1,
                                                style: TextStyle(
                                                  color: Colors.black,
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.w600,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      );
                                    },
                                  ),
                                  SizedBox(width: 16),
                                  _buildDrawerItem(
                                    assetpath: "assets/icons/Wallet.png",
                                    label: 'Wallet',
                                    trailing: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Image.asset(
                                          "assets/images/GoldCoins.png",
                                          height: 16,
                                          width: 16,
                                          color: Color(0xffFFCC00),
                                        ),
                                        const SizedBox(width: 4),
                                        FutureBuilder<String?>(
                                          future: AuthService.getCoins(),
                                          builder: (context, snapshot) {
                                            if (snapshot.connectionState ==
                                                ConnectionState.waiting) {
                                              return const Text(
                                                "Loading...",
                                                style: TextStyle(
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              );
                                            }
                                            final coins =
                                                int.tryParse(
                                                  snapshot.data ?? "0",
                                                ) ??
                                                0;
                                            return Text(
                                              '$coins',
                                              style: const TextStyle(
                                                fontSize: 14,
                                                color: Color(0xff333333),
                                                fontFamily: 'segeo',
                                                fontWeight: FontWeight.bold,
                                              ),
                                            );
                                          },
                                        ),
                                      ],
                                    ),
                                    onTap: () => _navigateToScreen('Wallet'),
                                  ),
                                  _buildDrawerItem(
                                    assetpath:
                                        "assets/icons/DownloadSimple.png",
                                    label: 'Downloads',
                                    onTap: () => _navigateToScreen('Downloads'),
                                  ),
                                  _buildDrawerItem(
                                    assetpath: "assets/icons/PencilRuler.png",
                                    label: 'Productivity Tools',
                                    onTap: () =>
                                        _navigateToScreen('Productivity Tools'),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(height: 20),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 10,
                              ),
                              color: Colors.white,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  _buildDrawerItem(
                                    assetpath:
                                        "assets/icons/VideoConference.png",
                                    label: 'Session Completed',
                                    onTap: () {
                                      context.pop();
                                      _navigateToScreen('Session Completed');
                                    },
                                  ),
                                  _buildDrawerItem(
                                    assetpath: "assets/icons/CalendarDots.png",
                                    label: 'Upcoming Sessions',
                                    onTap: () {
                                      context.pop();
                                      _navigateToScreen('Upcoming Sessions');
                                    },
                                  ),
                                  _buildDrawerItem(
                                    assetpath: "assets/icons/milestone.png",
                                    label: 'Milestones',
                                    onTap: () {
                                      context.pop();
                                      _navigateToScreen('Milestones');
                                    },
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(height: 20),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                vertical: 4,
                                horizontal: 16,
                              ),
                              color: Colors.white,
                              child: _buildDrawerItem(
                                assetpath: "assets/icons/crown.png",
                                label: 'Exclusive Services',
                                onTap: () =>
                                    _navigateToScreen('Executive services'),
                              ),
                            ),
                            BlocBuilder<MenteeProfileCubit, MenteeProfileState>(
                              builder: (context, state) {
                                if (state is! MenteeProfileLoaded)
                                  return SizedBox.shrink();

                                final user =
                                    state.menteeProfileModel.data?.user;
                                final status = (user?.mentorStatus ?? "none")
                                    .toLowerCase();
                                if (status == "approval") {
                                  return SizedBox.shrink();
                                }
                                return Container(
                                  padding: EdgeInsets.symmetric(
                                    vertical: 4,
                                    horizontal: 16,
                                  ),
                                  decoration: BoxDecoration(
                                    gradient: kCommonGradient.withOpacity(0.5),
                                  ),
                                  child: ListTile(
                                    leading: Image.asset(
                                      "assets/icons/mentor.png",
                                      width: 24,
                                      height: 24,
                                    ),
                                    title: Text(
                                      "Become Mentor",
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w500,
                                        color: Colors.white,
                                      ),
                                    ),
                                    onTap: () {
                                      context.pop();

                                      if (status == "none") {
                                        context.push('/becomementorscreen');
                                      } else if (status == "inreview") {
                                        context.push('/in_review');
                                      } else if (status == "rejected") {
                                        context.push('/profile_rejected');
                                      }
                                    },
                                  ),
                                );
                              },
                            ),
                            BlocBuilder<MenteeProfileCubit, MenteeProfileState>(
                              builder: (context, state) {
                                if (state is! MenteeProfileLoaded)
                                  return SizedBox.shrink();
                                final user =
                                    state.menteeProfileModel.data?.user;
                                final role = (user?.role ?? "").toLowerCase();
                                if (role != "both") return SizedBox.shrink();
                                return Container(
                                  height: 56,
                                  margin: EdgeInsets.symmetric(vertical: 10),
                                  padding: EdgeInsets.only(left: 5),
                                  decoration: BoxDecoration(
                                    color: Color(0xffFFF7CE),
                                  ),
                                  child: _DrawerItem(
                                    icon: Image.asset(
                                      "assets/icons/ArrowCircleleft.png",
                                      width: 50,
                                      height: 50,
                                    ),
                                    title:'Switch to Mentor',
                                    onTap: () {
                                      context.pop();
                                      context.pushReplacement(
                                        '/mentor_dashboard',
                                      );
                                    },
                                  ),
                                );
                              },
                            ),
                            SizedBox(height: 10),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                vertical: 4,
                                horizontal: 16,
                              ),
                              color: Colors.white,
                              child: Column(
                                children: [
                                  _buildDrawerItem(
                                    assetpath: "assets/icons/Info.png",
                                    label: 'User Guide',
                                    onTap: () => _navigateToScreen('info'),
                                  ),
                                  _buildDrawerItem(
                                    assetpath: "assets/icons/file.png",
                                    label: 'Terms And Conditions',
                                    onTap: () => _navigateToScreen('terms'),
                                  ),
                                  // _buildDrawerItem(
                                  //   assetpath: "assets/icons/UserCircleCheck.png",
                                  //   label: 'Invite Friend',
                                  //   onTap: () =>
                                  //       _navigateToScreen('Invite Friend'),
                                  // ),
                                  _buildDrawerItem(
                                    assetpath:
                                        "assets/icons/UserCircleGear.png",
                                    label: 'Customer Services',
                                    onTap: () =>
                                        _navigateToScreen('Customer Services'),
                                  ),
                                ],
                              ),
                            ),

                            const SizedBox(height: 18),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                vertical: 4,
                                horizontal: 16,
                              ),
                              color: Colors.white,
                              child: ListTile(
                                leading: Icon(Icons.logout, color: Colors.red),
                                title: const Text(
                                  'Logout',
                                  style: TextStyle(
                                    color: Colors.red,
                                    fontFamily: "Inter",
                                  ),
                                ),
                                onTap: () => _navigateToScreen('Logout'),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  body: SafeArea(
                    child: SingleChildScrollView(
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(16.0, 10, 16, 0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            BlocBuilder<Getbannerscubit, Getbannersstate>(
                              builder: (context, state) {
                                if (state is GetbannersStateLoaded) {
                                  final banners =
                                      state.getbannerModel.data ?? [];
                                  return LayoutBuilder(
                                    builder: (context, constraints) {
                                      final size = MediaQuery.of(context).size;
                                      final aspectRatio =
                                          size.width / size.height;

                                      // ✅ Simple tablet detection (you can tweak this logic as needed)
                                      final isTablet = size.shortestSide >= 600;

                                      final carouselHeight = isTablet
                                          ? size.height * 0.3
                                          : size.height * 0.25;

                                      return Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          CarouselSlider.builder(
                                            itemCount: banners.length,
                                            itemBuilder: (ctx, i, _) {
                                              final b = banners[i];
                                              return GestureDetector(
                                                onTap: () {
                                                  if (b.link != null)
                                                    _launchUrl(b.link!);
                                                },
                                                child: Padding(
                                                  padding:
                                                      const EdgeInsets.symmetric(
                                                        horizontal: 2.5,
                                                      ),
                                                  child: ClipRRect(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                          16,
                                                        ),
                                                    child: CachedNetworkImage(
                                                      imageUrl: b.imgUrl ?? '',
                                                      fit: BoxFit.cover,
                                                      width: double.infinity,
                                                      placeholder:
                                                          (
                                                            context,
                                                            url,
                                                          ) => Container(
                                                            color: Colors
                                                                .grey[200],
                                                            child: const Center(
                                                              child:
                                                                  CircularProgressIndicator(
                                                                    strokeWidth:
                                                                        2,
                                                                  ),
                                                            ),
                                                          ),
                                                      errorWidget:
                                                          (
                                                            context,
                                                            url,
                                                            error,
                                                          ) => Container(
                                                            color: Colors
                                                                .grey[200],
                                                            alignment: Alignment
                                                                .center,
                                                            child: const Icon(
                                                              Icons
                                                                  .broken_image,
                                                              color:
                                                                  Colors.grey,
                                                            ),
                                                          ),
                                                    ),
                                                  ),
                                                ),
                                              );
                                            },
                                            options: CarouselOptions(
                                              height:
                                                  carouselHeight, // 👈 dynamic based on device type
                                              autoPlay: true,
                                              autoPlayInterval: const Duration(
                                                seconds: 4,
                                              ),
                                              viewportFraction: 1.0,
                                              onPageChanged: (index, reason) {
                                                _currentIndex.value = index;
                                              },
                                            ),
                                          ),
                                          const SizedBox(height: 8),
                                          ValueListenableBuilder<int>(
                                            valueListenable: _currentIndex,
                                            builder: (context, currentIndex, _) {
                                              return Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: List.generate(
                                                  banners.length ?? 0,
                                                  (index) {
                                                    return AnimatedContainer(
                                                      duration: const Duration(
                                                        milliseconds: 300,
                                                      ),
                                                      margin:
                                                          const EdgeInsets.symmetric(
                                                            horizontal: 3,
                                                          ),
                                                      height:
                                                          SizeConfig
                                                              .screenHeight *
                                                          0.008,
                                                      width:
                                                          currentIndex == index
                                                          ? SizeConfig
                                                                    .screenWidth *
                                                                0.05
                                                          : SizeConfig
                                                                    .screenWidth *
                                                                0.014,
                                                      decoration: BoxDecoration(
                                                        color:
                                                            currentIndex ==
                                                                index
                                                            ? primarycolor
                                                            : Colors
                                                                  .grey
                                                                  .shade400,
                                                        borderRadius:
                                                            BorderRadius.circular(
                                                              100,
                                                            ),
                                                      ),
                                                    );
                                                  },
                                                ),
                                              );
                                            },
                                          ),
                                        ],
                                      );
                                    },
                                  );
                                } else {
                                  return SizedBox.shrink();
                                }
                              },
                            ),
                            !isGuest
                                ? Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      const SizedBox(height: 15),
                                      Container(
                                        decoration: BoxDecoration(
                                          color: const Color(0xFFE8EBF7),
                                          borderRadius: BorderRadius.circular(
                                            30,
                                          ),
                                        ),
                                        padding: const EdgeInsets.all(4),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Expanded(
                                              child: ValueListenableBuilder<String>(
                                                valueListenable:
                                                    _selectedFilterNotifier,
                                                builder: (context, selectedFilter, _) {
                                                  return FilterButton(
                                                    text: 'On Campus',
                                                    isSelected:
                                                        selectedFilter ==
                                                        'On Campus',
                                                    onPressed: () {
                                                      _selectedFilterNotifier
                                                              .value =
                                                          'On Campus';
                                                      _onCampusNotifier.value =
                                                          true;
                                                      context
                                                          .read<
                                                            CampusMentorListCubit
                                                          >()
                                                          .fetchCampusMentorList(
                                                            "",
                                                            "",
                                                          );
                                                    },
                                                  );
                                                },
                                              ),
                                            ),
                                            Expanded(
                                              child: ValueListenableBuilder<String>(
                                                valueListenable:
                                                    _selectedFilterNotifier,
                                                builder: (context, selectedFilter, _) {
                                                  return FilterButton(
                                                    text: 'Beyond Campus',
                                                    isSelected:
                                                        selectedFilter ==
                                                        'Beyond Campus',
                                                    onPressed: () {
                                                      _selectedFilterNotifier
                                                              .value =
                                                          'Beyond Campus';
                                                      _onCampusNotifier.value =
                                                          false;
                                                      context
                                                          .read<
                                                            CampusMentorListCubit
                                                          >()
                                                          .fetchCampusMentorList(
                                                            "beyond",
                                                            "",
                                                          );
                                                    },
                                                  );
                                                },
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  )
                                : SizedBox.shrink(),
                            SizedBox(height: 10),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'Top Mentors',
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w600,
                                    fontFamily: "Inter",
                                    color: Color(0xff222222),
                                  ),
                                ),
                                if (!isGuest) ...[
                                  ValueListenableBuilder(
                                    valueListenable: _onCampusNotifier,
                                    builder: (context, isCampus, _) {
                                      return TextButton(
                                        style: TextButton.styleFrom(
                                          visualDensity: VisualDensity.compact,
                                          padding: EdgeInsets.zero,
                                        ),
                                        onPressed: () {
                                          context.push(
                                            isCampus
                                                ? '/campus_mentor_list?scope='
                                                : '/campus_mentor_list?scope=beyond',
                                          );
                                        },
                                        child: Text(
                                          'View All',
                                          style: TextStyle(
                                            color: Color(0xff4076ED),
                                            fontFamily: 'segeo',
                                            fontWeight: FontWeight.w600,
                                            fontStyle: FontStyle.normal,
                                            fontSize: 14,
                                            decoration:
                                                TextDecoration.underline,
                                            decorationStyle:
                                                TextDecorationStyle.solid,
                                            decorationColor: Color(0xff4076ED),
                                            decorationThickness: 1,
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                                ],
                              ],
                            ),
                            SizedBox(height: 10),
                            if (isGuest) ...[
                              BlocBuilder<GuestMentorsCubit, GuestMentorsState>(
                                builder: (context, state) {
                                  if (state is GuestMentorsLoading) {
                                    int crossAxisCount;
                                    if (SizeConfig.screenWidth >= 1000) {
                                      crossAxisCount = 4; // Desktop
                                    } else if (SizeConfig.screenWidth >= 700) {
                                      crossAxisCount = 3; // Tablet
                                    } else {
                                      crossAxisCount = 2; // Mobile
                                    }

                                    final spacing = SizeConfig.width(3);
                                    final itemWidth =
                                        (SizeConfig.screenWidth -
                                            ((crossAxisCount + 1) * spacing)) /
                                        crossAxisCount;
                                    final itemHeight =
                                        itemWidth *
                                        (SizeConfig.screenWidth < 600
                                            ? 1.04 // mobile
                                            : SizeConfig.screenWidth < 1024
                                            ? 0.95 // tablet
                                            : 0.85); // desktop
                                    final aspectRatio = itemWidth / itemHeight;
                                    return GridView.builder(
                                      shrinkWrap: true,
                                      physics:
                                          const NeverScrollableScrollPhysics(),
                                      itemCount: 6,
                                      gridDelegate:
                                          SliverGridDelegateWithFixedCrossAxisCount(
                                            crossAxisCount: crossAxisCount,
                                            crossAxisSpacing: spacing,
                                            mainAxisSpacing: spacing,
                                            childAspectRatio: aspectRatio,
                                          ),
                                      itemBuilder: (context, index) {
                                        return Container(
                                          padding: const EdgeInsets.all(8),
                                          decoration: BoxDecoration(
                                            color: Colors.white,
                                            borderRadius: BorderRadius.circular(
                                              12,
                                            ),
                                            boxShadow: [
                                              BoxShadow(
                                                color: Colors.black.withOpacity(
                                                  0.05,
                                                ),
                                                blurRadius: 4,
                                                offset: const Offset(2, 2),
                                              ),
                                            ],
                                          ),
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              shimmerCircle(
                                                itemWidth * 0.4,
                                                context,
                                              ),
                                              const SizedBox(height: 12),
                                              shimmerText(
                                                itemWidth * 0.6,
                                                14,
                                                context,
                                              ), // name
                                              const SizedBox(height: 8),
                                              shimmerText(
                                                itemWidth * 0.4,
                                                12,
                                                context,
                                              ), // bio
                                              const SizedBox(height: 8),
                                              shimmerText(
                                                itemWidth * 0.5,
                                                12,
                                                context,
                                              ), // college name
                                              const SizedBox(height: 12),
                                            ],
                                          ),
                                        );
                                      },
                                    );
                                  }
                                  if (state is GuestMentorsLoaded) {
                                    final guestMentorlist =
                                        state.guestMentorsModel.data?.mentors ??
                                        [];
                                    if (guestMentorlist.isEmpty) {
                                      return Center(
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Image.asset(
                                              "assets/nodata/nodata_mentor_list.png",
                                              width: 200,
                                              height: 200,
                                            ),
                                          ],
                                        ),
                                      );
                                    }
                                    return MentorGridGuest(
                                      mentors: guestMentorlist,
                                      onTapMentor: (m) =>
                                          context.push('/auth_landing'),
                                    );
                                  } else {
                                    return SizedBox.shrink();
                                  }
                                },
                              ),
                            ],
                            if (!isGuest) ...[
                              BlocBuilder<
                                CampusMentorListCubit,
                                CampusMentorListState
                              >(
                                builder: (context, state) {
                                  if (state is CampusMentorListStateLoading) {
                                    int crossAxisCount;
                                    if (SizeConfig.screenWidth >= 1000) {
                                      crossAxisCount = 4; // Desktop
                                    } else if (SizeConfig.screenWidth >= 700) {
                                      crossAxisCount = 3; // Tablet
                                    } else {
                                      crossAxisCount = 2; // Mobile
                                    }

                                    final spacing = SizeConfig.width(3);
                                    final itemWidth =
                                        (SizeConfig.screenWidth -
                                            ((crossAxisCount + 1) * spacing)) /
                                        crossAxisCount;
                                    final itemHeight =
                                        itemWidth *
                                        (SizeConfig.screenWidth < 600
                                            ? 1.04 // mobile
                                            : SizeConfig.screenWidth < 1024
                                            ? 0.95 // tablet
                                            : 0.85); // desktop

                                    return MasonryGridView.count(
                                      crossAxisCount: _getCrossAxisCount(
                                        context,
                                      ),
                                      mainAxisSpacing: 16,
                                      crossAxisSpacing: 16,
                                      physics:
                                          const AlwaysScrollableScrollPhysics(),
                                      shrinkWrap: true,
                                      itemCount: 10,
                                      itemBuilder: (ctx, i) {
                                        return Container(
                                          padding: const EdgeInsets.all(8),
                                          decoration: BoxDecoration(
                                            color: Colors.white,
                                            borderRadius: BorderRadius.circular(
                                              12,
                                            ),
                                            boxShadow: [
                                              BoxShadow(
                                                color: Colors.black.withOpacity(
                                                  0.05,
                                                ),
                                                blurRadius: 4,
                                                offset: const Offset(2, 2),
                                              ),
                                            ],
                                          ),
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              shimmerCircle(
                                                itemWidth * 0.4,
                                                context,
                                              ),
                                              const SizedBox(height: 12),
                                              shimmerText(
                                                itemWidth * 0.6,
                                                14,
                                                context,
                                              ), // name
                                              const SizedBox(height: 8),
                                              shimmerText(
                                                itemWidth * 0.4,
                                                12,
                                                context,
                                              ), // bio
                                              const SizedBox(height: 8),
                                              shimmerText(
                                                itemWidth * 0.5,
                                                12,
                                                context,
                                              ), // college name
                                              const SizedBox(height: 12),
                                            ],
                                          ),
                                        );
                                      },
                                    );
                                  }
                                  if (state is CampusMentorListStateLoaded) {
                                    final campusMentorlist =
                                        state
                                            .campusMentorListModel
                                            .data
                                            ?.mentors_list ??
                                        [];

                                    if (campusMentorlist.isEmpty) {
                                      return Center(
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Image.asset(
                                              "assets/nodata/no_data.png",
                                              width: 220,
                                              height: 220,
                                            ),
                                            BlocBuilder<
                                              MenteeProfileCubit,
                                              MenteeProfileState
                                            >(
                                              builder: (context, state) {
                                                if (state
                                                    is! MenteeProfileLoaded)
                                                  return SizedBox.shrink();
                                                final user = state
                                                    .menteeProfileModel
                                                    .data
                                                    ?.user;
                                                final role = (user?.role ?? "")
                                                    .trim()
                                                    .toLowerCase();
                                                return ValueListenableBuilder<
                                                  bool
                                                >(
                                                  valueListenable:
                                                      _onCampusNotifier,
                                                  builder: (context, isOnCampus, _) {
                                                    String message;
                                                    Widget? actionButton;
                                                    if (isOnCampus) {
                                                      if (role == "both") {
                                                        message =
                                                            "No mentors in your campus yet";
                                                        actionButton = null;
                                                      } else {
                                                        message =
                                                            "Be the first mentor in your campus!";
                                                        actionButton = Padding(
                                                          padding:
                                                              const EdgeInsets.only(
                                                                top: 16,
                                                              ),
                                                          child: OutlinedButton.icon(
                                                            onPressed: () =>
                                                                context.push(
                                                                  '/becomementorscreen',
                                                                ),
                                                            label: const Text(
                                                              "Become a Mentor",
                                                              style: TextStyle(
                                                                fontFamily:
                                                                    'segeo',
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w600,
                                                                fontSize: 16,
                                                                color: Color(
                                                                  0xff4A7CF6,
                                                                ),
                                                              ),
                                                            ),
                                                            style: OutlinedButton.styleFrom(
                                                              backgroundColor:
                                                                  const Color(
                                                                    0xFFF5F8FF,
                                                                  ),
                                                              side: const BorderSide(
                                                                color: Color(
                                                                  0xff4A7CF6,
                                                                ),
                                                              ),
                                                              shape: RoundedRectangleBorder(
                                                                borderRadius:
                                                                    BorderRadius.circular(
                                                                      30,
                                                                    ),
                                                              ),
                                                              padding:
                                                                  const EdgeInsets.symmetric(
                                                                    horizontal:
                                                                        28,
                                                                    vertical:
                                                                        10,
                                                                  ),
                                                            ),
                                                          ),
                                                        );
                                                      }
                                                    } else {
                                                      // BEYOND CAMPUS
                                                      message =
                                                          "No mentors found beyond campus";
                                                      actionButton = null;
                                                    }
                                                    return Column(
                                                      children: [
                                                        Text(
                                                          message,
                                                          textAlign:
                                                              TextAlign.center,
                                                          style:
                                                              const TextStyle(
                                                                fontFamily:
                                                                    'segeo',
                                                                fontSize: 16,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w400,
                                                                color: Color(
                                                                  0xff333333,
                                                                ),
                                                              ),
                                                        ),
                                                        if (actionButton !=
                                                            null)
                                                          actionButton,
                                                      ],
                                                    );
                                                  },
                                                );
                                              },
                                            ),
                                          ],
                                        ),
                                      );
                                    }
                                    return MentorGridCampus(
                                      mentors_list: campusMentorlist,
                                      onTapMentor: (m) => context.push(
                                        '/mentor_profile?id=${m.userId}',
                                      ),
                                    );
                                  } else {
                                    return SizedBox.shrink();
                                  }
                                },
                              ),
                            ],
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              },
            );
          },
        );
      },
    );
  }

  int _getCrossAxisCount(BuildContext context) {
    final width = MediaQuery.of(context).size.width;

    if (width < 600) {
      return 2; // 📱 Mobile: 2 columns
    } else if (width > 600) {
      return 3; // 💻 Tablet/Desktop: 3 columns
    } else {
      return 4;
    }
  }

  void showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          elevation: 4.0,
          insetPadding: const EdgeInsets.symmetric(horizontal: 14.0),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16.0),
          ),
          child: SizedBox(
            width: 300.0,
            height: 230.0,
            child: Stack(
              clipBehavior: Clip.none,
              children: [
                // Power Icon Positioned Above Dialog
                Positioned(
                  top: -35.0,
                  left: 0.0,
                  right: 0.0,
                  child: Container(
                    width: 70.0,
                    height: 70.0,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      border: Border.all(width: 6.0, color: Colors.white),
                      shape: BoxShape.circle,
                      color: Colors.red.shade100, // Light red background
                    ),
                    child: const Icon(
                      Icons.power_settings_new,
                      size: 40.0,
                      color: Colors.red, // Power icon color
                    ),
                  ),
                ),
                Positioned.fill(
                  top: 30.0, // Moves content down
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 14.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const SizedBox(height: 15.0),
                        Text(
                          "Logout",
                          style: TextStyle(
                            fontSize: 24.0,
                            fontWeight: FontWeight.w700,
                            color: primarycolor,
                            fontFamily: "roboto_serif",
                          ),
                        ),
                        const SizedBox(height: 10.0),
                        const Text(
                          "Are you sure you want to logout?",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 16.0,
                            color: Colors.black54,
                            fontFamily: "roboto_serif",
                          ),
                        ),
                        const SizedBox(height: 20.0),

                        // Buttons Row
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            // No Button (Filled)
                            SizedBox(
                              width: 100,
                              child: ElevatedButton(
                                onPressed: () => Navigator.pop(context),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor:
                                      primarycolor, // Filled button color
                                  foregroundColor: Colors.white, // Text color
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 20,
                                    vertical: 10,
                                  ),
                                ),
                                child: const Text(
                                  "No",
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontFamily: "roboto_serif",
                                  ),
                                ),
                              ),
                            ),

                            // Yes Button (Outlined)
                            SizedBox(
                              width: 100,
                              child: OutlinedButton(
                                onPressed: () async {
                                  await AuthService.logout();
                                  context.go("/login");
                                },
                                style: OutlinedButton.styleFrom(
                                  foregroundColor: primarycolor, // Text color
                                  side: BorderSide(
                                    color: primarycolor,
                                  ), // Border color
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 20,
                                    vertical: 10,
                                  ),
                                ),
                                child: const Text(
                                  "Yes",
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontFamily: "roboto_serif",
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildDrawerItem({
    required String assetpath,
    required String label,
    Widget? trailing,
    GestureTapCallback? onTap,
  }) => ListTile(
    contentPadding: EdgeInsets.all(0),
    visualDensity: VisualDensity.compact,
    leading: Image.asset(assetpath, width: 24, height: 24),
    title: Text(
      label,
      style: const TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w500,
        color: Color(0xff444444),
      ),
    ),
    trailing: trailing,
    onTap: onTap,
  );
}

class _DrawerItem extends StatelessWidget {
  final Widget icon;
  final String title;
  final VoidCallback? onTap;

  const _DrawerItem({required this.icon, required this.title, this.onTap});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        child: Row(
          children: [
            icon,
            Expanded(
              child: Text(
                title,
                style: TextStyle(
                  fontFamily: 'segeo',
                  fontSize: 15,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
