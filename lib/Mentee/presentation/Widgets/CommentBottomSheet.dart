import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mentivisor/Components/CustomSnackBar.dart';
import 'package:mentivisor/Mentee/data/cubits/PostComment/post_comment_cubit.dart';
import 'package:mentivisor/Mentee/data/cubits/PostComment/post_comment_states.dart';
import '../../../utils/constants.dart';
import '../../../utils/spinkittsLoader.dart';
import '../../Models/CommunityPostsModel.dart';

class CommentBottomSheet extends StatefulWidget {
  final CommunityPosts communityPost;
  final ScrollController scrollController;
  final List<dynamic> comments;

  const CommentBottomSheet({
    super.key,
    required this.communityPost,
    required this.scrollController,
    required this.comments,
  });

  @override
  State<CommentBottomSheet> createState() => _CommentBottomSheetState();
}

class _CommentBottomSheetState extends State<CommentBottomSheet> {
  final TextEditingController _controller = TextEditingController();
  final GlobalKey<AnimatedListState> _listKey = GlobalKey<AnimatedListState>();
  late List<Map<String, dynamic>> _comments;
  int? _replyingToIndex;
  bool _isReplying = false;

  @override
  void initState() {
    super.initState();
    _comments = widget.comments.map((c) {
      if (c is Map) {
        return {
          ...Map<String, dynamic>.from(c),
          'replies': <Map<String, dynamic>>[],
        };
      } else {
        return {
          'name': 'Unknown',
          'profile': 'assets/images/profileimg.png',
          'comment': 'Invalid comment data',
          'time': 'Just now',
          'replies': <Map<String, dynamic>>[],
        };
      }
    }).toList();
  }

  void _addComment(String text, {int? parentIndex}) {
    final newComment = {
      "name": "You",
      "profile": "assets/images/profileimg.png",
      "comment": text,
      "time": "Just now",
      "replies": <Map<String, dynamic>>[],
    };

    setState(() {
      if (parentIndex == null) {
        _comments.add(newComment);
        _listKey.currentState?.insertItem(_comments.length - 1);
      } else {
        _comments[parentIndex]['replies'].add(newComment);
      }
      _isReplying = false;
      _replyingToIndex = null;
    });
    _controller.clear();
  }

  void _showReplyField(int index) {
    setState(() {
      _isReplying = true;
      _replyingToIndex = index;
    });
    _controller.clear();
    FocusScope.of(context).requestFocus(FocusNode());
  }

  void _cancelReply() {
    setState(() {
      _isReplying = false;
      _replyingToIndex = null;
    });
    _controller.clear();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
          top: 16,
          left: 16,
          right: 16,
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
            const SizedBox(height: 12),
            Expanded(
              child: AnimatedList(
                key: _listKey,
                controller: widget.scrollController,
                initialItemCount: _comments.length,
                itemBuilder: (context, index, animation) {
                  return _buildCommentItem(_comments[index], index, animation);
                },
              ),
            ),
            _buildInputField(),
          ],
        ),
      ),
    );
  }

  Widget _buildCommentItem(
    Map<String, dynamic> comment,
    int index,
    Animation<double> animation,
  ) {
    return SizeTransition(
      sizeFactor: animation,
      child: Padding(
        padding: EdgeInsets.only(bottom: 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CachedNetworkImage(
                  imageUrl: comment['profile'] ?? '',
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
                    margin: EdgeInsets.only(left: 8),
                    padding: EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Color(0xffFFFFFF),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Text(
                              comment['name'] ?? '',
                              style: const TextStyle(
                                fontWeight: FontWeight.w600,
                                fontFamily: 'segeo',
                                fontSize: 14,
                              ),
                            ),
                            const SizedBox(width: 8),
                            Text(
                              DateHelper.timeAgo(comment['time']),
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
                          comment['comment'] ?? '',
                          style: const TextStyle(
                            fontSize: 14,
                            fontFamily: 'segeo',
                            color: Color(0xff333333),
                          ),
                        ),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            BlocBuilder<PostCommentCubit, PostCommentStates>(
                              builder: (context, state) {
                                return TextButton(
                                  onPressed: () {
                                    final id = comment['id'];
                                    context
                                        .read<PostCommentCubit>()
                                        .postOnCommentLike(id);
                                  },
                                  style: TextButton.styleFrom(
                                    padding: EdgeInsets.zero,
                                    minimumSize: const Size(40, 20),
                                    tapTargetSize:
                                        MaterialTapTargetSize.shrinkWrap,
                                  ),
                                  child: Text(
                                    "Like",
                                    style: TextStyle(
                                      fontSize: 13,
                                      fontFamily: 'segeo',
                                      color: Color(0xFF4076ED),
                                    ),
                                  ),
                                );
                              },
                            ),
                            const SizedBox(width: 12),
                            TextButton(
                              onPressed: () => _showReplyField(index),
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
            if (comment['replies'].isNotEmpty)
              Padding(
                padding: const EdgeInsets.only(left: 32, top: 8),
                child: Column(
                  children: comment['replies']
                      .asMap()
                      .entries
                      .map<Widget>(
                        (entry) => _buildCommentItem(
                          entry.value, // <-- this is Replies, not Comments
                          entry.key,
                          const AlwaysStoppedAnimation(1.0),
                        ),
                      )
                      .toList(),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildInputField() {
    return BlocConsumer<PostCommentCubit, PostCommentStates>(
      listener: (context, state) {
        if (state is PostCommentLoaded) {
          _addComment(_controller.text.trim(), parentIndex: _replyingToIndex);
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
              if (_isReplying && _replyingToIndex != null)
                Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(
                          'Replying to ${_comments[_replyingToIndex!]['name']}',
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
                ),
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _controller,
                      decoration: InputDecoration(
                        hintText: _isReplying
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
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : IconButton(
                          icon: const Icon(
                            Icons.send,
                            color: Color(0xFF4076ED),
                            size: 28,
                          ),
                          onPressed: () {
                            if (_controller.text.trim().isNotEmpty) {
                              final text = _controller.text.trim();
                              final data = {
                                "community_id": widget.communityPost.id,
                                "comments": text,
                                if (_isReplying && _replyingToIndex != null)
                                  "parent_id":
                                      _isReplying && _replyingToIndex != null
                                      ? _comments[_replyingToIndex!]['id']
                                      : null,
                              };
                              context.read<PostCommentCubit>().postComment(
                                data,
                                widget.communityPost,
                              );
                            }
                          },
                        ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
