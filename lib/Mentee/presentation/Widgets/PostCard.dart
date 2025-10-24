import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:go_router/go_router.dart';
import 'package:mentivisor/Components/CustomSnackBar.dart';
import 'package:mentivisor/Components/Shimmers.dart';
import 'package:mentivisor/Mentee/data/cubits/CommunityPostReport/CommunityZoneReportCubit.dart';
import 'package:mentivisor/services/AuthService.dart';
import 'package:mentivisor/utils/AppLogger.dart';
import 'package:mentivisor/utils/constants.dart';
import 'package:mentivisor/utils/media_query_helper.dart';
import 'package:share_plus/share_plus.dart';

import '../../../Components/CustomAppButton.dart';
import '../../../utils/spinkittsLoader.dart';
import '../../Models/CommunityPostsModel.dart';
import '../../data/cubits/CommunityPostReport/CommunityZoneReportState.dart';
import '../../data/cubits/PostComment/post_comment_cubit.dart';
import '../../data/cubits/PostComment/post_comment_states.dart';
import 'CommentBottomSheet.dart';

class PostCard extends StatefulWidget {
  final String scope;
  final CommunityPosts communityPosts;
  const PostCard({Key? key, required this.communityPosts, required this.scope})
    : super(key: key);

  @override
  State<PostCard> createState() => _PostCardState();
}

