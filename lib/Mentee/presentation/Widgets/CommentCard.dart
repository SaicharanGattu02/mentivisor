import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:mentivisor/Mentee/data/cubits/DeleteComment/DeleteCommentCubit.dart';
import 'package:mentivisor/Mentee/data/cubits/DeleteComment/DeleteCommentStates.dart';

import '../../../Components/CustomSnackBar.dart';
import '../../../services/AuthService.dart';
import '../../../utils/AppLogger.dart';
import '../../../utils/constants.dart';
import '../../../utils/spinkittsLoader.dart';
import '../../Models/CommentsModel.dart';
import '../../data/cubits/Comments/FetchCommentsCubit.dart';


class CommentCard extends StatelessWidget {
  final int id;
  final int user_id;
  final int post_id;
  final String name;
  final String profileUrl;
  final String content;
  final String createdAt;

  final bool? isLiked; // ✅ NEW
  final int? likesCount; // ✅ already had

  final VoidCallback onLike;
  final VoidCallback onReply;
  final List<Replies> replies;

  // for replies
  final void Function(int replyId) onReplyLike;
  final void Function(String replyUserName, String replyMsg, int replyUserId)
  onReplyReply;

  const CommentCard({
    super.key,
    required this.id,
    required this.user_id,
    required this.post_id,
    required this.name,
    required this.profileUrl,
    required this.content,
    required this.createdAt,
    required this.isLiked, // ✅ NEW required param
    required this.likesCount, // ✅
    required this.onLike,
    required this.onReply,
    required this.replies,
    required this.onReplyLike,
    required this.onReplyReply,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              GestureDetector(
                onTap: () async {
                  final userIdStr =
                  await AuthService.getUSerId(); // String? like "107"
                  final userId = int.tryParse(
                    userIdStr ?? '',
                  ); // Parse to int, default 0 if null/invalid
                  AppLogger.info("userId::$userId (parsed as int: $userId)");
                  final uploaderId = user_id;
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
                child: CachedNetworkImage(
                  imageUrl: profileUrl,
                  imageBuilder: (context, imageProvider) =>
                      CircleAvatar(radius: 18, backgroundImage: imageProvider),
                  placeholder: (context, url) => CircleAvatar(
                    radius: 18,
                    backgroundColor: Colors.grey.shade300,
                    child: SizedBox(
                      width: 18,
                      height: 18,
                      child: spinkits.getSpinningLinespinkit(),
                    ),
                  ),
                  errorWidget: (context, url, error) => const CircleAvatar(
                    radius: 20,
                    backgroundImage: AssetImage("assets/images/profileimg.png"),
                  ),
                ),
              ),
              Expanded(
                child: Container(
                  margin: const EdgeInsets.only(left: 8),
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  name,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.w600,
                                    fontFamily: 'segeo',
                                    fontSize: 14,
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  DateHelper.timeAgo(createdAt),
                                  style: const TextStyle(
                                    fontSize: 12,
                                    fontFamily: 'segeo',
                                    color: Colors.grey,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          FutureBuilder(
                            future: AuthService.getUSerId(),
                            builder: (context, snapshot) {
                              if (!snapshot.hasData) return SizedBox();

                              final userId = int.tryParse(snapshot.data ?? '');
                              final uploaderId = user_id;
                              final isMyComment = (userId == uploaderId);

                              if (!isMyComment) return SizedBox(); // Hide delete button for others

                              return BlocConsumer<DeleteCommentCubit, DeleteCommentStates>(
                                listener: (context, state) {
                                  if (state is DeleteCommentLoaded) {
                                    Navigator.pop(context);
                                    context.read<FetchCommentsCubit>().getComments(post_id ?? 0);
                                  } else if (state is DeleteCommentFailure) {
                                    CustomSnackBar1.show(context, state.error);
                                  }
                                },
                                builder: (context, state) {
                                  final isLoading = state is DeleteCommentLoading;

                                  return IconButton(
                                    onPressed: isLoading
                                        ? null
                                        : () {
                                      showDeleteConfirmationDialog(
                                        context,
                                            () {
                                          context.read<DeleteCommentCubit>().deleteComment(
                                            id.toString(),
                                          );
                                        },
                                      );
                                    },
                                    icon: Image.asset(
                                      'assets/icons/delete.png',
                                      width: 25,
                                      height: 25,
                                    ),
                                  );
                                },
                              );
                            },
                          )
                        ],
                      ),
                      const SizedBox(height: 6),
                      Text(
                        content,
                        style: const TextStyle(
                          fontSize: 14,
                          fontFamily: 'segeo',
                          color: Color(0xff333333),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          GestureDetector(
                            onTap: onLike,
                            child: Row(
                              children: [
                                Icon(
                                  (isLiked ?? false)
                                      ? Icons.favorite
                                      : Icons.favorite_border,
                                  size: 16,
                                  color: (isLiked ?? false)
                                      ? Colors.red
                                      : Colors.black26,
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  "${likesCount ?? 0}",
                                  style: const TextStyle(
                                    fontSize: 12,
                                    fontFamily: "segeo",
                                    color: Colors.black54,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(width: 16),
                          TextButton(
                            onPressed: onReply,
                            style: TextButton.styleFrom(
                              padding: EdgeInsets.zero,
                              minimumSize: const Size(40, 20),
                              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                            ),
                            child: const Text(
                              "Reply",
                              style: TextStyle(
                                fontSize: 13,
                                fontFamily: 'segeo',
                                color: Color(0xFF4076ED),
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

          /// replies (one level)
          if (replies.isNotEmpty)
            Padding(
              padding: const EdgeInsets.only(left: 32, top: 8),
              child: Column(
                children: replies.map((r) {
                  return _ReplyTile(
                    reply: r,
                    post_id: post_id,
                    onLike: () => onReplyLike(r.id ?? 0),
                    onReply: () => onReplyReply(
                      r.user?.name ?? 'Unknown',
                      r.content ?? '',
                      r.user?.id ?? 0,
                    ),
                  );
                }).toList(),
              ),
            ),
        ],
      ),
    );
  }
}

Future<void> showDeleteConfirmationDialog(
  BuildContext context,
  VoidCallback onConfirm,
) async {
  return showDialog(
    context: context,
    barrierDismissible: false,
    builder: (context) {
      return BlocBuilder<DeleteCommentCubit, DeleteCommentStates>(
        builder: (context, state) {
          final isLoading = state is DeleteCommentLoading;

          return AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            title: Row(
              children: [
                Icon(Icons.warning_amber_rounded, color: Colors.red, size: 30),
                const SizedBox(width: 8),
                const Text("Delete Comment"),
              ],
            ),
            content: const Text(
              "Are you sure you want to delete this Comment? This action cannot be undone.",
            ),
            actions: [
              TextButton(
                onPressed: isLoading ? null : () => Navigator.pop(context),
                child: const Text("Cancel"),
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                onPressed: isLoading ? null : onConfirm,
                child: isLoading
                    ? const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Colors.white,
                        ),
                      )
                    : const Text("Delete"),
              ),
            ],
          );
        },
      );
    },
  );
}

class _ReplyTile extends StatelessWidget {
  final Replies reply;
  final int post_id;
  final VoidCallback onLike;
  final VoidCallback onReply;
  const _ReplyTile({
    required this.reply,
    required this.post_id,
    required this.onLike,
    required this.onReply,
  });
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          GestureDetector(
            onTap: () async {
              final userIdStr =
                  await AuthService.getUSerId(); // String? like "107"
              final userId = int.tryParse(
                userIdStr ?? '',
              ); // Parse to int, default 0 if null/invalid
              AppLogger.info("userId::$userId (parsed as int: $userId)");
              final uploaderId = userId;
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
            child: CachedNetworkImage(
              imageUrl: reply.user?.profilePicUrl ?? '',
              imageBuilder: (context, imageProvider) =>
                  CircleAvatar(radius: 16, backgroundImage: imageProvider),
              placeholder: (context, url) => CircleAvatar(
                radius: 16,
                backgroundColor: Colors.grey.shade300,
                child: SizedBox(
                  width: 16,
                  height: 16,
                  child: spinkits.getSpinningLinespinkit(),
                ),
              ),
              errorWidget: (context, url, error) => const CircleAvatar(
                radius: 16,
                backgroundImage: AssetImage("assets/images/profileimg.png"),
              ),
            ),
          ),
          Expanded(
            child: Container(
              margin: const EdgeInsets.only(left: 8),
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              reply.user?.name ?? 'Unknown',
                              style: const TextStyle(
                                fontWeight: FontWeight.w600,
                                fontFamily: 'segeo',
                                fontSize: 13,
                              ),
                            ),
                            const SizedBox(width: 8),
                            Text(
                              DateHelper.timeAgo(reply.createdAt ?? ''),
                              style: const TextStyle(
                                fontSize: 12,
                                fontFamily: 'segeo',
                                color: Colors.grey,
                              ),
                            ),
                          ],
                        ),
                      ),
                      FutureBuilder(
                        future: AuthService.getUSerId(),
                        builder: (context, snapshot) {
                          if (!snapshot.hasData) return SizedBox();

                          final loggedInUserId = int.tryParse(snapshot.data ?? '');
                          final replyUserId = reply.user?.id;

                          final isMyReply = (loggedInUserId == replyUserId);

                          if (!isMyReply) return SizedBox(); // hide delete icon

                          return BlocConsumer<DeleteCommentCubit, DeleteCommentStates>(
                            listener: (context, state) {
                              if (state is DeleteCommentFailure) {
                                CustomSnackBar1.show(context, state.error);
                              }
                            },
                            builder: (context, state) {
                              final isLoading = state is DeleteCommentLoading;

                              return IconButton(
                                onPressed: isLoading
                                    ? null
                                    : () {
                                  showDeleteConfirmationDialog(context, () {
                                    context.read<DeleteCommentCubit>().deleteComment(
                                      reply.id.toString(),
                                    );
                                  });
                                },
                                icon: Image.asset(
                                  'assets/icons/delete.png',
                                  width: 25,
                                  height: 25,
                                ),
                              );
                            },
                          );
                        },
                      )
                    ],
                  ),
                  const SizedBox(height: 4),
                  RichText(
                    text: TextSpan(
                      style: TextStyle(
                        fontSize: 13,
                        fontFamily: 'segeo',
                        color: Color(0xff333333),
                      ),
                      children: [
                        if (reply.replyTo != null && reply.replyTo!.isNotEmpty)
                          TextSpan(
                            text: "${reply.replyTo} ",
                            style: TextStyle(
                              fontWeight: FontWeight.w500,
                              color: Color(0xff2563EC),
                            ),
                          ),
                        TextSpan(text: reply.content ?? ''),
                      ],
                    ),
                  ),

                  const SizedBox(height: 6),

                  /// reply actions
                  Row(
                    children: [
                      GestureDetector(
                        onTap: onLike,
                        child: Row(
                          children: [
                            Icon(
                              (reply.isLiked ?? false)
                                  ? Icons.favorite
                                  : Icons.favorite_border,
                              size: 14,
                              color: (reply.isLiked ?? false)
                                  ? Colors.red
                                  : Colors.black26,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              "${reply.likesCount ?? 0}",
                              style: const TextStyle(
                                fontSize: 12,
                                fontFamily: "segeo",
                                color: Colors.black54,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 12),
                      TextButton(
                        onPressed: onReply,
                        style: TextButton.styleFrom(
                          padding: EdgeInsets.zero,
                          minimumSize: const Size(40, 20),
                          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        ),
                        child: const Text(
                          "Reply",
                          style: TextStyle(
                            fontSize: 13,
                            fontFamily: 'segeo',
                            color: Color(0xFF4076ED),
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
    );
  }
}
