import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:mentivisor/Mentor/data/Cubits/MentorProfile/mentor_profile_cubit.dart';
import 'package:mentivisor/Mentor/data/Cubits/MentorProfile/mentor_profile_states.dart';
import 'package:mentivisor/utils/media_query_helper.dart';

import '../../../services/AuthService.dart';
import '../../../utils/color_constants.dart';

class AppDrawer extends StatelessWidget {
  const AppDrawer({super.key});

  static const _textColor = Color(0xFF4D4F55);
  static const _separatorStart = Color(0xFFF7F8FE);
  static const _separatorEnd = Color(0xFFEFF4FF);
  static const _paleFillTop = Color(0xFFF5F8FF);
  static const _paleFillBottom = Color(0xFFEFF5FF);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      elevation: 0,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.zero),
      child: SafeArea(
        child: Container(
          // Big pale gradient fill like the screenshot background
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [_paleFillTop, _paleFillBottom],
              stops: [0.35, 1.0],
            ),
          ),
          child: Column(
            children: [
              Expanded(
                child: ListView(
                  padding: EdgeInsets.zero,
                  children: [
                    Container(
                      decoration: BoxDecoration(color: Colors.white),
                      child: Column(
                        children: [
                          GestureDetector(
                            onTap: () {
                              context.pop();
                              context.push("/mentor_profile_screen");
                            },
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child:
                                  BlocBuilder<
                                    MentorProfileCubit1,
                                    MentorProfileStates
                                  >(
                                    builder: (context, state) {
                                      final user_data =
                                          state is MentorProfile1Loaded
                                          ? state.mentorProfileModel
                                          : null;
                                      return Row(
                                        children: [
                                          CircleAvatar(
                                            radius: 20,
                                            backgroundImage:
                                                (user_data?.data?.profilePic !=
                                                        null &&
                                                    user_data!
                                                        .data!
                                                        .profilePic!
                                                        .isNotEmpty)
                                                ? CachedNetworkImageProvider(
                                                    user_data.data!.profilePic!,
                                                  )
                                                : const AssetImage(
                                                        "images/profile.png",
                                                      )
                                                      as ImageProvider,
                                          ),
                                          const SizedBox(width: 14),
                                          Text(
                                            user_data?.data?.name ?? "",
                                            style: const TextStyle(
                                              fontFamily: 'segeo',
                                              fontSize: 20,
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                        ],
                                      );
                                    },
                                  ),
                            ),
                          ),
                          _DrawerItem(
                            icon: Icon(Icons.groups_outlined),
                            title: 'My Mentees',
                            onTap: () {
                              context.pop();
                              context.push('/mentees_list');
                            },
                          ),
                          _DrawerItem(
                            icon: Icon(Icons.grade_outlined),
                            title: 'Feedback',
                            onTap: () {
                              context.pop();
                              context.push('/feedback');
                            },
                          ),
                        ],
                      ),
                    ),
                    _Separator(),
                    Container(
                      decoration: BoxDecoration(color: Colors.white),
                      child: Column(
                        children: [
                          _DrawerItem(
                            icon: Icon(Icons.history),
                            title: 'Coin History',
                            onTap: () {
                              context.pop();
                              context.push('/coinhistory');
                            },
                          ),
                          _DrawerItem(
                            icon: Icon(Icons.local_offer_outlined),
                            title: 'Coupon',
                            onTap: () {
                              context.pop();
                              context.push('/coupons');
                            },
                          ),
                        ],
                      ),
                    ),

                    _Separator(),
                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 10,
                      ),
                      // height: 56,
                      decoration: BoxDecoration(color: Color(0xffFFF7CE)),
                      child: Column(
                        children: [
                          InkWell(
                            onTap: () {
                              context.pop();
                              context.pushReplacement('/dashboard');
                            },
                            child: Row(
                              children: [
                                Image.asset(
                                  "assets/icons/ArrowCircleRight.png",
                                  fit: BoxFit.cover,
                                  width: SizeConfig.screenWidth * 0.082,
                                  height: SizeConfig.screenHeight * 0.055,
                                ), // Directly use the passed widget
                                SizedBox(width: 8),
                                Expanded(
                                  child: Text(
                                    'Switch to Mentee',
                                    style: TextStyle(
                                      fontFamily: 'segeo',
                                      fontSize: 14,
                                      fontWeight: FontWeight.w600,
                                      color: Color(0xff4B5462),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),

                    _Separator(),

                    // // Section label "Info"
                    // _SectionLabel(icon: Icons.info_outline, label: 'Info'),
                    Container(
                      decoration: BoxDecoration(color: Colors.white),
                      child: _DrawerItem(
                        icon: Icon(Icons.info_outline),
                        title: 'Info',
                        onTap: () {
                          context.pop();
                          context.push('/mentees_Info');
                        },
                      ),
                    ),

                    _Separator(),

                    Container(
                      decoration: BoxDecoration(color: Colors.white),
                      child: _DrawerItem(
                        icon: Icon(Icons.trending_up_outlined),
                        title: 'Update Mentor Profile',
                        onTap: () {
                          context.pop();
                          context.push("/update_expertise");
                        },
                      ),
                    ),

                    // Large spacer to mimic the tall empty gradient area
                    const SizedBox(height: 24),
                  ],
                ),
              ),

              // Fixed Logout at the bottom (white strip)
              Container(
                color: Colors.white,
                padding: const EdgeInsets.fromLTRB(20, 14, 20, 14),
                child: InkWell(
                  onTap: () {
                    showLogoutDialog(context);
                  },
                  borderRadius: BorderRadius.circular(12),
                  child: Row(
                    children: const [
                      Icon(Icons.logout, color: Color(0xFFFF4C4C)),
                      SizedBox(width: 12),
                      Text(
                        'Logout',
                        style: TextStyle(
                          fontFamily: 'segeo',
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFFFF4C4C),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 35),
            ],
          ),
        ),
      ),
    );
  }
}

/// Thin soft gradient bar used between groups (exact look from screenshot)
class _Separator extends StatelessWidget {
  const _Separator();

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 14,
      width: double.infinity,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [AppDrawer._separatorStart, AppDrawer._separatorEnd],
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
        ),
      ),
    );
  }
}

/// Standard drawer row with larger outlined icon + precise paddings
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
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 18, 20, 18),
          child: Row(
            children: [
              icon, // Directly use the passed widget
              const SizedBox(width: 16),
              Expanded(
                child: Text(
                  title,
                  style: const TextStyle(
                    fontFamily: 'segeo',
                    fontSize: 15,
                    fontWeight: FontWeight.w500,
                    color: AppDrawer._textColor,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
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
                          fontFamily: "segeo",
                        ),
                      ),
                      const SizedBox(height: 10.0),
                      const Text(
                        "Are you sure you want to logout?",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 16.0,
                          color: Colors.black54,
                          fontFamily: "segeo",
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
                                foregroundColor: primarycolor,
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
