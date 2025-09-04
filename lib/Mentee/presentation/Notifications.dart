import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mentivisor/Components/CutomAppBar.dart';
import 'package:mentivisor/Mentee/data/cubits/Notifications/notifications_cubit.dart';
import 'package:mentivisor/Mentee/data/cubits/Notifications/notifications_states.dart';

import '../../Components/CommonLoader.dart';
import '../../utils/color_constants.dart';
import '../../utils/media_query_helper.dart';

class Notifications extends StatefulWidget {
  const Notifications({super.key});

  @override
  State<Notifications> createState() => _NotificationsState();
}

class _NotificationsState extends State<Notifications> {
  @override
  void initState() {
    super.initState();
    context.read<NotificationsCubit>().notifiactions();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffF2F4FD),
      appBar: CustomAppBar1(
        title: 'Notification',
        actions: [],
        color: const Color(0xffF2F4FD),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
        child: BlocBuilder<NotificationsCubit, NotificationsStates>(
          builder: (context, state) {
            if (state is NotificationsLoading) {
              return Center(
                child: SizedBox(
                  height: SizeConfig.screenWidth * 1,
                  child: const DottedProgressWithLogo(),
                ),
              );
            } else if (state is NotificationsLoaded) {
              final data = state.notificationModel.data;

              return CustomScrollView(
                slivers: [
                  // Session Section
                  if (data?.session != null && data!.session!.isNotEmpty) ...[
                    _buildHeader("Session"),
                    // _buildList(
                    //   itemCount: data.session!.length,
                    //   itemBuilder: (context, index) {
                    //     final session = data.session![index];
                    //     return _buildCard(
                    //       icon: "assets/icons/meet.png",
                    //       title: session.title ?? "",
                    //       subtitle: session.message ?? "",
                    //     );
                    //   },
                    // ),
                  ],

                  // Reminder Section
                  if (data?.reminder != null && data!.reminder!.isNotEmpty) ...[
                    _buildHeader("Reminder"),
                    // _buildList(
                    //   itemCount: data.reminder!.length,
                    //   itemBuilder: (context, index) {
                    //     final reminder = data.reminder![index];
                    // return _buildCard(
                    //   icon: "assets/icons/calendar.png",
                    //   title: reminder.title ?? "",
                    //   subtitle: reminder.message ?? "",
                    // );
                    //   },
                    // ),
                  ],

                  // Rewards Section
                  if (data?.rewards != null && data!.rewards!.isNotEmpty) ...[
                    _buildHeader("Rewards"),
                    // _buildList(
                    //   itemCount: data.rewards!.length,
                    //   itemBuilder: (context, index) {
                    //     final reward = data.rewards![index];
                    // return _buildCard(
                    //   icon: "assets/icons/coin.png",
                    //   title: reward.title ?? "",
                    //   subtitle: reward.message ?? "",
                    // );
                    //   },
                    // ),
                  ],

                  if (data?.rejections != null) ...[
                    if (data!.rejections!.isEmpty)
                      SliverToBoxAdapter(
                        child: SizedBox(
                          height: SizeConfig.screenHeight*0.55,
                          child: Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                SizedBox(
                                  height: 200,
                                  width: 200,
                                  child: Image.asset("assets/nodata/no_data.png"),
                                ),
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
                        ),
                      )
                    else //
                      _buildHeader("Rejections"), // 👉 Show List if not empty
                    _buildList(
                      itemCount: data.rejections!.length,
                      itemBuilder: (context, index) {
                        final rejection = data.rejections![index];
                        return _buildCard(
                          icon: "assets/icons/meet.png",
                          title: rejection.message ?? "",
                          subtitle: rejection.date ?? "",
                        );
                      },
                    ),
                  ],
                ],
              );
            } else if (state is NotificationsFailure) {
              return Center(child: Text(state.msg));
            }
            return const Center(child: Text("No Data"));
          },
        ),
      ),
    );
  }

  // 🔹 Section Header
  SliverToBoxAdapter _buildHeader(String title) {
    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
        child: Text(
          title,
          style: const TextStyle(
            fontSize: 15,
            color: Color(0xff040404),
            fontWeight: FontWeight.w600,
            fontFamily: 'segeo',
          ),
        ),
      ),
    );
  }

  // 🔹 SliverList builder
  SliverList _buildList({
    required int itemCount,
    required Widget Function(BuildContext, int) itemBuilder,
  }) {
    return SliverList(
      delegate: SliverChildBuilderDelegate(itemBuilder, childCount: itemCount),
    );
  }

  // 🔹 Reusable Card Widget
  Widget _buildCard({
    required String icon,
    required String title,
    required String subtitle,
  }) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xffFFFFFF),
        borderRadius: BorderRadius.circular(8),
      ),
      child: ListTile(
        leading: SizedBox(
          width: 46,
          height: 46,
          child: Image.asset(icon, fit: BoxFit.fill),
        ),
        title: Text(
          title,
          style: const TextStyle(
            fontSize: 14,
            color: Color(0xff666666),
            fontWeight: FontWeight.w600,
            fontFamily: 'segeo',
          ),
        ),
        subtitle: Text(
          subtitle,
          style: const TextStyle(
            fontSize: 14,
            color: Color(0xff666666),
            fontWeight: FontWeight.w400,
            fontFamily: 'segeo',
          ),
        ),
      ),
    );
  }
}
