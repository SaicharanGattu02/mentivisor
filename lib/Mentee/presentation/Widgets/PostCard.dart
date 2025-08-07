import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import '../../Models/CommunityPostsModel.dart';

class PostCard extends StatelessWidget {
  final CommunityPosts communityPosts;
  const PostCard({Key? key, required this.communityPosts}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: InkWell(
        onTap: () {},
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(16),
              ),
              child: CachedNetworkImage(
                imageUrl: communityPosts.imgUrl ?? "",
                height: 180,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const CircleAvatar(
                        radius: 12,
                        backgroundImage: AssetImage(
                          'assets/images/profileimg.png',
                        ), // Replace with actual path
                      ),
                      const SizedBox(width: 8),
                      Text(
                        communityPosts.uploader?.name ?? "",
                        style: const TextStyle(
                          fontFamily: 'Segoe',
                          fontWeight: FontWeight.w600,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    communityPosts.heading ?? "",
                    style: const TextStyle(
                      fontFamily: 'Segoe',
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: Color(0xFF222222),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    communityPosts.description ?? "",
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontFamily: 'Segoe',
                      fontWeight: FontWeight.w400,
                      fontSize: 14,
                      color: Color(0xFF666666),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      const Icon(Icons.thumb_up_alt_outlined, size: 18),
                      const SizedBox(width: 6),
                      Text(
                        communityPosts.likesCount.toString() ?? "",
                        style: const TextStyle(fontFamily: 'Segoe'),
                      ),
                      const SizedBox(width: 24),
                      const Icon(Icons.comment_outlined, size: 18),
                      const SizedBox(width: 6),
                      Text(
                        communityPosts.commentsCount.toString() ?? "",
                        style: const TextStyle(fontFamily: 'Segoe'),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            // if ( communityPosts.likesCount.toString()??"", == 'true')
            //   Positioned(
            //     top: 8,
            //     right: 8,
            //     child: Container(
            //       padding: const EdgeInsets.symmetric(
            //         horizontal: 8,
            //         vertical: 4,
            //       ),
            //       decoration: BoxDecoration(
            //         color: Colors.amber[400],
            //         borderRadius: BorderRadius.circular(6),
            //       ),
            //       child: const Row(
            //         children: [
            //           Icon(Icons.star, size: 14, color: Colors.white),
            //           SizedBox(width: 4),
            //           Text(
            //             'Highlighted',
            //             style: TextStyle(
            //               fontFamily: 'Segoe',
            //               fontSize: 12,
            //               fontWeight: FontWeight.w600,
            //               color: Colors.white,
            //             ),
            //           ),
            //         ],
            //       ),
            //     ),
            //   ),
          ],
        ),
      ),
    );
  }
}
