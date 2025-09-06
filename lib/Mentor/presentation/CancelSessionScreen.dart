import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:mentivisor/Components/CustomAppButton.dart';
import 'package:mentivisor/Components/CustomSnackBar.dart';

import '../../Components/CommonLoader.dart';
import '../../Components/CutomAppBar.dart';
import '../../Components/ShakeWidget.dart';
import '../../utils/media_query_helper.dart';
import '../../utils/spinkittsLoader.dart';
import '../data/Cubits/MentorSessionCancel/mentor_session_cancel_cubit.dart';
import '../data/Cubits/MentorSessionCancel/mentor_session_cancel_states.dart';
import '../data/Cubits/SessionDetails/SessionsDetailsCubit.dart';
import '../data/Cubits/SessionDetails/SessionsDetailsStates.dart';

class CancelSessionScreen extends StatefulWidget {
  final int sessionId;
  const CancelSessionScreen({required this.sessionId});

  @override
  State<CancelSessionScreen> createState() => _CancelSessionScreenState();
}

class _CancelSessionScreenState extends State<CancelSessionScreen> {
  final TextEditingController reasonController = TextEditingController();
  int? fetchedSessionId;
  int? menteeId;
  bool _showCancelError = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await context.read<SessionDetailsCubit>().getSessionDetails(
        widget.sessionId,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar1(title: "Cancel", actions: []),
      body: SafeArea(
        child: Container(
          padding: const EdgeInsets.all(16.0),
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xffFAF5FF), Color(0xffF5F6FF), Color(0xffEFF6FF)],
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              BlocBuilder<SessionDetailsCubit, SessionDetailsStates>(
                builder: (context, state) {
                  if (state is SessionDetailsLoading) {
                    return const Center(child: DottedProgressWithLogo());
                  } else if (state is SessionDetailsLoaded) {
                    final sessionDetails = state.sessionDetailsModel.session;
                    fetchedSessionId = sessionDetails?.id;
                    menteeId = sessionDetails?.mentee?.id;

                    return Container(
                      padding: const EdgeInsets.symmetric(
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
                          SizedBox(
                            width: SizeConfig.screenWidth * 0.575,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  sessionDetails?.date ?? "",
                                  style: const TextStyle(
                                    fontFamily: 'Segeo',
                                    fontWeight: FontWeight.w600,
                                    fontSize: 16,
                                    color: Color(0xff333333),
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  'with ${sessionDetails?.mentee?.name ?? ""} '
                                  'from ${sessionDetails?.mentee?.collegeName ?? ""} college',
                                  style: const TextStyle(
                                    fontFamily: 'Segeo',
                                    fontWeight: FontWeight.w400,
                                    fontSize: 14,
                                  ),
                                ),
                                // const SizedBox(height: 8),
                                // Container(
                                //   padding: const EdgeInsets.symmetric(
                                //     horizontal: 8,
                                //     vertical: 4,
                                //   ),
                                //   decoration: BoxDecoration(
                                //     color: const Color(
                                //       0xff4076ED,
                                //     ).withOpacity(0.1),
                                //     borderRadius: BorderRadius.circular(12),
                                //   ),
                                //   child: Text(
                                //     sessionDetails?.minutesLeft ?? "",
                                //     style: const TextStyle(
                                //       color: Color(0xff4076ED),
                                //       fontSize: 12,
                                //       fontFamily: 'segeo',
                                //     ),
                                //   ),
                                // ),
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
                    );
                  } else if (state is SessionDetailsFailure) {
                    return Text(state.error);
                  }
                  return const Text("No Data");
                },
              ),
              const SizedBox(height: 32),
              const Text(
                'Reason to cancel',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  fontFamily: 'segeo',
                  color: Color(0xff000000),
                ),
              ),
              const SizedBox(height: 8),
              TextField(
                controller: reasonController,
                cursorColor: Colors.black,
                decoration: InputDecoration(
                  hintText: 'Explain here',
                  hintStyle: TextStyle(
                    fontFamily: 'segeo',
                    color: Colors.black.withOpacity(0.6),
                  ),
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  contentPadding: const EdgeInsets.symmetric(
                    vertical: 16,
                    horizontal: 16,
                  ),
                ),
                maxLines: 4,
              ),
              if (_showCancelError)
                Padding(
                  padding: const EdgeInsets.only(top: 6),
                  child: ShakeWidget(
                    key: const Key('ReasonError'),
                    duration: const Duration(milliseconds: 700),
                    child: const Text(
                      'Please enter a reason to cancel',
                      style: TextStyle(
                        fontFamily: 'Inter',
                        fontSize: 12,
                        color: Colors.redAccent,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child:
              BlocConsumer<MentorSessionCancelCubit, MentorSessionCancleStates>(
                listener: (context, state) {
                  if (state is MentorsessionCancelSuccess) {
                    context.pop();
                  } else if (state is MentorsessioncancleFailure) {
                    CustomSnackBar1.show(context, state.error);
                  }
                },
                builder: (context, state) {
                  return CustomAppButton1(
                    isLoading: state is MentorsessioncancleLoading,
                    text: "Submit",
                    onPlusTap: () {
                      setState(() {
                        _showCancelError = reasonController.text.trim().isEmpty;
                      });

                      if (_showCancelError) return;

                      final Map<String, dynamic> data = {
                        "session_id": fetchedSessionId ?? widget.sessionId,
                        "mentee_id": menteeId,
                        "cancelled_reason": reasonController.text.trim(),
                      };

                      context.read<MentorSessionCancelCubit>().sessionCancelled(
                        data,
                      );
                    },
                  );
                },
              ),
        ),
      ),
    );
  }
}
