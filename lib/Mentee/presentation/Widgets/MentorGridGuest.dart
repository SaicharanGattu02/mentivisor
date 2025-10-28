import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:mentivisor/utils/media_query_helper.dart';

import '../../../Components/Shimmers.dart';
import '../../../utils/constants.dart';
import '../../../utils/spinkittsLoader.dart';
import '../../Models/CompusMentorListModel.dart';
import '../../Models/GuestMentorsModel.dart';

class MentorGridGuest extends StatelessWidget {
  final List<Mentor>? mentors;
  final void Function(Mentor) onTapMentor;

  const MentorGridGuest({
    required this.mentors,
    required this.onTapMentor,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final width = SizeConfig.screenWidth;
    int crossAxisCount;
    if (width < 600) {
      crossAxisCount = 2;
    } else if (width > 600) {
      crossAxisCount = 3;
    } else {
      crossAxisCount = 4;
    }

    return MasonryGridView.count(
      crossAxisCount: crossAxisCount,
      mainAxisSpacing: 16,
      crossAxisSpacing: 16,
      physics: NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemCount: mentors?.length ?? 0,
      itemBuilder: (ctx, i) {
        final m = mentors?[i];
        if (m == null) return const SizedBox();
        final url = m.profilePicUrl?.trim() ?? "";

        return GestureDetector(
          onTap: () => onTapMentor(m),
          child: _MentorCard(
            stream: m.stream,
            year: m.year,
            name: m.name ?? '',
            designation: m.bio ?? '',
            collegeName: m.college?.name ?? '',
            image: url,
            rating: (m.ratingsReceivedCount ?? 0).toDouble(),
            ratingCount: m.ratingsReceivedCount ?? 0,
            coinsPerMinute: m.coinsPerMinute ?? "",
          ),
        );
      },
    );
  }
}

class MentorGridCampus extends StatelessWidget {
  final List<MentorsList>? mentors_list;
  final void Function(MentorsList) onTapMentor;
  const MentorGridCampus({
    required this.mentors_list,
    required this.onTapMentor,
  });

  @override
  Widget build(BuildContext context) {
    final width = SizeConfig.screenWidth;
    int crossAxisCount;
    if (width < 600) {
      crossAxisCount = 2;
    } else if (width > 600) {
      crossAxisCount = 3;
    } else {
      crossAxisCount = 4;
    }

    return MasonryGridView.count(
      crossAxisCount: crossAxisCount,
      mainAxisSpacing: 16,
      crossAxisSpacing: 16,
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemCount: mentors_list?.length ?? 0,
      itemBuilder: (ctx, i) {
        final m = mentors_list?[i];
        final url = m?.user?.profilePicUrl?.trim();
        return GestureDetector(
          onTap: () => onTapMentor(m!),
          child: _MentorCard(
            name: m?.user?.name ?? '',
            designation: m?.user?.bio ?? '',
            collegeName: m?.user?.college?.name ?? '',
            year: m?.user?.year ?? '',
            stream: m?.user?.stream ?? '',
            image: url ?? "",
            rating: double.tryParse(m?.averageRating?.toString() ?? "0") ?? 0.0,
            ratingCount: m?.totalReviews ?? 0,
            coinsPerMinute: m?.coinsPerMinute.toString() ?? "",
          ),
        );
      },
    );
  }
}

class _MentorCard extends StatelessWidget {
  final String name;
  final String designation;
  final String image;
  final double rating;
  final int ratingCount;
  final String coinsPerMinute;
  final String collegeName;
  final String? stream;
  final String? year;

  const _MentorCard({
    required this.name,
    required this.designation,
    required this.image,
    required this.rating,
    required this.ratingCount,
    required this.coinsPerMinute,
    required this.collegeName,
    this.stream,
    this.year,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Color(0xffF1F5FD).withOpacity(0.6),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        children: [
          CachedNetworkImage(
            imageUrl: image,
            imageBuilder: (context, imageProvider) =>
                CircleAvatar(radius: 36, backgroundImage: imageProvider),
            placeholder: (context, url) => CircleAvatar(
              radius: 36,
              backgroundColor: Colors.grey,
              child: SizedBox(
                width: 16,
                height: 16,
                child: Center(child: spinkits.getSpinningLinespinkit()),
              ),
            ),
            errorWidget: (context, url, error) => CircleAvatar(
              radius: 36,
              backgroundColor: Colors.grey.shade300,
              child: Text(
                (name != null && name.trim().isNotEmpty)
                    ? name.trim()[0].toUpperCase()
                    : 'U',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w700,
                  color: Color(0xff333333),
                  fontFamily: 'segeo',
                ),
              ),
            ),
          ),
          SizedBox(height: 3),
          Text(
            capitalize(name),
            textAlign: TextAlign.center,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w700,
              color: Color(0xff333333),
            ),
          ),
          SizedBox(height: 3),
          Text(
            "$collegeName",
            textAlign: TextAlign.center,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w400,
              color: Color(0xff555555),
            ),
          ),
          SizedBox(
            width: SizeConfig.screenWidth * 0.4,
            child: Center(
              child: Text(
                designation,
                textAlign: TextAlign.center,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  color: Color(0xff555555),
                  fontFamily: 'segeo',
                  fontWeight: FontWeight.w400,
                ),
              ),
            ),
          ),

