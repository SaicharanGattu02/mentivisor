import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:mentivisor/Components/CutomAppBar.dart';
import 'package:mentivisor/Mentee/data/cubits/MenteeProfile/GetMenteeProfile/MenteeProfileCubit.dart';
import 'package:mentivisor/Mentee/data/cubits/MenteeProfile/GetMenteeProfile/MenteeProfileState.dart';
import 'package:mentivisor/Mentee/data/cubits/MentorProfile/MentorProfileCubit.dart';
import 'package:mentivisor/utils/color_constants.dart';

import '../../../Components/CustomAppButton.dart';
import '../../../utils/media_query_helper.dart';
import '../../../utils/spinkittsLoader.dart';
import '../Widgets/CommentBottomSheet.dart';
import '../Widgets/CommonBackground.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreen1State();
}

class _ProfileScreen1State extends State<ProfileScreen> {
  final ValueNotifier<bool> isPost = ValueNotifier<bool>(true);

  @override
  void dispose() {
    isPost.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    context.read<MenteeProfileCubit>().fetchMenteeProfile();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar1(
        title: "Profile",
        actions: [],
        color: Color(0xFFF2F4FD),
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
            colors: [Color(0xFFFAF5FF), Color(0xFFF2F4FD)],
            stops: [0.0, 1.0],
          ),
        ),
        child: BlocBuilder<MenteeProfileCubit, MenteeProfileState>(
          builder: (context, state) {
            if (state is MenteeProfileLoading) {
              return const SizedBox(
                height: 180,
                child: Center(child: CircularProgressIndicator()),
              );
            } else if (state is MenteeProfileLoaded) {
              final menteeProfile = state.menteeProfileModel.data;
              return Column(
                children: [
                  SizedBox(height: 20),
                  Center(
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        CachedNetworkImage(
                          imageUrl: menteeProfile?.user?.profilePicUrl ?? "",
                          imageBuilder: (context, imageProvider) => Container(
                            padding: EdgeInsets.all(12),
                            width: 120,
                            height: 120,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              image: DecorationImage(
                                image: imageProvider,
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                          placeholder: (context, url) => Container(
                            width: 120,
                            height: 120,
                            alignment: Alignment.center,
                            decoration: BoxDecoration(shape: BoxShape.circle),
                            child: Center(
                              child: spinkits.getSpinningLinespinkit(),
                            ),
                          ),
                          errorWidget: (context, url, error) => Container(
                            width: 120,
                            height: 120,
                            decoration: const BoxDecoration(
                              shape: BoxShape.circle,
                              image: DecorationImage(
                                image: AssetImage("assets/images/profile.png"),
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                        ),

                        if (menteeProfile?.user?.mentorStatus ==
                            "approval") ...[
                          Positioned(
                            right: -0,
                            bottom: 0,
                            child: Image.asset(
                              'assets/images/become_mentor_medol.png',
                              width: 32,
                              height: 32,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),

                  SizedBox(height: 8),

                  Text(
                    menteeProfile?.user?.name ?? "UnKnown",
                    style: TextStyle(
                      color: Color(0xff121212),
                      fontSize: 18,
                      fontFamily: 'segeo',
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    'SVR College NZB ${menteeProfile?.user?.year ?? ""} year\n${menteeProfile?.user?.stream ?? ""}',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Color(0xff666666),
                      fontSize: 14,
                      fontFamily: 'segeo',
                      fontWeight: FontWeight.w600,
                    ),
                  ),

                  SizedBox(height: 12),

                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16),
                    child: Text(
                      menteeProfile?.user?.bio ?? "",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Color(0xff666666),
                        fontSize: 12,
                        fontFamily: 'segeo',
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ),

                  const SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      OutlinedButton.icon(
                        onPressed: () {
                          context.push(
                            '/edit_profile?collegeId=${menteeProfile?.user?.collegeId}',
                          );
                        },
                        icon: const Icon(
                          Icons.mode_edit_outlined,
                          size: 20,
                          color: Color(0xff4A7CF6),
                        ),
                        label: const Text(
                          'Edit',
                          style: TextStyle(
                            fontFamily: 'segeo',
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: Color(0xff4A7CF6),
                            decoration: TextDecoration.underline,
                            decorationColor: Color(0xff4A7CF6),
                          ),
                        ),
                        style: OutlinedButton.styleFrom(
                          side: BorderSide.none,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 20,
                            vertical: 8,
                          ),
                        ),
                      ),
                      const SizedBox(width: 16),
                      OutlinedButton.icon(
                        onPressed: () {},
                        icon: const Icon(
                          Icons.share_rounded,
                          size: 16,
                          color: Color(0xff4A7CF6),
                        ),
                        label: const Text(
                          'Share',
                          style: TextStyle(
                            fontFamily: 'segeo',
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: Color(0xff4A7CF6),
                          ),
                        ),
                        style: OutlinedButton.styleFrom(
                          side: BorderSide.none,
                          backgroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 20,
                            vertical: 8,
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 16),

                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: ValueListenableBuilder<bool>(
                      valueListenable: isPost,
                      builder: (context, value, _) {
                        return Row(
                          children: [
                            Expanded(
                              child: GestureDetector(
                                onTap: () => isPost.value = true,
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 12,
                                  ),
                                  decoration: BoxDecoration(
                                    border: Border(
                                      bottom: BorderSide(
                                        color: value
                                            ? primarycolor
                                            : Colors.transparent,
                                        width: 2,
                                      ),
                                    ),
                                  ),
                                  child: Text(
                                    "Post",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      fontWeight: FontWeight.w400,
                                      fontFamily: 'segeo',
                                      color: Color(0xff444444),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            Expanded(
                              child: GestureDetector(
                                onTap: () => isPost.value = false,
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 12,
                                  ),
                                  decoration: BoxDecoration(
                                    border: Border(
                                      bottom: BorderSide(
                                        color: !value
                                            ? primarycolor
                                            : Colors.transparent,
                                        width: 2,
                                      ),
                                    ),
                                  ),
                                  child: Text(
                                    "Resources",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      fontWeight: FontWeight.w400,
                                      fontFamily: 'segeo',
                                      color: Color(0xff444444),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        );
                      },
                    ),
                  ),
                  Expanded(
                    child: ValueListenableBuilder<bool>(
                      valueListenable: isPost,
                      builder: (context, value, _) {
                        if (value) {
                          return CustomScrollView(
                            slivers: [
                              SliverPadding(
                                padding: EdgeInsetsGeometry.only(top: 20),
                                sliver: SliverList(
                                  delegate: SliverChildBuilderDelegate(
                                    (context, index) {
                                      final menteePosts = state
                                          .menteeProfileModel
                                          .data
                                          ?.user
                                          ?.communityPost?[index];
                                      return Container(
                                        padding: EdgeInsets.symmetric(
                                          horizontal: 12,
                                          vertical: 10,
                                        ),
                                        margin: EdgeInsets.symmetric(
                                          horizontal: 16,
                                          vertical: 10,
                                        ),
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(
                                            8,
                                          ),
                                          color: Colors.white,
                                        ),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            ClipRRect(
                                              borderRadius:
                                                  BorderRadius.circular(8),
                                              child: CachedNetworkImage(
                                                height: 160,
                                                imageUrl:
                                                    menteePosts?.image ?? "",
                                                fit: BoxFit.cover,
                                                width: double.infinity,
                                                placeholder: (context, url) =>
                                                    spinkits
                                                        .getSpinningLinespinkit(),
                                                errorWidget:
                                                    (context, url, error) =>
                                                        Container(
                                                          height: 160,
                                                          color: Colors
                                                              .grey
                                                              .shade100,
                                                          child: const Icon(
                                                            Icons.broken_image,
                                                            size: 40,
                                                            color: Colors.grey,
                                                          ),
                                                        ),
                                              ),
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.all(12),
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Row(
                                                    children: [
                                                      CachedNetworkImage(
                                                        imageUrl:
                                                            menteePosts
                                                                ?.image ??
                                                            "",
                                                        imageBuilder:
                                                            (
                                                              context,
                                                              imageProvider,
                                                            ) => CircleAvatar(
                                                              radius: 12,
                                                              backgroundImage:
                                                                  imageProvider,
                                                            ),
                                                        placeholder:
                                                            (
                                                              context,
                                                              url,
                                                            ) => CircleAvatar(
                                                              radius: 12,
                                                              backgroundColor:
                                                                  Colors
                                                                      .grey
                                                                      .shade200,
                                                              child: Center(
                                                                child: spinkits
                                                                    .getSpinningLinespinkit(),
                                                              ),
                                                            ),
                                                        errorWidget:
                                                            (
                                                              context,
                                                              url,
                                                              error,
                                                            ) => const CircleAvatar(
                                                              radius: 12,
                                                              backgroundImage:
                                                                  AssetImage(
                                                                    "assets/images/profile.png",
                                                                  ),
                                                            ),
                                                      ),

                                                      SizedBox(width: 8),
                                                      // Text(
                                                      //   menteePosts?. ?? "",
                                                      //   style: TextStyle(
                                                      //     fontFamily: 'Segoe',
                                                      //     fontWeight:
                                                      //         FontWeight.w600,
                                                      //     fontSize: 14,
                                                      //   ),
                                                      // ),
                                                    ],
                                                  ),
                                                  const SizedBox(height: 4),
                                                  Text(
                                                    menteePosts?.heading ?? "",
                                                    style: TextStyle(
                                                      fontFamily: 'Segoe',
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontSize: 16,
                                                      color: Color(0xFF222222),
                                                    ),
                                                  ),
                                                  SizedBox(height: 4),
                                                  Text(
                                                    menteePosts?.description ??
                                                        "",
                                                    maxLines: 2,
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                    style: TextStyle(
                                                      fontFamily: 'Segoe',
                                                      fontWeight:
                                                          FontWeight.w400,
                                                      fontSize: 14,
                                                      color: Color(0xFF666666),
                                                    ),
                                                  ),
                                                  const SizedBox(height: 8),
                                                  Row(
                                                    children: [
                                                      const Icon(
                                                        Icons
                                                            .thumb_up_alt_outlined,
                                                        size: 18,
                                                      ),
                                                      SizedBox(width: 6),
                                                      Text(
                                                        menteePosts?.likeCount
                                                                .toString() ??
                                                            "0",
                                                        style: TextStyle(
                                                          color: Color(
                                                            0xff666666,
                                                          ),
                                                          fontWeight:
                                                              FontWeight.w400,
                                                          fontSize: 14,
                                                        ),
                                                      ),
                                                      SizedBox(width: 24),
                                                      Row(
                                                        children: [
                                                          IconButton(
                                                            padding:
                                                                EdgeInsets.zero,
                                                            visualDensity:
                                                                VisualDensity
                                                                    .compact,
                                                            onPressed: () {
                                                              showModalBottomSheet(
                                                                context:
                                                                    context,
                                                                isScrollControlled:
                                                                    true,
                                                                useRootNavigator:
                                                                    true,
                                                                backgroundColor:
                                                                    Colors
                                                                        .transparent,
                                                                builder: (context) {
                                                                  return DraggableScrollableSheet(
                                                                    initialChildSize:
                                                                        0.8,
                                                                    minChildSize:
                                                                        0.4,
                                                                    maxChildSize:
                                                                        0.95,
                                                                    expand:
                                                                        false,
                                                                    builder:
                                                                        (
                                                                          _,
                                                                          scrollController,
                                                                        ) => Container(
                                                                          decoration: const BoxDecoration(
                                                                            color:
                                                                                Colors.white,
                                                                            borderRadius: BorderRadius.vertical(
                                                                              top: Radius.circular(
                                                                                16,
                                                                              ),
                                                                            ),
                                                                          ),
                                                                          padding: const EdgeInsets.symmetric(
                                                                            horizontal:
                                                                                16,
                                                                            vertical:
                                                                                12,
                                                                          ),
                                                                          child: CommentBottomSheet(
                                                                            comments:
                                                                                (menteePosts?.comments ??
                                                                                        [])
                                                                                    .map(
                                                                                      (
                                                                                        comments,
                                                                                      ) => {
                                                                                        "name":
                                                                                            comments.user?.name ??
                                                                                            "Unknown",
                                                                                        "profile":
                                                                                            comments.user?.profilePicUrl ??
                                                                                            "assets/images/profile.png",
                                                                                        "comment":
                                                                                            comments.content ??
                                                                                            "",
                                                                                        "time":
                                                                                            comments.createdAt ??
                                                                                            "",
                                                                                      },
                                                                                    )
                                                                                    .toList(),
                                                                            scrollController:
                                                                                scrollController,
                                                                          ),
                                                                        ),
                                                                  );
                                                                },
                                                              );
                                                            },
                                                            icon: Icon(
                                                              Icons
                                                                  .comment_outlined,
                                                              size: 18,
                                                            ),
                                                          ),
                                                          SizedBox(width: 6),
                                                          Text(
                                                            menteePosts
                                                                    ?.messageCount
                                                                    .toString() ??
                                                                "0",
                                                            style: TextStyle(
                                                              color: Color(
                                                                0xff666666,
                                                              ),
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w400,
                                                              fontSize: 14,
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ],
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                      );
                                    },
                                    childCount: menteeProfile
                                        ?.user
                                        ?.communityPost
                                        ?.length,
                                  ),
                                ),
                              ),
                            ],
                          );
                        } else {
                          return CustomScrollView(
                            slivers: [
                              SliverPadding(
                                padding: EdgeInsets.only(top: 16),
                                sliver: SliverList(
                                  delegate: SliverChildBuilderDelegate(
                                    (context, index) {
                                      final campusList = menteeProfile
                                          ?.user
                                          ?.studyZoneBooks?[index];
                                      return Container(
                                        margin: EdgeInsets.only(
                                          bottom: 16,
                                          left: 16,
                                          right: 16,
                                        ),
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(
                                            24,
                                          ),
                                          color: Colors.white,
                                        ),
                                        child: Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Padding(
                                              padding: EdgeInsets.symmetric(
                                                vertical: 16,
                                                horizontal: 12,
                                              ),
                                              child: ClipRRect(
                                                borderRadius:
                                                    BorderRadius.circular(4),
                                                child: CachedNetworkImage(
                                                  width:
                                                      MediaQuery.of(
                                                        context,
                                                      ).size.width *
                                                      0.3,
                                                  height: 144,
                                                  imageUrl:
                                                      campusList?.image ?? "",
                                                  fit: BoxFit.cover,
                                                  placeholder: (context, url) =>
                                                      SizedBox(
                                                        width: 120,
                                                        height: 120,
                                                        child: Center(
                                                          child: spinkits
                                                              .getSpinningLinespinkit(),
                                                        ),
                                                      ),
                                                  errorWidget:
                                                      (
                                                        context,
                                                        url,
                                                        error,
                                                      ) => Container(
                                                        width: 120,
                                                        height: 120,
                                                        color: const Color(
                                                          0xffF8FAFE,
                                                        ),
                                                        child: const Icon(
                                                          Icons.broken_image,
                                                          size: 40,
                                                          color: Colors.grey,
                                                        ),
                                                      ),
                                                ),
                                              ),
                                            ),
                                            Expanded(
                                              child: Padding(
                                                padding: const EdgeInsets.all(
                                                  10.0,
                                                ),
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                      campusList?.name ?? "",
                                                      style: TextStyle(
                                                        fontFamily: 'segeo',
                                                        fontWeight:
                                                            FontWeight.w700,
                                                        fontSize: 12,
                                                        height: 1,
                                                        letterSpacing: 0.5,
                                                      ),
                                                    ),
                                                    const SizedBox(height: 8),
                                                    Text(
                                                      campusList?.description ??
                                                          "",
                                                      style: const TextStyle(
                                                        fontFamily: 'segeo',
                                                        fontWeight:
                                                            FontWeight.w400,
                                                        fontSize: 11,
                                                        height: 1,
                                                      ),
                                                    ),
                                                    const SizedBox(height: 12),

                                                    if (campusList
                                                            ?.tag
                                                            ?.isNotEmpty ??
                                                        false)
                                                      Wrap(
                                                        spacing: 8,
                                                        runSpacing: 8,
                                                        children: campusList!.tag!.map((
                                                          tag,
                                                        ) {
                                                          return Container(
                                                            padding:
                                                                const EdgeInsets.symmetric(
                                                                  horizontal:
                                                                      12,
                                                                  vertical: 6,
                                                                ),
                                                            decoration:
                                                                BoxDecoration(
                                                                  color: Colors
                                                                      .white,
                                                                  borderRadius:
                                                                      BorderRadius.circular(
                                                                        20,
                                                                      ),
                                                                ),
                                                            child: Text(
                                                              tag,
                                                              style: const TextStyle(
                                                                fontFamily:
                                                                    'segeo',
                                                                fontSize: 12,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w600,
                                                              ),
                                                            ),
                                                          );
                                                        }).toList(),
                                                      ),
                                                    const SizedBox(height: 16),
                                                    Row(
                                                      children: [
                                                        Expanded(
                                                          child:
                                                              CustomOutlinedButton(
                                                                height: 38,
                                                                width: 110,
                                                                radius: 24,
                                                                text: "View",
                                                                onTap: () {},
                                                              ),
                                                        ),
                                                        const SizedBox(
                                                          width: 10,
                                                        ),
                                                        Expanded(
                                                          child:
                                                              CustomAppButton1(
                                                                width: 110,
                                                                height: 38,
                                                                radius: 24,
                                                                text:
                                                                    "Download",
                                                                onPlusTap:
                                                                    () {},
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
                                      );
                                    },
                                    childCount: menteeProfile
                                        ?.user
                                        ?.studyZoneBooks
                                        ?.length,
                                  ),
                                ),
                              ),
                            ],
                          );
                        }
                      },
                    ),
                  ),
                ],
              );
            } else if (state is MenteeProfileFailure) {
              return SizedBox(
                height: 180,
                child: Center(child: Text(state.message)),
              );
            }
            return Center(child: Text("No Data "));
          },
        ),
      ),
    );
  }
}
