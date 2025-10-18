import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:mentivisor/Components/CutomAppBar.dart';
import 'package:mentivisor/Mentee/data/cubits/CommunityDetails/CommunityDetailsCubit.dart';
import 'package:share_plus/share_plus.dart';

import '../../../Components/CommonLoader.dart';
import '../../../Components/CustomAppButton.dart';
import '../../../Components/CustomSnackBar.dart';
import '../../../services/AuthService.dart';
import '../../../utils/constants.dart';
import '../../../utils/media_query_helper.dart';
import '../../../utils/spinkittsLoader.dart';
import '../../Models/CommunityPostsModel.dart';
import '../../data/cubits/CommunityDetails/CommunityDetailsState.dart';
import '../../data/cubits/CommunityPostReport/CommunityZoneReportCubit.dart';
import '../../data/cubits/CommunityPostReport/CommunityZoneReportState.dart';
import '../../data/cubits/PostComment/post_comment_cubit.dart';
import '../../data/cubits/PostComment/post_comment_states.dart';
import '../Widgets/CommentBottomSheet.dart';

class CommunityDetails extends StatefulWidget {
  final int communityId;
  final String scope;

  const CommunityDetails({
    super.key,
    required this.communityId,
    required this.scope,
  });

  @override
  State<CommunityDetails> createState() => _CommunityDetailsState();
}

class _CommunityDetailsState extends State<CommunityDetails> {

