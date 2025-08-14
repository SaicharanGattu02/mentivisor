import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:mentivisor/Components/CutomAppBar.dart';
import '../../../services/AuthService.dart';
import '../../../utils/spinkittsLoader.dart';
import '../Widgets/CommentBottomSheet.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreen1State();
}

class _ProfileScreen1State extends State<ProfileScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar1(title: "Profile", actions: []),
      body: Container(
        padding: EdgeInsetsGeometry.symmetric(horizontal: 16, vertical: 20),
        child: Column(
          children: [
            CircleAvatar(
              radius: 20,
              child: Image.asset("assets/images/profile.png"),
            ),
            Text(
              'Rahul',
              style: TextStyle(
                color: Color(0xff121212),
                fontSize: 18,
                fontFamily: 'segeo',
                fontWeight: FontWeight.w700,
              ),
            ),

            SizedBox(height: 4),

            const Text(
              'SVR Collage NZB 2nd year\nMechanical Engineering',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Color(0xff666666),
                fontSize: 14,
                fontFamily: 'segeo',
                fontWeight: FontWeight.w600,
              ),
            ),

            const SizedBox(height: 12),

            const Text(
              '"Future biologist, passionate about specific area of biology, e.g., marine ecosystems and always eager to learn more. Currently studying at University Name, and excited to see where my studies take me"',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Color(0xff666666),
                fontSize: 12,
                fontFamily: 'segeo',
                fontWeight: FontWeight.w400,
              ),
            ),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                OutlinedButton.icon(
                  onPressed: () {},
                  icon: const Icon(Icons.mode_edit_outlined, size: 16),
                  label: const Text(
                    'Edit',
                    style: TextStyle(
                      fontFamily: 'segeo',
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Color(0xff4A7CF6),
                      decoration: TextDecoration.underline,
                      decorationColor: Color(0xff4A7CF6),
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    side: BorderSide.none,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 8,
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                OutlinedButton.icon(
                  onPressed: () {},
                  icon: Icon(Icons.share_rounded, size: 16),
                  label: Text('Share', style: TextStyle(fontFamily: 'segeo')),
                  style: OutlinedButton.styleFrom(
                    side: BorderSide.none,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 8,
                    ),
                  ),
                ),
              ],
            ),

            SizedBox(height: 16),

            const TabBar(
              indicatorColor: Colors.blue,
              labelColor: Colors.blue,
              unselectedLabelColor: Colors.grey,
              labelStyle: TextStyle(fontFamily: 'segeo'),
              tabs: [
                Tab(text: 'Posts'),
                Tab(text: 'Resources'),
              ],
            ),

            // Tab Views
            Expanded(
              child: TabBarView(
                children: [
                  Expanded(
                    child: NotificationListener<ScrollNotification>(
                      onNotification: (scrollInfo) {
                        if (scrollInfo.metrics.pixels >=
                            scrollInfo.metrics.maxScrollExtent * 0.9) {
                          // if (state is CommunityPostsLoaded &&
                          //     state.hasNextPage) {
                          //   final selectedUpdate = _filters[_selectedFilter].toLowerCase();

                          // }
                          return false;
                        }
                        return false;
                      },
                      child: CustomScrollView(
                        slivers: [
                          SliverList.separated(
                            itemCount: 2,
                            separatorBuilder: (_, __) =>
                                const SizedBox(height: 16), // The separator
                            itemBuilder: (context, index) {
                              // final communitypost = communityposts?[index];
                              return Container(
                                margin: const EdgeInsets.symmetric(
                                  horizontal: 0,
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 16.0,
                                        vertical: 10,
                                      ),
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(8),
                                        child: CachedNetworkImage(
                                          height: 160,
                                          imageUrl: "",
                                          fit: BoxFit.cover,
                                          width: double.infinity,
                                          placeholder: (context, url) => Center(
                                            child: spinkits
                                                .getSpinningLinespinkit(),
                                          ),
                                          errorWidget: (context, url, error) =>
                                              Container(
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
                                    Padding(
                                      padding: const EdgeInsets.all(12),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
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
                                                "",
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
                                            "",
                                            style: const TextStyle(
                                              fontFamily: 'Segoe',
                                              fontWeight: FontWeight.bold,
                                              fontSize: 16,
                                              color: Color(0xFF222222),
                                            ),
                                          ),
                                          const SizedBox(height: 4),
                                          Text(
                                            "",
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
                                          FutureBuilder(
                                            future: AuthService.isGuest,
                                            builder: (context, snapshot) {
                                              final isGuest =
                                                  snapshot.data ?? false;
                                              return Row(
                                                children: [
                                                  const Icon(
                                                    Icons.thumb_up_alt_outlined,
                                                    size: 18,
                                                  ),
                                                  const SizedBox(width: 6),
                                                  // Text(communityPosts.likesCount.toString() ?? ""),
                                                  const SizedBox(width: 24),
                                                  GestureDetector(
                                                    onTap: () {
                                                      showModalBottomSheet(
                                                        context: context,
                                                        isScrollControlled:
                                                            true,
                                                        useRootNavigator: true,
                                                        backgroundColor:
                                                            Colors.transparent,
                                                        builder: (context) {
                                                          return DraggableScrollableSheet(
                                                            initialChildSize:
                                                                0.8,
                                                            minChildSize: 0.4,
                                                            maxChildSize: 0.95,
                                                            expand: false,
                                                            builder: (_, scrollController) => Container(
                                                              decoration: const BoxDecoration(
                                                                color: Colors
                                                                    .white,
                                                                borderRadius:
                                                                    BorderRadius.vertical(
                                                                      top:
                                                                          Radius.circular(
                                                                            16,
                                                                          ),
                                                                    ),
                                                              ),
                                                              padding:
                                                                  const EdgeInsets.symmetric(
                                                                    horizontal:
                                                                        16,
                                                                    vertical:
                                                                        12,
                                                                  ),
                                                              child: CommentBottomSheet(
                                                                postId: 0,
                                                                scrollController:
                                                                    scrollController, // pass it down
                                                              ),
                                                            ),
                                                          );
                                                        },
                                                      );

                                                      child:
                                                      Row(
                                                        children: [
                                                          const Icon(
                                                            Icons
                                                                .comment_outlined,
                                                            size: 18,
                                                          ),
                                                          const SizedBox(
                                                            width: 6,
                                                          ),
                                                          Text(
                                                            "nityPosts",
                                                            style:
                                                                const TextStyle(
                                                                  fontFamily:
                                                                      'Segoe',
                                                                ),
                                                          ),
                                                        ],
                                                      );
                                                    },
                                                  ),
                                                ],
                                              );
                                            },
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            },
                          ),

                          // if (state is CommunityPostsLoadingMore)
                          //   SliverToBoxAdapter(
                          //     child: Padding(
                          //       padding: const EdgeInsets.all(25.0),
                          //       child: Center(
                          //         child: CircularProgressIndicator(
                          //           strokeWidth: 0.8,
                          //         ),
                          //       ),
                          //     ),
                          //   ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
