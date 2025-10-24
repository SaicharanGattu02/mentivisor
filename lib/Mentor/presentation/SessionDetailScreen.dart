import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:mentivisor/Components/CutomAppBar.dart';
import 'package:mentivisor/Mentor/data/Cubits/SessionDetails/SessionsDetailsCubit.dart';
import 'package:mentivisor/Mentor/data/Cubits/SessionDetails/SessionsDetailsStates.dart';
import 'package:mentivisor/utils/AppLogger.dart';
import 'package:mentivisor/utils/media_query_helper.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../Components/CommonLoader.dart';
import '../../Components/CustomAppButton.dart';
import '../../Components/CustomSnackBar.dart';
import '../../utils/spinkittsLoader.dart';
import '../data/Cubits/SessionComplete/session_complete_cubit.dart';
import '../data/Cubits/SessionComplete/session_complete_states.dart';
import '../data/Cubits/Sessions/SessionsCubit.dart';

class SessionDetailScreen extends StatefulWidget {
  final int sessionId;
  final bool? past;

  const SessionDetailScreen({Key? key, required this.sessionId, this.past})
    : super(key: key);

  @override
  State<SessionDetailScreen> createState() => _SessionDetailScreenState();
}

class _SessionDetailScreenState extends State<SessionDetailScreen> {
  @override
  void initState() {
    debugPrint("time123434:${widget.past}");
    super.initState();

    context.read<SessionDetailsCubit>().getSessionDetails(widget.sessionId);
  }

