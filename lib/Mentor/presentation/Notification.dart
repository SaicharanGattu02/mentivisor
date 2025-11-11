import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mentivisor/Components/CutomAppBar.dart';
import 'package:mentivisor/Mentee/data/cubits/Notifications/notifications_cubit.dart';
import 'package:mentivisor/Mentee/data/cubits/Notifications/notifications_states.dart';
import '../../Components/CommonLoader.dart';
import '../../Mentee/presentation/Widgets/CommonChoiceChip.dart';
import '../../utils/color_constants.dart';
import '../../utils/media_query_helper.dart';

class NotificationMentor extends StatefulWidget {
  const NotificationMentor({super.key});

  @override
  State<NotificationMentor> createState() => _NotificationMentorState();
}

class _NotificationMentorState extends State<NotificationMentor> {
  final ValueNotifier<bool> _fabVisible = ValueNotifier<bool>(true);

  @override
  void initState() {
    super.initState();
    context.read<NotificationsCubit>().fetchNotifications("mentor", "");
  }

  int _selectedFilter = 0;
  final List<String> _filters = [
    "All",
    "Sessions",
    "Rewards",
    "Expertise updates",
  ];

  final Map<String, String> _filterKeywordMap = {
    "All": "",
    "Sessions": "session",
    "Rewards": "reward",
    "Expertise updates": "expertise",
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffF2F4FD),
      appBar: CustomAppBar1(
        title: 'Notification',
        actions: [],
        color: Color(0xffF2F4FD),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
        child: Column(
          children: [
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
                        "mentor",
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
                    return const Center(child: CircularProgressIndicator());
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
                        _filterKeywordMap[selectedLabel]?.toLowerCase() ??
                        "all";

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
                                .fetchMoreNotifications("mentor", keyword);
                          }
                        }
                        return false;
                      },
                      child: NotificationListener<UserScrollNotification>(
                        onNotification: (notification) {
                          if (notification.direction ==
                                  ScrollDirection.reverse &&
                              _fabVisible.value) {
                            _fabVisible.value = false;
                          } else if (notification.direction ==
                                  ScrollDirection.forward &&
                              !_fabVisible.value) {
                            _fabVisible.value = true;
                          }
                          return false;
                        },
                        child: CustomScrollView(
                          slivers: [
                            SliverPadding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 4,
                              ),
                              sliver: SliverList(
                                delegate: SliverChildBuilderDelegate(
                                  (context, index) {
                                    final item = filtered[index];
                                    return _buildNotificationCard(
                                      icon: _getIconForType(item.type),
                                      title: item.title ?? "",
                                      subtitle:
                                          item.remarks ?? item.message ?? "",
                                      date: item.createdAt ?? "",
                                    );
                                  },
                                  childCount: filtered.length,
                                  addAutomaticKeepAlives: false,
                                  addRepaintBoundaries: true,
                                  addSemanticIndexes: false,
                                ),
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
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Image.asset(
              icon,
              width: 50,
              height: 70,
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
    if (t.contains("reminder")) return "assets/images/coinsimage.png";
    if (t.contains("mention")) return "assets/icons/approval.png";
    return "assets/images/coinsimage.png";
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
