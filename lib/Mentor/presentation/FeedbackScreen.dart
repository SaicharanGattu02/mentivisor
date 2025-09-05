import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:mentivisor/Components/CustomAppButton.dart';
import 'package:mentivisor/Components/CutomAppBar.dart';
import 'package:mentivisor/services/AuthService.dart';
import 'package:mentivisor/utils/AppLogger.dart';

import '../../Mentor/Models/FeedbackModel.dart';
import '../data/Cubits/FeedBack/feedback_cubit.dart';
import '../data/Cubits/FeedBack/feedback_states.dart';

class FeedbackScreen extends StatefulWidget {
  const FeedbackScreen({super.key});

  @override
  State<FeedbackScreen> createState() => _FeedbackScreenState();
}

class _FeedbackScreenState extends State<FeedbackScreen> {
  final ValueNotifier<String?> userIdNotifier = ValueNotifier(null);
  @override
  void initState() {
    super.initState();
    getUserID();
  }

  Future<void> getUserID() async {
    final userId = await AuthService.getUSerId();
    userIdNotifier.value = userId;
    context.read<FeedbackCubit>().getFeedback(
      userIdNotifier.value ?? "",
      [],
      "",
    );
  }

  void showReview(BuildContext context) {
    List<int> _selectedRatings = [];
    String _selectedTime = "All Time";

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (BuildContext builderContext) {
        return StatefulBuilder(
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
                        'Filter',
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

                  // Row(
                  //   crossAxisAlignment: CrossAxisAlignment.start,
                  //   children: [
                  //     // ⭐ Rating Column
                  //     Row(
                  //       crossAxisAlignment: CrossAxisAlignment.start,
                  //       children: [
                  //         // ⭐ Rating Column
                  //         Expanded(
                  //           child: Column(
                  //             crossAxisAlignment: CrossAxisAlignment.start,
                  //             children: [
                  //               const Text(
                  //                 "Rating",
                  //                 style: TextStyle(
                  //                   fontSize: 18,
                  //                   fontWeight: FontWeight.w600,
                  //                 ),
                  //               ),
                  //               const SizedBox(height: 8),
                  //               ...List.generate(5, (index) {
                  //                 int star = index + 1;
                  //                 return CheckboxListTile(
                  //                   title: Text("$star Star"),
                  //                   value: _selectedRatings.contains(star),
                  //                   onChanged: (bool? checked) {
                  //                     setState(() {
                  //                       if (checked == true) {
                  //                         _selectedRatings.add(star);
                  //                       } else {
                  //                         _selectedRatings.remove(star);
                  //                       }
                  //                     });
                  //                   },
                  //                   activeColor: const Color(0xFF4A00E0),
                  //                   contentPadding: EdgeInsets.zero,
                  //                   controlAffinity: ListTileControlAffinity.leading,
                  //                 );
                  //               }),
                  //             ],
                  //           ),
                  //         ),
                  //
                  //         const SizedBox(width: 16),
                  //
                  //
                  //       ],
                  //     )
                  //
                  //   ],
                  // ),
                  const SizedBox(height: 8),

                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        backgroundColor: const Color(0xFF4A00E0),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                      ),
                      onPressed: () {
                        // ✅ Here you can call API or refresh reviews with selected filters
                        print("Selected Ratings: $_selectedRatings");
                        print("Selected Time: $_selectedTime");
                        Navigator.pop(context);
                      },
                      child: const Text(
                        "Apply",
                        style: TextStyle(fontSize: 16, color: Colors.white),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                ],
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF3F7FF),
      appBar: CustomAppBar1(title: "Feedback", actions: []),
      body: BlocBuilder<FeedbackCubit, FeedbackStates>(
        builder: (context, state) {
          if (state is FeedbackLoading || state is FeedbackInitially) {
            return const _LoadingSkeleton();
          }
          if (state is FeedbackFailure) {
            return Center(child: Text(state.error));
          }

          final data = (state as FeedbackLoaded).feedbackModel.data!;

          // Prefer filtered average if filters are applied; else fall back to overall
          final rawAvg = data.filteredOverall?.average ?? data.overall?.average;

          // Normalize to double safely (handles int, double, string, null)
          final avg = rawAvg == null ? null : double.tryParse('$rawAvg');

          final hasNoFeedback =
              avg == null ||
              avg == 0.0 ||
              (data.reviews?.items?.isEmpty ?? true);

          if (hasNoFeedback) {
            return const NoFeedbackUI();
          }

          return _FeedbackBody(data: data, userIdNotifier: userIdNotifier);
        },
      ),
    );
  }
}

