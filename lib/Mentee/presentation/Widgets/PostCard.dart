import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:mentivisor/Components/CustomSnackBar.dart';
import 'package:mentivisor/Mentee/data/cubits/CommunityPostReport/CommunityZoneReportCubit.dart';
import 'package:mentivisor/services/AuthService.dart';
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
  final CommunityPosts communityPosts;
  const PostCard({Key? key, required this.communityPosts}) : super(key: key);

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
                          height: 160,
                          imageUrl: widget.communityPosts.imgUrl ?? "",
                          fit: BoxFit.cover,
                          width: SizeConfig.screenWidth,
                          placeholder: (context, url) =>
                              Center(child: spinkits.getSpinningLinespinkit()),
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
                    Row(
                      children: [
                        CachedNetworkImage(
                          imageUrl: widget.communityPosts.image ?? "",
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
                                child: spinkits.getSpinningLinespinkit(),
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
                        const SizedBox(width: 8),
                        Text(
                          capitalize(
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
                                      children: [
                                        GestureDetector(
                                          onTap: () {
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
                                          child: Icon(
                                            (post.isLiked ?? false)
                                                ? Icons.favorite
                                                : Icons.favorite_border,
                                            size: 16,
                                            color: (post.isLiked ?? false)
                                                ? Colors.red
                                                : Colors.black26,
                                          ),
                                        ),
                                        const SizedBox(width: 4),
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

                                const SizedBox(width: 12),

                                // Comments
                                GestureDetector(
                                  onTap: () {
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
                                            builder: (_, scrollController) =>
                                                Container(
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
                                  child: Row(
                                    children: [
                                      Image.asset(
                                        "assets/icons/Chat.png",
                                        width: 16,
                                        height: 16,
                                      ),
                                      const SizedBox(width: 6),
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
                                ),
                                // Share
                                IconButton(
                                  padding: EdgeInsets.zero, // remove default extra padding
                                  visualDensity: VisualDensity.compact,
                                  icon: Image.asset(
                                    'assets/icons/share.png',
                                    width: 16,
                                    height: 16,
                                  ),
                                  onPressed: () async {
                                    final postId = widget.communityPosts.id;
                                    final shareUrl = "https://mentivisor.com/community_post/$postId";

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
