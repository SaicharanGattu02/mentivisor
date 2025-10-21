import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mentivisor/Components/CutomAppBar.dart';
import 'package:mentivisor/Mentee/data/cubits/Notifications/notifications_cubit.dart';
import 'package:mentivisor/Mentee/data/cubits/Notifications/notifications_states.dart';
import 'package:mentivisor/utils/color_constants.dart';
import '../../Components/Shimmers.dart';
import 'Widgets/CommonChoiceChip.dart';

class Notifications extends StatefulWidget {
  const Notifications({super.key});

  @override
  State<Notifications> createState() => _NotificationsState();
}

class _NotificationsState extends State<Notifications> {
  final ValueNotifier<bool> _fabVisible = ValueNotifier<bool>(true);
  int _selectedFilter = 0;

  final List<String> _filters = [
    "All",
    "Sessions",
    "Rewards",
    "Reminders",
    "Mentions",
  ];

  final Map<String, String> _filterKeywordMap = {
    "All": "",
    "Sessions": "session",
    "Rewards": "reward",
    "Reminders": "reminder",
    "Mentions": "mention",
  };

  @override
  void initState() {
    super.initState();
    context.read<NotificationsCubit>().fetchNotifications("", "");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffF2F4FD),
      appBar: CustomAppBar1(
        title: 'Notifications',
        actions: [],
        color: const Color(0xffF2F4FD),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 🔹 Filters Row
            SizedBox(
              height: 32,
              child: ListView.separated(
                physics: const BouncingScrollPhysics(),
                scrollDirection: Axis.horizontal,
                itemCount: _filters.length,
                separatorBuilder: (_, __) => const SizedBox(width: 8),
                itemBuilder: (context, i) {
                  final selected = i == _selectedFilter;
                  return CustomChoiceChip(
                    label: _filters[i],
                    selected: selected,
                    onSelected: (_) {
                      setState(() => _selectedFilter = i);
                      final filterKey = _filters[i];
                      final filterType = _filterKeywordMap[filterKey] ?? "";
                      context.read<NotificationsCubit>().fetchNotifications(
                        "",
                        filterType,
                      );
                    },
                  );
                },
              ),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: BlocBuilder<NotificationsCubit, NotificationsStates>(
                builder: (context, state) {
                  if (state is NotificationsLoading) {
                    return NotificationsListShimmer();
                  } else if (state is NotificationsFailure) {
                    return Center(child: Text(state.message));
                  } else if (state is NotificationsLoaded ||
                      state is NotificationsLoadingMore) {
                    final notificationModel = (state is NotificationsLoaded)
                        ? state.notificationModel
                        : (state as NotificationsLoadingMore).notificationModel;

                    final notifyData = notificationModel.notify?.data ?? [];

                    if (notifyData.isEmpty) {
                      return _noDataWidget();
                    }

                    final selectedLabel = _filters[_selectedFilter];
                    final keyword =
                        _filterKeywordMap[selectedLabel]?.toLowerCase() ?? "";

                    // Apply filter
                    final filtered = keyword == ""
                        ? notifyData
                        : notifyData
                              .where(
                                (n) => (n.type ?? "").toLowerCase().contains(
                                  keyword,
                                ),
                              )
                              .toList();

                    if (filtered.isEmpty) {
                      return _noDataWidget();
                    }

                    return NotificationListener<ScrollNotification>(
                      onNotification: (scrollInfo) {
                        if (scrollInfo.metrics.pixels >=
                            scrollInfo.metrics.maxScrollExtent * 0.9) {
                          if (state is NotificationsLoaded &&
                              state.hasNextPage) {
                            context
                                .read<NotificationsCubit>()
                                .fetchMoreNotifications("", keyword);
                          }
                        }
                        return false;
                      },
                      child: CustomScrollView(
                        slivers: [
                          SliverGrid(
                            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: _getCrossAxisCount(context), // 👈 1 on mobile, 2 on tab
                              crossAxisSpacing: 12,
                              mainAxisSpacing: 0,
                              childAspectRatio: _getChildAspectRatio(context), // 👈 based on screen ratio
                            ),
                            delegate: SliverChildBuilderDelegate(
                                  (context, index) {
                                final item = filtered[index];
                                return _buildNotificationCard(
                                  icon: _getIconForType(item.type),
                                  title: item.title ?? "",
                                  subtitle: item.remarks ?? item.message ?? "",
                                  date: item.createdAt ?? "",
                                );
                              },
                              childCount: filtered.length,
                              addAutomaticKeepAlives: false,
                              addRepaintBoundaries: true,
                              addSemanticIndexes: false,
                            ),
                          ),
                          if (state is NotificationsLoadingMore)
                            const SliverToBoxAdapter(
                              child: Padding(
                                padding: EdgeInsets.all(25.0),
                                child: Center(
                                  child: CircularProgressIndicator(
                                    strokeWidth: 1,
                                  ),
                                ),
                              ),
                            ),
                        ],
                      ),
                    );
                  } else {
                    return const SizedBox.shrink();
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  int _getCrossAxisCount(BuildContext context) {
    final width = MediaQuery.of(context).size.width;

    if (width < 600) {
      return 1; // 📱 Mobile
    } else if (width > 600) {
      return 2; // 💻 Tablet
    } else {
      return 3; // 🖥️ Desktop or large screens
    }
  }

  double _getChildAspectRatio(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final width = size.width;
    final height = size.height;

    // derive a smooth ratio that fits naturally on each device
    final baseRatio = width / height;

    if (width < 600) {
      // Mobile – taller cards for better readability
      return baseRatio *6.2;
    } else if (width > 600) {
      // Tablet – wider cards
      return baseRatio * 4;
    } else {
      // Desktop – most balanced layout
      return baseRatio * 2.2;
    }
  }


  // 🔹 Notification Card Widget
  Widget _buildNotificationCard({
    required String icon,
    required String title,
    required String subtitle,
    required String date,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Image.asset(
              icon,
              width: 40,
              height: 40,
              fit: BoxFit.contain,
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: Color(0xff222222),
                    fontFamily: 'segeo',
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  subtitle,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 13,
                    color: Color(0xff666666),
                    fontFamily: 'segeo',
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  date,
                  style: const TextStyle(
                    fontSize: 11,
                    color: Color(0xff999999),
                    fontFamily: 'segeo',
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // 🔹 Icon helper
  String _getIconForType(String? type) {
    final t = type?.toLowerCase() ?? "";
    if (t.contains("session")) return "assets/icons/meet.png";
    if (t.contains("reward")) return "assets/images/coinsimage.png";
    if (t.contains("reminder")) return "assets/icons/approval.png";
    if (t.contains("mention")) return "assets/icons/approval.png";
    return "assets/icons/approval.png";
  }

  // 🔹 Empty state
  Widget _noDataWidget() {
    return Center(
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Image.asset("assets/nodata/no_data.png", height: 200),
            const SizedBox(height: 10),
            Text(
              'No Notifications Found!',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: primarycolor,
                fontSize: 18,
                fontWeight: FontWeight.w400,
                fontFamily: 'Poppins',
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class NotificationsListShimmer extends StatelessWidget {
  const NotificationsListShimmer({super.key});

  int _getCrossAxisCount(BuildContext context) {
    final width = MediaQuery.of(context).size.width;

    if (width < 600) {
      return 1; // 📱 Mobile
    } else if (width > 600) {
      return 2; // 💻 Tablet
    } else {
      return 3; // 🖥️ Desktop or large screens
    }
  }

  double _getChildAspectRatio(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final width = size.width;
    final height = size.height;

    // derive a smooth ratio that fits naturally on each device
    final baseRatio = width / height;

    if (width < 600) {
      // Mobile – taller cards for better readability
      return baseRatio *6.5;
    } else if (width > 600) {
      // Tablet – wider cards
      return baseRatio * 4;
    } else {
      // Desktop – most balanced layout
      return baseRatio * 2.2;
    }
  }

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      physics: const NeverScrollableScrollPhysics(),
      slivers: [
        SliverPadding(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
          sliver: SliverGrid(
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: _getCrossAxisCount(context), // 👈 responsive layout
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              childAspectRatio: _getChildAspectRatio(context), // 👈 responsive ratio
            ),
            delegate: SliverChildBuilderDelegate(
                  (context, index) => const _NotificationCardShimmer(),
              childCount: 6, // number of shimmer placeholders
            ),
          ),
        ),
      ],
    );
  }
}

class _NotificationCardShimmer extends StatelessWidget {
  const _NotificationCardShimmer();

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: shimmerContainer(40, 40, context),
          ),
          const SizedBox(width: 10),

          // 🔹 Text shimmer section
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Title shimmer
                shimmerText(140, 14, context),
                const SizedBox(height: 6),

                // Subtitle shimmer (2 lines)
                shimmerText(double.infinity, 12, context),
                const SizedBox(height: 4),
                shimmerText(220, 12, context),

                const SizedBox(height: 6),

                // Date shimmer
                shimmerText(100, 10, context),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