class NoFeedbackUI extends StatelessWidget {
  const NoFeedbackUI({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.reviews_outlined, size: 64, color: Colors.black26),
            const SizedBox(height: 12),
            const Text(
              "No feedback yet",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 6),
            const Text(
              "Once reviews start coming in, you’ll see ratings and comments here.",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 14, color: Colors.black54),
            ),
          ],
        ),
      ),
    );
  }
}

// ========== BODY CONTENT ==========
class _FeedbackBody extends StatelessWidget {
  final Data data;
  final ValueNotifier<String?> userIdNotifier;

  const _FeedbackBody({required this.data, required this.userIdNotifier});

  @override
  Widget build(BuildContext context) {
    final overall = data.overall!;
    final filtered = data.filteredOverall!;
    final reviews = data.reviews?.items ?? [];

    return CustomScrollView(
      slivers: [
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 12),
            child: Column(
              children: [
                _CardContainer(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _SectionTitle(
                        icon: Icons.star_border_rounded,
                        title: 'Overall Rating',
                      ),
                      const SizedBox(height: 12),
                      Center(
                        child: Text(
                          _fmtDouble(overall.average),
                          style: const TextStyle(
                            fontFamily: 'segeo',
                            fontSize: 48,
                            height: 1.0,
                            fontWeight: FontWeight.w700,
                            color: Color(0xFF111827),
                          ),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Center(child: _StarRow(rating: overall.average)),
                      const SizedBox(height: 8),
                      Center(
                        child: Text(
                          'Based on ${overall.totalReviews ?? 0} reviews',
                          style: const TextStyle(
                            fontFamily: 'segeo',
                            fontSize: 16,
                            color: Color(0xFF6B7280),
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      _Histogram(
                        histogram: overall.histogram,
                        total: overall.totalReviews ?? 0,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 12),
                _CardContainer(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _SectionTitle(
                        icon: Icons.trending_up_rounded,
                        title: 'Performance Metrics',
                      ),
                      const SizedBox(height: 18),
                      _MetricRow(
                        label: 'Average Rating',
                        value: _fmtDouble(filtered.average),
                        trailingChip: _DeltaChip(
                          delta: overall.avgDeltaThisMonth ?? 0,
                        ),
                      ),
                      const SizedBox(height: 14),
                      _MetricRow(
                        label: 'Total Reviews',
                        value: '${filtered.totalReviews ?? 0}',
                      ),
                      const SizedBox(height: 14),
                      _MetricRow(
                        label: '5-Star Reviews',
                        value: '${_fmtDouble(filtered.fiveStarShare)}%',
                      ),
                      const SizedBox(height: 14),
                      _MetricRow(
                        label: 'Response Rate',
                        value: filtered.responseRate == null
                            ? '—'
                            : '${filtered.responseRate}%',
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 16),
                GestureDetector(
                  onTap: () {
                    showReview(context, userIdNotifier.value ?? '');
                  },
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.fromLTRB(16, 14, 16, 14),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF7F3FF),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Row(
                      children: const [
                        Expanded(
                          child: Text(
                            'Filter by',
                            style: TextStyle(
                              fontFamily: 'segeo',
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                              color: Color(0xFF111827),
                            ),
                          ),
                        ),
                        Icon(Icons.tune_rounded, color: Color(0xFF6B7280)),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 12),
              ],
            ),
          ),
        ),
        SliverList.separated(
          itemCount: reviews.length,
          separatorBuilder: (_, __) => const SizedBox(height: 10),
          itemBuilder: (context, i) {
            final item = reviews[i];
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: _ReviewCard(item: item),
            );
          },
        ),
        const SliverToBoxAdapter(child: SizedBox(height: 24)),
      ],
    );
  }

  void showReview(BuildContext context, String userID) {
    List<int> _selectedRatings = [];
    String _selectedTime = "All Time"; // default for UI

    // 🔹 map UI labels to API params
    String mapTime(String time) {
      switch (time) {
        case "All Time":
          return "all_time";
        case "This Week":
          return "week";
        case "This Month":
          return "month";
        case "This Quarter":
          return "quarter";
        default:
          return "";
      }
    }

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (BuildContext builderContext) {
        return StatefulBuilder(
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
                  // Title and Close
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Filter',
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

                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // ⭐ Ratings
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              "Rating",
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const SizedBox(height: 8),
                            ...List.generate(5, (index) {
                              int star = index + 1;
                              return CheckboxListTile(
                                title: Text("$star Star"),
                                value: _selectedRatings.contains(star),
                                onChanged: (bool? checked) {
                                  setState(() {
                                    if (checked == true) {
                                      _selectedRatings.add(star);
                                    } else {
                                      _selectedRatings.remove(star);
                                    }
                                  });
                                },
                                activeColor: const Color(0xFF4A00E0),
                                contentPadding: EdgeInsets.zero,
                                controlAffinity:
                                    ListTileControlAffinity.leading,
                              );
                            }),
                          ],
                        ),
                      ),

                      const SizedBox(width: 16),

                      // ⏰ Time Filter
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              "Time",
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const SizedBox(height: 8),
                            ...[
                              "All Time",
                              "This Week",
                              "This Month",
                              "This Quarter",
                            ].map(
                              (time) => CheckboxListTile(
                                title: Text(time),
                                value: _selectedTime == time,
                                onChanged: (bool? checked) {
                                  setState(() {
                                    _selectedTime = time; // only one active
                                  });
                                },
                                activeColor: const Color(0xFF4A00E0),
                                contentPadding: EdgeInsets.zero,
                                controlAffinity:
                                    ListTileControlAffinity.leading,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 24),

                  SafeArea(
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
                      child: CustomAppButton1(
                        text: "Apply",
                        onPlusTap: () {
                          final apiTime = mapTime(_selectedTime);

                          AppLogger.info("Selected Ratings (UI): $_selectedRatings");
                          AppLogger.info("Selected Time (UI): $_selectedTime");
                          AppLogger.info("Selected Time (API): $apiTime");

                          context.read<FeedbackCubit>().getFeedback(
                            userID,
                            _selectedRatings,
                            apiTime,
                          );

                          Navigator.of(context).pop();
                        },
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }
}

// ========== WIDGETS ==========

class _CardContainer extends StatelessWidget {
  final Widget child;
  const _CardContainer({required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF111827).withOpacity(0.06),
            blurRadius: 16,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: child,
    );
  }
}

class _SectionTitle extends StatelessWidget {
  final IconData icon;
  final String title;
  const _SectionTitle({required this.icon, required this.title});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, color: const Color(0xFFFFC107), size: 26),
        const SizedBox(width: 8),
        Text(
          title,
          style: const TextStyle(
            fontFamily: 'segeo',
            fontWeight: FontWeight.w800,
            fontSize: 22,
            color: Color(0xFF111827),
          ),
        ),
      ],
    );
  }
}

class _StarRow extends StatelessWidget {
  final dynamic rating; // 0..5
  const _StarRow({required this.rating});

