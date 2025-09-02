import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:mentivisor/utils/media_query_helper.dart';
import '../../../utils/color_constants.dart';
import '../../../utils/spinkittsLoader.dart';

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
  final String remainingTime; // For upcoming sessions

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
    this.remainingTime = '', // Default empty for non-upcoming sessions
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Color statusColor;
    Color statusTextColor;
    String statusText;
    // Set the status-specific properties
    if (status == 'Cancelled') {
      statusColor = Color(0xffF37F7F).withOpacity(0.1);
      statusTextColor = Color(0xffF37F7F);
      statusText = 'Cancelled';
    } else if (status == 'Completed') {
      statusColor = Color(0xff7FF38D).withOpacity(0.1);
      statusTextColor = Color(0xff7FF38D);
      statusText = 'Completed';
    } else {
      statusColor = primarycolor1.withOpacity(0.1);
      statusTextColor = primarycolor1;
      statusText = remainingTime.isEmpty
          ? 'Upcoming'
          : remainingTime; // Show remaining time for upcoming
    }

    return InkWell(
      onTap: () {
        context.push("/session_details");
      },
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        elevation: 1,
        child: Container(padding: EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
              spacing: 12,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: SizeConfig.screenWidth*0.6,
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
                        const SizedBox(height: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
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
                        const Text(
                          'Session Topics',
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontFamily: 'segeo',
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
                        context.push("/cancel_session");
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
          ),
        ),
      ),
    );
  }
}
