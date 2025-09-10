import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:mentivisor/Components/CustomAppButton.dart';
import 'package:mentivisor/services/AuthService.dart';
import 'package:mentivisor/utils/constants.dart';

import '../../../utils/spinkittsLoader.dart';
import '../../Models/ECCModel.dart';
import 'DetailRow.dart';

class EventCard extends StatelessWidget {
  final ECCList eccList;

  const EventCard({Key? key, required this.eccList}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 0),
      decoration: BoxDecoration(
        color: eccList.popular == 1 ? const Color(0xffFFF7CE) : Colors.white,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Stack(
        children: [
          // 🔹 Main Content (put in a Column)
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16.0,
                  vertical: 10,
                ),
                child: SizedBox(
                  width: double.infinity,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: CachedNetworkImage(
                      height: 160,
                      imageUrl: eccList.imgUrl ?? "",
                      fit: BoxFit.cover,
                      width: double.infinity,
                      placeholder: (context, url) =>
                          Center(child: spinkits.getSpinningLinespinkit()),
                      errorWidget: (context, url, error) => Container(
                        height: 160,
                        color: Colors.grey.shade100,
                        child: const Icon(
                          Icons.broken_image,
                          size: 40,
                          color: Colors.grey,
                        ),
                      ),
                    ),
                  ),
                ),
              ),

              // Title
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Text(
                  eccList.name ?? "",
                  style: const TextStyle(
                    fontFamily: 'segeo',
                    fontWeight: FontWeight.w700,
                    fontSize: 18,
                    color: Colors.black,
                  ),
                ),
              ),
              const SizedBox(height: 10),

              // Details
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  children: [
                    DetailRow(
                      asset: "assets/icons/calender.png",
                      bgColor: const Color(0xFF3F51B5),
                      text:
                          '${formatDate(eccList.dateofevent ?? "")} at ${formatTimeRange(eccList.time)}',
                    ),
                    const SizedBox(height: 8),
                    DetailRow(
                      asset: "assets/icons/location.png",
                      bgColor: const Color(0xFF4CAF50),
                      text: eccList.location ?? "",
                    ),
                    const SizedBox(height: 8),
                    DetailRow(
                      asset: "assets/icons/institution.png",
                      bgColor: const Color(0xFF000000),
                      text: eccList.college ?? "",
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 15),

              // View Details button
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: FutureBuilder(
                  future: AuthService.isGuest,
                  builder: (context, snapshot) {
                    final isGuest = snapshot.data ?? false;
                    return CustomAppButton1(
                      text: "View Details",
                      onPlusTap: () {
                        if (isGuest) {
                          context.push('/auth_landing');
                        } else {
                          context.push('/view_event/${eccList.id}',);
                        }
                      },
                    );
                  },
                ),
              ),
              const SizedBox(height: 10),
            ],
          ),

          // 🔹 Highlight Ribbon
          if (eccList.popular == 1)
            Positioned(
              top: 0,
              right: 0,
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 4,
                ),
                decoration: const BoxDecoration(
                  color: Color(0xffFFD700),
                  borderRadius: BorderRadius.only(
                    topRight: Radius.circular(8),
                    bottomLeft: Radius.circular(6),
                  ),
                ),
                child: Row(
                  children: [
                    Image.asset(
                      "assets/icons/Sparkle.png",
                      width: 16,
                      height: 16,
                    ),
                    const SizedBox(width: 6),
                    const Text(
                      "Highlighted",
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'segeo',
                        color: Color(0xff5E5E5E),
                      ),
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }
}
