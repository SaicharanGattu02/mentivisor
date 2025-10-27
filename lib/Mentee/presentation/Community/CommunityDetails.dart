// import 'package:cached_network_image/cached_network_image.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:go_router/go_router.dart';
// import 'package:mentivisor/Components/CutomAppBar.dart';
// import 'package:mentivisor/Mentee/data/cubits/CommunityDetails/CommunityDetailsCubit.dart';
// import 'package:share_plus/share_plus.dart';
//
// import '../../../Components/CommonLoader.dart';
// import '../../../Components/CustomAppButton.dart';
// import '../../../Components/CustomSnackBar.dart';
// import '../../../services/AuthService.dart';
// import '../../../utils/constants.dart';
// import '../../../utils/media_query_helper.dart';
// import '../../../utils/spinkittsLoader.dart';
// import '../../Models/CommunityPostsModel.dart';
// import '../../data/cubits/CommunityDetails/CommunityDetailsState.dart';
// import '../../data/cubits/CommunityPostReport/CommunityZoneReportCubit.dart';
// import '../../data/cubits/CommunityPostReport/CommunityZoneReportState.dart';
// import '../../data/cubits/PostComment/post_comment_cubit.dart';
// import '../../data/cubits/PostComment/post_comment_states.dart';
// import '../Widgets/CommentBottomSheet.dart';
//
// class CommunityDetails extends StatefulWidget {
//   final int communityId;
//   final String scope;
//
//   const CommunityDetails({
//     super.key,
//     required this.communityId,
//     required this.scope,
//   });
//
//   @override
//   State<CommunityDetails> createState() => _CommunityDetailsState();
// }
//
// class _CommunityDetailsState extends State<CommunityDetails> {
//   @override
//   void initState() {
//     super.initState();
//     context.read<CommunityDetailsCubit>().communityDetails(
//       widget.communityId,
//       widget.scope,
//     );
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: CustomAppBar1(title: "Post Details", actions: []),
//       body: Container(
//         color: Color(0xffF4F8FD),
//         child: BlocBuilder<CommunityDetailsCubit, CommunityDetailsState>(
//           builder: (context, state) {
//             if (state is CommunityDetailsLoading) {
//               return const Center(child: DottedProgressWithLogo());
//             } else if (state is CommunityDetailsLoaded) {
//               final communityDetails =
//                   state.communityDetailsModel.communityposts;
//               return Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Padding(
//                     padding: const EdgeInsets.symmetric(
//                       horizontal: 16.0,
//                       vertical: 10,
//                     ),
//                     child: Stack(
//                       alignment: Alignment.center,
//                       children: [
//                         GestureDetector(
//                           onDoubleTap: () async {},
//                           child: ClipRRect(
//                             borderRadius: BorderRadius.circular(8),
//                             child: CachedNetworkImage(
//                               height: 160,
//                               imageUrl: communityDetails?.imgUrl ?? "",
//                               fit: BoxFit.cover,
//                               width: SizeConfig.screenWidth,
//                               placeholder: (context, url) => Center(
//                                 child: spinkits.getSpinningLinespinkit(),
//                               ),
//                               errorWidget: (context, url, error) => Container(
//                                 height: 160,
//                                 color: Colors.grey.shade100,
//                                 child: const Icon(
//                                   Icons.broken_image,
//                                   size: 40,
//                                   color: Colors.grey,
//                                 ),
//                               ),
//                             ),
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//                   Padding(
//                     padding: EdgeInsets.all(12),
//                     child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         if (communityDetails?.anonymous == 0)
//                           Row(
//                             children: [
//                               GestureDetector(
//                                 onTap: () {
//                                   // if (widget.communityPosts.anonymous == 1) {
//                                   //   CustomSnackBar1.show(
//                                   //     context,
//                                   //     "Anonymous post user profile cannot be visited.",
//                                   //   );
//                                   // } else {
//                                   context.push(
//                                     "/common_profile/${communityDetails?.uploader?.id}",
//                                   );
//                                   // }
//                                 },
//                                 child:
//                                 communityDetails
//                                     ?.uploader
//                                     ?.profilePicUrl
//                                     ?.isEmpty ==
//                                     true
//                                     ? CircleAvatar(
//                                   radius: 16,
//                                   backgroundColor: Colors.grey.shade400,
//                                   child: Text(
//                                     communityDetails?.uploader?.name![0]
//                                         .toUpperCase() ??
//                                         "",
//                                     style: TextStyle(
//                                       fontSize: 16,
//                                       fontWeight: FontWeight.bold,
//                                       color: Colors.white,
//                                     ),
//                                   ),
//                                 )
//                                     : CachedNetworkImage(
//                                   imageUrl:
//                                   communityDetails?.anonymous == 1
//                                       ? "assets/images/profile.png"
//                                       : communityDetails
//                                       ?.uploader
//                                       ?.profilePicUrl ??
//                                       "",
//                                   imageBuilder:
//                                       (context, imageProvider) =>
//                                       CircleAvatar(
//                                         radius: 16,
//                                         backgroundImage:
//                                         imageProvider,
//                                       ),
//                                   placeholder: (context, url) =>
//                                       CircleAvatar(
//                                         radius: 16,
//                                         backgroundColor: Colors.grey,
//                                         child: SizedBox(
//                                           width: 14,
//                                           height: 14,
//                                           child: Center(
//                                             child: spinkits
//                                                 .getSpinningLinespinkit(),
//                                           ),
//                                         ),
//                                       ),
//                                   errorWidget: (context, url, error) =>
//                                   const CircleAvatar(
//                                     radius: 16,
//                                     backgroundImage: AssetImage(
//                                       "assets/images/profile.png",
//                                     ),
//                                   ),
//                                 ),
//                               ),
//                               const SizedBox(width: 8),
//                               Text(
//                                 communityDetails?.anonymous == 1
//                                     ? "Anonymous"
//                                     : capitalize(
//                                   communityDetails?.uploader?.name ?? "",
//                                 ),
//                                 style: const TextStyle(
//                                   fontFamily: 'segeo',
//                                   fontWeight: FontWeight.w400,
//                                   fontSize: 12,
//                                   color: Color(0xff222222),
//                                 ),
//                               ),
//                             ],
//                           ),
//                         const SizedBox(height: 4),
//                         Text(
//                           communityDetails?.heading ?? "",
//                           style: const TextStyle(
//                             fontFamily: 'segeo',
//                             fontWeight: FontWeight.bold,
//                             fontSize: 16,
//                             color: Color(0xFF222222),
//                           ),
//                         ),
//
//                         const SizedBox(height: 4),
//                         Text(
//                           communityDetails?.description ?? "",
//                           maxLines: 2,
//                           overflow: TextOverflow.ellipsis,
//                           style: const TextStyle(
//                             fontFamily: 'segeo',
//                             fontWeight: FontWeight.w400,
//                             fontSize: 14,
//                             color: Color(0xFF666666),
//                           ),
//                         ),
//
//                         const SizedBox(height: 8),
//                         FutureBuilder(
//                           future: AuthService.isGuest,
//                           builder: (context, snapshot) {
//                             final isGuest = snapshot.data ?? false;
//                             return StatefulBuilder(
//                               builder: (context, setState) {
//                                 return Row(
//                                   children: [
//                                     BlocBuilder<
//                                         PostCommentCubit,
//                                         PostCommentStates
//                                     >(
//                                       builder: (context, commentState) {
//                                         return Row(
//                                           children: [
//                                             IconButton(
//                                               visualDensity:
//                                               VisualDensity.compact,
//                                               padding: EdgeInsets.zero,
//                                               onPressed: () {
//                                                 if (isGuest) {
//                                                   context.push('/auth_landing');
//                                                 } else {
//                                                   final data = {
//                                                     "community_id":
//                                                     communityDetails?.id,
//                                                   };
//                                                   context
//                                                       .read<PostCommentCubit>()
//                                                       .postLike(
//                                                     data,
//                                                     communityDetails!,
//                                                   );
//                                                 }
//                                               },
//                                               icon: Icon(
//                                                 (communityDetails?.isLiked ??
//                                                     false)
//                                                     ? Icons.favorite
//                                                     : Icons.favorite_border,
//                                                 size: 16,
//                                                 color:
//                                                 (communityDetails
//                                                     ?.isLiked ??
//                                                     false)
//                                                     ? Colors.red
//                                                     : Colors.black26,
//                                               ),
//                                             ),
//                                             Text(
//                                               "${communityDetails?.likesCount ?? 0}",
//                                               style: const TextStyle(
//                                                 color: Color(0xff666666),
//                                                 fontSize: 14,
//                                                 fontFamily: 'segeo',
//                                                 fontWeight: FontWeight.w400,
//                                               ),
//                                             ),
//                                           ],
//                                         );
//                                       },
//                                     ),
//                                     Row(
//                                       mainAxisSize: MainAxisSize.min,
//                                       children: [
//                                         IconButton(
//                                           visualDensity: VisualDensity.compact,
//                                           padding: EdgeInsets.zero,
//                                           onPressed: () {
//                                             if (isGuest) {
//                                               context.push('/auth_landing');
//                                             } else {
//                                               showModalBottomSheet(
//                                                 context: context,
//                                                 isScrollControlled: true,
//                                                 useRootNavigator: true,
//                                                 backgroundColor:
//                                                 Colors.transparent,
//                                                 builder: (context) {
//                                                   return DraggableScrollableSheet(
//                                                     initialChildSize: 0.8,
//                                                     minChildSize: 0.4,
//                                                     maxChildSize: 0.95,
//                                                     expand: false,
//                                                     builder: (_, scrollController) => Container(
//                                                       decoration: const BoxDecoration(
//                                                         color: Color(
//                                                           0xffF4F8FD,
//                                                         ),
//                                                         borderRadius:
//                                                         BorderRadius.vertical(
//                                                           top:
//                                                           Radius.circular(
//                                                             16,
//                                                           ),
//                                                         ),
//                                                       ),
//                                                       padding:
//                                                       const EdgeInsets.symmetric(
//                                                         horizontal: 16,
//                                                         vertical: 12,
//                                                       ),
//                                                       child: CommentBottomSheet(
//                                                         communityPost:
//                                                         communityDetails ??
//                                                             CommunityPosts(),
//                                                         scrollController:
//                                                         scrollController,
//                                                       ),
//                                                     ),
//                                                   );
//                                                 },
//                                               );
//                                             }
//                                           },
//                                           icon: Image.asset(
//                                             "assets/icons/Chat.png",
//                                             width: 18,
//                                             height: 18,
//                                           ),
//                                         ),
//                                         BlocBuilder<
//                                             PostCommentCubit,
//                                             PostCommentStates
//                                         >(
//                                           builder: (context, state) {
//                                             return Text(
//                                               communityDetails?.commentsCount
//                                                   ?.toString() ??
//                                                   "0",
//                                               style: const TextStyle(
//                                                 fontFamily: 'segeo',
//                                               ),
//                                             );
//                                           },
//                                         ),
//                                       ],
//                                     ),
//                                     IconButton(
//                                       padding: EdgeInsets
//                                           .zero, // remove default extra padding
//                                       visualDensity: VisualDensity.compact,
//                                       icon: Image.asset(
//                                         'assets/icons/share.png',
//                                         width: 16,
//                                         height: 16,
//                                       ),
//                                       onPressed: () async {
//                                         final postId = communityDetails?.id;
//                                         final shareUrl =
//                                             "https://mentivisor.com/community_post/$postId";
//                                         Share.share(
//                                           "Check out this Community Post on Mentivisor:\n$shareUrl",
//                                           subject: "Mentivisor Community Post",
//                                         );
//                                       },
//                                     ),
//                                     Spacer(),
//                                     GestureDetector(
//                                       onTap: () => _showReportSheet(
//                                         context,
//                                         communityDetails,
//                                       ),
//                                       child: Row(
//                                         children: [
//                                           Image.asset(
//                                             "assets/images/ReportmenteImg.png",
//                                             width: 16,
//                                             height: 16,
//                                           ),
//                                           SizedBox(width: 5),
//                                           Text(
//                                             'Report',
//                                             style: TextStyle(
//                                               fontSize: 14,
//                                               color: Colors.black87,
//                                               fontFamily: 'segeo',
//                                               fontWeight: FontWeight.w400,
//                                             ),
//                                           ),
//                                         ],
//                                       ),
//                                     ),
//                                   ],
//                                 );
//                               },
//                             );
//                           },
//                         ),
//                       ],
//                     ),
//                   ),
//                 ],
//               );
//             } else if (state is CommunityDetailsFailure) {
//               return Center(child: Text(state.message));
//             } else {
//               return Center(child: Text("No Data"));
//             }
//           },
//         ),
//       ),
//     );
//   }
//
//   void _showReportSheet(BuildContext context, communityPosts) {
//     String _selected = 'False Information';
//     final TextEditingController _otherController = TextEditingController();
//     final List<String> _reportReasons = [
//       'Copied',
//       'Scam or Fraud ',
//       'Abusing Post',
//       'Other',
//     ];
//
//     showModalBottomSheet(
//       context: context,
//       isScrollControlled: true,
//       backgroundColor: Colors.white,
//       shape: const RoundedRectangleBorder(
//         borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
//       ),
//       builder: (BuildContext builderContext) {
//         return SafeArea(
//           child: StatefulBuilder(
//             builder: (BuildContext context, StateSetter setState) {
//               return Padding(
//                 padding: EdgeInsets.only(
//                   bottom: MediaQuery.of(context).viewInsets.bottom,
//                   left: 16,
//                   right: 16,
//                   top: 16,
//                 ),
//                 child: Column(
//                   mainAxisSize: MainAxisSize.min,
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Row(
//                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                       children: [
//                         const Text(
//                           'Post Report',
//                           style: TextStyle(
//                             fontSize: 20,
//                             color: Color(0xff444444),
//                             fontFamily: 'segeo',
//                             fontWeight: FontWeight.w600,
//                           ),
//                         ),
//                         IconButton(
//                           icon: const Icon(Icons.close, color: Colors.grey),
//                           onPressed: () => Navigator.of(context).pop(),
//                         ),
//                       ],
//                     ),
//                     Column(
//                       children: _reportReasons.map((String reason) {
//                         return RadioListTile<String>(
//                           title: Text(
//                             reason,
//                             style: const TextStyle(
//                               fontFamily: 'segeo',
//                               fontSize: 16,
//                             ),
//                           ),
//                           value: reason,
//                           visualDensity: VisualDensity.compact,
//                           groupValue: _selected,
//                           onChanged: (String? value) {
//                             setState(() {
//                               _selected = value!;
//                             });
//                           },
//                           activeColor: const Color(0xFF4A00E0),
//                           contentPadding: const EdgeInsets.symmetric(
//                             horizontal: 8,
//                           ),
//                         );
//                       }).toList(),
//                     ),
//                     // Custom Reason TextField
//                     if (_selected == 'Other') ...[
//                       const SizedBox(height: 16),
//                       TextField(
//                         controller: _otherController,
//                         maxLines: 3,
//                         decoration: InputDecoration(
//                           hintText: 'Please explain your reason',
//                           hintStyle: const TextStyle(fontFamily: 'segeo'),
//                           border: OutlineInputBorder(
//                             borderRadius: BorderRadius.circular(8),
//                           ),
//                           contentPadding: const EdgeInsets.symmetric(
//                             horizontal: 12,
//                             vertical: 12,
//                           ),
//                         ),
//                       ),
//                     ],
//                     const SizedBox(height: 24),
//                     BlocConsumer<
//                         CommunityZoneReportCubit,
//                         CommunityZoneReportState
//                     >(
//                       listener: (context, state) {
//                         if (state is CommunityZoneReportSuccess) {
//                           CustomSnackBar1.show(
//                             context,
//                             "Report submitted successfully.",
//                           );
//                           context.pop();
//                         } else if (state is CommunityZoneReportFailure) {
//                           return CustomSnackBar1.show(
//                             context,
//                             state.message ?? "",
//                           );
//                         }
//                       },
//                       builder: (context, state) {
//                         return SafeArea(
//                           child: CustomAppButton1(
//                             isLoading: state is CommunityZoneReportLoading,
//                             text: "Submit Report",
//                             onPlusTap: () {
//                               final Map<String, dynamic> data = {
//                                 "content_id": communityPosts.id,
//                                 "reason": _selected,
//                               };
//                               context
//                                   .read<CommunityZoneReportCubit>()
//                                   .postCommunityZoneReport(data);
//                             },
//                           ),
//                         );
//                       },
//                     ),
//                     const SizedBox(height: 16),
//                   ],
//                 ),
//               );
//             },
//           ),
//         );
//       },
//     );
//   }
// }

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:share_plus/share_plus.dart';
import '../../../Components/CommonLoader.dart';
import '../../../Components/CustomAppButton.dart';
import '../../../Components/CustomSnackBar.dart';
import '../../../Components/CutomAppBar.dart';
import '../../../Components/Shimmers.dart';
import '../../../services/AuthService.dart';
import '../../../utils/constants.dart';
import '../../../utils/media_query_helper.dart';
import '../../../utils/spinkittsLoader.dart';
import '../../Models/CommentsModel.dart';
import '../../Models/CommunityPostsModel.dart';
import '../../data/cubits/Comments/FetchCommentsCubit.dart';
import '../../data/cubits/Comments/FetchCommentsStates.dart';
import '../../data/cubits/CommunityDetails/CommunityDetailsCubit.dart';
import '../../data/cubits/CommunityDetails/CommunityDetailsState.dart';
import '../../data/cubits/CommunityPostReport/CommunityZoneReportCubit.dart';
import '../../data/cubits/CommunityPostReport/CommunityZoneReportState.dart';
import '../../data/cubits/PostComment/post_comment_cubit.dart';
import '../../data/cubits/PostComment/post_comment_states.dart';
import '../Widgets/CommentCard.dart';

class CommunityDetails extends StatefulWidget {
  final int communityId;
  final String scope;

  const CommunityDetails({
    super.key,
    required this.communityId,
    required this.scope,
  });

  @override
  State<CommunityDetails> createState() => _CommunityDetailsState();
}

class _CommunityDetailsState extends State<CommunityDetails> {
  final TextEditingController _controller = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  int? _replyParentId;
  int? _replyingToUserId;
  String? _replyingToName;
  String? _replyingToMsg;

  @override
  void initState() {
    super.initState();
    context.read<CommunityDetailsCubit>().communityDetails(
      widget.communityId,
      widget.scope,
    );
    context.read<FetchCommentsCubit>().getComments(widget.communityId);
  }

  void _startReply(
    int parentId,
    String displayName,
    String msg,
    int replyingToUserId,
  ) {
    setState(() {
      _replyParentId = parentId;
      _replyingToName = displayName;
      _replyingToMsg = msg;
      _replyingToUserId = replyingToUserId;
    });
  }

  void _cancelReply() {
    setState(() {
      _replyParentId = null;
      _replyingToName = null;
      _replyingToMsg = null;
      _replyingToUserId = null;
    });
  }

  void _send() {
    final text = _controller.text.trim();
    if (text.isEmpty) return;

    final payload = {
      "community_id": widget.communityId,
      "comments": text,
      if (_replyParentId != null) ...{
        "parent_id": _replyParentId,
        "is_reply": 1,
        "hashuser": _replyingToUserId,
      },
    };
    context.read<PostCommentCubit>().postComment(payload, CommunityPosts());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: CustomAppBar1(title: "Post Details", actions: []),
      body: BlocBuilder<CommunityDetailsCubit, CommunityDetailsState>(
        builder: (context, state) {
          if (state is CommunityDetailsLoading) {
            return CommunityDetailsShimmer();
          } else if (state is CommunityDetailsLoaded) {
            final communityDetails = state.communityDetailsModel.communityposts;
            return SingleChildScrollView(
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: CachedNetworkImage(
                      imageUrl:
                          communityDetails?.imgUrl?.trim().isNotEmpty == true
                          ? communityDetails!.imgUrl!
                          : '', // handle null/empty URL safely
                      width: double.infinity,
                      fit: BoxFit.cover,
                      placeholder: (context, url) => Container(
                        color: Colors.grey.shade100,
                        child: Center(
                          child: SizedBox(
                            width: 30,
                            height: 30,
                            child: spinkits.getSpinningLinespinkit(),
                          ),
                        ),
                      ),

                      errorWidget: (context, url, error) => Container(
                        color: Colors.grey.shade200,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: const [
                            Icon(
                              Icons.broken_image,
                              size: 42,
                              color: Colors.grey,
                            ),
                            SizedBox(height: 8),
                            Text(
                              "Image not available",
                              style: TextStyle(
                                color: Colors.grey,
                                fontSize: 12,
                                fontFamily: 'segeo',
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),

                  // ClipRRect(
                  //   borderRadius: BorderRadius.circular(8),
                  //   child: CachedNetworkImage(
                  //     width: SizeConfig.screenWidth,
                  //     imageUrl: communityDetails?.imgUrl ?? "",
                  //     fit: BoxFit.cover,
                  //     placeholder: (context, url) =>
                  //         Center(child: spinkits.getSpinningLinespinkit()),
                  //     errorWidget: (context, url, error) => Container(height: 180,
                  //       color: Colors.grey.shade100,
                  //       child: const Icon(Icons.broken_image, size: 40),
                  //     ),
                  //   ),
                  // ),
                  const SizedBox(height: 12),
                  if (communityDetails?.anonymous == 0) ...[
                    Row(
                      children: [
                        CircleAvatar(
                          radius: 16,
                          backgroundImage:
                              (communityDetails
                                      ?.uploader
                                      ?.profilePicUrl
                                      ?.isNotEmpty ??
                                  false)
                              ? NetworkImage(
                                  communityDetails!.uploader!.profilePicUrl!,
                                )
                              : const AssetImage("assets/images/profile.png")
                                    as ImageProvider,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          communityDetails?.anonymous == 1
                              ? "Anonymous"
                              : capitalize(
                                  communityDetails?.uploader?.name ?? "",
                                ),
                          style: const TextStyle(
                            fontFamily: 'segeo',
                            fontSize: 13,
                            color: Color(0xff222222),
                          ),
                        ),
                      ],
                    ),
                  ] else ...[
                    Text(
                      "Anonymous Post",
                      style: const TextStyle(
                        fontFamily: 'segeo',
                        fontWeight: FontWeight.w500,
                        fontSize: 15,
                        color: Color(0xFF222222),
                      ),
                    ),
                    const SizedBox(height: 8),
                  ],
                  Text(
                    "Posted At ${formatSmartDateTime(communityDetails?.createdAt ?? "")}",
                    style: const TextStyle(
                      fontFamily: 'segeo',
                      fontWeight: FontWeight.w500,
                      fontSize: 12,
                      color: Color(0xFF222222),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    communityDetails?.heading ?? "",
                    style: const TextStyle(
                      fontFamily: 'segeo',
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: Color(0xFF222222),
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    communityDetails?.description ?? "",
                    style: const TextStyle(
                      fontFamily: 'segeo',
                      fontSize: 14,
                      color: Color(0xFF666666),
                    ),
                  ),

                  const SizedBox(height: 12),
                  FutureBuilder(
                    future: AuthService.isGuest,
                    builder: (context, snapshot) {
                      final isGuest = snapshot.data ?? false;
                      return StatefulBuilder(
                        builder: (context, setState) {
                          return Row(
                            children: [
                              BlocBuilder<PostCommentCubit, PostCommentStates>(
                                builder: (context, commentState) {
                                  return Row(
                                    children: [
                                      IconButton(
                                        visualDensity: VisualDensity.compact,
                                        padding: EdgeInsets.zero,
                                        onPressed: () {
                                          if (isGuest) {
                                            context.push('/auth_landing');
                                          } else {
                                            final data = {
                                              "community_id":
                                                  communityDetails?.id,
                                            };
                                            context
                                                .read<PostCommentCubit>()
                                                .postLike(
                                                  data,
                                                  communityDetails!,
                                                );
                                          }
                                        },
                                        icon: Icon(
                                          (communityDetails?.isLiked ?? false)
                                              ? Icons.favorite
                                              : Icons.favorite_border,
                                          size: 16,
                                          color:
                                              (communityDetails?.isLiked ??
                                                  false)
                                              ? Colors.red
                                              : Colors.black26,
                                        ),
                                      ),
                                      Text(
                                        "${communityDetails?.likesCount ?? 0}",
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
                              Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  IconButton(
                                    visualDensity: VisualDensity.compact,
                                    padding: EdgeInsets.zero,
                                    onPressed: () {
                                      if (isGuest) {
                                        context.push('/auth_landing');
                                      }
                                    },
                                    icon: Image.asset(
                                      "assets/icons/Chat.png",
                                      width: 18,
                                      height: 18,
                                    ),
                                  ),
                                  BlocBuilder<
                                    PostCommentCubit,
                                    PostCommentStates
                                  >(
                                    builder: (context, state) {
                                      return Text(
                                        communityDetails?.commentsCount
                                                ?.toString() ??
                                            "0",
                                        style: const TextStyle(
                                          fontFamily: 'segeo',
                                        ),
                                      );
                                    },
                                  ),
                                ],
                              ),
                              IconButton(
                                padding: EdgeInsets
                                    .zero, // remove default extra padding
                                visualDensity: VisualDensity.compact,
                                icon: Image.asset(
                                  'assets/icons/share.png',
                                  width: 16,
                                  height: 16,
                                ),
                                onPressed: () async {
                                  final postId = communityDetails?.id;
                                  final shareUrl =
                                      "https://mentivisor.com/community_post/$postId";
                                  Share.share(
                                    "Check out this Community Post on Mentivisor:\n$shareUrl",
                                    subject: "Mentivisor Community Post",
                                  );
                                },
                              ),
                              Spacer(),
                              GestureDetector(
                                onTap: () =>
                                    _showReportSheet(context, communityDetails),
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
                  const SizedBox(height: 20),
                  const Text(
                    'Comments',
                    style: TextStyle(
                      fontFamily: 'segeo',
                      fontWeight: FontWeight.w700,
                      fontSize: 16,
                      color: Color(0xff333333),
                    ),
                  ),
                  const SizedBox(height: 12),

                  BlocBuilder<FetchCommentsCubit, FetchCommentsStates>(
                    builder: (context, fetchState) {
                      if (fetchState is FetchCommentsLoading) {
                        return CommentsListShimmer();
                      }
                      if (fetchState is FetchCommentsFailure) {
                        return Center(
                          child: Text(
                            fetchState.error ?? "Failed to load comments",
                          ),
                        );
                      }
                      if (fetchState is FetchCommentsLoaded) {
                        final list =
                            fetchState.commentsModel.data ??
                            <CommunityOnComments>[];
                        if (list.isEmpty) {
                          return const Center(
                            child: Text(
                              "No comments yet",
                              style: TextStyle(fontFamily: 'segeo'),
                            ),
                          );
                        }

                        return RefreshIndicator(
                          onRefresh: () => context
                              .read<FetchCommentsCubit>()
                              .getComments(widget.communityId),
                          child: ListView.builder(
                            padding: EdgeInsets.only(
                              left: 10,
                              right: 10,
                              top: 10,
                            ),
                            controller: _scrollController,
                            physics: NeverScrollableScrollPhysics(),
                            shrinkWrap: true,
                            itemCount: list.length,
                            itemBuilder: (ctx, i) {
                              final c = list[i];
                              return CommentCard(
                                key: ValueKey(c.id),
                                id: c.id ?? 0,
                                name: c.user?.name ?? 'Unknown',
                                profileUrl: c.user?.profilePicUrl ?? '',
                                content: c.content ?? '',
                                createdAt: c.createdAt ?? '',
                                isLiked: c.isLiked,
                                likesCount: c.likesCount,
                                onLike: () {
                                  setState(
                                    () {},
                                  ); // instantly rebuild this widget
                                  context
                                      .read<PostCommentCubit>()
                                      .likeParentComment(c);
                                },

                                replies: c.replies ?? const [],
                                onReplyLike: (replyId) {
                                  setState(() {});
                                  final reply = c.replies?.firstWhere(
                                    (r) => r.id == replyId,
                                    orElse: () => Replies(),
                                  );
                                  if (reply != null) {
                                    context.read<PostCommentCubit>().likeReply(
                                      parent: c,
                                      reply: reply,
                                    );
                                  }
                                },
                                onReplyReply:
                                    (replyUserName, replyMsg, replyUserId) =>
                                        _startReply(
                                          c.id!,
                                          replyUserName,
                                          replyMsg,
                                          replyUserId,
                                        ),
                                onReply: () => _startReply(
                                  c.id!,
                                  c.user?.name ?? 'Unknown',
                                  c.content ?? "",
                                  c.user?.id ?? 0,
                                ),
                              );
                            },
                          ),
                        );
                      }
                      return const SizedBox.shrink();
                    },
                  ),
                ],
              ),
            );
          } else if (state is CommunityDetailsFailure) {
            return Center(child: Text(state.message));
          } else {
            return const Center(child: Text("No Data"));
          }
        },
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 0, 16, 20),
          child: BlocConsumer<PostCommentCubit, PostCommentStates>(
            listener: (context, state) async {
              if (state is PostCommentLoaded) {
                _controller.clear();
                _cancelReply();
                await context.read<FetchCommentsCubit>().getComments(
                  widget.communityId,
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

              return Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // 🔹 Show reply target if user is replying
                  if (_replyParentId != null && _replyingToName != null)
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 8,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.grey.shade200,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      margin: const EdgeInsets.only(bottom: 8),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                '@$_replyingToName',
                                style: const TextStyle(
                                  fontFamily: 'segeo',
                                  fontWeight: FontWeight.w600,
                                  color: Colors.black87,
                                ),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                _replyingToMsg ?? '',
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                  fontFamily: 'segeo',
                                  fontSize: 13,
                                  color: Colors.grey,
                                ),
                              ),
                            ],
                          ),
                          IconButton(
                            onPressed: _cancelReply,
                            icon: const Icon(
                              Icons.close,
                              color: Colors.grey,
                              size: 20,
                            ),
                            padding: EdgeInsets.zero,
                            visualDensity: VisualDensity.compact,
                          ),
                        ],
                      ),
                    ),

                  // 🔹 Comment Input Field
                  Padding(
                    padding: EdgeInsets.only(
                      bottom: MediaQuery.of(context).viewInsets.bottom,
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: TextField(
                            controller: _controller,
                            autofocus:
                                _replyParentId !=
                                null, // auto-focus when replying
                            textInputAction: TextInputAction.send,
                            onSubmitted: (_) => _send(),
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
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }

  void _showReportSheet(BuildContext context, communityPosts) {
    String _selected = 'Copied';
    final TextEditingController _otherController = TextEditingController();
    final List<String> _reportReasons = [
      'Copied',
      'Scam or Fraud',
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
                        );
                      }).toList(),
                    ),
                    if (_selected == 'Other')
                      TextField(
                        controller: _otherController,
                        maxLines: 3,
                        decoration: InputDecoration(
                          hintText: 'Please explain your reason',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                      ),
                    const SizedBox(height: 16),
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
                          CustomSnackBar1.show(context, state.message ?? "");
                        }
                      },
                      builder: (context, state) {
                        return CustomAppButton1(
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
                        );
                      },
                    ),
                    const SizedBox(height: 20),
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

class CommentsListShimmer extends StatelessWidget {
  const CommentsListShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.only(left: 10, right: 10, top: 10),
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemCount: 6, // number of shimmer placeholders
      itemBuilder: (ctx, i) => const _CommentCardShimmer(),
    );
  }
}

class _CommentCardShimmer extends StatelessWidget {
  const _CommentCardShimmer();

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 🔹 Header row (profile + name + date)
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              shimmerCircle(36, context),
              const SizedBox(width: 10),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  shimmerText(120, 14, context), // username
                  const SizedBox(height: 4),
                  shimmerText(80, 10, context), // date
                ],
              ),
            ],
          ),
          const SizedBox(height: 10),

          // 🔹 Comment content shimmer (2–3 lines)
          shimmerText(double.infinity, 12, context),
          const SizedBox(height: 6),
          shimmerText(250, 12, context),
          const SizedBox(height: 8),

          // 🔹 Like & Reply bar
          Row(
            children: [
              shimmerContainer(60, 20, context), // Like
              const SizedBox(width: 10),
              shimmerContainer(60, 20, context), // Reply
            ],
          ),

          // 🔹 Optional replies shimmer
          const SizedBox(height: 12),
          Padding(
            padding: const EdgeInsets.only(left: 46), // align under parent
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                shimmerText(100, 12, context), // reply user
                const SizedBox(height: 6),
                shimmerText(200, 12, context),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class CommunityDetailsShimmer extends StatelessWidget {
  const CommunityDetailsShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 🔹 Post Banner Image
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: shimmerContainer(double.infinity, 160, context),
          ),
          const SizedBox(height: 12),

          // 🔹 User Info
          Row(
            children: [
              shimmerCircle(32, context),
              const SizedBox(width: 8),
              shimmerText(100, 13, context),
            ],
          ),
          const SizedBox(height: 10),

          // 🔹 Heading
          shimmerText(180, 16, context),
          const SizedBox(height: 6),

          // 🔹 Description (2–3 lines)
          shimmerText(double.infinity, 12, context),
          const SizedBox(height: 6),
          shimmerText(240, 12, context),
          const SizedBox(height: 6),
          shimmerText(180, 12, context),

          const SizedBox(height: 12),
          Row(
            children: [
              shimmerCircle(16, context),
              const SizedBox(width: 6),
              shimmerText(30, 12, context), // Likes count
              const SizedBox(width: 14),
              shimmerCircle(16, context),
              const SizedBox(width: 6),
              shimmerText(30, 12, context), // Comments count
              const SizedBox(width: 14),
              shimmerCircle(16, context),
              const SizedBox(width: 6),
              shimmerText(40, 12, context), // Share
              const Spacer(),
              shimmerCircle(16, context),
              const SizedBox(width: 6),
              shimmerText(50, 12, context), // Report
            ],
          ),

          const SizedBox(height: 20),

          // 🔹 "Comments" Title
          shimmerText(100, 16, context),
          const SizedBox(height: 12),

          // 🔹 Comments list shimmer
          const CommentsListShimmer(),
        ],
      ),
    );
  }
}
