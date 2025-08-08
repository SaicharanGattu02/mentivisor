import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mentivisor/Components/CustomSnackBar.dart';
import 'package:mentivisor/Mentee/data/cubits/PostComment/post_comment_cubit.dart';
import 'package:mentivisor/Mentee/data/cubits/PostComment/post_comment_states.dart';

class CommentBottomSheet extends StatefulWidget {
  final int postId;
  final ScrollController scrollController;

  const CommentBottomSheet({
    super.key,
    required this.postId,
    required this.scrollController,
  });

  @override
  State<CommentBottomSheet> createState() => _CommentBottomSheetState();
}

class _CommentBottomSheetState extends State<CommentBottomSheet> {
  final TextEditingController _controller = TextEditingController();
  final List<Map<String, dynamic>> _comments = [
    {
      "name": "Ramesh",
      "profile": "assets/images/profileimg.png",
      "comment":
          "Seen many students struggle to for clear road map for the data",
      "time": "4 Days ago",
    },
    {
      "name": "Ramesh",
      "profile": "assets/images/profileimg.png",
      "comment": "OK i will given the clarity",
      "time": "2 Days ago",
    },
  ];

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
                fontFamily: 'Segoe',
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: ListView.builder(
                controller: widget.scrollController,
                shrinkWrap: true,
                itemCount: _comments.length,
                itemBuilder: (context, index) {
                  final comment = _comments[index];
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        CircleAvatar(
                          radius: 16,
                          backgroundImage: AssetImage(comment['profile']),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  '${comment['name']}   ${comment['time']}',
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontFamily: 'Segoe',
                                    fontSize: 13,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  comment['comment'],
                                  style: const TextStyle(
                                    fontSize: 14,
                                    fontFamily: 'Segoe',
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _controller,
                    decoration: InputDecoration(
                      hintText: 'Write a comment...',
                      hintStyle: const TextStyle(fontFamily: 'Segoe'),
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
                      CustomSnackBar1.show(
                        context,
                        state.successModel.message ?? "",
                      );
                    } else if (state is PostCommentFailure) {
                      CustomSnackBar1.show(context, state.error ?? "");
                    }
                  },
                  builder: (context, state) {
                    final isLoading = state is PostCommentLoading;
                    return isLoading
                        ? CircularProgressIndicator()
                        : IconButton(
                            icon: const Icon(
                              Icons.send,
                              color: Color(0xFF4076ED),
                            ),
                            onPressed: () {
                              if (_controller.text.trim().isNotEmpty) {
                                // _addComment(_controller.text.trim());
                                Map<String, dynamic> data = {
                                  "community_id": widget.postId,
                                };
                                context.read<PostCommentCubit>().postComment(
                                  data,
                                );
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
