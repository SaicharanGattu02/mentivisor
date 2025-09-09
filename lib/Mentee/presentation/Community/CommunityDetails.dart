import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:mentivisor/Components/CutomAppBar.dart';

import '../../../Components/CustomAppButton.dart';
import '../../../Components/CustomSnackBar.dart';
import '../../../services/AuthService.dart';
import '../../../utils/constants.dart';
import '../../../utils/media_query_helper.dart';
import '../../../utils/spinkittsLoader.dart';
import '../../Models/CommunityPostsModel.dart';
import '../../data/cubits/CommunityPostReport/CommunityZoneReportCubit.dart';
import '../../data/cubits/CommunityPostReport/CommunityZoneReportState.dart';
import '../../data/cubits/PostComment/post_comment_cubit.dart';
import '../../data/cubits/PostComment/post_comment_states.dart';
import '../Widgets/CommentBottomSheet.dart';

class CommunityDetails extends StatefulWidget {
  final CommunityPosts communityPosts;
  const CommunityDetails({super.key,required this.communityPosts});

  @override
  State<CommunityDetails> createState() => _CommunityDetailsState();
}

class _CommunityDetailsState extends State<CommunityDetails> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:CustomAppBar1(title: "PostDetails", actions: []),
      body: Container(color: Color(0xffF4F8FD),child: Column(children: [
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

                    },
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: CachedNetworkImage(
                        height: 160,
                        imageUrl: "widget.communityPosts.imgUrl ?? """,
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
                        imageUrl: "",
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
                          "widget.communityPosts.uploader?.name ?? """,
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
                    "widget.communityPosts.heading ?? """,
                    style: const TextStyle(
                      fontFamily: 'segeo',
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: Color(0xFF222222),
                    ),
                  ),

                  const SizedBox(height: 4),
                  Text(
                    "widget.communityPosts.description ?? """,
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

                  /// Likes, Comments & Share
                  // FutureBuilder(
                  //   future: AuthService.isGuest,
                  //   builder: (context, snapshot) {
                  //     final isGuest = snapshot.data ?? false;
                  //     return StatefulBuilder(
                  //       builder: (context, setState) {
                  //         return Row(
                  //           children: [
                  //
                  //             BlocBuilder<
                  //                 PostCommentCubit,
                  //                 PostCommentStates
                  //             >(
                  //               builder: (context, state) {
                  //                 final post = widget.communityPosts;
                  //                 return Row(
                  //                   children: [
                  //                     GestureDetector(
                  //                       onTap: () {
                  //                         if (isGuest) {
                  //                           context.push('/auth_landing');
                  //                         } else {
                  //                           final data = {
                  //                             "community_id": post.id,
                  //                           };
                  //                           context
                  //                               .read<PostCommentCubit>()
                  //                               .postLike(data, post);
                  //                         }
                  //                       },
                  //                       child: Icon(
                  //                         (post.isLiked ?? false)
                  //                             ? Icons.favorite
                  //                             : Icons.favorite_border,
                  //                         size: 16,
                  //                         color: (post.isLiked ?? false)
                  //                             ? Colors.red
                  //                             : Colors.black26,
                  //                       ),
                  //                     ),
                  //                     const SizedBox(width: 4),
                  //                     Text(
                  //                       "${post.likesCount ?? 0}",
                  //                       style: const TextStyle(
                  //                         color: Color(0xff666666),
                  //                         fontSize: 14,
                  //                         fontFamily: 'segeo',
                  //                         fontWeight: FontWeight.w400,
                  //                       ),
                  //                     ),
                  //                   ],
                  //                 );
                  //               },
                  //             ),
                  //
                  //             const SizedBox(width: 12),
                  //
                  //             // Comments
                  //             GestureDetector(
                  //               onTap: () {
                  //
                  //                   showModalBottomSheet(
                  //                     context: context,
                  //                     isScrollControlled: true,
                  //                     useRootNavigator: true,
                  //                     backgroundColor: Colors.transparent,
                  //                     builder: (context) {
                  //                       return DraggableScrollableSheet(
                  //                         initialChildSize: 0.8,
                  //                         minChildSize: 0.4,
                  //                         maxChildSize: 0.95,
                  //                         expand: false,
                  //                         builder: (_, scrollController) =>
                  //                             Container(
                  //                               decoration: const BoxDecoration(
                  //                                 color: Color(0xffF4F8FD),
                  //                                 borderRadius:
                  //                                 BorderRadius.vertical(
                  //                                   top: Radius.circular(
                  //                                     16,
                  //                                   ),
                  //                                 ),
                  //                               ),
                  //                               padding:
                  //                               const EdgeInsets.symmetric(
                  //                                 horizontal: 16,
                  //                                 vertical: 12,
                  //                               ),
                  //                               child: CommentBottomSheet(
                  //                                 communityPost:
                  //                                "widget.communityPosts",
                  //                                 scrollController:
                  //                                 scrollController,
                  //                               ),
                  //                             ),
                  //                       );
                  //                     }
                  //                   );
                  //               },
                  //               child: Row(
                  //                 children: [
                  //                   Image.asset(
                  //                     "assets/icons/Chat.png",
                  //                     width: 16,
                  //                     height: 16,
                  //                   ),
                  //                   const SizedBox(width: 6),
                  //                   BlocBuilder<
                  //                       PostCommentCubit,
                  //                       PostCommentStates
                  //                   >(
                  //                     builder: (context, state) {
                  //                       return Text(
                  //                         widget.communityPosts.commentsCount
                  //                             .toString(),
                  //                         style: const TextStyle(
                  //                           fontFamily: 'segeo',
                  //                         ),
                  //                       );
                  //                     },
                  //                   ),
                  //                 ],
                  //               ),
                  //             ),
                  //
                  //             const SizedBox(width: 12),
                  //
                  //             // Share
                  //             // GestureDetector(
                  //             //   onTap: () async {
                  //             //     final post = widget.communityPosts;
                  //             //     final shareText =
                  //             //     """
                  //             //         ${post.heading ?? "Check this out!"}
                  //             //
                  //             //         ${post.description ?? ""}
                  //             //
                  //             //         ${post.imgUrl ?? ""}
                  //             //         """;
                  //             //     await Share.share(shareText.trim());
                  //             //   },
                  //             //   child: Image.asset(
                  //             //     'assets/icons/share.png',
                  //             //     width: 16,
                  //             //     height: 16,
                  //             //   ),
                  //             // ),
                  //             // Spacer(),
                  //             GestureDetector(
                  //               onTap: () => _showReportSheet(
                  //                 context,
                  //                " widget.communityPosts",
                  //               ),
                  //               child: Row(
                  //                 children: [
                  //                   Image.asset(
                  //                     "assets/images/ReportmenteImg.png",
                  //                     width: 16,
                  //                     height: 16,
                  //                   ),
                  //                   SizedBox(width: 5),
                  //                   Text(
                  //                     'Report',
                  //                     style: TextStyle(
                  //                       fontSize: 14,
                  //                       color: Colors.black87,
                  //                       fontFamily: 'segeo',
                  //                       fontWeight: FontWeight.w400,
                  //                     ),
                  //                   ),
                  //                 ],
                  //               ),
                  //             ),
                  //           ],
                  //         );
                  //       },
                  //     );
                  //   },
                  // ),
                ],
              ),
            ),
          ],
        ),
      ],),),

    );
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
}
