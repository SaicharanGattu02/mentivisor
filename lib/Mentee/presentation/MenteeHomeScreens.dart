import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:mentivisor/Components/CustomAppButton.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../services/AuthService.dart';
import '../../utils/color_constants.dart';
import '../../utils/constants.dart';
import '../../utils/spinkittsLoader.dart';
import '../data/cubits/CampusMentorList/campus_mentor_list_cubit.dart';
import '../data/cubits/GetBanners/GetBannersCubit.dart';
import '../data/cubits/GetBanners/GetBannersState.dart';
import '../data/cubits/MenteeDashBoard/mentee_dashboard_cubit.dart';
import '../data/cubits/MenteeDashBoard/mentee_dashboard_state.dart';
import 'Widgets/FilterButton.dart';
import 'Widgets/MentorGridGuest.dart';

class MenteeHomeScreen extends StatefulWidget {
  const MenteeHomeScreen({Key? key}) : super(key: key);

  @override
  _MenteeHomeScreenState createState() => _MenteeHomeScreenState();
}

class _MenteeHomeScreenState extends State<MenteeHomeScreen> {
  ValueNotifier<String> _mentorStatus = ValueNotifier<String>("none");
  ValueNotifier<String?> _mentorProfileUrl = ValueNotifier<String?>("");
  ValueNotifier<String?> _mentorProfileName = ValueNotifier<String?>("");
  ValueNotifier<int?> _availableCoins = ValueNotifier<int?>(0);

