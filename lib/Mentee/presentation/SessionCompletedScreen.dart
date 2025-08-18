import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:mentivisor/Components/CustomAppButton.dart';
import 'package:mentivisor/Components/CustomSnackBar.dart';
import 'package:mentivisor/Components/CutomAppBar.dart';
import 'package:mentivisor/Mentee/data/cubits/StudyZoneReport/StudyZoneReportState.dart';
import 'package:mentivisor/Mentee/data/cubits/SubmitReview/submit_review_cubit.dart';
import 'package:mentivisor/Mentee/data/cubits/SubmitReview/submit_review_states.dart';

import '../../utils/color_constants.dart';
import '../../utils/constants.dart';
import '../../utils/media_query_helper.dart';
import '../data/cubits/SessionCompleted/session_completed_cubit.dart';
import '../data/cubits/SessionCompleted/session_completed_states.dart';

class SessionCompletedScreen extends StatefulWidget {
  const SessionCompletedScreen({Key? key}) : super(key: key);

  @override
  State<SessionCompletedScreen> createState() => _SessionCompletedScreenState();
}

class _SessionCompletedScreenState extends State<SessionCompletedScreen> {
  int selectedRating = 0;
  final TextEditingController feedbackController = TextEditingController();
  int? _selectedSessionId;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<SessionCompletedCubit>().sessionComplete();
    });
  }

  @override
  void dispose() {
    feedbackController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xffF5F6FF),
      appBar: CustomAppBar1(
        title: 'Session Completed',
        actions: [],
        color: Color(0xffF5F6FF),
      ),
      body: SafeArea(
        child: BlocBuilder<SessionCompletedCubit, SessionCompletedStates>(
          builder: (context, state) {
            if (state is SessionCompletedLoading) {
              return Center(
                child: CircularProgressIndicator(color: primarycolor),
              );
            } else if (state is SessionCompletedLoaded) {
              return CustomScrollView(
                slivers: [
                  SliverPadding(
                    padding: const EdgeInsets.all(16.0),
                    sliver: SliverList(
                      delegate: SliverChildBuilderDelegate((context, index) {
                        final completeSessions =
                            state.completedSessionModel.data?[index];

                        if (completeSessions == null) {
                          return const SizedBox.shrink();
                        }
                        final isReviewing =
                            _selectedSessionId == completeSessions.id;

                        return Column(
                          spacing: 12,
                          children: [
                            if (isReviewing &&
                                completeSessions.hasRating == false) ...[
                              Container(
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(16),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.grey.shade200,
                                      blurRadius: 6,
                                      offset: const Offset(0, 2),
                                    ),
                                  ],
                                ),
                                padding: const EdgeInsets.all(16),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    // Row(
                                    //   children: [
                                    //     Text(
                                    //       completeSessions.topics?.isNotEmpty ??
                                    //               false
                                    //           ? completeSessions.topics!
                                    //           : "No topics specified",
                                    //       style: TextStyle(
                                    //         fontSize:
                                    //             18, // Slightly larger for emphasis
                                    //         fontWeight: FontWeight.bold,
                                    //         fontFamily: "segeo",
                                    //         color: Colors.black87,
                                    //       ),
                                    //     ),
                                    //     const SizedBox(height: 6),
                                    //
                                    //     Text(
                                    //       "With ${capitalize(completeSessions.mentor?.name ?? "Unknown Mentor")}",
                                    //       style: TextStyle(
                                    //         fontSize: 14,
                                    //         fontFamily: "segeo",
                                    //         color: Colors.grey.shade600,
                                    //       ),
                                    //     ),
                                    //     const SizedBox(height: 12),
                                    //     Wrap(
                                    //       spacing: 12,
                                    //       runSpacing: 8,
                                    //       children: [
                                    //         _buildInfoChip(
                                    //           icon: Icons.calendar_today,
                                    //           label:
                                    //               completeSessions.date ??
                                    //               "N/A",
                                    //           color: Colors.blue.shade50,
                                    //           textColor: Colors.blue.shade700,
                                    //         ),
                                    //         _buildInfoChip(
                                    //           icon: Icons.access_time,
                                    //           label:
                                    //               "${completeSessions.startTime ?? 'N/A'} - ${completeSessions.endTime ?? 'N/A'}",
                                    //           color: Colors.blue.shade50,
                                    //           textColor: Colors.blue.shade700,
                                    //         ),
                                    //       ],
                                    //     ),
                                    //     Column(
                                    //       children: [
                                    //         ClipOval(
                                    //           child: CachedNetworkImage(
                                    //             width: 56, // Consistent size
                                    //             height: 56,
                                    //             imageUrl:
                                    //                 completeSessions
                                    //                     .mentor
                                    //                     ?.mentorProfile ??
                                    //                 "",
                                    //             fit: BoxFit.cover,
                                    //             placeholder: (context, url) =>
                                    //                 Container(
                                    //                   width: 56,
                                    //                   height: 56,
                                    //                   color:
                                    //                       Colors.grey.shade200,
                                    //                   child: const Center(
                                    //                     child: CircularProgressIndicator(
                                    //                       valueColor:
                                    //                           AlwaysStoppedAnimation<
                                    //                             Color
                                    //                           >(Colors.blue),
                                    //                     ),
                                    //                   ),
                                    //                 ),
                                    //             errorWidget:
                                    //                 (
                                    //                   context,
                                    //                   url,
                                    //                   error,
                                    //                 ) => Container(
                                    //                   width: 56,
                                    //                   height: 56,
                                    //                   color:
                                    //                       Colors.grey.shade200,
                                    //                   child: Image.asset(
                                    //                     "assets/images/profile.png",
                                    //                     fit: BoxFit.cover,
                                    //                   ),
                                    //                 ),
                                    //           ),
                                    //         ),
                                    //         CircleAvatar(
                                    //           radius: 20,
                                    //           backgroundColor: Colors.white,
                                    //           child: const Icon(
                                    //             Icons.check_circle_outline,
                                    //             color: Colors.green,
                                    //             size: 30,
                                    //           ),
                                    //         ),
                                    //         SizedBox(height: 12),
                                    //         Text(
                                    //           'Session completed',
                                    //           style: TextStyle(
                                    //             color: Color(0xff444444),
                                    //             fontWeight: FontWeight.w600,
                                    //             fontFamily: 'segeo',
                                    //             fontSize: 14,
                                    //           ),
                                    //         ),
                                    //       ],
                                    //     ),
                                    //   ],
                                    // ),
                                    SizedBox(height: 12),
                                    Text(
                                      "Rate your Experience",
                                      style: TextStyle(
                                        color: Color(0xff666666),
                                        fontWeight: FontWeight.w400,
                                        fontSize: 12,
                                      ),
                                    ),
                                    SizedBox(height: 12),

                                    Row(
                                      children: List.generate(5, (i) {
                                        final starIndex = i + 1;
                                        return GestureDetector(
                                          onTap: () {
                                            setState(() {
                                              selectedRating = starIndex;
                                            });
                                          },
                                          child: Icon(
                                            selectedRating >= starIndex
                                                ? Icons.star
                                                : Icons.star_border,
                                            size: 42,
                                            color: Colors.amber,
                                          ),
                                        );
                                      }),
                                    ),
                                    const SizedBox(height: 12),

                                    TextField(
                                      controller: feedbackController,
                                      maxLines: 3,
                                      decoration: InputDecoration(
                                        hintText: 'Explain here (optional)',
                                        filled: true,
                                        fillColor: Color(0xFFF5F5F5),
                                        border: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(
                                            24,
                                          ),
                                          borderSide: BorderSide.none,
                                        ),
                                      ),
                                    ),

                                    const SizedBox(height: 12),

                                    BlocConsumer<
                                      SubmitReviewCubit,
                                      SubmitReviewStates
                                    >(
                                      listener: (context, reviewSubmit) {
                                        if (reviewSubmit
                                            is SubmitReviewSuccess) {
                                          feedbackController.clear();
                                          selectedRating = 0;
                                          context
                                              .read<SessionCompletedCubit>()
                                              .sessionComplete();
                                        } else if (reviewSubmit
                                            is SubmitReviewFailure) {
                                          CustomSnackBar1.show(
                                            context,
                                            reviewSubmit.error,
                                          );
                                        }
                                      },
                                      builder: (context, reviewSubmit) {
                                        return CustomAppButton1(
                                          isLoading:
                                              reviewSubmit
                                                  is SubmitReviewLoading,
                                          text: "Submit",
                                          onPlusTap: () {
                                            if (selectedRating == 0) {
                                              CustomSnackBar1.show(
                                                context,
                                                "Please select a rating",
                                              );
                                              return;
                                            }

                                            final Map<String, dynamic> data = {
                                              "rating": selectedRating,
                                              "feedback": feedbackController
                                                  .text
                                                  .trim(),
                                            };

                                            context
                                                .read<SubmitReviewCubit>()
                                                .submitReview(
                                                  data,
                                                  completeSessions.id ?? 0,
                                                );
                                          },
                                        );
                                      },
                                    ),
                                  ],
                                ),
                              ),
                            ],
                            Container(
                              margin: const EdgeInsets.only(bottom: 16),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(16),
                              ),
                              padding: EdgeInsets.all(8),
                              child: Column(
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Container(
                                        width: SizeConfig.screenWidth * 0.6,
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              completeSessions
                                                          .topics
                                                          ?.isNotEmpty ??
                                                      false
                                                  ? completeSessions.topics!
                                                  : "No topics specified",
                                              style: TextStyle(
                                                fontSize:
                                                    18, // Slightly larger for emphasis
                                                fontWeight: FontWeight.bold,
                                                fontFamily: "segeo",
                                                color: Colors.black87,
                                              ),
                                            ),
                                            const SizedBox(height: 6),

                                            Text(
                                              "With ${capitalize(completeSessions.mentor?.name ?? "Unknown Mentor")}",
                                              style: TextStyle(
                                                fontSize: 14,
                                                fontFamily: "segeo",
                                                color: Colors.grey.shade600,
                                              ),
                                            ),
                                            const SizedBox(height: 12),
                                            Wrap(
                                              spacing: 12,
                                              runSpacing: 8,
                                              children: [
                                                _buildInfoChip(
                                                  icon: Icons.calendar_today,
                                                  label:
                                                      completeSessions.date ??
                                                      "N/A",
                                                  color: Colors.blue.shade50,
                                                  textColor:
                                                      Colors.blue.shade700,
                                                ),
                                                _buildInfoChip(
                                                  icon: Icons.access_time,
                                                  label:
                                                      "${completeSessions.startTime ?? 'N/A'} - ${completeSessions.endTime ?? 'N/A'}",
                                                  color: Colors.blue.shade50,
                                                  textColor:
                                                      Colors.blue.shade700,
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),

                                      Container(
                                        width: SizeConfig.screenWidth * 0.25,
                                        child: Column(
                                          children: [
                                            ClipOval(
                                              child: CachedNetworkImage(
                                                width: 56, // Consistent size
                                                height: 56,
                                                imageUrl:
                                                    completeSessions
                                                        .mentor
                                                        ?.mentorProfile ??
                                                    "",
                                                fit: BoxFit.cover,
                                                placeholder: (context, url) =>
                                                    Container(
                                                      width: 56,
                                                      height: 56,
                                                      color:
                                                          Colors.grey.shade200,
                                                      child: const Center(
                                                        child: CircularProgressIndicator(
                                                          valueColor:
                                                              AlwaysStoppedAnimation<
                                                                Color
                                                              >(Colors.blue),
                                                        ),
                                                      ),
                                                    ),
                                                errorWidget:
                                                    (
                                                      context,
                                                      url,
                                                      error,
                                                    ) => Container(
                                                      width: 56,
                                                      height: 56,
                                                      color:
                                                          Colors.grey.shade200,
                                                      child: Image.asset(
                                                        "assets/images/profile.png",
                                                        fit: BoxFit.cover,
                                                      ),
                                                    ),
                                              ),
                                            ),
                                            CircleAvatar(
                                              radius: 20,
                                              backgroundColor: Colors.white,
                                              child: const Icon(
                                                Icons.check_circle_outline,
                                                color: Colors.green,
                                                size: 30,
                                              ),
                                            ),
                                            SizedBox(height: 12),
                                            Text(
                                              'Session completed',
                                              style: TextStyle(
                                                color: Color(0xff444444),
                                                fontWeight: FontWeight.w600,
                                                fontFamily: 'segeo',
                                                fontSize: 14,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: 16),
                                  Row(
                                    spacing: 10,
                                    children: [
                                      SizedBox(
                                        height: 48,
                                        child: OutlinedButton.icon(
                                          onPressed: () {
                                            _showReportSheet(
                                              context,
                                              completeSessions.id ?? 0,
                                            );
                                          },
                                          icon: const Icon(
                                            Icons.flag,
                                            color: Color(0xFF8B5CF6),
                                            size: 16,
                                          ),
                                          label: Text(
                                            "Report Session",
                                            style: const TextStyle(
                                              fontSize: 12,
                                              fontFamily: "segeo",
                                              color: Colors.black87,
                                            ),
                                          ),
                                          style: OutlinedButton.styleFrom(
                                            visualDensity:
                                                VisualDensity.compact,
                                            side: BorderSide(
                                              color: Colors.grey.shade300,
                                            ),
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(8),
                                            ),
                                            padding: const EdgeInsets.symmetric(
                                              vertical: 8,
                                              horizontal: 12,
                                            ),
                                          ),
                                        ),
                                      ),
                                      if (completeSessions.hasRating ==
                                          false) ...[
                                        SizedBox(
                                          height: 48,
                                          child: OutlinedButton(
                                            onPressed: () {
                                              setState(() {
                                                _selectedSessionId =
                                                    completeSessions.id;
                                              });
                                            },
                                            style: OutlinedButton.styleFrom(
                                              visualDensity:
                                                  VisualDensity.compact,
                                              side: BorderSide(
                                                color: Colors.grey.shade300,
                                              ),
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(8),
                                              ),
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                    vertical: 8,
                                                    horizontal: 12,
                                                  ),
                                            ),
                                            child: Text(
                                              "Rate Us",
                                              style: TextStyle(
                                                fontSize: 12,
                                                fontFamily: "segeo",
                                                color: Colors.black87,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ],
                        );
                      }, childCount: state.completedSessionModel.data?.length ?? 0),
                    ),
                  ),
                ],
              );
            } else if (state is SessionCompletedFailure) {
              return Text(state.msg);
            }
            return Text("No Data");
          },
        ),
      ),
    );
  }

  Widget _buildInfoChip({
    required IconData icon,
    required String label,
    required Color color,
    required Color textColor,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: textColor),
          const SizedBox(width: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              fontFamily: "segeo",
              color: textColor,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  void _showReportSheet(BuildContext context, int sessionId) {
    String _selected = 'False Information';
    final TextEditingController _otherController = TextEditingController();
    final List<String> _reportReasons = [
      'Mentor is not available',
      'Vulgar language by mentor',
      'Not skilled mentor',
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
                    // Title and Close Button
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Report Session',
                          style: TextStyle(
                            fontSize: 20,
                            fontFamily: 'segeo',
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.close, color: Colors.grey),
                          onPressed: () => Navigator.of(context).pop(),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      'Reason for reporting',
                      style: TextStyle(
                        fontSize: 16,
                        fontFamily: 'segeo',
                        fontWeight: FontWeight.w600,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 8),
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
                    BlocConsumer<SubmitReviewCubit, SubmitReviewStates>(
                      listener: (context, state) {
                        if (state is SessionReportSuccess) {
                          context.pop();
                        } else if (state is SubmitReportFailure) {
                          CustomSnackBar1.show(context, state.error ?? "");
                        }
                      },
                      builder: (context, state) {
                        return CustomAppButton1(
                          isLoading: state is SessionReportReviewLoading,
                          text: "Submit Report",
                          onPlusTap: () {
                            final Map<String, dynamic> data = {
                              "content_id": sessionId,
                              "reason": _selected,
                            };
                            context.read<SubmitReviewCubit>().reportReview(
                              data,
                            );
                          },
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
