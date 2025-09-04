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
  final VoidCallback onLike;
  final VoidCallback onReply;
  final List<Replies> replies;

  // NEW:
  final void Function(int replyId) onReplyLike;
  final void Function(String replyUserName) onReplyReply;

  const CommentCard({
    required this.id,
    required this.name,
    required this.profileUrl,
    required this.content,
    required this.createdAt,
    required this.onLike,
    required this.onReply,
    required this.replies,
    required this.onReplyLike, // NEW
    required this.onReplyReply, // NEW
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
                    color: const Color(0xffFFFFFF),
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
                          TextButton(
                            onPressed: onLike,
                            style: TextButton.styleFrom(
                              padding: EdgeInsets.zero,
                              minimumSize: const Size(40, 20),
                              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                            ),
                            child: const Text(
                              "Like",
                              style: TextStyle(
                                fontSize: 13,
                                fontFamily: 'segeo',
                                color: Color(0xFF4076ED),
                              ),
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

          // replies (one level)
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
                    ), // parent stays this comment
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

  // NEW:
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
                color: const Color(0xffFFFFFF),
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
                  Text(
                    reply.content ?? '',
                    style: const TextStyle(
                      fontSize: 13,
                      fontFamily: 'segeo',
                      color: Color(0xff333333),
                    ),
                  ),
                  const SizedBox(height: 6),

                  // NEW: actions for reply row
                  Row(
                    children: [
                      TextButton(
                        onPressed: onLike,
                        style: TextButton.styleFrom(
                          padding: EdgeInsets.zero,
                          minimumSize: const Size(40, 20),
                          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        ),
                        child: const Text(
                          "Like",
                          style: TextStyle(
                            fontSize: 13,
                            fontFamily: 'segeo',
                            color: Color(0xFF4076ED),
                          ),
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
