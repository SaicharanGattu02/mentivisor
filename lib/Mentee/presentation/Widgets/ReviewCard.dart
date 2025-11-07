import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../services/AuthService.dart';
import '../../../utils/AppLogger.dart';
import '../../../utils/spinkittsLoader.dart';

class ReviewCard extends StatelessWidget {
  final String name;
  final int id;
  final int rating;
  final String createdAt;
  final String review;
  final String imgeUrl;

  const ReviewCard({
    Key? key,
    required this.name,
    required this.id,
    required this.rating,
    required this.createdAt,
    required this.review,
    required this.imgeUrl,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final timeAgo = getTimeAgo(createdAt);

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Vertical line (left side)
          Container(
            width: 3,
            height: 60,
            decoration: BoxDecoration(
              color: const Color(0xFFc084fc),
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(width: 8),

          // Profile + Review Content
          Expanded(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Profile picture
                GestureDetector(
                  onTap: () async {
                    final userIdStr =
                        await AuthService.getUSerId(); // String? like "107"
                    final userId = int.tryParse(
                      userIdStr ?? '',
                    ); // Parse to int, default 0 if null/invalid
                    AppLogger.info("userId::$userId (parsed as int: $userId)");

                    final uploaderId = id;
                    if (userId == uploaderId) {
                      context.push("/profile");
                      AppLogger.info(
                        "Navigating to own profile (userId: $userId == uploaderId: $uploaderId)",
                      );
                      AppLogger.info("profile::true");
                    } else {
                      context.push("/common_profile/$uploaderId");
                      AppLogger.info(
                        "Navigating to common profile (userId: $userId != uploaderId: $uploaderId)",
                      );
                      AppLogger.info("profile::false...$uploaderId");
                    }
                  },
                  child: CachedNetworkImage(
                    imageUrl: imgeUrl,
                    imageBuilder: (context, imageProvider) => CircleAvatar(
                      radius: 20,
                      backgroundImage: imageProvider,
                    ),
                    placeholder: (context, url) => CircleAvatar(
                      radius: 20,
                      backgroundColor: Colors.grey,
                      child: SizedBox(
                        width: 16,
                        height: 16,
                        child: Center(child: spinkits.getSpinningLinespinkit()),
                      ),
                    ),
                    errorWidget: (context, url, error) => const CircleAvatar(
                      radius: 20,
                      backgroundImage: AssetImage("assets/images/profile.png"),
                    ),
                  ),
                ),

                const SizedBox(width: 10),

                // Review content
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Row with name + stars + timeAgo
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            name,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontFamily: "Inter",
                            ),
                          ),
                          SizedBox(width: 6),
                          Row(
                            children: List.generate(
                              rating,
                              (index) => const Icon(
                                Icons.star,
                                color: Colors.amber,
                                size: 14,
                              ),
                            ),
                          ),
                          Spacer(),
                          Text(
                            timeAgo,
                            style: const TextStyle(
                              color: Colors.grey,
                              fontSize: 12,
                              fontFamily: "Inter",
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 4),
                      Text(
                        review,
                        style: TextStyle(
                          fontSize: 13,
                          fontFamily: "Inter",
                          color: Colors.black87,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

String getTimeAgo(String createdAt) {
  try {
    final dateTime = DateTime.parse(createdAt);
    final difference = DateTime.now().difference(dateTime);

    if (difference.inDays > 0) {
      return "${difference.inDays} day${difference.inDays > 1 ? 's' : ''} ago";
    } else if (difference.inHours > 0) {
      return "${difference.inHours} hour${difference.inHours > 1 ? 's' : ''} ago";
    } else if (difference.inMinutes > 0) {
      return "${difference.inMinutes} minute${difference.inMinutes > 1 ? 's' : ''} ago";
    } else {
      return "just now";
    }
  } catch (e) {
    return "";
  }
}
