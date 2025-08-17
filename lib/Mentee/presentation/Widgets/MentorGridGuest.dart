import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

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
        final hasPic = url != null && url.isNotEmpty;
        return GestureDetector(
          onTap: () => onTapMentor(m!),
          child: _MentorCard(
            name: m?.name ?? '',
            designation: m?.designation ?? '',
            imageProvider: hasPic ? CachedNetworkImageProvider(url!) : null,
            rating: (m?.ratingsReceivedCount ?? 0)
                .toDouble(), // adjust if you have separate average
            ratingCount: m?.ratingsReceivedCount ?? 0,
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
        final hasPic = url != null && url.isNotEmpty;
        return GestureDetector(
          onTap: () => onTapMentor(m!),
          child: _MentorCard(
            name: m?.user?.name ?? '',
            designation: m?.user?.designation ?? '',
            imageProvider: hasPic ? CachedNetworkImageProvider(url!) : null,
            rating: double.parse(m?.averageRating.toString() ?? ""), // average
            ratingCount:
                0, // <-- add correct count field in your model if available
          ),
        );
      },
    );
  }
}

class _MentorCard extends StatelessWidget {
  final String name;
  final String designation;
  final ImageProvider? imageProvider;
  final double rating;
  final int ratingCount;

  const _MentorCard({
    required this.name,
    required this.designation,
    required this.imageProvider,
    required this.rating,
    required this.ratingCount,
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
          CircleAvatar(
            radius: 60,
            backgroundColor: Colors.grey.shade200,
            backgroundImage: imageProvider,
            child: imageProvider == null
                ? const Icon(Icons.person, size: 60, color: Colors.grey)
                : null,
          ),
          const SizedBox(height: 8),
          Text(
            name,
            textAlign: TextAlign.center,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w700,
              color: Color(0xff333333),
            ),
          ),
          const SizedBox(height: 4),
          Text(
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
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                "assets/images/starvector.png",
                color: Colors.amber,
                height: 14,
                width: 14,
              ),
              const SizedBox(width: 4),
              Text(
                rating.toStringAsFixed(1),
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
                '$ratingCount',
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
