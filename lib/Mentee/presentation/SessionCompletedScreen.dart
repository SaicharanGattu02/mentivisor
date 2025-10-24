import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:go_router/go_router.dart';
import 'package:mentivisor/Components/CustomAppButton.dart';
import 'package:mentivisor/Components/CustomSnackBar.dart';
import 'package:mentivisor/Components/CutomAppBar.dart';
import 'package:mentivisor/Mentee/data/cubits/SubmitReview/submit_review_cubit.dart';
import 'package:mentivisor/Mentee/data/cubits/SubmitReview/submit_review_states.dart';
import 'package:mentivisor/utils/media_query_helper.dart';
import '../../Components/CommonLoader.dart';
import '../../Components/Shimmers.dart';
import '../../utils/constants.dart';
import '../data/cubits/SessionCompleted/session_completed_cubit.dart';
import '../data/cubits/SessionCompleted/session_completed_states.dart';

class SessionCompletedScreen extends StatefulWidget {
  SessionCompletedScreen({Key? key}) : super(key: key);

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
      backgroundColor: Color(0xffF5F6FF),
      appBar: CustomAppBar1(
        title: 'Session Completed',
        actions: const [],
        color: const Color(0xffF5F6FF),
      ),
      body: SafeArea(
        child: BlocBuilder<SessionCompletedCubit, SessionCompletedStates>(
          builder: (context, state) {
            if (state is SessionCompletedLoading) {
              return CompletedSessionsShimmer();
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
                    sliver: SliverMasonryGrid.count(
                      crossAxisCount: _getCrossAxisCount(
                        context,
                      ), // 👈 Responsive count
                      mainAxisSpacing: 16,
                      crossAxisSpacing: 16,
                      childCount: sessions.length,
                      itemBuilder: (context, index) {
                        final completeSessions = sessions[index];
                        if (completeSessions == null) {
                          return const SizedBox.shrink();
                        }

                        return Container(
                          width: double.infinity,
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
                                  // 🔹 Left side: Session details
                                  Expanded(
                                    child: Column(
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
                                          style: const TextStyle(
                                            fontSize: 14,
                                            fontFamily: "segeo",
                                            color: Colors.black87,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),

                                  // 🔹 Right side: Completed status
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: const [
                                      SizedBox(height: 20),
                                      Icon(
                                        Icons.check_circle_outline,
                                        color: Colors.green,
                                        size: 24,
                                      ),
                                      SizedBox(height: 4),
                                      Text(
                                        "Session completed",
                                        textAlign: TextAlign.center,
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

                              // 🔹 Action Buttons
                              Row(
                                spacing: 12,
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
                      },
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

  int _getCrossAxisCount(BuildContext context) {
    final width = MediaQuery.of(context).size.width;

    if (width < 600) {
      return 1; // 📱 Mobile: single column
    } else if (width < 900) {
      return 2;
    } else {
      return 3; // 🖥️ Desktop / large screen: three columns
    }
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
                                fontSize: 16,
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
                                    size: 36,
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
                                  context.pop();
                                  context
                                      .read<SessionCompletedCubit>()
                                      .sessionComplete();
                                  CustomSnackBar1.show(
                                    context,
                                    "Report Submitted Successfully",
                                  );
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
                          CustomSnackBar1.show(
                            context,
                            state.successModel.message ??
                                'Reported Successfully',
                          );
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

class CompletedSessionsShimmer extends StatelessWidget {
  const CompletedSessionsShimmer({super.key});
  int _getCrossAxisCount(BuildContext context) {
    final width = MediaQuery.of(context).size.width;

    if (width < 600) {
      return 1; // 📱 Mobile
    } else if (width < 900) {
      return 2; // 💻 Tablet
    } else {
      return 3; // 🖥 Desktop
    }
  }

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      physics: const NeverScrollableScrollPhysics(),
      slivers: [
        SliverPadding(
          padding: const EdgeInsets.all(16.0),
          sliver: SliverMasonryGrid.count(
            crossAxisCount: _getCrossAxisCount(
              context,
            ), // 👈 Responsive count (1 mobile, 2 tablet, 3 desktop)
            mainAxisSpacing: 16,
            crossAxisSpacing: 16,
            childCount: 5, // shimmer placeholders
            itemBuilder: (context, index) {
              return Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 6,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    /// 🔹 Header Row (Left: session info | Right: completed badge)
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Left Column
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            shimmerText(180, 18, context), // topic title
                            const SizedBox(height: 6),
                            shimmerText(150, 14, context), // mentor name
                            const SizedBox(height: 8),
                            shimmerText(130, 12, context), // date/time
                          ],
                        ),

                        // Right Column
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            const SizedBox(height: 20),
                            shimmerCircle(24, context), // check icon shimmer
                            const SizedBox(height: 6),
                            shimmerText(
                              100,
                              12,
                              context,
                            ), // "Session completed"
                          ],
                        ),
                      ],
                    ),

                    const SizedBox(height: 12),

                    /// 🔹 Action Button Placeholder
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.4,
                      child: shimmerRectangle(40, context), // button shimmer
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
