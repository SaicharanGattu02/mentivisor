import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import '../../../utils/constants.dart';
import '../../../utils/spinkittsLoader.dart';
import '../../Models/CommentsModel.dart';

class CommentCard extends StatelessWidget {
  final int id;
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
              CachedNetworkImage(
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

class _ReplyTile extends StatelessWidget {
  final Replies reply;
  final VoidCallback onLike;
  final VoidCallback onReply;

  const _ReplyTile({
    required this.reply,
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
          CachedNetworkImage(
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