  @override
  void initState() {
    super.initState();
    context.read<CommunityDetailsCubit>().communityDetails(
      widget.communityId,
      widget.scope,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar1(title: "Post Details", actions: []),
      body: Container(
        color: Color(0xffF4F8FD),
        child: BlocBuilder<CommunityDetailsCubit, CommunityDetailsState>(
          builder: (context, state) {
            if (state is CommunityDetailsLoading) {
              return const Center(child: DottedProgressWithLogo());
            } else if (state is CommunityDetailsLoaded) {
              final communityDetails =
                  state.communityDetailsModel.communityposts;
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16.0,
                      vertical: 10,
                    ),
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        GestureDetector(
                          onDoubleTap: () async {},
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: CachedNetworkImage(
                              height: 160,
                              imageUrl: communityDetails?.imgUrl ?? "",
                              fit: BoxFit.cover,
                              width: SizeConfig.screenWidth,
                              placeholder: (context, url) => Center(
                                child: spinkits.getSpinningLinespinkit(),
                              ),
                              errorWidget: (context, url, error) => Container(
                                height: 160,
                                color: Colors.grey.shade100,
                                child: const Icon(
                                  Icons.broken_image,
                                  size: 40,
                                  color: Colors.grey,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.all(12),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (communityDetails?.anonymous == 0)
                          Row(
                            children: [
                              GestureDetector(
                                onTap: () {
                                  // if (widget.communityPosts.anonymous == 1) {
                                  //   CustomSnackBar1.show(
                                  //     context,
                                  //     "Anonymous post user profile cannot be visited.",
                                  //   );
                                  // } else {
                                  context.push(
                                    "/common_profile/${communityDetails?.uploader?.id}",
                                  );
                                  // }
                                },
                                child:
                                    communityDetails
                                            ?.uploader
                                            ?.profilePicUrl
                                            ?.isEmpty ==
                                        true
                                    ? CircleAvatar(
                                        radius: 16,
                                        backgroundColor: Colors.grey.shade400,
                                        child: Text(
                                          communityDetails?.uploader?.name![0]
                                                  .toUpperCase() ??
                                              "",
                                          style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.white,
                                          ),
                                        ),
                                      )
                                    : CachedNetworkImage(
                                        imageUrl:
                                            communityDetails?.anonymous == 1
                                            ? "assets/images/profile.png"
                                            : communityDetails
                                                      ?.uploader
                                                      ?.profilePicUrl ??
                                                  "",
                                        imageBuilder:
                                            (context, imageProvider) =>
                                                CircleAvatar(
                                                  radius: 16,
                                                  backgroundImage:
                                                      imageProvider,
                                                ),
                                        placeholder: (context, url) =>
                                            CircleAvatar(
                                              radius: 16,
                                              backgroundColor: Colors.grey,
                                              child: SizedBox(
                                                width: 14,
                                                height: 14,
                                                child: Center(
                                                  child: spinkits
                                                      .getSpinningLinespinkit(),
                                                ),
                                              ),
                                            ),
                                        errorWidget: (context, url, error) =>
                                            const CircleAvatar(
                                              radius: 16,
                                              backgroundImage: AssetImage(
                                                "assets/images/profile.png",
                                              ),
                                            ),
                                      ),
                              ),
                              const SizedBox(width: 8),
                              Text(
                                communityDetails?.anonymous == 1
                                    ? "Anonymous"
                                    : capitalize(
                                        communityDetails?.uploader?.name ?? "",
                                      ),
                                style: const TextStyle(
                                  fontFamily: 'segeo',
                                  fontWeight: FontWeight.w400,
                                  fontSize: 12,
                                  color: Color(0xff222222),
                                ),
                              ),
                            ],
                          ),
                        const SizedBox(height: 4),
                        Text(
                          communityDetails?.heading ?? "",
                          style: const TextStyle(
                            fontFamily: 'segeo',
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                            color: Color(0xFF222222),
                          ),
                        ),

                        const SizedBox(height: 4),
                        Text(
                          communityDetails?.description ?? "",
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontFamily: 'segeo',
                            fontWeight: FontWeight.w400,
                            fontSize: 14,
                            color: Color(0xFF666666),
                          ),
                        ),

                        const SizedBox(height: 8),
                        FutureBuilder(
                          future: AuthService.isGuest,
                          builder: (context, snapshot) {
                            final isGuest = snapshot.data ?? false;
                            return StatefulBuilder(
                              builder: (context, setState) {
                                return Row(
                                  children: [
                                    BlocBuilder<
                                      PostCommentCubit,
                                      PostCommentStates
                                    >(
                                      builder: (context, commentState) {
                                        return Row(
                                          children: [
                                            IconButton(
                                              visualDensity:
                                                  VisualDensity.compact,
                                              padding: EdgeInsets.zero,
                                              onPressed: () {
                                                if (isGuest) {
                                                  context.push('/auth_landing');
                                                } else {
                                                  final data = {
                                                    "community_id":
                                                        communityDetails?.id,
                                                  };
                                                  context
                                                      .read<PostCommentCubit>()
                                                      .postLike(
                                                        data,
                                                        communityDetails!,
                                                      );
                                                }
                                              },
                                              icon: Icon(
                                                (communityDetails?.isLiked ??
                                                        false)
                                                    ? Icons.favorite
                                                    : Icons.favorite_border,
                                                size: 16,
                                                color:
                                                    (communityDetails
                                                            ?.isLiked ??
                                                        false)
                                                    ? Colors.red
                                                    : Colors.black26,
                                              ),
                                            ),
                                            Text(
                                              "${communityDetails?.likesCount ?? 0}",
                                              style: const TextStyle(
                                                color: Color(0xff666666),
                                                fontSize: 14,
                                                fontFamily: 'segeo',
                                                fontWeight: FontWeight.w400,
                                              ),
                                            ),
                                          ],
                                        );
                                      },
                                    ),
                                    Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        IconButton(
                                          visualDensity: VisualDensity.compact,
                                          padding: EdgeInsets.zero,
                                          onPressed: () {
                                            if (isGuest) {
                                              context.push('/auth_landing');
                                            } else {
                                              showModalBottomSheet(
                                                context: context,
                                                isScrollControlled: true,
                                                useRootNavigator: true,
                                                backgroundColor:
                                                    Colors.transparent,
                                                builder: (context) {
                                                  return DraggableScrollableSheet(
                                                    initialChildSize: 0.8,
                                                    minChildSize: 0.4,
                                                    maxChildSize: 0.95,
                                                    expand: false,
                                                    builder: (_, scrollController) => Container(
                                                      decoration: const BoxDecoration(
                                                        color: Color(
                                                          0xffF4F8FD,
                                                        ),
                                                        borderRadius:
                                                            BorderRadius.vertical(
                                                              top:
                                                                  Radius.circular(
                                                                    16,
                                                                  ),
                                                            ),
                                                      ),
                                                      padding:
                                                          const EdgeInsets.symmetric(
                                                            horizontal: 16,
                                                            vertical: 12,
                                                          ),
                                                      child: CommentBottomSheet(
                                                        communityPost:
                                                            communityDetails ??
                                                            CommunityPosts(),
                                                        scrollController:
                                                            scrollController,
                                                      ),
                                                    ),
                                                  );
                                                },
                                              );
                                            }
                                          },
                                          icon: Image.asset(
                                            "assets/icons/Chat.png",
                                            width: 18,
                                            height: 18,
                                          ),
                                        ),
                                        BlocBuilder<
                                          PostCommentCubit,
                                          PostCommentStates
                                        >(
                                          builder: (context, state) {
                                            return Text(
                                              communityDetails?.commentsCount
                                                      ?.toString() ??
                                                  "0",
                                              style: const TextStyle(
                                                fontFamily: 'segeo',
                                              ),
                                            );
                                          },
                                        ),
                                      ],
                                    ),
                                    IconButton(
                                      padding: EdgeInsets
                                          .zero, // remove default extra padding
                                      visualDensity: VisualDensity.compact,
                                      icon: Image.asset(
                                        'assets/icons/share.png',
                                        width: 16,
                                        height: 16,
                                      ),
                                      onPressed: () async {
                                        final postId = communityDetails?.id;
                                        final shareUrl =
                                            "https://mentivisor.com/community_post/$postId";
                                        Share.share(
                                          "Check out this Community Post on Mentivisor:\n$shareUrl",
                                          subject: "Mentivisor Community Post",
                                        );
                                      },
                                    ),
                                    Spacer(),
                                    GestureDetector(
                                      onTap: () => _showReportSheet(
                                        context,
                                        communityDetails,
                                      ),
                                      child: Row(
                                        children: [
                                          Image.asset(
                                            "assets/images/ReportmenteImg.png",
                                            width: 16,
                                            height: 16,
                                          ),
                                          SizedBox(width: 5),
                                          Text(
                                            'Report',
                                            style: TextStyle(
                                              fontSize: 14,
                                              color: Colors.black87,
                                              fontFamily: 'segeo',
                                              fontWeight: FontWeight.w400,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                );
                              },
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                ],
              );
            } else if (state is CommunityDetailsFailure) {
              return Center(child: Text(state.message));
            } else {
              return Center(child: Text("No Data"));
            }
          },
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