  ValueNotifier<String> status = ValueNotifier<String>("");

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar1(title: "Session Details", actions: []),
      body: SafeArea(
        child: Container(height: SizeConfig.screenHeight,
          padding: const EdgeInsets.all(16.0),
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Color(0xffFAF5FF),
                Color(0xffF5F6FF),
                Color(0xffEFF6FF),
              ],
            ),
          ),
          child: BlocConsumer<SessionDetailsCubit, SessionDetailsStates>(
            listener: (context, state) {
              if (state is SessionDetailsLoaded) {
                setState(() {
                  status.value = state.sessionDetailsModel.session?.status ?? "";
                });
              }
            },
            builder: (context, state) {
              if (state is SessionDetailsLoading) {
                return const Center(child: DottedProgressWithLogo());
              } else if (state is SessionDetailsLoaded) {
                final session = state.sessionDetailsModel.session;
                if (session == null) return const Center(child: Text("No session found"));

                return SingleChildScrollView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // 🧑‍🎓 Session Info Card
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.1),
                              blurRadius: 6,
                              spreadRadius: 2,
                            )
                          ],
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            // Left Section — Session info
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    session.date ?? "",
                                    style: const TextStyle(
                                      fontFamily: 'Segeo',
                                      fontWeight: FontWeight.w600,
                                      fontSize: 16,
                                      color: Color(0xff333333),
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    'with ${session.mentee?.name ?? ""} from ${session.mentee?.collegeName ?? ""}',
                                    style: const TextStyle(
                                      fontFamily: 'Segeo',
                                      fontWeight: FontWeight.w400,
                                      fontSize: 14,
                                      color: Color(0xff555555),
                                    ),
                                  ),
                                  if( session.minutesLeft!=null)...[
                                    const SizedBox(height: 8),
                                    Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                      decoration: BoxDecoration(
                                        color: const Color(0xff4076ED).withOpacity(0.1),
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      child: Text(
                                        session.minutesLeft ?? "",
                                        style: const TextStyle(
                                          color: Color(0xff4076ED),
                                          fontSize: 12,
                                          fontFamily: 'Segeo',
                                        ),
                                      ),
                                    ),
                                  ]

                                ],
                              ),
                            ),

                            const SizedBox(width: 12),

                            // Right Section — Mentee image
                            ClipRRect(
                              borderRadius: BorderRadius.circular(12),
                              child: CachedNetworkImage(
                                imageUrl: session.mentee?.profile ?? "",
                                width: 70,
                                height: 70,
                                fit: BoxFit.cover,
                                placeholder: (context, url) => Center(
                                  child: SizedBox(
                                    width: 20,
                                    height: 20,
                                    child: spinkits.getSpinningLinespinkit(),
                                  ),
                                ),
                                errorWidget: (context, url, error) => const CircleAvatar(
                                  radius: 35,
                                  backgroundImage: AssetImage("assets/images/profile.png"),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 24),

                      // 🧾 Session Topics
                      if ((session.topics ?? "").isNotEmpty) ...[
                        const Text(
                          'Session Topics',
                          style: TextStyle(
                            fontFamily: 'Segeo',
                            fontWeight: FontWeight.w600,
                            fontSize: 16,
                            color: Color(0xff444444),
                          ),
                        ),
                        const SizedBox(height: 8),
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            session.topics ?? "",
                            style: const TextStyle(
                              fontFamily: 'Segeo',
                              fontSize: 14,
                              color: Color(0xff555555),
                              height: 1.5,
                            ),
                          ),
                        ),
                        const SizedBox(height: 24),
                      ],

                      // 💰 Session Cost
                      Row(
                        children: [
                          const Text(
                            "Session Cost: ",
                            style: TextStyle(
                              fontFamily: 'Segeo',
                              fontWeight: FontWeight.w600,
                              fontSize: 15,
                              color: Color(0xff333333),
                            ),
                          ),
                          Image.asset('assets/images/GoldCoins.png', height: 18, width: 18),
                          const SizedBox(width: 6),
                          Text(
                            "${session.sessionCost ?? 0}",
                            style: const TextStyle(
                              fontFamily: 'Segeo',
                              fontWeight: FontWeight.w500,
                              fontSize: 15,
                              color: Color(0xff555555),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 24),

                      // 📎 Attachment
                      if ((session.attachment ?? "").isNotEmpty) ...[
                        const Text(
                          'Attachment',
                          style: TextStyle(
                            fontFamily: 'Segeo',
                            fontWeight: FontWeight.w600,
                            fontSize: 16,
                            color: Color(0xff444444),
                          ),
                        ),
                        const SizedBox(height: 8),
                        GestureDetector(
                          onTap: () {
                            context.push("/pdf_viewer?file_url=${session.attachment}");
                          },
                          child: Container(
                            padding: const EdgeInsets.all(22),
                            width: 125,
                            height: 125,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: Center(
                              child: Image.asset('assets/images/file.png'),
                            ),
                          ),
                        ),
                        const SizedBox(height: 24),
                      ],

                    ],
                  ),
                );
              } else if (state is SessionDetailsFailure) {
                return Center(
                  child: Text(
                    state.error,
                    style: const TextStyle(color: Colors.red),
                  ),
                );
              }
              return const Center(child: Text("No Data"));
            },
          ),
        ),
      ),

      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(16),
          child: ValueListenableBuilder<String>(
            valueListenable: status,
            builder: (context, currentStatus, _) {
              return (widget.past == true) && (currentStatus == "pending")
                  ? BlocConsumer<SessionCompleteCubit, SessionCompleteStates>(
                      listener: (context, state) {
                        if (state is SessionCompletdSuccess) {
                          CustomSnackBar1.show(
                            context,
                            "Session has been completed.",
                          );
                          context.read<SessionCubit>().getSessions("upcoming");
                          context.pop();
                        } else if (state is SessionCompletdFailure) {
                          CustomSnackBar1.show(context, state.error);
                        }
                      },
                      builder: (context, state) {
                        return CustomAppButton1(
                          isLoading: state is SessionCompletdLoading,
                          text: "Mark Session as Completed",
                          onPlusTap: () {
                            context
                                .read<SessionCompleteCubit>()
                                .sessionComplete(widget.sessionId);
                          },
                        );
                      },
                    )
                  : CustomAppButton1(
                      text: "Okay",
                      onPlusTap: () {
                        context.pop();
                      },
                    );
            },
          ),
        ),
      ),
    );
  }
}
