import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:url_launcher/url_launcher.dart';
import '../bloc/GetBanners/GetBannersCubit.dart';
import '../bloc/GetBanners/GetBannersState.dart';
import '../bloc/Mentee/CampusMentorList/campus_mentor_list_cubit.dart';
import '../bloc/Mentee/CampusMentorList/campus_mentor_list_state.dart';
import '../services/AuthService.dart';
import '../utils/color_constants.dart';

class MenteeHomeScreen extends StatefulWidget {
  const MenteeHomeScreen({Key? key}) : super(key: key);

  @override
  _MenteeHomeScreenState createState() => _MenteeHomeScreenState();
}

class _MenteeHomeScreenState extends State<MenteeHomeScreen> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  bool _onCampus = true;
  @override
  void initState() {
    super.initState();
    context.read<CampusMentorListCubit>().fetchCampusMentorList("", "");
    context.read<Getbannerscubit>().getbanners();
  }

  void _navigateToScreen(String name) {
    switch (name) {
      case 'Wallet':
       context.push("/wallet");
        break;
      case 'Downloads':
        Navigator.pushNamed(context, '/downloads');
        break;
      case 'Productivity Tools':
        Navigator.pushNamed(context, '/productivity');
        break;
      case 'Session Completed':
        Navigator.pushNamed(context, '/sessions/completed');
        break;
      case 'Upcoming Sessions':
        Navigator.pushNamed(context, '/sessions/upcoming');
        break;
      case 'Info':
        Navigator.pushNamed(context, 'infoscreen');
        break;
      case 'Invite Friend':
        Navigator.pushNamed(context, '/invite');
        break;
      case 'Customer Services':
        Navigator.pushNamed(context, '/support');
        break;
      case 'Become Mentor':
        Navigator.pushNamed(context, '/become-mentor');
        break;
      case 'Logout':
        showLogoutDialog(context);
        break;
      case 'View All':
        Navigator.pushNamed(context, '/mentors');
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
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.menu, color: Colors.black),
          onPressed: () => _scaffoldKey.currentState?.openDrawer(),
        ),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [
            Text(
              'Hello!',
              style: TextStyle(
                color: Colors.black,
                fontSize: 16,
                fontWeight: FontWeight.w700,
                fontFamily: "Inter",
              ),
            ),
            Text(
              'Vijay',
              style: TextStyle(
                color: Colors.black,
                fontSize: 16,
                fontWeight: FontWeight.w700,
                fontFamily: "Inter",
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_outlined, color: Colors.black),
            onPressed: () => ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Notifications clicked')),
            ),
          ),
        ],
      ),
      drawer: Drawer(
        child: Container(
          color: const Color(0xFFF5F7FA),
          child: ListView(
            padding: EdgeInsets.zero,
            children: [
              Container(
                padding: const EdgeInsets.all(16),
                color: Colors.white,
                child: Row(
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
                        fontFamily: "Inter",
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 8),
              _buildDrawerItem(
                icon: Icons.account_balance_wallet,
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
                icon: Icons.download,
                label: 'Downloads',
                onTap: () => _navigateToScreen('Downloads'),
              ),
              _buildDrawerItem(
                icon: Icons.work,
                label: 'Productivity Tools',
                onTap: () => _navigateToScreen('Productivity Tools'),
              ),
              _buildDrawerItem(
                icon: Icons.check_circle_outline,
                label: 'Session Completed',
                onTap: () => _navigateToScreen('Session Completed'),
              ),
              _buildDrawerItem(
                icon: Icons.calendar_today,
                label: 'Upcoming Sessions',
                onTap: () => _navigateToScreen('Upcoming Sessions'),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  vertical: 8,
                  horizontal: 16,
                ),
                color: const Color(0xFFE6E6FA),
                child: const Text(
                  'Exclusive Services',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w400,
                    color: Colors.purple,
                    fontFamily: "Inter",
                  ),
                ),
              ),
              _buildDrawerItem(
                icon: Icons.info_outline,
                label: 'Info',
                onTap: () => _navigateToScreen('Info'),
              ),
              _buildDrawerItem(
                icon: Icons.person_add,
                label: 'Invite Friend',
                onTap: () => _navigateToScreen('Invite Friend'),
              ),
              _buildDrawerItem(
                icon: Icons.support_agent,
                label: 'Customer Services',
                onTap: () => _navigateToScreen('Customer Services'),
              ),
              ListTile(
                leading: const Icon(Icons.school),
                title: const Text(
                  'Become Mentor',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                    color: Color(0xff444444),
                    fontFamily: "Inter",
                  ),
                ),
                tileColor: const Color(0xFF6D4AFF).withOpacity(0.1),
                textColor: const Color(0xFF6D4AFF),
                onTap: () => _navigateToScreen('Become Mentor'),
              ),
              const SizedBox(height: 18),
              ListTile(
                leading: const Icon(Icons.exit_to_app, color: Colors.red),
                title: const Text(
                  'Logout',
                  style: TextStyle(color: Colors.red, fontFamily: "Inter"),
                ),
                onTap: () => _navigateToScreen('Logout'),
              ),
            ],
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
                      (state as GetbannersStateLoaded).getbannerModel.data ??
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
              const SizedBox(height: 24),
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
                child: Container(
                  decoration: BoxDecoration(
                    color: const Color(0xFFE8EBF7),
                    borderRadius: BorderRadius.circular(30),
                  ),
                  padding: const EdgeInsets.all(4),
                  child: Row(
                    mainAxisAlignment:
                        MainAxisAlignment.center, // Ensures the row is centered
                    children: [
                      _buildToggle('On Campus', _onCampus, () {
                        setState(() {
                          _onCampus = true;
                        });
                        context
                            .read<CampusMentorListCubit>()
                            .fetchCampusMentorList("", "");
                      }),
                      const SizedBox(width: 8),
                      _buildToggle('Beyond Campus', !_onCampus, () {
                        setState(() {
                          _onCampus = false;
                        });
                        context
                            .read<CampusMentorListCubit>()
                            .fetchCampusMentorList("", "beyond");
                      }),
                    ],
                  ),
                ),
              ),

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
                        context.push('/campus_mentor_list?scope=${"beyond"}');
                      }
                    },
                    child: const Text(
                      'View All',
                      style: TextStyle(color: Color(0xff4076ED)),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),

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
                      child: Center(child: Text(state.msg ?? 'Failed to load')),
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
                        onTap: () =>
                            Navigator.pushNamed(context, '/mentor/${m.id}'),
                        child: Column(
                          children: [
                            CircleAvatar(
                              radius: 60,
                              backgroundColor: Colors.grey.shade200,
                              backgroundImage:
                                  m.profilePicUrl != null &&
                                      m.profilePicUrl!.isNotEmpty
                                  ? CachedNetworkImageProvider(m.profilePicUrl!)
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
                                fontFamily: 'segeo',
                                fontWeight: FontWeight.w400,
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
                            SizedBox(height: 24),
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
                                  m.ratingsReceivedAvgRating?.toStringAsFixed(
                                        1,
                                      ) ??
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
    required IconData icon,
    required String label,
    Widget? trailing,
    GestureTapCallback? onTap,
  }) => ListTile(
    leading: Icon(icon),
    title: Text(
      label,
      style: const TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w400,
        color: Color(0xff444444),
        fontFamily: "Inter",
      ),
    ),
    trailing: trailing,
    onTap: onTap,
  );
}
