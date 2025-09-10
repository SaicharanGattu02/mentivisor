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

import '../../Components/CommonLoader.dart';
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
  @override
  void initState() {
    super.initState();
    context.read<SessionCompletedCubit>().sessionComplete();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffF5F6FF),
      appBar: CustomAppBar1(
        title: 'Session Completed',
        actions: const [],
        color: const Color(0xffF5F6FF),
      ),
      body: SafeArea(
        child: BlocBuilder<SessionCompletedCubit, SessionCompletedStates>(
          builder: (context, state) {
            if (state is SessionCompletedLoading) {
              return Scaffold(body: Center(child: DottedProgressWithLogo()));
            } else if (state is SessionCompletedLoaded) {
              final sessions = state.completedSessionModel.data ?? [];

              if (sessions.isEmpty) {
                return CustomScrollView(
                  slivers: [
                    SliverFillRemaining(
                      hasScrollBody: false,
                      child: Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: const [
                            Image(
                              image: AssetImage("assets/nodata/no_data.png"),
                              height: 120,
                            ),
                            SizedBox(height: 16),
                            Text(
                              "No Sessions Available",
                              style: TextStyle(
                                color: Colors.grey,
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                                fontFamily: 'segeo',
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                );
              }

              return CustomScrollView(
                slivers: [
                  SliverPadding(
                    padding: const EdgeInsets.all(16.0),
                    sliver: SliverList(
                      delegate: SliverChildBuilderDelegate((context, index) {
                        final completeSessions = sessions[index];
                        if (completeSessions == null) {
                          return const SizedBox.shrink();
                        }

                        return
                        //   Container(
                        //   margin: const EdgeInsets.only(bottom: 16),
                        //   decoration: BoxDecoration(
                        //     color: Colors.white,
                        //     borderRadius: BorderRadius.circular(16),
                        //   ),
                        //   padding: EdgeInsets.all(12),
                        //   child: Column(
                        //     children: [
                        //       Row(
                        //         mainAxisAlignment:
                        //             MainAxisAlignment.spaceBetween,
                        //         children: [
                        //           SizedBox(
                        //             width: SizeConfig.screenWidth * 0.6,
                        //             child: Column(
                        //               crossAxisAlignment:
                        //                   CrossAxisAlignment.start,
                        //               children: [
                        //                 Text(
                        //                   completeSessions.topics?.isNotEmpty ??
                        //                           false
                        //                       ? completeSessions.topics!
                        //                       : "No topics specified",
                        //                   style: const TextStyle(
                        //                     fontSize: 18,
                        //                     fontWeight: FontWeight.bold,
                        //                     fontFamily: "segeo",
                        //                     color: Colors.black87,
                        //                   ),
                        //                 ),
                        //                 const SizedBox(height: 6),
                        //                 Text(
                        //                   "With ${capitalize(completeSessions.mentor?.name ?? "Unknown Mentor")}",
                        //                   style: TextStyle(
                        //                     fontSize: 14,
                        //                     fontFamily: "segeo",
                        //                     color: Colors.grey.shade600,
                        //                   ),
                        //                 ),
                        //                 const SizedBox(height: 12),
                        //                 Wrap(
                        //                   spacing: 12,
                        //                   runSpacing: 8,
                        //                   children: [
                        //                     _buildInfoChip(
                        //                       icon: Icons.calendar_today,
                        //                       label:
                        //                           completeSessions.date ??
                        //                           "N/A",
                        //                       color: Colors.blue.shade50,
                        //                       textColor: Colors.blue.shade700,
                        //                     ),
                        //                     _buildInfoChip(
                        //                       icon: Icons.access_time,
                        //                       label:
                        //                           "${completeSessions.startTime ?? 'N/A'} - ${completeSessions.endTime ?? 'N/A'}",
                        //                       color: Colors.blue.shade50,
                        //                       textColor: Colors.blue.shade700,
                        //                     ),
                        //                   ],
                        //                 ),
                        //               ],
                        //             ),
                        //           ),
                        //           SizedBox(
                        //             width: SizeConfig.screenWidth * 0.25,
                        //             child: Column(
                        //               crossAxisAlignment:
                        //                   CrossAxisAlignment.center,
                        //               mainAxisAlignment:
                        //                   MainAxisAlignment.center,
                        //               children: [
                        //                 Center(
                        //                   child: CircleAvatar(
                        //                     radius: 20,
                        //                     backgroundColor: Colors.white,
                        //                     child: Icon(
                        //                       Icons.check_circle_outline,
                        //                       color: Colors.green,
                        //                       size: 30,
                        //                     ),
                        //                   ),
                        //                 ),
                        //                 const SizedBox(height: 12),
                        //                 const Text(
                        //                   'Session completed',
                        //                   style: TextStyle(
                        //                     color: Color(0xff444444),
                        //                     fontWeight: FontWeight.w600,
                        //                     fontFamily: 'segeo',
                        //                     fontSize: 14,
                        //                   ),
                        //                 ),
                        //               ],
                        //             ),
                        //           ),
                        //         ],
                        //       ),
                        //       const SizedBox(height: 16),
                        //       Row(
                        //         spacing: 10,
                        //         children: [
                        //           SizedBox(
                        //             height: 32,
                        //             child: OutlinedButton.icon(
                        //               onPressed: () {
                        //                 _showReportSheet(
                        //                   context,
                        //                   completeSessions.id ?? 0,
                        //                 );
                        //               },
                        //               icon: Icon(
                        //                 Icons.flag,
                        //                 color: Color(0xFFA6A6A6),
                        //                 size: 16,
                        //               ),
                        //               label: Text(
                        //                 "Report Session",
                        //                 style: TextStyle(
                        //                   fontSize: 12,
                        //                   fontFamily: "segeo",
                        //                   fontWeight: FontWeight.w600,
                        //                   color: Color(0xff000000),
                        //                 ),
                        //               ),
                        //               style: OutlinedButton.styleFrom(
                        //                 backgroundColor: Color(0xffF5F5F5),
                        //                 visualDensity: VisualDensity.compact,
                        //                 side: BorderSide(
                        //                   color: Colors.transparent,
                        //                 ),
                        //                 shape: RoundedRectangleBorder(
                        //                   borderRadius: BorderRadius.circular(
                        //                     8,
                        //                   ),
                        //                 ),
                        //                 padding: EdgeInsets.symmetric(
                        //                   vertical: 8,
                        //                   horizontal: 8,
                        //                 ),
                        //               ),
                        //             ),
                        //           ),
                        //           if (completeSessions.hasRating == false) ...[
                        //             SizedBox(
                        //               height: 32,
                        //               child: OutlinedButton(
                        //                 onPressed: () {
                        //                   showReviewBottomSheet(
                        //                     context: context,
                        //                     sessionId: completeSessions.id ?? 0,
                        //                   );
                        //                 },
                        //                 style: OutlinedButton.styleFrom(
                        //                   visualDensity: VisualDensity.compact,
                        //                   side: BorderSide(
                        //                     color: Colors.grey.shade300,
                        //                   ),
                        //                   shape: RoundedRectangleBorder(
                        //                     borderRadius: BorderRadius.circular(
                        //                       8,
                        //                     ),
                        //                   ),
                        //                   padding: const EdgeInsets.symmetric(
                        //                     vertical: 8,
                        //                     horizontal: 12,
                        //                   ),
                        //                 ),
                        //                 child: const Text(
                        //                   "Rate Us",
                        //                   style: TextStyle(
                        //                     fontSize: 12,
                        //                     fontFamily: "segeo",
                        //                     color: Colors.black87,
                        //                   ),
                        //                 ),
                        //               ),
                        //             ),
                        //           ],
                        //         ],
                        //       ),
                        //     ],
                        //   ),
                        // );
                        Container(
                          margin: const EdgeInsets.only(bottom: 16),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(16),
                          ),
                          padding: const EdgeInsets.all(12),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  // Left side: title, mentor, date
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        completeSessions.topics?.isNotEmpty ??
                                                false
                                            ? completeSessions.topics!
                                            : "No topics specified",
                                        style: const TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                          fontFamily: "segeo",
                                          color: Colors.black87,
                                        ),
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        "With ${capitalize(completeSessions.mentor?.name ?? "Unknown Mentor")}",
                                        style: TextStyle(
                                          fontSize: 14,
                                          fontFamily: "segeo",
                                          color: Colors.grey.shade600,
                                        ),
                                      ),
                                      const SizedBox(height: 6),
                                      Text(
                                        "${formatDate(completeSessions.date ?? "N/A")} ${completeSessions.startTime ?? ""}",
                                        style: TextStyle(
                                          fontSize: 14,
                                          fontFamily: "segeo",
                                          color: Colors.black87,
                                        ),
                                      ),
                                    ],
                                  ),

                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      SizedBox(height: 20),
                                      const Icon(
                                        Icons.check_circle_outline,
                                        color: Colors.green,
                                        size: 24,
                                      ),
                                      const SizedBox(height: 4),
                                      const Text(
                                        textAlign: TextAlign.center,
                                        "Session completed",
                                        style: TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w600,
                                          fontFamily: "segeo",
                                          color: Colors.black87,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                              const SizedBox(height: 12),
                              // Report button
                              Row(spacing: 12,
                                children: [
                                  SizedBox(
                                    height: 32,
                                    child: OutlinedButton.icon(
                                      onPressed: () {
                                        _showReportSheet(
                                          context,
                                          completeSessions.id ?? 0,
                                        );
                                      },
                                      icon: const Icon(
                                        Icons.flag,
                                        color: Color(0xFFA6A6A6),
                                        size: 16,
                                      ),
                                      label: const Text(
                                        "Report Session",
                                        style: TextStyle(
                                          fontSize: 12,
                                          fontFamily: "segeo",
                                          fontWeight: FontWeight.w600,
                                          color: Color(0xff000000),
                                        ),
                                      ),
                                      style: OutlinedButton.styleFrom(
                                        backgroundColor: const Color(
                                          0xffF5F5F5,
                                        ),
                                        visualDensity: VisualDensity.compact,
                                        side: BorderSide.none,
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(
                                            8,
                                          ),
                                        ),
                                        padding: const EdgeInsets.symmetric(
                                          vertical: 8,
                                          horizontal: 8,
                                        ),
                                      ),
                                    ),
                                  ),
                                  if (completeSessions.hasRating == false) ...[
                                    SizedBox(
                                      height: 32,
                                      child: OutlinedButton(
                                        onPressed: () {
                                          showReviewBottomSheet(
                                            context: context,
                                            sessionId: completeSessions.id ?? 0,
                                          );
                                        },
                                        style: OutlinedButton.styleFrom(
                                          visualDensity: VisualDensity.compact,
                                          side: BorderSide(
                                            color: Colors.grey.shade300,
                                          ),
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(
                                              8,
                                            ),
                                          ),
                                          padding: const EdgeInsets.symmetric(
                                            vertical: 8,
                                            horizontal: 12,
                                          ),
                                        ),
                                        child: const Text(
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
                        );
                      }, childCount: sessions.length),
                    ),
                  ),
                ],
              );
            } else if (state is SessionCompletedFailure) {
              return Center(child: Text(state.msg));
            }
            return const Center(child: Text("No Data"));
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

  void showReviewBottomSheet({
    required BuildContext context,
    required int sessionId,
  }) {
    final TextEditingController feedbackController = TextEditingController();
    int selectedRating = 0;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) {
        return SafeArea(
          child: StatefulBuilder(
            builder: (context, setState) {
              return Padding(
                padding: EdgeInsets.only(
                  bottom: MediaQuery.of(context).viewInsets.bottom,
                  left: 16,
                  right: 16,
                  top: 16,
                ),
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16),
                        ),
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                             SizedBox(height: 12),
                             Text(
                              "Rate your Experience",
                              style: TextStyle(
                                color: Color(0xff666666),
                                fontWeight: FontWeight.w600,
                                fontSize: 14,
                              ),
                            ),
                            const SizedBox(height: 12),
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
                                fillColor: const Color(0xFFF5F5F5),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(24),
                                  borderSide: BorderSide.none,
                                ),
                              ),
                            ),
                            const SizedBox(height: 12),
                            BlocConsumer<SubmitReviewCubit, SubmitReviewStates>(
                              listener: (context, reviewSubmit) {
                                if (reviewSubmit is SubmitReviewSuccess) {
                                  feedbackController.clear();
                                  selectedRating = 0;
                                  Navigator.pop(context);
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
                                      reviewSubmit is SubmitReviewLoading,
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
                                      "feedback": feedbackController.text
                                          .trim(),
                                    };

                                    context
                                        .read<SubmitReviewCubit>()
                                        .submitReview(data, sessionId);
                                  },
                                );
                              },
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 16),
                    ],
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }

  void _showReportSheet(BuildContext context, int sessionId) {
    String _selected = 'Mentor is not available';
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
                          debugPrint("errorrrrr:${state.error ?? ""}");
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
                              "reason": _selected == 'Other'
                                  ? _otherController.text.trim()
                                  : _selected,
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
