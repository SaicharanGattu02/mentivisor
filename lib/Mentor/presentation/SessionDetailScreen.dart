import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:mentivisor/Components/CutomAppBar.dart';
import 'package:mentivisor/Mentor/data/Cubits/SessionDetails/SessionsDetailsCubit.dart';
import 'package:mentivisor/Mentor/data/Cubits/SessionDetails/SessionsDetailsStates.dart';
import 'package:mentivisor/utils/AppLogger.dart';
import 'package:mentivisor/utils/media_query_helper.dart';
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
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await Future.wait([
        context.read<SessionDetailsCubit>().getSessionDetails(widget.sessionId),
      ]);
    });
  }

  ValueNotifier<String> status = ValueNotifier<String>("");

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar1(title: "Session Details", actions: []),
      body: SafeArea(
        child: Container(
          padding: const EdgeInsets.all(16.0),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xffFAF5FF), Color(0xffF5F6FF), Color(0xffEFF6FF)],
            ),
          ),
          child: BlocBuilder<SessionDetailsCubit, SessionDetailsStates>(
            builder: (context, state) {
              if (state is SessionDetailsLoading) {
                return Scaffold(body: Center(child: DottedProgressWithLogo()));
              } else if (state is SessionDetailsLoaded) {
                final sessionDetails = state.sessionDetailsModel.session;
                status.value =
                    state.sessionDetailsModel.status?.toString() ?? "";
                AppLogger.info("session Status:${status.value}");
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 12,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            width: SizeConfig.screenWidth * 0.575,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  sessionDetails?.date ?? "",
                                  style: TextStyle(
                                    fontFamily: 'Segeo',
                                    fontWeight: FontWeight.w600,
                                    fontSize: 16,
                                    color: Color(0xff333333),
                                  ),
                                ),
                                SizedBox(height: 8),
                                Text(
                                  'with ${sessionDetails?.mentee?.name ?? ""} from ${sessionDetails?.mentee?.collegeName} collage',
                                  style: TextStyle(
                                    fontFamily: 'Segeo',
                                    fontWeight: FontWeight.w400,
                                    fontSize: 14,
                                  ),
                                ),
                                SizedBox(height: 8),
                                Container(
                                  padding: EdgeInsets.symmetric(
                                    horizontal: 8,
                                    vertical: 4,
                                  ),
                                  decoration: BoxDecoration(
                                    color: Color(0xff4076ED).withOpacity(0.1),
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Text(
                                    sessionDetails?.minutesLeft ?? "",
                                    style: TextStyle(
                                      color: Color(0xff4076ED),
                                      fontSize: 12,
                                      fontFamily: 'segeo',
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(16),
                              color: Colors.brown.withOpacity(0.5),
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(8),
                              child: CachedNetworkImage(
                                imageUrl: sessionDetails?.mentee?.profile ?? "",
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
                                errorWidget: (context, url, error) => Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(8),
                                    image: const DecorationImage(
                                      image: AssetImage(
                                        "assets/images/profile.png",
                                      ),
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 24),
                    if ((sessionDetails?.topics ?? "").isNotEmpty) ...[
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
                      Text(
                        sessionDetails?.topics ?? "",
                        style: TextStyle(
                          fontFamily: 'Segeo',
                          fontSize: 14,
                          color: Colors.grey[700],
                        ),
                      ),
                      const SizedBox(height: 24),
                    ],
                    if ((sessionDetails?.attachment ?? "").isNotEmpty) ...[
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
                          context.push(
                            "/pdf_viewer?file_url=${sessionDetails?.attachment ?? ""}",
                          );
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
                    ],
                  ],
                );
              } else if (state is SessionDetailsFailure) {
                return Text(state.error);
              }
              return Text("No Data");
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

return(widget.past==true)
    ? BlocConsumer<SessionCompleteCubit, SessionCompleteStates>(
                      listener: (context, state) {
                        if (state is SessionCompletdSuccess) {
                          CustomSnackBar1.show(
                            context,
                            "Session has been completed.",
                          );
                          context.read<SessionCubit>().getSessions("");
                          context.pop();
                        } else if (state is SessionCompletdFailure) {
                          CustomSnackBar1.show(context, state.error);
                        }
                      },
                      builder: (context, state) {
                        return CustomAppButton1(
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
