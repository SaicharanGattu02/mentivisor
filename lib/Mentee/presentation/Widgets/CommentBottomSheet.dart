import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mentivisor/Components/CustomSnackBar.dart';
import 'package:mentivisor/Mentee/data/cubits/PostComment/post_comment_cubit.dart';
import 'package:mentivisor/Mentee/data/cubits/PostComment/post_comment_states.dart';
import '../../../Components/CommonLoader.dart';
import '../../../utils/constants.dart';
import '../../../utils/spinkittsLoader.dart';
import '../../Models/CommentsModel.dart';
import '../../Models/CommunityPostsModel.dart' hide Data;
import '../../data/cubits/Comments/FetchCommentsCubit.dart';
import '../../data/cubits/Comments/FetchCommentsStates.dart';
import 'CommentCard.dart';

class CommentBottomSheet extends StatefulWidget {
  final CommunityPosts communityPost;
  final ScrollController scrollController;

  const CommentBottomSheet({
    super.key,
    required this.communityPost,
    required this.scrollController,
  });

  @override
  State<CommentBottomSheet> createState() => _CommentBottomSheetState();
}

class _CommentBottomSheetState extends State<CommentBottomSheet> {
  final TextEditingController _controller = TextEditingController();

  // reply state
  int? _replyParentId; // if set, we're replying to that comment id
  String? _replyingToName;
  String? _replyingToMsg;

  @override
  void initState() {
    super.initState();
    // kick off fetch
    context.read<FetchCommentsCubit>().getComments(
      widget.communityPost.id ?? 0,
    );
  }

  void _startReply(int parentId, String displayName, String msg) {
    setState(() {
      _replyParentId = parentId;
      _replyingToName = displayName;
      _replyingToMsg = msg;
    });
  }

  void _cancelReply() {
    setState(() {
      _replyParentId = null;
      _replyingToName = null;
      _replyingToMsg = null;
    });
  }