class _PostCardState extends State<PostCard>
    with SingleTickerProviderStateMixin {
  bool _showHeart = false;
  late AnimationController _animationController;
  late Animation<double> _heartAnimation;
  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );
    _heartAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );

    _animationController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        setState(() {
          _showHeart = false;
        });
        _animationController.reset();
      }
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _handleDoubleTap() {
    final post = widget.communityPosts;
    if (!(post.isLiked ?? false)) {
      setState(() {
        _showHeart = true;
      });
      _animationController.forward();
      final Map<String, dynamic> data = {"community_id": post.id};
      context.read<PostCommentCubit>().postLike(data, post);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: widget.communityPosts.popular == 1
            ? const Color(0xffFFF7CE)
            : Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Stack(
        children: [
          Column(
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
                      onTap: () async {
                        final isGuest = await AuthService.isGuest;
                        if (isGuest) {
                          if (mounted) context.push('/auth_landing');
                        } else {
                          context.push(
                            "/community_details/${widget.communityPosts.id}?scope=${widget.scope}",
                          );
                        }
                      },
                      onDoubleTap: () async {
                        final isGuest = await AuthService.isGuest;
                        if (isGuest) {
                          if (mounted) context.push('/auth_landing');
                        } else {
                          _handleDoubleTap();
                        }
                      },
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: CachedNetworkImage(
                          imageUrl: widget.communityPosts.imgUrl ?? "",
                          fit: BoxFit.cover,
                          width: SizeConfig.screenWidth,
                          placeholder: (context, url) => Container(
                            height: 160,
                            color: Colors.grey.shade100,
                            child: Center(
                              child: spinkits.getSpinningLinespinkit(),
                            ),
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
                    if (_showHeart)
                      AnimatedBuilder(
                        animation: _heartAnimation,
                        builder: (context, child) {
                          return Opacity(
                            opacity: _heartAnimation.value,
                            child: Transform.scale(
                              scale: _heartAnimation.value * 0.5 + 0.5,
                              child: const Icon(
                                Icons.favorite,
                                color: Colors.red,
                                size: 80,
                              ),
                            ),
                          );
                        },
                      ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (widget.communityPosts.anonymous == 0)
                      Row(
                        children: [
                          GestureDetector(
                            onTap: () async {
                              final userIdStr =
                                  await AuthService.getUSerId(); // String? like "107"
                              final userId = int.tryParse(
                                userIdStr ?? '',
                              ); // Parse to int, default 0 if null/invalid
                              AppLogger.info(
                                "userId::$userId (parsed as int: $userId)",
                              );

                              final uploaderId =
                                  widget.communityPosts.uploader?.id;
                              if (userId == uploaderId) {
                                context.push("/profile");
                                AppLogger.info(
                                  "Navigating to own profile (userId: $userId == uploaderId: $uploaderId)",
                                );
                                AppLogger.info("profile::true");
                              } else {
                                context.push("/common_profile/$uploaderId");
                                AppLogger.info(
                                  "Navigating to common profile (userId: $userId != uploaderId: $uploaderId)",
                                );
                                AppLogger.info("profile::false...$uploaderId");
                              }
                            },
                            child: widget.communityPosts.imgUrl?.isEmpty == true
                                ? CircleAvatar(
                                    radius: 16,
                                    backgroundColor: Colors.grey.shade400,
                                    child: Text(
                                      widget.communityPosts.uploader?.name![0]
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
                                        widget.communityPosts.anonymous == 1
                                        ? "assets/images/profile.png"
                                        : widget
                                                  .communityPosts
                                                  .uploader
                                                  ?.profilePicUrl ??
                                              "",
                                    imageBuilder: (context, imageProvider) =>
                                        CircleAvatar(
                                          radius: 16,
                                          backgroundImage: imageProvider,
                                        ),
                                    placeholder: (context, url) => CircleAvatar(
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
                            widget.communityPosts.anonymous == 1
                                ? "Anonymous"
                                : capitalize(
                                    widget.communityPosts.uploader?.name ?? "",
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
                      widget.communityPosts.heading ?? "",
                      style: const TextStyle(
                        fontFamily: 'segeo',
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        color: Color(0xFF222222),
                      ),
                    ),

                    const SizedBox(height: 4),
                    Text(
                      widget.communityPosts.description ?? "",
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontFamily: 'segeo',
                        fontWeight: FontWeight.w400,
                        fontSize: 14,
                        color: Color(0xFF666666),
                      ),
                    ),

                    /// Likes, Comments & Share
                    FutureBuilder(
                      future: AuthService.isGuest,
                      builder: (context, snapshot) {
                        final isGuest = snapshot.data ?? false;
                        return StatefulBuilder(
                          builder: (context, setState) {
                            return Row(
                              children: [
                                // Likes
                                BlocBuilder<
                                  PostCommentCubit,
                                  PostCommentStates
                                >(
                                  builder: (context, state) {
                                    final post = widget.communityPosts;
                                    return Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        IconButton(
                                          visualDensity: VisualDensity.compact,
                                          padding: EdgeInsets.zero,
                                          onPressed: () {
                                            if (isGuest) {
                                              context.push('/auth_landing');
                                            } else {
                                              final data = {
                                                "community_id": post.id,
                                              };
                                              context
                                                  .read<PostCommentCubit>()
                                                  .postLike(data, post);
                                            }
                                          },
                                          icon: Icon(
                                            (post.isLiked ?? false)
                                                ? Icons.favorite
                                                : Icons.favorite_border,
                                            size: 16,
                                            color: (post.isLiked ?? false)
                                                ? Colors.red
                                                : Colors.black26,
                                          ),
                                        ),
                                        Text(
                                          "${post.likesCount ?? 0}",
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
                                            backgroundColor: Colors.transparent,
                                            builder: (context) {
                                              return DraggableScrollableSheet(
                                                initialChildSize: 0.8,
                                                minChildSize: 0.4,
                                                maxChildSize: 0.95,
                                                expand: false,
                                                builder: (_, scrollController) => Container(
                                                  decoration: const BoxDecoration(
                                                    color: Color(0xffF4F8FD),
                                                    borderRadius:
                                                        BorderRadius.vertical(
                                                          top: Radius.circular(
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
                                                        widget.communityPosts,
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
                                          widget.communityPosts.commentsCount
                                              .toString(),
                                          style: const TextStyle(
                                            fontFamily: 'segeo',
                                          ),
                                        );
                                      },
                                    ),
                                  ],
                                ),

                                // Share
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
                                    final postId = widget.communityPosts.id;
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
                                    widget.communityPosts,
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
          ),

          // 🔹 Highlight Ribbon (only if popular)
          if (widget.communityPosts.popular == 1)
            Positioned(
              top: 0,
              right: 0,
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 4,
                ),
                decoration: const BoxDecoration(
                  color: Color(0xffFFD700),
                  borderRadius: BorderRadius.only(
                    topRight: Radius.circular(12),
                    bottomLeft: Radius.circular(8),
                  ),
                ),
                child: Row(
                  children: [
                    Image.asset(
                      "assets/icons/Sparkle.png",
                      width: 16,
                      height: 16,
                    ),
                    const SizedBox(width: 6),
                    const Text(
                      "Highlighted",
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'segeo',
                        color: Color(0xff5E5E5E),
                      ),
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }
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

class CommunityPostShimmer extends StatelessWidget {
  final int itemCount;
  const CommunityPostShimmer({super.key, this.itemCount = 6});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: const [
          BoxShadow(
            color: Color(0x0F0E1240),
            blurRadius: 14,
            offset: Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: shimmerContainer(SizeConfig.screenWidth, 140, context),
            ),
          ),

          const SizedBox(height: 12),

          /// 👤 Profile shimmer
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: Row(
              children: [
                shimmerCircle(32, context),
                const SizedBox(width: 10),
                shimmerText(100, 12, context),
              ],
            ),
          ),

          const SizedBox(height: 12),

          /// 🏷 Title
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: shimmerText(180, 16, context),
          ),

          const SizedBox(height: 8),

          /// 📝 Description
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                shimmerText(250, 14, context),
                const SizedBox(height: 6),
                shimmerText(200, 14, context),
              ],
            ),
          ),

          const SizedBox(height: 16),

          /// ❤️ 💬 🔄 Like / Comment / Share Row
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: Row(
              children: [
                shimmerCircle(20, context),
                const SizedBox(width: 8),
                shimmerText(24, 10, context),
                const SizedBox(width: 20),
                shimmerCircle(20, context),
                const SizedBox(width: 8),
                shimmerText(24, 10, context),
                const SizedBox(width: 20),
                shimmerCircle(20, context),
                const SizedBox(width: 8),
                shimmerText(24, 10, context),
                const Spacer(),
                shimmerText(60, 12, context),
              ],
            ),
          ),

          const SizedBox(height: 12),
        ],
      ),
    );
  }
}
