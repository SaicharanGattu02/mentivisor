import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:mentivisor/utils/media_query_helper.dart';

import '../../../utils/spinkittsLoader.dart';
import '../../Models/CompusMentorListModel.dart';
import '../../Models/GuestMentorsModel.dart';

class MentorGridGuest extends StatelessWidget {
  final List<Mentor>? mentors;
  final void Function(Mentor) onTapMentor;
  const MentorGridGuest({required this.mentors, required this.onTapMentor});

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: mentors?.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
        childAspectRatio: 0.7,
      ),
      itemBuilder: (ctx, i) {
        final m = mentors?[i];
        final url = m?.profilePicUrl?.trim();
        return GestureDetector(
          onTap: () => onTapMentor(m!),
          child: _MentorCard(
            name: m?.name ?? '',
            designation: m?.bio ?? '',
            image: url ?? "",
            rating: (m?.ratingsReceivedCount ?? 0).toDouble(),
            ratingCount: m?.ratingsReceivedCount ?? 0,
            coinsPerMinute: "",
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
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: mentors_list?.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
        childAspectRatio: 0.7,
      ),
      itemBuilder: (ctx, i) {
        final m = mentors_list?[i];
        final url = m?.user?.profilePicUrl?.trim();
        return GestureDetector(
          onTap: () => onTapMentor(m!),
          child: _MentorCard(
            name: m?.user?.name ?? '',
            designation: m?.user?.bio ?? '',
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

  const _MentorCard({
    required this.name,
    required this.designation,
    required this.image,
    required this.rating,
    required this.ratingCount,
    required this.coinsPerMinute,
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
                CircleAvatar(radius: 60, backgroundImage: imageProvider),
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
          const SizedBox(height: 8),
          Text(
            name,
            textAlign: TextAlign.center,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w700,
              color: Color(0xff333333),
            ),
          ),
          SizedBox(height: 5),
          SizedBox(
            width: SizeConfig.screenWidth * 0.18,
            child: Text(
              designation,
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                color: Color(0xff555555),
                fontFamily: 'segeo',
                fontWeight: FontWeight.w400,
              ),
            ),
          ),
          SizedBox(height: 5),
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
              Text(
                "${rating.toStringAsFixed(1)} ($ratingCount)",
                style: const TextStyle(
                  fontSize: 12,
                  fontFamily: 'segeo',
                  color: Color(0xff333333),
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(width: 8),
              Image.asset("assets/images/coinsgold.png", height: 16, width: 16),
              SizedBox(width: 4),
              Text(
                '$coinsPerMinute',
                style: TextStyle(
                  fontSize: 12,
                  color: Color(0xff666666),
                  fontWeight: FontWeight.w400,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