          // SizedBox(height: 5),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                "assets/images/starvector.png",
                color: Colors.amber,
                height: 14,
                width: 14,
              ),
              SizedBox(width: 4),
              RichText(
                text: TextSpan(
                  children: [
                    TextSpan(
                      text: rating.toStringAsFixed(1),
                      style: const TextStyle(
                        fontSize: 12,
                        fontFamily: 'segeo',
                        color: Color(0xff333333),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    TextSpan(
                      text: " ($ratingCount)",
                      style: const TextStyle(
                        fontSize: 12,
                        fontFamily: 'segeo',
                        color: Color(0xff666666),
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ],
                ),
              ),
              // const SizedBox(width: 8),
              // Image.asset("assets/images/coinsgold.png", height: 16, width: 16),
              // SizedBox(width: 4),
              // Text(
              //   '$coinsPerMinute',
              //   style: TextStyle(
              //     fontSize: 12,
              //     fontFamily: 'segeo',
              //     color: Color(0xff333333),
              //     fontWeight: FontWeight.bold,
              //   ),
              // ),
            ],
          ),
        ],
      ),
    );
  }
}

class MentorGridCampusShimmer extends StatefulWidget {
  const MentorGridCampusShimmer({super.key});

  @override
  State<MentorGridCampusShimmer> createState() =>
      _MentorGridCampusShimmerState();
}

class _MentorGridCampusShimmerState extends State<MentorGridCampusShimmer> {
  @override
  Widget build(BuildContext context) {
    final width = SizeConfig.screenWidth;

    int crossAxisCount;
    if (width >= 1000) {
      crossAxisCount = 4; // Desktop
    } else if (width >= 700) {
      crossAxisCount = 3; // Tablet
    } else {
      crossAxisCount = 2; // Mobile
    }

    final spacing = SizeConfig.width(3);
    final itemWidth =
        (width - ((crossAxisCount + 1) * spacing)) / crossAxisCount;
    final itemHeight =
        itemWidth *
        (width < 600
            ? 1.04 // mobile
            : width < 1024
            ? 0.95 // tablet
            : 0.85); // desktop
    final aspectRatio = itemWidth / itemHeight;

    // Let's show 6 shimmer cards for smooth UX
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        automaticallyImplyLeading: false,
        title: Row(
          spacing: 10,
          children: [
            shimmerCircle(48, context),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                shimmerText(itemWidth * 0.6, 14, context),
                SizedBox(height: 6),
                shimmerText(itemWidth * 0.2, 14, context), // name
              ],
            ),
          ],
        ),
        actions: [
          Padding(
            padding: EdgeInsets.only(right: 16.0),
            child: Row(
              spacing: 5,
              children: [
                shimmerRectangle(22, context),
                shimmerRectangle(22, context),
              ],
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: SizeConfig.height(25),
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  itemCount: 2,
                  separatorBuilder: (_, __) => const SizedBox(width: 8),
                  itemBuilder: (context, index) {
                    return shimmerContainer(
                      SizeConfig.screenWidth,
                      160,
                      context,
                    );
                  },
                ),
              ),
              SizedBox(height: 8),
              shimmerText(itemWidth * 0.6, 14, context), // name
              SizedBox(height: 8),
              GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: 6,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: crossAxisCount,
                  crossAxisSpacing: spacing,
                  mainAxisSpacing: spacing,
                  childAspectRatio: aspectRatio,
                ),
                itemBuilder: (context, index) {
                  return Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.05),
                          blurRadius: 4,
                          offset: const Offset(2, 2),
                        ),
                      ],
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        shimmerCircle(itemWidth * 0.4, context),
                        const SizedBox(height: 12),
                        shimmerText(itemWidth * 0.6, 14, context), // name
                        const SizedBox(height: 8),
                        shimmerText(itemWidth * 0.4, 12, context), // bio
                        const SizedBox(height: 8),
                        shimmerText(
                          itemWidth * 0.5,
                          12,
                          context,
                        ), // college name
                        const SizedBox(height: 12),
                      ],
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
