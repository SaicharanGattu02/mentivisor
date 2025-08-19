import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:mentivisor/Mentor/data/Cubits/MentorProfile/mentor_profile_cubit.dart';
import 'package:mentivisor/Mentor/data/Cubits/MentorProfile/mentor_profile_states.dart';

class AppDrawer extends StatelessWidget {
  const AppDrawer({super.key});

  static const _textColor = Color(0xFF4D4F55);
  static const _labelBlue = Color(0xFF3C506B);
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
                                            radius: 30,
                                            backgroundImage:
                                                CachedNetworkImageProvider(
                                                  user_data?.data?.profilePic ??
                                                      "",
                                                ),
                                          ),
                                          const SizedBox(width: 14),
                                          Text(
                                            user_data?.data?.name ?? "",
                                            style: const TextStyle(
                                              fontFamily: 'segeo',
                                              fontSize: 20,
                                              fontWeight: FontWeight.w600,
                                              color: _labelBlue,
                                            ),
                                          ),
                                        ],
                                      );
                                    },
                                  ),
                            ),
                          ),
                          _DrawerItem(
                            icon: Icons.groups_outlined,
                            title: 'My Mentees',
                            onTap: () {
                              context.pop();
                              context.push('/mentees_list');
                            },
                          ),
                          _DrawerItem(
                            icon: Icons.grade_outlined,
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
                            icon: Icons.history,
                            title: 'Coin History',
                            onTap: () {
                              context.pop();
                              context.push('/coinhistory');
                            },
                          ),
                          _DrawerItem(
                            icon: Icons.local_offer_outlined,
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

                    // // Section label "Info"
                    // _SectionLabel(icon: Icons.info_outline, label: 'Info'),

                    _DrawerItem(
                      icon: Icons.info_outline,
                      title: 'Info',
                      onTap: () {
                        context.pop();
                        context.push('/mentees_Info');
                      },
                    ),

                    _Separator(),

                    Container(
                      decoration: BoxDecoration(color: Colors.white),
                      child: _DrawerItem(
                        icon: Icons.trending_up_outlined,
                        title: 'Update Mentor Profile',
                        onTap: () {
                          // Navigate to Update Mentor Profile
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
                    // Handle logout
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
  final IconData icon;
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
              Icon(icon, size: 20, color: AppDrawer._textColor),
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

/// The blue "Info" row that looks like a label rather than a tappable tile
class _SectionLabel extends StatelessWidget {
  final IconData icon;
  final String label;

  const _SectionLabel({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(color: Colors.white),
      padding: const EdgeInsets.fromLTRB(20, 18, 20, 18),
      child: Row(
        children: [
          // Circle outline with i icon inside (visual approximation)
          Icon(icon, size: 18, color: AppDrawer._labelBlue),
          const SizedBox(width: 16),
          Text(
            label,
            style: const TextStyle(
              fontFamily: 'segeo',
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: AppDrawer._labelBlue,
            ),
          ),
        ],
      ),
    );
  }
}
