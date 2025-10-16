import 'dart:async';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:mentivisor/Components/CommonLoader.dart';
import 'package:mentivisor/Components/CutomAppBar.dart';
import 'package:mentivisor/services/AuthService.dart';
import 'package:mentivisor/utils/media_query_helper.dart';
import '../../Components/Shimmers.dart';
import '../../utils/color_constants.dart';
import '../data/cubits/CampusMentorList/campus_mentor_list_cubit.dart';
import '../data/cubits/CampusMentorList/campus_mentor_list_state.dart';

class Campusmentorlist extends StatefulWidget {
  final String scope;
  const Campusmentorlist({super.key, required this.scope});

  @override
  State<Campusmentorlist> createState() => _CampusmentorlistState();
}

class _CampusmentorlistState extends State<Campusmentorlist> {
  String searchQuery = '';

  final TextEditingController searchController = TextEditingController();
  Timer? _debounce;

  @override
  void initState() {
    super.initState();
    context.read<CampusMentorListCubit>().fetchCampusMentorList(
      "${widget.scope}",
      "",
    );
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: AuthService.isGuest,
      builder: (context, asyncSnapshot) {
        final isGuest = asyncSnapshot.data ?? false;
        return Scaffold(
          resizeToAvoidBottomInset: true,
          appBar: CustomAppBar1(
            title: isGuest
                ? "Top Mentors"
                : widget.scope.isEmpty
                ? "On Campus Mentors"
                : "Beyond Campus Mentors",
            actions: [],
          ),
          body: Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFFF7F8FC), Color(0xFFEFF4FF)],
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
              ),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 20),
            child: Column(
              children: [
                SizedBox(
                  height: 48,
                  child: TextField(
                    controller: searchController,
                    cursorColor: primarycolor,
                    onChanged: (query) {
                      if (_debounce?.isActive ?? false) _debounce!.cancel();
                      _debounce = Timer(const Duration(milliseconds: 300), () {
                        context
                            .read<CampusMentorListCubit>()
                            .fetchCampusMentorList("${widget.scope}", query);
                      });
                    },
                    style: const TextStyle(fontFamily: "Poppins", fontSize: 15),
                    decoration: InputDecoration(
                      hintText: 'Search your mentor /Collage',
                      prefixIcon: const Icon(Icons.search),
                    ),
                  ),
                ),
                SizedBox(height: 16),
                BlocBuilder<CampusMentorListCubit, CampusMentorListState>(
                  builder: (context, state) {
                    if (state is CampusMentorListStateLoading) {
                      return MentorGridShimmer();
                    }
                    if (state is CampusMentorListStateFailure) {
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
                            ?.mentors_list ??
                        [];
                    if (list.isEmpty) {
                      return SizedBox(
                        height: SizeConfig.screenHeight * 0.6,
                        child: Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Image.asset(
                                "assets/nodata/no_data.png",
                                width: 250,
                              ),
                              Text(
                                "No Mentors Found!",
                                style: TextStyle(fontWeight: FontWeight.w500),
                              ),
                            ],
                          ),
                        ),
                      );
                    }
                    return Expanded(
                      child: GridView.builder(
                        shrinkWrap: true,
                        physics:  AlwaysScrollableScrollPhysics(),
                        itemCount: list.length,
                        gridDelegate:
                             SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              crossAxisSpacing: 16,
                              mainAxisSpacing: 16,
                              childAspectRatio: () {
                                final screenHeight = MediaQuery.of(context).size.height;
                                final size = MediaQuery.of(context).size;
                                final screenWidth = size.width;
                                double aspectRatio = screenWidth / (screenHeight * 0.5);
                                if (screenWidth < 400) {
                                  aspectRatio = screenWidth / (screenHeight * 0.6);
                                } else if (screenWidth < 800) {
                                  aspectRatio = screenWidth / (screenHeight * 0.4);
                                } else {
                                  aspectRatio = screenWidth / (screenHeight * 0.35);
                                }
                                return aspectRatio;
                              }(),
                            ),
                        itemBuilder: (ctx, i) {
                          final m = list[i];
                          final url = m.user?.profilePicUrl?.trim();
                          final hasPic = url != null && url.isNotEmpty;
                          return GestureDetector(
                            onTap: () {
                              if (isGuest) {
                                context.push('/auth_landing');
                              } else {
                                context.push('/mentor_profile?id=${m.userId}');
                              }
                            },
                            child: Container(
                              padding: EdgeInsets.all(15),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Column(
                                children: [
                                  CircleAvatar(
                                    radius: 40,
                                    backgroundColor: Colors.grey.shade200,
                                    backgroundImage: hasPic
                                        ? CachedNetworkImageProvider(url)
                                        : null,
                                    child: hasPic
                                        ? null
                                        : const Icon(
                                            Icons.person,
                                            size: 60,
                                            color: Colors.grey,
                                          ),
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    m.user?.name ?? '',
                                    textAlign: TextAlign.center,
                                    style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w700,
                                      color: Color(0xff333333),
                                    ),
                                  ),
                                  SizedBox(height: 4),
                                  Text(
                                    m.user?.college?.name ?? '',
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                    textAlign: TextAlign.center,
                                    style: const TextStyle(
                                      color: Color(0xff555555),
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
                                      RichText(
                                        text: TextSpan(
                                          children: [
                                            TextSpan(
                                              text:
                                                  m.averageRating
                                                      ?.toStringAsFixed(1) ??
                                                  '0.0',
                                              style: const TextStyle(
                                                fontSize: 12,
                                                fontFamily: 'segeo',
                                                color: Color(0xff333333),
                                                fontWeight: FontWeight.w700,
                                              ),
                                            ),
                                            TextSpan(
                                              text:
                                                  ' (${m.totalReviews ?? 0.0})',
                                              style: const TextStyle(
                                                fontSize: 12,
                                                fontFamily: 'segeo',
                                                color: Color(0xff666666),
                                                fontWeight: FontWeight.w400,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      // SizedBox(width: 8),
                                      // Image.asset(
                                      //   "assets/images/coinsgold.png",
                                      //   height: 16,
                                      //   width: 16,
                                      // ),
                                      // const SizedBox(width: 4),
                                      // Text(
                                      //   '${m.coinsPerMinute ?? 0}',
                                      //   style: const TextStyle(
                                      //     fontSize: 12,
                                      //     color: Color(0xff333333),
                                      //     fontWeight: FontWeight.w700,
                                      //   ),
                                      // ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class MentorGridShimmer extends StatelessWidget {
  const MentorGridShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: 6, // number of shimmer placeholders
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
          childAspectRatio: 0.85,
        ),
        itemBuilder: (ctx, i) {
          return Container(
            padding: const EdgeInsets.all(15),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Column(
              children: [
                /// 👤 Profile Image Placeholder
                shimmerCircle(80, context),
                const SizedBox(height: 8),

                /// 🧾 Mentor Name Placeholder
                shimmerText(100, 16, context),
                const SizedBox(height: 6),

                /// 🎓 College Name Placeholder (2 lines)
                shimmerText(120, 12, context),
                const SizedBox(height: 4),
                shimmerText(80, 12, context),

                const SizedBox(height: 12),

                /// ⭐ Rating Row Placeholder
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    shimmerCircle(14, context),
                    const SizedBox(width: 6),
                    shimmerText(30, 12, context),
                    const SizedBox(width: 4),
                    shimmerText(20, 12, context),
                  ],
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
