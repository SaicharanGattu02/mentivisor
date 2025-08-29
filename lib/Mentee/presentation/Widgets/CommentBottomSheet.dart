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
  late List<Map<String, dynamic>> _comments;

  @override
  void initState() {
    super.initState();
    debugPrint("commentsList :${widget.comments}");
    _comments = List.from(widget.comments);
  }

  void _addComment(String text) {
    setState(() {
      _comments.add({
        "name": "You",
        "profile": "assets/images/profileimg.png",
        "comment": text,
        "time": "Just now",
      });
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
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: CustomScrollView(
                controller: widget.scrollController,
                slivers: [
                  SliverList(
                    delegate: SliverChildBuilderDelegate((context, index) {
                      final comment = _comments[index];
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 12),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            CachedNetworkImage(
                              imageUrl: comment['profile'] ?? '',
                              imageBuilder: (context, imageProvider) =>
                                  CircleAvatar(
                                    radius: 16,
                                    backgroundImage: imageProvider,
                                  ),
                              placeholder: (context, url) => CircleAvatar(
                                radius: 16,
                                backgroundColor: Colors.grey.shade300,
                                child: SizedBox(
                                  width: 16,
                                  height: 16,
                                  child: Center(
                                    child: spinkits.getSpinningLinespinkit(),
                                  ),
                                ),
                              ),
                              errorWidget: (context, url, error) =>
                                  const CircleAvatar(
                                    radius: 16,
                                    backgroundImage: AssetImage(
                                      "assets/images/profileimg.png",
                                    ),
                                  ),
                            ),
                            Expanded(
                              child: Container(
                                padding: EdgeInsets.only(left: 10),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      '${comment['name']}  ${DateHelper.timeAgo(comment['time'])}',
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontFamily: 'segeo',
                                        fontSize: 13,
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      comment['comment'],
                                      style: const TextStyle(
                                        fontSize: 14,
                                        fontFamily: 'segeo',
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    }, childCount: _comments.length),
                  ),
                ],
              ),
            ),

          widget.communityPost.id == null
                ? const SizedBox.shrink() // nothing shown
                : Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: _controller,
                          decoration: InputDecoration(
                            hintText: 'Write a comment...',
                            hintStyle: const TextStyle(fontFamily: 'segeo'),
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 12,
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
                      BlocConsumer<PostCommentCubit, PostCommentStates>(
                        listener: (context, state) {
                          if (state is PostCommentLoaded) {

                            _addComment(_controller.text.trim());

                          } else if (state is PostCommentFailure) {
                            CustomSnackBar1.show(context, state.error ?? "");
                          }
                        },
                        builder: (context, state) {
                          final isLoading = state is PostCommentLoading;
                          return isLoading
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
                                  ),
                                  onPressed: () {
                                    if (_controller.text.trim().isNotEmpty) {
                                      final text = _controller.text.trim();
                                      Map<String, dynamic> data = {
                                        "community_id": widget.communityPost.id,
                                        "comments": text,
                                      };
                                      context.read<PostCommentCubit>().postComment(data, widget.communityPost);
                                    }
                                  },
                                );
                        },
                      ),
                    ],
                  ),
          ],
        ),
      ),
    );
  }
}



