import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:mentivisor/utils/media_query_helper.dart';
import '../../../Components/CustomAppButton.dart';
import '../../../Components/CustomSnackBar.dart';
import '../../../utils/color_constants.dart';
import '../../../utils/spinkittsLoader.dart';
import '../../data/Cubits/ReportMentee/report_mentee_cubit.dart';
import '../../data/Cubits/ReportMentor/report_mentor_cubit.dart';
import '../../data/Cubits/ReportMentor/report_mentor_states.dart';

class SessionCard extends StatelessWidget {
  final String status;
  final String sessionDate;
  final String sessionTime;
  final String sessionName;
  final String sessionImage;
  final String sessionTopics;
  final String reason;
  final String buttonText;
  final String buttonIcon;
  final String remainingTime;
  final int sessionId;
  final int? menteeId;

  const SessionCard({
    Key? key,
    required this.status,
    required this.sessionDate,
    required this.sessionTime,
    required this.sessionName,
    required this.sessionImage,
    required this.sessionTopics,
    required this.reason,
    required this.buttonText,
    required this.buttonIcon,
    required this.sessionId,
    this.remainingTime = '',
    this.menteeId,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Color statusColor;
    Color statusTextColor;
    String statusText;
    if (status == 'cancelled') {
      statusColor = Color(0xffF37F7F).withOpacity(0.1);
      statusTextColor = Color(0xffF37F7F);
      statusText = 'cancelled';
    } else if (status == 'completed') {
      statusColor = Color(0xff7FF38D).withOpacity(0.1);
      statusTextColor = Color(0xff7FF38D);
      statusText = 'completed';
    } else {
      statusColor = primarycolor1.withOpacity(0.1);
      statusTextColor = primarycolor1;
      statusText = remainingTime.isEmpty ? 'upcoming' : remainingTime;
    }

    return InkWell(
      onTap: () {
        context.push("/session_details?sessionId=${sessionId}");
      },
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        elevation: 1,
        child: Container(
          padding: EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                spacing: 12,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: SizeConfig.screenWidth * 0.575,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          sessionDate,
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            fontFamily: 'segeo',
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          sessionName,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'segeo',
                          ),
                        ),
                        SizedBox(height: 8),
                        Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: statusColor,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            statusText,
                            style: TextStyle(
                              color: statusTextColor,
                              fontSize: 12,
                              fontFamily: 'segeo',
                            ),
                          ),
                        ),
                        const SizedBox(height: 8),

                        if (sessionTopics.trim().isNotEmpty) ...[
                          const Text(
                            'Session Topics',
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                              fontFamily: 'segeo',
                              fontSize: 14,
                              color: Color(0xff444444),
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            sessionTopics,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              fontSize: 14,
                              color: Colors.grey,
                              fontFamily: 'segeo',
                            ),
                          ),
                        ],
                        const SizedBox(height: 16),
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
                        imageUrl: sessionImage ?? "",
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
                              image: AssetImage("assets/images/profile.png"),
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              if (status == 'upcoming') ...[
                Row(
                  children: [
                    Expanded(
                      child: Container(
                        height: 48,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              Color(0xFFF4E9FF),
                              Color(0xFFE1E4FF),
                              Color(0xFFE2EEFF),
                            ],
                          ),
                          borderRadius: BorderRadius.circular(24),
                        ),
                        child: ElevatedButton.icon(
                          onPressed: () {},
                          icon: Image.asset(buttonIcon, width: 18, height: 18),
                          label: Text(
                            buttonText,
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.black,
                              fontWeight: FontWeight.w600,
                              fontFamily: 'segeo',
                            ),
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.transparent,
                            shadowColor: Colors.transparent,
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(24),
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(width: 12),
                    SizedBox(
                      height: 48,
                      child: OutlinedButton(
                        onPressed: () {
                          context.push(
                            "/cancel_session?sessionId=${sessionId}",
                          );
                        },
                        style: OutlinedButton.styleFrom(
                          side: BorderSide(color: Colors.grey.shade400),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(24),
                          ),
                          backgroundColor: Color(0xFFF5F5F5),
                        ),
                        child: Text(
                          'Cancel',
                          style: TextStyle(
                            fontSize: 14,
                            color: Color(0xFF333333),
                            fontFamily: 'segeo',
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
              if (status == "completed") ...[
                Align(
                  alignment: Alignment.centerLeft,
                  child: InkWell(
                    onTap: () {
                      _showReportSheet(context, sessionId, menteeId ?? 0);
                    },
                    child: Container(
                      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: Color(0xffF5F5F5),
                        borderRadius: BorderRadius.circular(24),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Image.asset(
                            "assets/images/ReportmenteImg.png",
                            height: 20,
                            width: 20,
                          ),
                          SizedBox(width: 4),
                          Text(
                            'Report mentee',
                            style: TextStyle(color: Color(0xff222222)),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
              if (status == 'cancelled') ...[
                Column(
                  children: [
                    Text(
                      'Reason',
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontFamily: 'segeo',
                        fontSize: 14,
                        color: Color(0xff444444),
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      reason,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 14,
                        color: Colors.grey,
                        fontFamily: 'segeo',
                      ),
                    ),
                  ],
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  void _showReportSheet(BuildContext context, int sessionId, int menteeId) {
    String? _selected;
    final TextEditingController _otherController = TextEditingController();
    final List<String> _reportReasons = [
      'Abuse Words',
      'Scam or Fraud ',
      'Sexual Arrestment',
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
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            return SafeArea(
              child: Padding(
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
                    // Title and Close Button
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Report Mentee',
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
                          visualDensity: VisualDensity.compact,
                          activeColor: const Color(0xFF4A00E0),
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 0,
                          ),
                        );
                      }).toList(),
                    ),
                    // Custom Reason TextField
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
                    BlocConsumer<ReportMentorCubit, ReportMentorStates>(
                      listener: (context, state) {
                        if (state is ReportMentorSuccess) {
                          context.pop(); // ✅ close bottom sheet on success
                        } else if (state is ReportMentorFailure) {
                          CustomSnackBar1.show(context, state.error);
                        }
                      },
                      builder: (context, state) {
                        return CustomAppButton1(
                          isLoading:
                              state is ReportMentorLoading, // ✅ show loader
                          text: "Submit Report",
                          onPlusTap: () {
                            String finalReason =
                                _selected == "Other" &&
                                    _otherController.text.isNotEmpty
                                ? _otherController.text
                                : _selected ?? "";

                            final Map<String, dynamic> data = {
                              "mentee_id": menteeId,
                              "session_id": sessionId,
                              "reason": finalReason,
                            };

                            context.read<ReportMentorCubit>().reportMentor(
                              data,
                            );
                          },
                        );
                      },
                    ),
                    const SizedBox(height: 16),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }
}
