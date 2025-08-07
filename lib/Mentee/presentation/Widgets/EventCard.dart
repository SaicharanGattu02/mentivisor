import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:mentivisor/Components/CustomAppButton.dart';

import '../../Models/ECCModel.dart';
import 'DetailRow.dart';

class EventCard extends StatelessWidget {
  final ECCList eccList;

  const EventCard({Key? key, required this.eccList}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 0),
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(color: Colors.black12, blurRadius: 8, offset: Offset(0, 2)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Banner
          ClipRRect(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
            child: CachedNetworkImage(
              imageUrl: eccList.imgUrl ?? "",
              height: 160,
              fit: BoxFit.cover,
            ),
          ),

          const SizedBox(height: 16),

          // Title
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Text(
              eccList.name ?? "",
              style: TextStyle(
                fontFamily: 'segeo',
                fontWeight: FontWeight.w700,
                fontSize: 18,
                color: Colors.black,
              ),
            ),
          ),
          const SizedBox(height: 16),
          // Details
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              children: [
                DetailRow(
                  icon: Icons.calendar_today,
                  bgColor: Color(0xFF3F51B5),
                  text: '${eccList.dateofevent ?? ""} ${eccList.time}',
                ),
                SizedBox(height: 8),
                DetailRow(
                  icon: Icons.location_on,
                  bgColor: Color(0xFF4CAF50),
                  text: eccList.location ?? "",
                ),
                SizedBox(height: 8),
                DetailRow(
                  icon: Icons.apartment,
                  bgColor: Color(0xFF000000),
                  text: eccList.college ?? "",
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          // View Details button
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: CustomAppButton1(
              text: "View Details",
              onPlusTap: () {
                context.push('/view_event', extra: eccList);
              },
            ),
          ),

          const SizedBox(height: 16),
        ],
      ),
    );
  }
}
