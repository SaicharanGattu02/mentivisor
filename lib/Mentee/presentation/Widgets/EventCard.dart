import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:mentivisor/Components/CustomAppButton.dart';
import 'package:mentivisor/services/AuthService.dart';

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
        color: eccList.popular == 1 ? Color(0xffFFF7CE) : Colors.white,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (eccList.popular == 1) ...[
            Align(
              alignment: Alignment.topRight,
              child: Container(
                width: 150,
                padding: EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Color(0xffFFD700),
                  borderRadius: BorderRadius.only(
                    topRight: Radius.circular(8),
                    bottomRight: Radius.circular(8),
                  ),
                ),
                child: Row(
                  spacing: 10,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset(
                      "assets/icons/Sparkle.png",
                      width: 18,
                      height: 18,
                    ),
                    Text("Highlighted"),
                  ],
                ),
              ),
            ),
          ],
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10),
            child: SizedBox(
              width: double.infinity,
              child:
              ClipRRect(
                borderRadius:
                BorderRadius.circular(8),
                child: CachedNetworkImage(height: 160,
                  imageUrl: eccList.imgUrl ?? "",
                  fit: BoxFit.cover,
                  width: double.infinity,
                  placeholder: (context, url) =>
                      Center(
                        child: spinkits
                            .getSpinningLinespinkit(),
                      ),
                  errorWidget:
                      (
                      context,
                      url,
                      error,
                      ) => Container(height: 160,
                    color: Colors
                        .grey
                        .shade100,
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
              style: TextStyle(
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
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              children: [
                DetailRow(
                  asset: "assets/icons/calender.png",
                  bgColor: Color(0xFF3F51B5),
                  text: '${eccList.dateofevent ?? ""} ${eccList.time}',
                ),
                SizedBox(height: 8),
                DetailRow(
                  asset: "assets/icons/location.png",
                  bgColor: Color(0xFF4CAF50),
                  text: eccList.location ?? "",
                ),
                SizedBox(height: 8),
                DetailRow(
                  asset: "assets/icons/institution.png",
                  bgColor: Color(0xFF000000),
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
                      context.push('/view_event', extra: eccList);
                    }
                  },
                );
              },
            ),
          ),

          const SizedBox(height: 10),
        ],
      ),
    );
  }
}