  @override
  Widget build(BuildContext context) {
    final full = rating.floor();
    final hasHalf = (rating - full) >= 0.5;
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(5, (i) {
        if (i < full) {
          return const Icon(
            Icons.star_rounded,
            color: Color(0xFFFFC107),
            size: 25,
          );
        } else if (i == full && hasHalf) {
          return const Icon(
            Icons.star_half_rounded,
            color: Color(0xFFFFC107),
            size: 25,
          );
        } else {
          return const Icon(
            Icons.star_border_rounded,
            color: Color(0xFFFFC107),
            size: 25,
          );
        }
      }),
    );
  }
}

class _Histogram extends StatelessWidget {
  final Histogram? histogram;
  final int total;
  const _Histogram({required this.histogram, required this.total});

  int _countFor(int star) {
    switch (star) {
      case 1:
        return histogram?.i1 ?? 0;
      case 2:
        return histogram?.i2 ?? 0;
      case 3:
        return histogram?.i3 ?? 0;
      case 4:
        return histogram?.i4 ?? 0;
      case 5:
        return histogram?.i5 ?? 0;
      default:
        return 0;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [5, 4, 3, 2, 1].map((s) {
        final count = _countFor(s);
        final pct = total == 0 ? 0.0 : (count / total);
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 6),
          child: Row(
            children: [
              const Icon(
                Icons.star_rounded,
                color: Color(0xFFFFC107),
                size: 20,
              ),
              const SizedBox(width: 4),
              Text(
                '$s',
                style: const TextStyle(
                  fontFamily: 'segeo',
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF111827),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Stack(
                  children: [
                    Container(
                      height: 10,
                      decoration: BoxDecoration(
                        color: const Color(0xFFE5E7EB),
                        borderRadius: BorderRadius.circular(999),
                      ),
                    ),
                    FractionallySizedBox(
                      widthFactor: pct.clamp(0.0, 1.0),
                      child: Container(
                        height: 10,
                        decoration: BoxDecoration(
                          color: const Color(0xFFFFC107),
                          borderRadius: BorderRadius.circular(999),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 10),
              SizedBox(
                width: 28,
                child: Text(
                  '$count',
                  textAlign: TextAlign.right,
                  style: const TextStyle(
                    fontFamily: 'segeo',
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF111827),
                  ),
                ),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }
}

class _MetricRow extends StatelessWidget {
  final String label;
  final String value;
  final Widget? trailingChip;

  const _MetricRow({
    required this.label,
    required this.value,
    this.trailingChip,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Text(
            label,
            style: const TextStyle(
              fontFamily: 'segeo',
              fontSize: 18,
              color: Color(0xFF6B7280),
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        Text(
          value,
          style: const TextStyle(
            fontFamily: 'segeo',
            fontSize: 18,
            fontWeight: FontWeight.w800,
            color: Color(0xFF111827),
          ),
        ),
        if (trailingChip != null) ...[const SizedBox(width: 8), trailingChip!],
      ],
    );
  }
}

class _DeltaChip extends StatelessWidget {
  final int delta; // positive or negative change this month
  const _DeltaChip({required this.delta});

  @override
  Widget build(BuildContext context) {
    final isPos = delta >= 0;
    final txt = (isPos ? '+' : '') + delta.toString();
    final bg = isPos ? const Color(0xFFD1FAE5) : const Color(0xFFFEE2E2);
    final fg = isPos ? const Color(0xFF065F46) : const Color(0xFF991B1B);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(
        '$txt this month',
        style: TextStyle(
          fontFamily: 'segeo',
          fontWeight: FontWeight.w700,
          color: fg,
        ),
      ),
    );
  }
}

class _ReviewCard extends StatelessWidget {
  final Items item;
  const _ReviewCard({required this.item});

  @override
  Widget build(BuildContext context) {
    final user = item.user;
    final date = item.date ?? '';
    return _CardContainer(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header row
          Row(
            children: [
              CircleAvatar(
                radius: 22,
                backgroundColor: const Color(0xFFE5E7EB),
                backgroundImage: (user?.image?.isNotEmpty ?? false)
                    ? NetworkImage(user!.image!)
                    : null,
                child: (user?.image?.isEmpty ?? true)
                    ? const Icon(Icons.person, color: Color(0xFF6B7280))
                    : null,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      user?.name ?? '-',
                      style: const TextStyle(
                        fontFamily: 'segeo',
                        fontWeight: FontWeight.w600,
                        fontSize: 17,
                        color: Color(0xFF111827),
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      user?.institution ?? '',
                      style: const TextStyle(
                        fontFamily: 'segeo',
                        fontWeight: FontWeight.w500,
                        fontSize: 14,
                        color: Color(0xFF6B7280),
                      ),
                    ),
                  ],
                ),
              ),
              const Icon(Icons.event, size: 18, color: Color(0xFF6B7280)),
              const SizedBox(width: 6),
              Text(
                date,
                style: const TextStyle(
                  fontFamily: 'segeo',
                  fontWeight: FontWeight.w700,
                  fontSize: 14,
                  color: Color(0xFF6B7280),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          _StarRow(rating: (item.rating ?? 0).toDouble()),
          const SizedBox(height: 10),
          if (item.tag != null && item.tag.toString().trim().isNotEmpty)
            Padding(
              padding: const EdgeInsets.only(bottom: 8.0),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xFFEFF6FF),
                    borderRadius: BorderRadius.circular(999),
                    border: Border.all(color: const Color(0xFFBFDBFE)),
                  ),
                  child: Text(
                    item.tag.toString(),
                    style: const TextStyle(
                      fontFamily: 'segeo',
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF1D4ED8),
                    ),
                  ),
                ),
              ),
            ),
          Text(
            item.feedback ?? '',
            style: const TextStyle(
              fontFamily: 'segeo',
              fontSize: 16,
              height: 1.5,
              color: Color(0xFF111827),
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}

String _fmtDouble(num? v) {
  if (v == null) return '0.0';
  return v.toStringAsFixed(v % 1 == 0 ? 0 : 1);
}

class _ErrorRetry extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;
  const _ErrorRetry({required this.message, required this.onRetry});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            message.isEmpty ? 'Something went wrong' : message,
            textAlign: TextAlign.center,
            style: const TextStyle(fontFamily: 'segeo'),
          ),
          const SizedBox(height: 12),
          ElevatedButton(
            onPressed: onRetry,
            child: const Text('Retry', style: TextStyle(fontFamily: 'segeo')),
          ),
        ],
      ),
    );
  }
}

class _LoadingSkeleton extends StatelessWidget {
  const _LoadingSkeleton();

  @override
  Widget build(BuildContext context) {
    Widget bar({double h = 16, double w = double.infinity}) => Container(
      height: h,
      width: w,
      margin: const EdgeInsets.symmetric(vertical: 6),
      decoration: BoxDecoration(
        color: const Color(0xFFE5E7EB),
        borderRadius: BorderRadius.circular(8),
      ),
    );

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        _CardContainer(
          child: Column(
            children: [
              bar(h: 28, w: 180),
              const SizedBox(height: 12),
              bar(h: 44, w: 120),
              bar(w: 220),
              const SizedBox(height: 8),
              bar(w: double.infinity),
              bar(w: double.infinity),
              bar(w: double.infinity),
            ],
          ),
        ),
        const SizedBox(height: 12),
        _CardContainer(
          child: Column(
            children: [
              bar(h: 28, w: 220),
              const SizedBox(height: 12),
              bar(),
              bar(),
              bar(),
              bar(),
            ],
          ),
        ),
        const SizedBox(height: 12),
        bar(w: 140, h: 26),
        const SizedBox(height: 12),
        _CardContainer(
          child: Column(
            children: [
              bar(w: 260),
              bar(w: double.infinity),
              bar(w: double.infinity),
              bar(w: 200),
            ],
          ),
        ),
        const SizedBox(height: 12),
        _CardContainer(
          child: Column(
            children: [
              bar(w: 260),
              bar(w: double.infinity),
              bar(w: double.infinity),
              bar(w: 200),
            ],
          ),
        ),
      ],
    );
  }
}
