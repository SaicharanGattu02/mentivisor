import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:mentivisor/Components/CustomAppButton.dart';
import 'package:mentivisor/utils/AppLogger.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../services/AuthService.dart';
import '../../utils/color_constants.dart';
import '../data/cubits/CampusMentorList/campus_mentor_list_cubit.dart';
import '../data/cubits/CampusMentorList/campus_mentor_list_state.dart';
import '../data/cubits/GetBanners/GetBannersCubit.dart';
import '../data/cubits/GetBanners/GetBannersState.dart';
import 'Widgets/FilterButton.dart';

class MenteeHomeScreen extends StatefulWidget {
  const MenteeHomeScreen({Key? key}) : super(key: key);

  @override
  _MenteeHomeScreenState createState() => _MenteeHomeScreenState();
}

class _MenteeHomeScreenState extends State<MenteeHomeScreen> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  bool _onCampus = true;
  String selectedFilter = 'On Campuses';
  @override
  void initState() {
    super.initState();
    context.read<CampusMentorListCubit>().fetchCampusMentorList("", "");
    context.read<Getbannerscubit>().getbanners();
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
      case 'Invite Friend':
        break;
      case 'Customer Services':
        context.push('/customersscreen');
        break;

      case 'BecomeMentor':
        context.push('/becomementorscreen');
        break;

      case 'Executive services':
        context.push('/executiveservices');
        break;

      case 'info':
        context.push('/infoscreen');
        break;

      case 'Logout':
        showLogoutDialog(context);
        break;
      case 'View All':
        if (_onCampus == true) {
          context.push('/campus_mentor_list?scope=${""}');
        } else {
          context.push('/campus_mentor_list?scope=${"beyond"}');
        }
        break;
    }
  }

  Future<void> _launchUrl(String url) async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
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

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: AuthService.isGuest,
      builder: (context, snapshot) {
        final isGuest = snapshot.data ?? false;
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
                        icon: const Icon(
                          Icons.menu,
                          color: Colors.black,
                          size: 36,
                        ),
                        onPressed: () =>
                            _scaffoldKey.currentState?.openDrawer(),
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
                  ),

            actions: [
              isGuest
                  ? Padding(
                      padding: const EdgeInsets.only(right: 16.0),
                      child: CustomAppButton1(
                        text: "Sign Up",
                        width: 100,
                        height: 35,
                        onPlusTap: () {
                          context.push('/auth_landing');
                        },
                      ),
                    )
                  : IconButton(
                      icon: const Icon(
                        Icons.notifications_outlined,
                        color: Colors.black,
                      ),
                      onPressed: () =>
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Notifications clicked'),
                            ),
                          ),
                    ),
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
                          Row(
                            children: [
                              const CircleAvatar(
                                radius: 20,
                                backgroundImage: AssetImage(
                                  'assets/images/profileimg.png',
                                ),
                              ),
                              const SizedBox(width: 12),
                              const Text(
                                'Profile',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.black,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          _buildDrawerItem(
                            assetpath: "assets/icons/Wallet.png",
                            label: 'Wallet',
                            trailing: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Image.asset(
                                  "assets/images/coinsgold.png",
                                  height: 16,
                                  width: 16,
                                ),
                                const SizedBox(width: 4),
                                const Text(
                                  '120',
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.orange,
                                    fontWeight: FontWeight.bold,
                                  ),
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
                            onTap: () => _navigateToScreen('Session Completed'),
                          ),
                          _buildDrawerItem(
                            assetpath: "assets/icons/CalendarDots.png",
                            label: 'Upcoming Sessions',
                            onTap: () => _navigateToScreen('Upcoming Sessions'),
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
                        onTap: () => _navigateToScreen('Executive services'),
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.symmetric(
                        vertical: 4,
                        horizontal: 16,
                      ),
                      decoration: BoxDecoration(gradient: kCommonGradient),
                      child: ListTile(
                        contentPadding: EdgeInsets.all(0),
                        visualDensity: VisualDensity.compact,
                        leading: Image.asset(
                          "assets/icons/mentor.png",
                          width: 24,
                          height: 24,
                        ),
                        title: Text(
                          "Become Mentor",
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                            color: Colors.white,
                          ),
                        ),
                        onTap: () => _navigateToScreen('BecomeMentor'),
                      ),
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
                            onTap: () => _navigateToScreen('Invite Friend'),
                          ),
                          _buildDrawerItem(
                            assetpath: "assets/icons/UserCircleGear.png",
                            label: 'Customer Services',
                            onTap: () => _navigateToScreen('Customer Services'),
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
                      if (state is GetbannersStateLoading) {
                        return const SizedBox(
                          height: 180,
                          child: Center(child: CircularProgressIndicator()),
                        );
                      }
                      if (state is GetbannersStateFailure) {
                        return SizedBox(
                          height: 180,
                          child: Center(child: Text(state.msg)),
                        );
                      }
                      final banners =
                          (state as GetbannersStateLoaded)
                              .getbannerModel
                              .data ??
                          [];
                      if (banners.isEmpty) {
                        return const SizedBox(
                          height: 180,
                          child: Center(child: Text("No banners available")),
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
                                mainAxisAlignment: MainAxisAlignment
                                    .center, // Ensures the row is centered
                                children: [
                                  Expanded(
                                    child: FilterButton(
                                      text: 'On Campuses',
                                      isSelected: selectedFilter == 'On Campuses',
                                      onPressed: () {
                                        setState(() {
                                          selectedFilter = 'On Campuses';
                                        });
                                      },
                                    ),
                                  ),
                                  Expanded(
                                    child: FilterButton(
                                      text: 'Beyond Campuses',
                                      isSelected:
                                          selectedFilter == 'Beyond Campuses',
                                      onPressed: () {
                                        setState(() {
                                          selectedFilter = 'Beyond Campuses';
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
                            context.push('/campus_mentor_list?scope=${""}');
                          } else {
                            context.push(
                              '/campus_mentor_list?scope=${"beyond"}',
                            );
                          }
                        },
                        child: const Text(
                          'View All',
                          style: TextStyle(color: Color(0xff4076ED)),
                        ),
                      ),
                    ],
                  ),
                  BlocBuilder<CampusMentorListCubit, CampusMentorListState>(
                    builder: (context, state) {
                      if (state is CampusMentorListStateLoading) {
                        return const SizedBox(
                          height: 200,
                          child: Center(child: CircularProgressIndicator()),
                        );
                      } else if (state is CampusMentorListStateFailure) {
                        return SizedBox(
                          height: 200,
                          child: Center(
                            child: Text(state.msg ?? 'Failed to load'),
                          ),
                        );
                      }
                      final list =
                          (state as CampusMentorListStateLoaded)
                              .campusMentorListModel
                              .data
                              ?.campusMentorData ??
                          [];
                      if (list.isEmpty) {
                        return const SizedBox(
                          height: 200,
                          child: Center(child: Text('No mentors found')),
                        );
                      }
                      return GridView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: list.length,
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              crossAxisSpacing: 16,
                              mainAxisSpacing: 16,
                              childAspectRatio: 0.75,
                            ),
                        itemBuilder: (ctx, i) {
                          final m = list[i];
                          return GestureDetector(
                            onTap: () {
                              if (isGuest) {
                                context.push('/auth_landing');
                              } else {
                                context.push('/mentor_profile?id=${m.id}');
                              }
                            },
                            child: Container(
                              padding: EdgeInsets.all(15),
                              decoration: BoxDecoration(
                                color: Color(0xffF1F5FD).withOpacity(0.6),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Column(
                                children: [
                                  CircleAvatar(
                                    radius: 60,
                                    backgroundColor: Colors.grey.shade200,
                                    backgroundImage:
                                        m.profilePicUrl != null &&
                                            m.profilePicUrl!.isNotEmpty
                                        ? CachedNetworkImageProvider(
                                            m.profilePicUrl!,
                                          )
                                        : null,
                                    child:
                                        (m.profilePicUrl == null ||
                                            m.profilePicUrl!.isEmpty)
                                        ? const Icon(
                                            Icons.person,
                                            size: 60,
                                            color: Colors.grey,
                                          )
                                        : null,
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    m.name ?? '',
                                    textAlign: TextAlign.center,
                                    style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w700,
                                      color: Color(0xff333333),
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    m.designation ?? '',
                                    textAlign: TextAlign.center,
                                    style: const TextStyle(
                                      color: Color(0xff555555),
                                      fontFamily: 'segeo',
                                      fontWeight: FontWeight.w400,
                                    ),
                                  ),
                                  SizedBox(height: 12),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Image.asset(
                                        "assets/images/starvector.png",
                                        color: Colors.amber,
                                        height: 14,
                                        width: 14,
                                      ),
                                      const SizedBox(width: 4),
                                      Text(
                                        m.ratingsReceivedAvgRating
                                                ?.toStringAsFixed(1) ??
                                            '0.0',
                                        style: const TextStyle(
                                          fontSize: 12,
                                          fontFamily: 'segeo',
                                          color: Color(0xff333333),

                                          fontWeight: FontWeight.w700,
                                        ),
                                      ),
                                      const SizedBox(width: 8),
                                      Image.asset(
                                        "assets/images/coinsgold.png",
                                        height: 16,
                                        width: 16,
                                      ),
                                      const SizedBox(width: 4),
                                      Text(
                                        '${m.ratingsReceivedCount ?? 0}',
                                        style: const TextStyle(
                                          fontSize: 12,
                                          color: Color(0xff666666),
                                          fontWeight: FontWeight.w400,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildToggle(String label, bool active, VoidCallback onTap) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 8),
          decoration: BoxDecoration(
            color: active
                ? const Color(0xFF4076ED).withOpacity(0.1)
                : Colors.transparent,
            borderRadius: BorderRadius.circular(30),
            border: Border.all(
              color: active ? const Color(0xFF4076ED) : Colors.transparent,
            ),
          ),
          child: Center(
            child: Text(
              label,
              style: TextStyle(
                fontFamily: 'Segoe',
                fontWeight: FontWeight.w700,
                fontSize: 14,
                color: active ? const Color(0xFF4076ED) : Colors.black54,
              ),
            ),
          ),
        ),
      ),
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
