import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:mentivisor/Components/CutomAppBar.dart';
import 'package:mentivisor/Mentee/data/cubits/CommonProfile/CommonProfileCubit.dart';
import 'package:mentivisor/Mentee/data/cubits/PostComment/post_comment_states.dart';
import 'package:share_plus/share_plus.dart';
import '../../../Components/CustomAppButton.dart';
import '../../../Components/CustomSnackBar.dart';
import '../../../Components/Shimmers.dart';
import '../../../utils/color_constants.dart';
import '../../../utils/constants.dart';
import '../../../utils/spinkittsLoader.dart';
import '../../Models/CommunityPostsModel.dart';
import '../../data/cubits/AddResource/add_resource_cubit.dart';
import '../../data/cubits/AddResource/add_resource_states.dart';
import '../../data/cubits/CommonProfile/CommonProfileState.dart';
import '../../data/cubits/CommunityPostReport/CommunityZoneReportCubit.dart';
import '../../data/cubits/CommunityPostReport/CommunityZoneReportState.dart';
import '../../data/cubits/PostComment/post_comment_cubit.dart';
import '../Widgets/CommentBottomSheet.dart';

class ProfileDetails extends StatefulWidget {
  final int id;
  ProfileDetails({super.key, required this.id});
  @override
  State<ProfileDetails> createState() => _ProfileDetailsState();
}

class _ProfileDetailsState extends State<ProfileDetails> {
  final ValueNotifier<bool> isPost = ValueNotifier<bool>(true);