  final _scaffoldKey = GlobalKey<ScaffoldState>();
  bool _onCampus = true;
  String selectedFilter = 'On Campus';

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<MenteeDashboardCubit>().fetchDashboard();
    });
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
      // case 'Invite Friend':
      //   break;
      case 'Customer Services':
        context.push('/customersscreen');
        break;
      case 'Executive services':
        context.push('/executiveservices');
        break;
      case 'info':
        context.push('/info');
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
        return BlocBuilder<MenteeDashboardCubit, MenteeDashboardState>(
          builder: (context, state) {
            if (state is MenteeDashboardLoading) {
              return Scaffold(
                body: Center(
                  child: CircularProgressIndicator(color: primarycolor),
                ),
              );
            } else if (state is MenteeDashboardLoaded) {
              final menteeProfile = state.menteeProfileModel.data;
              final banners = state.getbannerModel.data ?? [];
              final guestMentorlist =
                  state.guestMentorsModel.data?.mentors ?? [];
              final campusMentorlist =
                  state.campusMentorListModel.data?.mentors_list ?? [];
              _mentorStatus.value = menteeProfile?.user?.mentorStatus ?? "none";
              _mentorProfileUrl.value =
                  menteeProfile?.user?.profilePicUrl ?? "";
              _mentorProfileName.value = menteeProfile?.user?.name ?? "";
              _availableCoins.value =
                  menteeProfile?.user?.availabilityCoins ?? 0;
              return Scaffold(
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
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Hello!',
                                  style: TextStyle(
                                    color: Color(0xff666666),
                                    fontSize: 16,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                                Text(
                                  capitalize(
                                    menteeProfile?.user?.name ?? "User",
                                  ),
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                  actions: [
                    isGuest
                        ? Padding(
                            padding: const EdgeInsets.only(right: 16.0),
                            child: CustomAppButton1(
                              text: "Sign Up",
                              width: 105,
                              height: 35,
                              onPlusTap: () {
                                context.push('/auth_landing');
                              },
                            ),
                          )
                        :Padding(
                          padding: const EdgeInsets.only(right: 40),
                          child: IconButton(
                                                icon: Image.asset(
                          "images/crownonly.png",
                          height: 21,
                          width: 26,
                                                ),
                                                onPressed: () {
                          context.push('/mentor_dashboard');
                                                },
                                              ),
                        ),
                    // IconButton(
                    //   icon: const Icon(
                    //     Icons.notifications_outlined,
                    //     color: Colors.black,
                    //   ),
                    //   onPressed: () =>
                    //       ScaffoldMessenger.of(context).showSnackBar(
                    //         const SnackBar(
                    //           content: Text('Notifications clicked'),
                    //         ),
                    //       ),
                    // ),
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
                                GestureDetector(
                                  onTap: () {
                                    context.pop();
                                    context.push("/profile");
                                  },
                                  child: Row(
                                    children: [
                                      ValueListenableBuilder<String?>(
                                        valueListenable: _mentorProfileUrl,
                                        builder: (context, url, _) {
                                          return CachedNetworkImage(
                                            imageUrl:
                                                url ?? "", // listen for updates
                                            imageBuilder:
                                                (context, imageProvider) =>
                                                    CircleAvatar(
                                                      radius: 20,
                                                      backgroundImage:
                                                          imageProvider,
                                                    ),
                                            placeholder: (context, url) =>
                                                CircleAvatar(
                                                  radius: 20,
                                                  backgroundColor: Colors.grey,
                                                  child: SizedBox(
                                                    width: 16,
                                                    height: 16,
                                                    child: Center(
                                                      child: spinkits
                                                          .getSpinningLinespinkit(),
                                                    ),
                                                  ),
                                                ),
                                            errorWidget:
                                                (
                                                  context,
                                                  url,
                                                  error,
                                                ) => const CircleAvatar(
                                                  radius: 20,
                                                  backgroundImage: AssetImage(
                                                    "assets/images/profile.png",
                                                  ),
                                                ),
                                          );
                                        },
                                      ),
                                      const SizedBox(width: 12),
                                      ValueListenableBuilder<String?>(
                                        valueListenable: _mentorProfileName,
                                        builder: (context, name, _) {
                                          return Text(
                                            capitalize(name ?? 'Profile'),

                                            style: const TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.w400,
                                              color: Color(0xff4B5462),
                                              fontFamily: "segeo",
                                            ),
                                          );
                                        },
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(height: 8),
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
                                      ValueListenableBuilder<int?>(
                                        valueListenable: _availableCoins,
                                        builder: (context, value, child) {
                                          return Text(
                                            '${value ?? 0}',
                                            style: TextStyle(
                                              fontSize: 14,
                                              color: Color(0xff121212),
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
                                  assetpath: "assets/icons/DownloadSimple.png",
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
                                  assetpath: "assets/icons/VideoConference.png",
                                  label: 'Session Completed',
                                  onTap: () =>
                                      _navigateToScreen('Session Completed'),
                                ),
                                _buildDrawerItem(
                                  assetpath: "assets/icons/CalendarDots.png",
                                  label: 'Upcoming Sessions',
                                  onTap: () =>
                                      _navigateToScreen('Upcoming Sessions'),
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
                          ValueListenableBuilder<String>(
                            valueListenable: _mentorStatus,
                            builder: (context, status, _) {
                              if (status != "approval") {
                                return Container(
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 4,
                                    horizontal: 16,
                                  ),
                                  decoration: BoxDecoration(
                                    gradient: kCommonGradient,
                                  ),
                                  child: ListTile(
                                    contentPadding: EdgeInsets.zero,
                                    visualDensity: VisualDensity.compact,
                                    leading: Image.asset(
                                      "assets/icons/mentor.png",
                                      width: 24,
                                      height: 24,
                                    ),
                                    title: const Text(
                                      "Become Mentor",
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w500,
                                        color: Colors.white,
                                      ),
                                    ),
                                    onTap: () {
                                      if (status == "") {
                                        context.push('/becomementorscreen');
                                      } else if (status == "inreview") {
                                        context.push('/in_review');
                                      } else if (status == "rejected") {
                                        context.push('/profile_rejected');
                                      }
                                    },
                                  ),
                                );
                              }
                              return const SizedBox.shrink();
                            },
                          ),

                          SizedBox(height: 20),
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
                                  label: 'Info',
                                  onTap: () => _navigateToScreen('info'),
                                ),
                                _buildDrawerItem(
                                  assetpath: "assets/icons/UserCircleCheck.png",
                                  label: 'Invite Friend',
                                  onTap: () =>
                                      _navigateToScreen('Invite Friend'),
                                ),
                                _buildDrawerItem(
                                  assetpath: "assets/icons/UserCircleGear.png",
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
                              leading: const Icon(
                                Icons.exit_to_app,
                                color: Colors.red,
                              ),
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
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        BlocBuilder<Getbannerscubit, Getbannersstate>(
                          builder: (context, state) {
                            if (banners.isEmpty) {
                              return Container(
                                height: 160,
                                alignment: Alignment.center,
                                child: Column(
                                  children: [
                                    Center(
                                      child: Image.asset(
                                        "assets/nodata/no_data.png",
                                      ),
                                    ),
                                    const Text(
                                      "No banners available",
                                      style: TextStyle(
                                        color: Colors.grey,
                                        fontSize: 16,
                                        fontWeight: FontWeight.w500,
                                        fontFamily: 'segeo',
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            }
                            return CarouselSlider.builder(
                              itemCount: banners.length,
                              itemBuilder: (ctx, i, _) {
                                final b = banners[i];
                                return GestureDetector(
                                  onTap: () {
                                    if (b.link != null) _launchUrl(b.link!);
                                  },
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(16),
                                    child: Image.network(
                                      b.imgUrl ?? '',
                                      fit: BoxFit.cover,
                                      width: double.infinity,
                                      errorBuilder: (_, __, ___) => Container(
                                        color: Colors.grey[200],
                                        alignment: Alignment.center,
                                        child: const Icon(
                                          Icons.broken_image,
                                          color: Colors.grey,
                                        ),
                                      ),
                                    ),
                                  ),
                                );
                              },
                              options: CarouselOptions(
                                height: 180,
                                autoPlay: true,
                                autoPlayInterval: const Duration(seconds: 4),
                                viewportFraction: 1.0,
                              ),
                            );
                          },
                        ),
                        !isGuest
                            ? Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const SizedBox(height: 24),
                                  Container(
                                    decoration: BoxDecoration(
                                      color: const Color(0xFFE8EBF7),
                                      borderRadius: BorderRadius.circular(30),
                                    ),
                                    padding: const EdgeInsets.all(4),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Expanded(
                                          child: FilterButton(
                                            text: 'On Campus',
                                            isSelected:
                                                selectedFilter == 'On Campus',
                                            onPressed: () {
                                              context
                                                  .read<CampusMentorListCubit>()
                                                  .fetchCampusMentorList(
                                                    "",
                                                    "",
                                                  );
                                              setState(() {
                                                selectedFilter = 'On Campus';
                                                _onCampus = true; // ✅ FIX
                                                context
                                                    .read<
                                                      MenteeDashboardCubit
                                                    >()
                                                    .fetchDashboard();
                                              });
                                            },
                                          ),
                                        ),
                                        Expanded(
                                          child: FilterButton(
                                            text: 'Beyond Campus',
                                            isSelected:
                                                selectedFilter ==
                                                'Beyond Campus',
                                            onPressed: () {
                                              context
                                                  .read<CampusMentorListCubit>()
                                                  .fetchCampusMentorList(
                                                    "beyond",
                                                    "",
                                                  );
                                              setState(() {
                                                selectedFilter =
                                                    'Beyond Campus';
                                                _onCampus = false;
                                                context
                                                    .read<
                                                      MenteeDashboardCubit
                                                    >()
                                                    .fetchDashboard();
                                              });
                                            },
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              )
                            : SizedBox.shrink(),
                        const SizedBox(height: 24),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              'Mentors',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w400,
                                fontFamily: "Inter",
                              ),
                            ),
                            TextButton(
                              onPressed: () {
                                if (_onCampus == true) {
                                  context.push('/campus_mentor_list?scope=');
                                } else {
                                  context.push(
                                    '/campus_mentor_list?scope=beyond',
                                  );
                                }
                              },
                              child: Text(
                                'View All',
                                style: TextStyle(color: Color(0xff4076ED)),
                              ),
                            ),
                          ],
                        ),
                        if (isGuest) ...[
                          guestMentorlist.isEmpty
                              ? SizedBox(
                                  height: 200,
                                  width: 200,
                                  child: Center(
                                    child: Image.asset(
                                      "assets/nodata/nodata_mentor_list.png",
                                    ),
                                  ),
                                )
                              : MentorGridGuest(
                                  mentors: guestMentorlist,
                                  onTapMentor: (m) =>
                                      context.push('/auth_landing'),
                                ),
                        ],

                        if (!isGuest) ...[
                          campusMentorlist.isEmpty
                              ? SizedBox(
                                  height: 200,
                                  width: 200,
                                  child: Center(
                                    child: Image.asset(
                                      "assets/nodata/nodata_mentor_list.png",
                                    ),
                                  ),
                                )
                              : MentorGridCampus(
                                  mentors_list: campusMentorlist,
                                  onTapMentor: (m) => context.push(
                                    '/mentor_profile?id=${m.userId}',
                                  ),
                                ),
                        ],
                      ],
                    ),
                  ),
                ),
              );
            } else if (state is MenteeDashboardFailure) {
              return Center(child: Text(state.message));
            }
            return Center(child: Text("No Data"));
          },
        );
      },
    );
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
