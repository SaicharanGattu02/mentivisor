import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mentivisor/Components/CutomAppBar.dart';
import 'package:mentivisor/Mentee/data/cubits/Notifications/notifications_cubit.dart';

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
      backgroundColor: Color(0xffF2F4FD),
      appBar: CustomAppBar1(
        title: 'Notification',
        actions: [],
        color: Color(0xffF2F4FD),
      ),
      body: Container(
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 24),
        child: CustomScrollView(
          slivers: [
            // Session Section
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  vertical: 8,
                  horizontal: 16,
                ),
                child: Text(
                  "Session",
                  style: const TextStyle(
                    fontSize: 15,
                    color: Color(0xff040404),
                    fontWeight: FontWeight.w400,
                    fontFamily: 'segeo',
                  ),
                ),
              ),
            ),

            SliverList(
              delegate: SliverChildBuilderDelegate(
                (context, index) {
                  // final session =
                  //     sessions[index]; // <- replace with your API data
                  return Container(
                    margin: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 6,
                    ),
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: const Color(0xffFFFFFF),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: ListTile(
                      leading: SizedBox(
                        width: 46,
                        height: 46,
                        child: Image.asset(
                          "assets/icons/meet.png",
                          fit: BoxFit.fill,
                        ),
                      ),
                      title: Text(
                        "title",
                        style: const TextStyle(
                          fontSize: 14,
                          color: Color(0xff666666),
                          fontWeight: FontWeight.w600,
                          fontFamily: 'segeo',
                        ),
                      ),
                      subtitle: Text(
                        "subtitle",
                        style: const TextStyle(
                          fontSize: 14,
                          color: Color(0xff666666),
                          fontWeight: FontWeight.w400,
                          fontFamily: 'segeo',
                        ),
                      ),
                    ),
                  );
                },
                childCount: 10, // length of your list
              ),
            ),
          ],
        ),
      ),
    );
  }
}
