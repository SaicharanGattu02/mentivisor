import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:mentivisor/Components/CustomSnackBar.dart';
import 'package:mentivisor/services/AuthService.dart';
import 'package:mentivisor/utils/media_query_helper.dart';

import '../../../utils/spinkittsLoader.dart';
import '../../Models/CommunityPostsModel.dart';
import '../../data/cubits/PostComment/post_comment_cubit.dart';
import '../../data/cubits/PostComment/post_comment_states.dart';
import 'CommentBottomSheet.dart';

class PostCard extends StatefulWidget {
  final CommunityPosts communityPosts;
  const PostCard({Key? key, required this.communityPosts}) : super(key: key);

  @override
  State<PostCard> createState() => _PostCardState();
}

class _PostCardState extends State<PostCard> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 0),
      decoration: BoxDecoration(
        color: widget.communityPosts.popular == 1
            ? Color(0xffFFF7CE)
            : Colors.white,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (widget.communityPosts.popular == 1) ...[
            Align(
              alignment: Alignment.topRight,
              child: Container(
                width: 150,
                padding: EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Color(0xffFFD700),
                  borderRadius: BorderRadius.only(
                    topRight: Radius.circular(8),
                    bottomRight: Radius.circular(8),
                  ),
                ),
                child: Row(
                  spacing: 10,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset(
                      "assets/icons/Sparkle.png",
                      width: 18,
                      height: 18,
                    ),
                    Text("Highlighted"),
                  ],
                ),
              ),
            ),
          ],
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: CachedNetworkImage(
                height: 160,
                imageUrl: widget.communityPosts.imgUrl ?? "",
                fit: BoxFit.cover,
                width: double.infinity,
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
          Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    CachedNetworkImage(
                      imageUrl:
                          widget.communityPosts.image ??
                          "", // listen for updates
                      imageBuilder: (context, imageProvider) => CircleAvatar(
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
                      errorWidget: (context, url, error) => const CircleAvatar(
                        radius: 16,
                        backgroundImage: AssetImage(
                          "assets/images/profile.png",
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      widget.communityPosts.uploader?.name ?? "",
                      style: const TextStyle(
                        fontFamily: 'segeo',
                        fontWeight: FontWeight.w600,
                        fontSize: 14,
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
                const SizedBox(height: 8),
                FutureBuilder(
                  future: AuthService.isGuest,
                  builder: (context, snapshot) {
                    final isGuest = snapshot.data ?? false;
                    return StatefulBuilder(
                      builder: (context, setState) {
                        return Row(
                          children: [
                            BlocBuilder<PostCommentCubit, PostCommentStates>(
                              builder: (context, state) {
                                final post = widget.communityPosts;
                                return Row(
                                  children: [
                                    GestureDetector(
                                      onTap: () {
                                        final Map<String, dynamic> data = {
                                          "community_id": post.id,
                                        };
                                        context
                                            .read<PostCommentCubit>()
                                            .postLike(data, post);
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
                                    SizedBox(width: 4),
                                    Text(
                                      "${post.likesCount ?? 0}",
                                      style: TextStyle(
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
                                        builder: (_, scrollController) => Container(
                                          decoration: const BoxDecoration(
                                            color: Colors.white,
                                            borderRadius: BorderRadius.vertical(
                                              top: Radius.circular(16),
                                            ),
                                          ),
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 16,
                                            vertical: 12,
                                          ),
                                          child: CommentBottomSheet(
                                            communityPost:
                                                widget.communityPosts,
                                            comments:
                                                (widget
                                                            .communityPosts
                                                            .comments ??
                                                        [])
                                                    .map(
                                                      (comments) => {
                                                        "name":
                                                            comments
                                                                .user
                                                                ?.name ??
                                                            "Unknown",
                                                        "profile":
                                                            comments
                                                                .user
                                                                ?.profilePicUrl ??
                                                            "assets/images/profile.png",
                                                        "comment":
                                                            comments.content ??
                                                            "",
                                                        "time":
                                                            comments
                                                                .createdAt ??
                                                            "",
                                                      },
                                                    )
                                                    .toList(),

                                            scrollController:
                                                scrollController, // pass it down
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
                                  SizedBox(width: 6),
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
                            const SizedBox(width: 12),
                            GestureDetector(
                              onTap: () {},
                              child: Image.asset(
                                'assets/icons/share.png',
                                width: 16,
                                height: 16,
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
    );
  }
}
