import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mentivisor/Mentee/data/cubits/CommunityPosts/CommunityPostsCubit.dart';
import 'package:mentivisor/Mentee/data/cubits/CommunityPosts/CommunityPostsStates.dart';

import '../../Models/CommunityPostsModel.dart';
import '../Widgets/PostCard.dart';

class Communityscreen extends StatefulWidget {
  const Communityscreen({Key? key}) : super(key: key);

  @override
  _CommunityScreenState createState() => _CommunityScreenState();
}

class _CommunityScreenState extends State<Communityscreen> {
  bool _onCampus = true;
  int _selectedTabIndex = 0;

  final List<String> _mainTabs = ['On Campus', 'Beyond Campus'];
  final List<String> _subTabs = ['All', 'Recent', 'Trending', 'Highlighted'];

  // Gradient colors for FAB
  static const Color grad1 = Color(0xFFA258F7);
  static const Color grad2 = Color(0xFF726CF7);
  static const Color grad3 = Color(0xFF4280F6);

  @override
  void initState() {
    super.initState();
    context.read<CommunityPostsCubit>().getCommunityPosts();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFE0F0FF), // Match image background
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        automaticallyImplyLeading: false,
        title: const Text(
          'Community',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Color(0xFF121212),
            fontFamily: 'Segoe',
          ),
        ),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(4),
          child: const Text(
            'Connect and Collaborate with Peers',
            style: TextStyle(
              fontSize: 14,
              color: Color(0xFF666666),
              fontFamily: 'Segoe',
            ),
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Container(
              decoration: BoxDecoration(
                color: const Color(0xFFE8EBF7),
                borderRadius: BorderRadius.circular(30),
              ),
              padding: const EdgeInsets.all(4),
              child: Row(
                children: [
                  _buildToggle('On Campus', _onCampus, () {
                    setState(() => _onCampus = true);
                  }),
                  const SizedBox(width: 8),
                  _buildToggle('Beyond Campus', !_onCampus, () {
                    setState(() => _onCampus = false);
                  }),
                ],
              ),
            ),

            // Posts section
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Posts',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF121212),
                    fontFamily: 'Segoe',
                  ),
                ),
                Container(
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        decoration: const BoxDecoration(
                          color: Color(
                            0xFF8A56AC,
                          ), // Solid darker purple for icon
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(20),
                            bottomLeft: Radius.circular(20),
                          ),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(8),
                          child: const Icon(
                            Icons.add,
                            size: 24,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      Container(
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            colors: [
                              Color(0xFFD1A9F0), // Lighter purple start
                              Color(0xFFE6C4F5), // Even lighter purple end
                            ],
                            begin: Alignment.centerLeft,
                            end: Alignment.centerRight,
                          ),
                          borderRadius: const BorderRadius.only(
                            topRight: Radius.circular(20),
                            bottomRight: Radius.circular(20),
                          ),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                            vertical: 10,
                            horizontal: 12,
                          ),
                          child: const Text(
                            'Add',
                            style: TextStyle(
                              fontFamily: 'Segoe',
                              fontSize: 16,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),

            SizedBox(
              height: 42,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                itemCount: _subTabs.length,
                separatorBuilder: (_, __) => const SizedBox(width: 8),
                itemBuilder: (ctx, i) {
                  final sel = i == _selectedTabIndex;
                  return AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 14,
                      vertical: 8,
                    ),
                    decoration: BoxDecoration(
                      color: sel ? const Color(0xFFB9DFFF) : Colors.white,
                      borderRadius: BorderRadius.circular(24),
                      border: Border.all(
                        color: sel
                            ? Colors.transparent
                            : const Color(0xFFE0E0E0),
                      ),
                    ),
                    child: GestureDetector(
                      onTap: () => setState(() => _selectedTabIndex = i),
                      child: Center(
                        child: Text(
                          _subTabs[i],
                          style: TextStyle(
                            fontFamily: 'Segoe',
                            fontWeight: FontWeight.w500,
                            fontSize: 12,
                            color: sel
                                ? const Color(0xFF2196F3)
                                : const Color(0xFF555555),
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),

            const SizedBox(height: 12),

            // Post list
            BlocBuilder<CommunityPostsCubit, CommunityPostsStates>(
              builder: (context, state) {
                if (state is CommunityPostsLoading) {
                  return Center(child: CircularProgressIndicator());
                } else if (state is CommunityPostsLoaded ||
                    state is CommunityPostsLoadingMore) {
                  final communityPostsModel = (state is CommunityPostsLoaded)
                      ? (state as CommunityPostsLoaded).communityPostsModel
                      : (state as CommunityPostsLoadingMore)
                            .communityPostsModel;
                  final communityposts =
                      communityPostsModel.data?.communityposts;
                  return Expanded(
                    child: NotificationListener<ScrollNotification>(
                      onNotification: (scrollInfo) {
                        if (scrollInfo.metrics.pixels >=
                            scrollInfo.metrics.maxScrollExtent * 0.9) {
                          if (state is CommunityPostsLoaded &&
                              state.hasNextPage) {
                            context
                                .read<CommunityPostsCubit>()
                                .fetchMoreCommunityPosts();
                          }
                          return false;
                        }
                        return false;
                      },
                      child: CustomScrollView(
                        slivers: [
                          SliverList.separated(
                            itemCount: communityposts?.length ?? 0,
                            separatorBuilder: (_, __) =>
                                const SizedBox(height: 16), // The separator
                            itemBuilder: (context, index) {
                              final communitypost = communityposts?[index];
                              return PostCard(
                                communityPosts:
                                    communitypost ?? CommunityPosts(),
                              );
                            },
                          ),

                          if (state is CommunityPostsLoadingMore)
                            SliverToBoxAdapter(
                              child: Padding(
                                padding: const EdgeInsets.all(25.0),
                                child: Center(
                                  child: CircularProgressIndicator(
                                    strokeWidth: 0.8,
                                  ),
                                ),
                              ),
                            ),
                        ],
                      ),
                    ),
                  );
                } else {
                  return Center(child: Text("No Data Found"));
                }
              },
            ),
          ],
        ),
      ),

      // Floating Action Button
      floatingActionButton: Container(
        height: 64,
        width: 64,
        decoration: const BoxDecoration(
          shape: BoxShape.circle,
          gradient: LinearGradient(
            colors: [grad1, grad2, grad3],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black26,
              blurRadius: 12,
              offset: Offset(0, 6),
            ),
          ],
        ),
        child: FloatingActionButton(
          onPressed: () {},
          backgroundColor: Colors.transparent,
          elevation: 0,
          child: const Icon(Icons.chat_bubble, size: 28),
        ),
      ),
    );
  }

  Widget _buildToggle(String label, bool active, VoidCallback onTap) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 8),
          decoration: BoxDecoration(
            color: active
                ? const Color(0xFF4076ED).withOpacity(0.1)
                : Colors.transparent,
            borderRadius: BorderRadius.circular(30),
            border: Border.all(
              color: active ? const Color(0xFF4076ED) : Colors.transparent,
            ),
          ),
          child: Center(
            child: Text(
              label,
              style: TextStyle(
                fontFamily: 'Segoe',
                fontWeight: FontWeight.w700,
                fontSize: 14,
                color: active ? const Color(0xFF4076ED) : Colors.black54,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
