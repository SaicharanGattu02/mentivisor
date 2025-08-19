import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:mentivisor/Mentor/data/Cubits/ReportMentee/report_mentee_cubit.dart';

import '../../../Components/CustomAppButton.dart';
import '../../../Components/CustomSnackBar.dart';
import '../../Models/MyMenteesModel.dart';
import '../../data/Cubits/ReportMentee/report_mentee_states.dart';

class MenteeCard extends StatelessWidget {
  final MenteeData mentee;
  const MenteeCard({required this.mentee});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      elevation: 6, // Subtle shadow
      color: Color(0xFFF5F6F5), // Light grayish-white background
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(
                        8,
                      ), // Adjust the radius for rounded corners
                      child: CachedNetworkImage(
                        imageUrl: mentee.image ?? "",
                        imageBuilder: (context, imageProvider) => Container(
                          width: 60,
                          height: 60,
                          decoration: BoxDecoration(
                            image: DecorationImage(
                              image: imageProvider,
                              fit: BoxFit.fill,
                            ),
                            color: Color(
                              0xFFF5E6CC,
                            ), // Beige background for image
                          ),
                        ),
                        placeholder: (context, url) => Container(
                          width: 60,
                          height: 60,
                          color: Color(0xFFF5E6CC),
                          child: Center(child: CircularProgressIndicator()),
                        ),
                        errorWidget: (context, url, error) => Container(
                          width: 60,
                          height: 60,
                          decoration: BoxDecoration(
                            image: DecorationImage(
                              image: AssetImage("images/profileimg.png"),
                              fit: BoxFit.cover,
                            ),
                            color: Color(0xFFF5E6CC),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            mentee.name ?? "",
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: Color(0xFF222222), // Dark gray for name
                            ),
                          ),
                          SizedBox(height: 5),
                          Text(
                            "",
                            // mentee.name ?? "",
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color: Color(0xFF666666), // Gray for email
                            ),
                          ),
                          SizedBox(height: 5),
                          Text(
                            'Last interaction was ${mentee.lastSession?.date ?? "N/A"}',
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color: Color(
                                0xFF757575,
                              ), // Lighter gray for last interaction
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 10),
                Align(
                  alignment: Alignment.centerLeft,
                  child: InkWell(
                    onTap: () {
                      _showReportSheet(
                        context,
                        mentee.lastSession?.sessionId ?? 0,mentee.menteeId??0
                      );
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
                            "images/ReportmenteImg.png",
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
            ),
          ),

          Positioned(
            bottom: -10,
            right: -10,
            child: ClipRRect(
              borderRadius: BorderRadius.only(bottomRight: Radius.circular(16)),
              child: Image.asset(
                'images/colorpatch.png', // Ensure you have this image asset
                width: 80,
                height: 80,
                fit: BoxFit.cover,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showReportSheet(BuildContext context, int sessionId,int menteeId) {
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
                        activeColor: const Color(0xFF4A00E0),
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 8,
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

                  BlocConsumer<ReportMenteeCubit, ReportMenteeStates>(
                    listener: (context, state) {
                      if (state is ReportMenteeSuccess) {
                        context.pop();
                      } else if (state is ReportMenteeFailure) {
                        CustomSnackBar1.show(context, state.error ?? "");
                      }
                    },
                    builder: (context, state) {
                      return CustomAppButton1(
                        isLoading: state is ReportMenteeLoading,
                        text: "Submit Report",
                        onPlusTap: () {
                          final Map<String, dynamic> data = {
                            "mentee_id": menteeId,
                            "session_id": sessionId,
                            "reason": _selected,
                          };
                          context.read<ReportMenteeCubit>().reportMentee(data);
                        },
                      );
                    },
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
}