  void _send() {
    final text = _controller.text.trim();
    if (text.isEmpty) return;

    final payload = {
      "community_id": widget.communityPost.id,
      "comments": text,
      if (_replyParentId != null) "parent_id": _replyParentId,
    };

    context.read<PostCommentCubit>().postComment(payload, widget.communityPost);
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
          top: 16,
          left: 0,
          right: 0,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'Comments',
              style: TextStyle(
                fontFamily: 'segeo',
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
             SizedBox(height: 12),
            Expanded(
              child: BlocBuilder<FetchCommentsCubit, FetchCommentsStates>(
                builder: (context, state) {
                  if (state is FetchCommentsLoading) {
                    return const Center(child: DottedProgressWithLogo());
                  }
                  if (state is FetchCommentsFailure) {
                    return Center(
                      child: Text(
                        state.error ?? "Failed to load comments",
                        style: const TextStyle(fontFamily: 'segeo'),
                      ),
                    );
                  }
                  if (state is FetchCommentsLoaded) {
                    final list =
                        state.commentsModel.data ?? <CommunityOnComments>[];
                    if (list.isEmpty) {
                      return const Center(
                        child: Text(
                          "No comments yet",
                          style: TextStyle(fontFamily: 'segeo'),
                        ),
                      );
                    }

                    return RefreshIndicator(
                      onRefresh: () async {
                        await context.read<FetchCommentsCubit>().getComments(
                          widget.communityPost.id ?? 0,
                        );
                      },
                      child: ListView.builder(
                        controller: widget.scrollController,
                        itemCount: list.length,
                        itemBuilder: (ctx, i) {
                          final c = list[i];
                          return StatefulBuilder(
                            builder: (context, setState) {
                              return CommentCard(
                                id: c.id!,
                                name: c.user?.name ?? 'Unknown',
                                profileUrl: c.user?.profilePicUrl ?? '',
                                content: c.content ?? '',
                                createdAt: c.createdAt ?? '',
                                isLiked: c.isLiked,
                                likesCount: c.likesCount,
                                onLike: () {
                                  final wasLiked = c.isLiked ?? false;
                                  setState(() {
                                    c.isLiked = !wasLiked;
                                    c.likesCount = wasLiked
                                        ? (c.likesCount ?? 0) - 1
                                        : (c.likesCount ?? 0) + 1;
                                  });

                                  context
                                      .read<PostCommentCubit>()
                                      .postOnCommentLike(c.id!, c);
                                },

                                replies: c.replies ?? [],
                                onReplyLike: (replyId) {
                                  final reply = c.replies?.firstWhere(
                                    (r) => r.id == replyId,
                                  );
                                  if (reply != null) {
                                    final wasLiked = reply.isLiked ?? false;
                                    setState(() {
                                      reply.isLiked = !wasLiked;
                                      reply.likesCount = wasLiked
                                          ? (reply.likesCount ?? 0) - 1
                                          : (reply.likesCount ?? 0) + 1;
                                    });
                                  }
                                  context
                                      .read<PostCommentCubit>()
                                      .postOnCommentLike(replyId, c);
                                },
                                onReplyReply: (replyUserName, replyMsg) =>
                                    _startReply(c.id!, replyUserName, replyMsg),
                                onReply: () => _startReply(
                                  c.id!,
                                  c.user?.name ?? 'Unknown',
                                  c.content ?? "",
                                ),
                              );
                            },
                          );

                          // return CommentCard(
                          //   likesCount: c.likesCount,
                          //   isLiked: c.isLiked,
                          //   id: c.id!,
                          //   name: c.user?.name ?? 'Unknown',
                          //   profileUrl: c.user?.profilePicUrl ?? '',
                          //   content: c.content ?? '',
                          //   createdAt: c.createdAt ?? '',
                          //   onLike: () => context
                          //       .read<PostCommentCubit>()
                          //       .postOnCommentLike(c.id ?? 0, c),
                          //   onReply: () =>
                          //       _startReply(c.id!, c.user?.name ?? 'Unknown'),
                          //   replies: (c.replies ?? []),
                          //   onReplyLike: (replyId) {
                          //     context
                          //         .read<PostCommentCubit>()
                          //         .postOnCommentLike(replyId, c);
                          //   },
                          //   onReplyReply: (replyUserName) {
                          //     // IMPORTANT: keep parentId = top-level comment id (c.id!)
                          //     _startReply(c.id!, replyUserName);
                          //   },
                          // );
                        },
                      ),
                    );
                  }
                  // initial/unknown
                  return const SizedBox.shrink();
                },
              ),
            ),

            BlocConsumer<PostCommentCubit, PostCommentStates>(
              listener: (context, state) async {
                if (state is PostCommentLoaded) {
                  _controller.clear();
                  _cancelReply();
                  await context.read<FetchCommentsCubit>().getComments(
                    widget.communityPost.id ?? 0,
                  );
                } else if (state is PostCommentFailure) {
                  CustomSnackBar1.show(
                    context,
                    state.error ?? "Failed to post comment",
                  );
                }
              },
              builder: (context, state) {
                final isLoading = state is PostCommentLoading;

                return Padding(
                  padding: const EdgeInsets.only(top: 12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (_replyParentId != null && _replyingToName != null)
                        Padding(
                          padding: const EdgeInsets.only(bottom: 8),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Expanded(
                                    child: Text(
                                      '@ $_replyingToName',
                                      style: const TextStyle(
                                        fontFamily: 'segeo',
                                        fontSize: 14,
                                        color: Colors.grey,
                                      ),
                                    ),
                                  ),
                                  IconButton(
                                    icon: const Icon(
                                      Icons.close,
                                      color: Colors.grey,
                                      size: 20,
                                    ),
                                    onPressed: _cancelReply,
                                  ),
                                ],
                              ),

                              Text(
                                'Replying to $_replyingToMsg',
                                style: const TextStyle(
                                  fontFamily: 'segeo',
                                  fontSize: 14,
                                  color: Colors.grey,
                                ),
                              ),
                            ],
                          ),
                        ),
                      Row(
                        children: [
                          Expanded(
                            child: TextField(
                              controller: _controller,
                              decoration: InputDecoration(
                                hintText: _replyParentId != null
                                    ? 'Write a reply...'
                                    : 'Write a comment...',
                                hintStyle: const TextStyle(fontFamily: 'segeo'),
                                contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 16,
                                  vertical: 12,
                                ),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(24),
                                  borderSide: BorderSide.none,
                                ),
                                filled: true,
                                fillColor: Colors.grey.shade100,
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          isLoading
                              ? const SizedBox(
                                  width: 24,
                                  height: 24,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                  ),
                                )
                              : IconButton(
                                  icon: const Icon(
                                    Icons.send,
                                    color: Color(0xFF4076ED),
                                    size: 28,
                                  ),
                                  onPressed: _send,
                                ),
                        ],
                      ),
                    ],
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