  @override
  void dispose() {
    isPost.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    context.read<CommonProfileCubit>().fetchCommonProfile(widget.id);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar1(
        title: "Profile",
        actions: [],
        color: Color(0xFFF2F4FD),
      ),
      body: SafeArea(
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFFFAF5FF), Color(0xFFF2F4FD)],
            ),
          ),
          child: BlocBuilder<CommonProfileCubit, CommonProfileState>(
            builder: (context, state) {
              if (state is CommonProfileLoading) {
                return const MenteeProfileShimmer();
              } else if (state is CommonProfileLoaded) {
                final menteeProfile = state.mentorProfileModel;
                return Column(
                  children: [
                    SizedBox(height: 20),
                    Center(
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          CachedNetworkImage(
                            imageUrl:
                                menteeProfile.data?.user?.profilePicUrl ?? "",
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
                                  image: AssetImage(
                                    "assets/images/profile.png",
                                  ),
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                          ),

                          if (menteeProfile.data?.user?.mentorStatus ==
                              "approval") ...[
                            Positioned(
                              right: 0,
                              bottom: 0,
                              child: GestureDetector(
                                onTap: () {
                                  context.push(
                                    '/mentor_profile?id=${menteeProfile.data?.user?.id ?? ""}',
                                  );
                                },
                                child: Image.asset(
                                  'assets/images/become_mentor_medol.png',
                                  width: 32,
                                  height: 32,
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      capitalize(menteeProfile.data?.user?.name ?? "UnKnown"),
                      style: TextStyle(
                        color: Color(0xff121212),
                        fontSize: 18,
                        fontFamily: 'segeo',
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      '${menteeProfile.data?.user?.yearName ?? ""} year student in ${menteeProfile.data?.user?.stream ?? ""} from ${menteeProfile.data?.user?.collegeName ?? ""}',
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
                      child:
                          // Text(
                          //   menteeProfile?.user?.bio ?? "",
                          //   textAlign: TextAlign.center,
                          //   maxLines: 3,                // ✅ limit to 3 lines
                          //   overflow: TextOverflow.ellipsis, // ✅ show "..." if longer
                          //   style: const TextStyle(
                          //     color: Color(0xff666666),
                          //     fontSize: 12,
                          //     fontFamily: 'segeo',
                          //     fontWeight: FontWeight.w400,
                          //   ),
                          // ),
                          Text(
                            (menteeProfile.data?.user?.bio?.length ?? 0) > 100
                                ? "${menteeProfile.data?.user?.bio?.substring(0, 100)}..."
                                : (menteeProfile.data?.user?.bio ?? ""),
                            textAlign: TextAlign.center,
                            style: const TextStyle(
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
                        // OutlinedButton.icon(
                        //   onPressed: () {
                        //     context.push(
                        //       '/edit_profile?collegeId=${menteeProfile?.user?.collegeId}',
                        //     );
                        //   },
                        //   icon: const Icon(
                        //     Icons.mode_edit_outlined,
                        //     size: 20,
                        //     color: Color(0xff4A7CF6),
                        //   ),
                        //   label: const Text(
                        //     'Edit',
                        //     style: TextStyle(
                        //       fontFamily: 'segeo',
                        //       fontSize: 16,
                        //       fontWeight: FontWeight.w600,
                        //       color: Color(0xff4A7CF6),
                        //       decoration: TextDecoration.underline,
                        //       decorationColor: Color(0xff4A7CF6),
                        //     ),
                        //   ),
                        //   style: OutlinedButton.styleFrom(
                        //     side: BorderSide.none,
                        //     shape: RoundedRectangleBorder(
                        //       borderRadius: BorderRadius.circular(20),
                        //     ),
                        //     padding: const EdgeInsets.symmetric(
                        //       horizontal: 20,
                        //       vertical: 8,
                        //     ),
                        //   ),
                        // ),
                        // const SizedBox(width: 16),
                        OutlinedButton.icon(
                          onPressed: () {
                            final profileId = menteeProfile.data?.user?.id;
                            final shareUrl =
                                "https://mentivisor.com/profile/$profileId";
                            Share.share(
                              "Check out this profile on Mentivisor:\n$shareUrl",
                              subject: "Mentivisor Profile",
                            );
                          },
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
                    const SizedBox(height: 12),
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
                            if (state
                                    .mentorProfileModel
                                    .data
                                    ?.user
                                    ?.communityPost
                                    ?.length ==
                                0) {
                              return Center(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Image.asset(
                                      "assets/nodata/no_data.png",
                                      height: 120,
                                    ),
                                    const SizedBox(height: 16),
                                    const Text(
                                      "No Posts Available",
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

                            return BlocListener<
                              PostCommentCubit,
                              PostCommentStates
                            >(
                              listener: (context, state) {
                                if (state is PostCommentLoaded) {}
                              },
                              child: CustomScrollView(
                                slivers: [
                                  SliverList(
                                    delegate: SliverChildBuilderDelegate(
                                      (context, index) {
                                        final menteePosts = state
                                            .mentorProfileModel
                                            .data
                                            ?.user
                                            ?.communityPost![index];
                                        return GestureDetector(
                                          onTap: () {
                                            context.push(
                                              "/community_details/${menteePosts?.id}",
                                            );
                                          },
                                          child: Container(
                                            padding: EdgeInsets.symmetric(
                                              horizontal: 12,
                                              vertical: 10,
                                            ),
                                            margin: EdgeInsets.symmetric(
                                              horizontal: 16,
                                              vertical: 10,
                                            ),
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(8),
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
                                                    imageUrl:
                                                        menteePosts?.image ??
                                                        "",
                                                    fit: BoxFit.cover,
                                                    width: double.infinity,
                                                    placeholder:
                                                        (
                                                          context,
                                                          url,
                                                        ) => spinkits
                                                            .getSpinningLinespinkit(),
                                                    errorWidget:
                                                        (
                                                          context,
                                                          url,
                                                          error,
                                                        ) => Container(
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
                                                Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    SizedBox(height: 4),
                                                    Text(
                                                      menteePosts?.title ?? "",
                                                      maxLines: 2,
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                      style: TextStyle(
                                                        fontFamily: 'segeo',
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        fontSize: 16,
                                                        color: Color(
                                                          0xFF222222,
                                                        ),
                                                      ),
                                                    ),
                                                    SizedBox(height: 4),
                                                    Text(
                                                      menteePosts?.content ??
                                                          "",
                                                      maxLines: 2,
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                      style: TextStyle(
                                                        fontFamily: 'segeo',
                                                        fontWeight:
                                                            FontWeight.w400,
                                                        fontSize: 14,
                                                        color: Color(
                                                          0xFF666666,
                                                        ),
                                                      ),
                                                    ),
                                                    const SizedBox(height: 8),
                                                    Row(
                                                      children: [
                                                        IconButton(
                                                          visualDensity:
                                                              VisualDensity
                                                                  .compact,
                                                          padding:
                                                              EdgeInsets.zero,
                                                          onPressed: () {
                                                            final data = {
                                                              "community_id":
                                                                  menteePosts
                                                                      ?.id,
                                                            };
                                                            context
                                                                .read<
                                                                  PostCommentCubit
                                                                >()
                                                                .postLike(
                                                                  data,
                                                                  CommunityPosts(),
                                                                );
                                                          },
                                                          icon: Icon(
                                                            (menteePosts?.isLike ??
                                                                    false)
                                                                ? Icons.favorite
                                                                : Icons
                                                                      .favorite_border,
                                                            size: 16,
                                                            color:
                                                                (menteePosts
                                                                        ?.isLike ??
                                                                    false)
                                                                ? Colors.red
                                                                : Colors
                                                                      .black26,
                                                          ),
                                                        ),
                                                        Text(
                                                          menteePosts
                                                                  ?.likesCount
                                                                  .toString() ??
                                                              "0",
                                                          style: TextStyle(
                                                            color: Color(
                                                              0xff666666,
                                                            ),
                                                            fontSize: 14,
                                                            fontFamily: 'segeo',
                                                            fontWeight:
                                                                FontWeight.w400,
                                                          ),
                                                        ),
                                                        IconButton(
                                                          visualDensity:
                                                              VisualDensity
                                                                  .compact,
                                                          padding:
                                                              EdgeInsets.zero,
                                                          onPressed: () {
                                                            showModalBottomSheet(
                                                              context: context,
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
                                                                  expand: false,
                                                                  builder:
                                                                      (
                                                                        _,
                                                                        scrollController,
                                                                      ) => Container(
                                                                        decoration: const BoxDecoration(
                                                                          color: Color(
                                                                            0xffF4F8FD,
                                                                          ),
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
                                                                          communityPost: CommunityPosts(
                                                                            id: menteePosts?.id,
                                                                            heading:
                                                                                menteePosts?.title,
                                                                            description:
                                                                                menteePosts?.content,
                                                                          ),
                                                                          scrollController:
                                                                              scrollController,
                                                                        ),
                                                                      ),
                                                                );
                                                              },
                                                            );
                                                          },
                                                          icon: Image.asset(
                                                            "assets/icons/Chat.png",
                                                            width: 18,
                                                            height: 18,
                                                          ),
                                                        ),
                                                        Text(
                                                          menteePosts
                                                                  ?.commentsCount
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
                                                        IconButton(
                                                          padding: EdgeInsets
                                                              .zero, // remove default extra padding
                                                          visualDensity:
                                                              VisualDensity
                                                                  .compact,
                                                          icon: Image.asset(
                                                            'assets/icons/share.png',
                                                            width: 16,
                                                            height: 16,
                                                          ),
                                                          onPressed: () async {
                                                            final postId =
                                                                menteePosts?.id;
                                                            final shareUrl =
                                                                "https://mentivisor.com/community_post/$postId";

                                                            Share.share(
                                                              "Check out this Community Post on Mentivisor:\n$shareUrl",
                                                              subject:
                                                                  "Mentivisor Community Post",
                                                            );
                                                          },
                                                        ),
                                                        Spacer(),
                                                        GestureDetector(
                                                          onTap: () =>
                                                              _showReportSheet(
                                                                context,
                                                                menteePosts,
                                                              ),
                                                          child: Row(
                                                            children: [
                                                              Image.asset(
                                                                "assets/images/ReportmenteImg.png",
                                                                width: 16,
                                                                height: 16,
                                                              ),
                                                              SizedBox(
                                                                width: 5,
                                                              ),
                                                              Text(
                                                                'Report',
                                                                style: TextStyle(
                                                                  fontSize: 14,
                                                                  color: Colors
                                                                      .black87,
                                                                  fontFamily:
                                                                      'segeo',
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w400,
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ],
                                                ),
                                              ],
                                            ),
                                          ),
                                        );
                                      },
                                      childCount: menteeProfile
                                          .data
                                          ?.user
                                          ?.communityPost
                                          ?.length,
                                    ),
                                  ),
                                ],
                              ),
                            );
                          } else {
                            if (menteeProfile
                                    .data
                                    ?.user
                                    ?.studyZoneBooks
                                    ?.length ==
                                0) {
                              return Center(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Image.asset(
                                      "assets/nodata/no_data.png",
                                      height: 120,
                                    ),
                                    const SizedBox(height: 16),
                                    const Text(
                                      "No Resources Available",
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
                            return CustomScrollView(
                              slivers: [
                                SliverPadding(
                                  padding: EdgeInsets.only(top: 16),
                                  sliver: SliverList(
                                    delegate: SliverChildBuilderDelegate(
                                      (context, index) {
                                        final campusList = menteeProfile
                                            .data
                                            ?.user
                                            ?.studyZoneBooks?[index];
                                        return GestureDetector(
                                          onTap: () {
                                            context.push(
                                              '/resource_details_screen/${campusList?.id}',
                                            );
                                          },
                                          child: Container(
                                            margin: EdgeInsets.only(
                                              bottom: 16,
                                              left: 16,
                                              right: 16,
                                            ),
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(24),
                                              color: Colors.white,
                                            ),

                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              children: [
                                                Padding(
                                                  padding: EdgeInsets.only(
                                                    left: 10,
                                                    top: 16,
                                                    bottom: 16,
                                                  ),
                                                  child: ClipRRect(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                          4,
                                                        ),
                                                    child: CachedNetworkImage(
                                                      width:
                                                          MediaQuery.of(
                                                            context,
                                                          ).size.width *
                                                          0.25,
                                                      height: 130,
                                                      imageUrl:
                                                          campusList?.image ??
                                                          "",
                                                      fit: BoxFit.cover,
                                                      placeholder:
                                                          (
                                                            context,
                                                            url,
                                                          ) => SizedBox(
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
                                                              Icons
                                                                  .broken_image,
                                                              size: 40,
                                                              color:
                                                                  Colors.grey,
                                                            ),
                                                          ),
                                                    ),
                                                  ),
                                                ),
                                                Expanded(
                                                  child: Padding(
                                                    padding:
                                                        const EdgeInsets.all(
                                                          8.0,
                                                        ),
                                                    child: Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        Text(
                                                          campusList?.title ??
                                                              "",
                                                          overflow: TextOverflow
                                                              .ellipsis,
                                                          style: TextStyle(
                                                            fontFamily: 'segeo',
                                                            fontWeight:
                                                                FontWeight.w700,
                                                            fontSize: 12,
                                                            height: 1,
                                                            letterSpacing: 0.5,
                                                          ),
                                                        ),
                                                        const SizedBox(
                                                          height: 8,
                                                        ),
                                                        Text(
                                                          campusList
                                                                  ?.description ??
                                                              "",
                                                          maxLines: 3,
                                                          style:
                                                              const TextStyle(
                                                                fontFamily:
                                                                    'segeo',
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w400,
                                                                fontSize: 11,
                                                                height: 1,
                                                              ),
                                                        ),
                                                        SizedBox(height: 12),
                                                        if (campusList
                                                                ?.tags
                                                                ?.isNotEmpty ??
                                                            false)
                                                          Wrap(
                                                            spacing: 8,
                                                            runSpacing: 8,
                                                            children: campusList!.tags!.map((
                                                              tag,
                                                            ) {
                                                              return Container(
                                                                padding:
                                                                    EdgeInsets.symmetric(
                                                                      horizontal:
                                                                          12,
                                                                      vertical:
                                                                          6,
                                                                    ),
                                                                decoration: BoxDecoration(
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
                                                                    fontSize:
                                                                        12,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w600,
                                                                  ),
                                                                ),
                                                              );
                                                            }).toList(),
                                                          ),
                                                        SizedBox(height: 16),
                                                        Row(
                                                          spacing: 3,
                                                          children: [
                                                            Expanded(
                                                              child: CustomOutlinedButton(
                                                                radius: 24,
                                                                height: 38,
                                                                text: "View",
                                                                onTap: () {
                                                                  context.push(
                                                                    "/pdf_viewer?file_url=${campusList?.filePdf ?? ""}",
                                                                  );
                                                                },
                                                              ),
                                                            ),
                                                            BlocConsumer<
                                                              AddResourceCubit,
                                                              AddResourceStates
                                                            >(
                                                              listener: (context, state) {
                                                                if (state
                                                                    is AddResourceLoaded) {
                                                                  CustomSnackBar1.show(
                                                                    context,
                                                                    "Downloaded Successfully",
                                                                  );
                                                                } else if (state
                                                                    is AddResourceFailure) {
                                                                  CustomSnackBar1.show(
                                                                    context,
                                                                    state
                                                                            .error
                                                                            .isNotEmpty
                                                                        ? state
                                                                              .error
                                                                        : "Download Failed",
                                                                  );
                                                                }
                                                              },
                                                              builder: (context, state) {
                                                                final currentId =
                                                                    campusList
                                                                        ?.id
                                                                        .toString() ??
                                                                    "";
                                                                final isLoading =
                                                                    state
                                                                        is AddResourceLoading &&
                                                                    state.resourceId ==
                                                                        currentId;

                                                                return Expanded(
                                                                  child: CustomAppButton1(
                                                                    radius: 24,
                                                                    height: 38,
                                                                    isLoading:
                                                                        isLoading,
                                                                    text:
                                                                        "Download",
                                                                    textSize:
                                                                        14,
                                                                    onPlusTap: () {
                                                                      context
                                                                          .read<
                                                                            AddResourceCubit
                                                                          >()
                                                                          .resourceDownload(
                                                                            currentId,
                                                                          );
                                                                    },
                                                                  ),
                                                                );
                                                              },
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
                                      childCount: menteeProfile
                                          .data
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
              } else if (state is CommonProfileFailure) {
                return SizedBox(
                  height: 180,
                  child: Center(child: Text(state.message)),
                );
              }
              return Center(child: Text("No Data "));
            },
          ),
        ),
      ),
    );
  }

  void _showReportSheet(BuildContext context, communityPosts) {
    String _selected = 'False Information';
    final TextEditingController _otherController = TextEditingController();
    final List<String> _reportReasons = [
      'Copied',
      'Scam or Fraud ',
      'Abusing Post',
      'Other',
    ];

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (BuildContext builderContext) {
        return SafeArea(
          child: StatefulBuilder(
            builder: (BuildContext context, StateSetter setState) {
              return Padding(
                padding: EdgeInsets.only(
                  bottom: MediaQuery.of(context).viewInsets.bottom,
                  left: 16,
                  right: 16,
                  top: 16,
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Post Report',
                          style: TextStyle(
                            fontSize: 20,
                            color: Color(0xff444444),
                            fontFamily: 'segeo',
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.close, color: Colors.grey),
                          onPressed: () => Navigator.of(context).pop(),
                        ),
                      ],
                    ),
                    Column(
                      children: _reportReasons.map((String reason) {
                        return RadioListTile<String>(
                          title: Text(
                            reason,
                            style: const TextStyle(
                              fontFamily: 'segeo',
                              fontSize: 16,
                            ),
                          ),
                          value: reason,
                          visualDensity: VisualDensity.compact,
                          groupValue: _selected,
                          onChanged: (String? value) {
                            setState(() {
                              _selected = value!;
                            });
                          },
                          activeColor: const Color(0xFF4A00E0),
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 8,
                          ),
                        );
                      }).toList(),
                    ),
                    // Custom Reason TextField
                    if (_selected == 'Other') ...[
                      const SizedBox(height: 16),
                      TextField(
                        controller: _otherController,
                        maxLines: 3,
                        decoration: InputDecoration(
                          hintText: 'Please explain your reason',
                          hintStyle: const TextStyle(fontFamily: 'segeo'),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 12,
                          ),
                        ),
                      ),
                    ],
                    const SizedBox(height: 24),
                    BlocConsumer<
                      CommunityZoneReportCubit,
                      CommunityZoneReportState
                    >(
                      listener: (context, state) {
                        if (state is CommunityZoneReportSuccess) {
                          CustomSnackBar1.show(
                            context,
                            "Report submitted successfully.",
                          );
                          context.pop();
                        } else if (state is CommunityZoneReportFailure) {
                          return CustomSnackBar1.show(
                            context,
                            state.message ?? "",
                          );
                        }
                      },
                      builder: (context, state) {
                        return SafeArea(
                          child: CustomAppButton1(
                            isLoading: state is CommunityZoneReportLoading,
                            text: "Submit Report",
                            onPlusTap: () {
                              final Map<String, dynamic> data = {
                                "content_id": communityPosts.id,
                                "reason": _selected,
                              };
                              context
                                  .read<CommunityZoneReportCubit>()
                                  .postCommunityZoneReport(data);
                            },
                          ),
                        );
                      },
                    ),
                    const SizedBox(height: 16),
                  ],
                ),
              );
            },
          ),
        );
      },
    );
  }
}

class MenteeProfileShimmer extends StatelessWidget {
  const MenteeProfileShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFFFAF5FF), Color(0xFFF2F4FD)],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
      ),
      child: SingleChildScrollView(
        padding: const EdgeInsets.only(top: 20, bottom: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            shimmerCircle(120, context),
            const SizedBox(height: 12),
            shimmerText(120, 16, context),
            const SizedBox(height: 8),
            shimmerText(180, 14, context),
            const SizedBox(height: 8),
            shimmerText(160, 14, context),
            const SizedBox(height: 16),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32),
              child: Column(
                children: [
                  shimmerText(double.infinity, 12, context),
                  const SizedBox(height: 6),
                  shimmerText(double.infinity, 12, context),
                  const SizedBox(height: 6),
                  shimmerText(220, 12, context),
                ],
              ),
            ),

            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                shimmerContainer(100, 36, context, isButton: true),
                const SizedBox(width: 16),
                shimmerContainer(100, 36, context, isButton: true),
              ],
            ),

            const SizedBox(height: 20),

            // 🔹 Tabs: Post / Resources
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                children: [
                  Expanded(child: shimmerText(80, 14, context)),
                  Expanded(child: shimmerText(80, 14, context)),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // 🔹 Simulate 3 Post Cards (for Post tab)
            ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: 3,
              separatorBuilder: (_, __) => const SizedBox(height: 12),
              itemBuilder: (context, index) => Container(
                margin: const EdgeInsets.symmetric(horizontal: 16),
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  color: Colors.white,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Post Image
                    shimmerContainer(double.infinity, 160, context),
                    const SizedBox(height: 8),
                    // Post Title
                    shimmerText(160, 14, context),
                    const SizedBox(height: 6),
                    // Post Content
                    shimmerText(double.infinity, 12, context),
                    const SizedBox(height: 4),
                    shimmerText(220, 12, context),
                    const SizedBox(height: 8),
                    // Like & Comment Icons Row
                    Row(
                      children: [
                        shimmerCircle(16, context),
                        const SizedBox(width: 8),
                        shimmerText(30, 10, context),
                        const SizedBox(width: 20),
                        shimmerCircle(16, context),
                        const SizedBox(width: 8),
                        shimmerText(30, 10, context),
                      ],
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 20),

            // 🔹 Resource Placeholder (for Resources tab)
            ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: 2,
              separatorBuilder: (_, __) => const SizedBox(height: 12),
              itemBuilder: (context, index) => Container(
                margin: const EdgeInsets.symmetric(horizontal: 16),
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  color: Colors.white,
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    shimmerContainer(90, 120, context),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          shimmerText(140, 14, context),
                          const SizedBox(height: 6),
                          shimmerText(double.infinity, 12, context),
                          const SizedBox(height: 6),
                          shimmerText(200, 12, context),
                          const SizedBox(height: 12),
                          Row(
                            children: [
                              shimmerContainer(80, 28, context, isButton: true),
                              const SizedBox(width: 12),
                              shimmerContainer(
                                100,
                                28,
                                context,
                                isButton: true,
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
