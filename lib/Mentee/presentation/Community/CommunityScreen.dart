import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:mentivisor/Mentee/data/cubits/CommunityPosts/CommunityPostsCubit.dart';
import 'package:mentivisor/Mentee/data/cubits/CommunityPosts/CommunityPostsStates.dart';

import '../../Models/CommunityPostsModel.dart';
import '../Widgets/FilterButton.dart';
import '../Widgets/PostCard.dart';

class Communityscreen extends StatefulWidget {
  const Communityscreen({Key? key}) : super(key: key);

  @override
  _CommunityScreenState createState() => _CommunityScreenState();
}

class _CommunityScreenState extends State<Communityscreen> {
  bool _onCampus = true;
  int _selectedTabIndex = 0;

  int _selectedFilter = 0;
  String selectedFilter = 'On Campus';
  final List<String> _filters = ['All', 'Active', 'Upcoming', 'Highlighted'];
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
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFFF7F8FC), Color(0xFFEFF4FF)],
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
          ),
        ),
        padding: const EdgeInsets.all(16.0),
        child: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Community',
                style: TextStyle(
                  fontFamily: 'segeo',
                  fontWeight: FontWeight.w700,
                  height: 1,
                  fontSize: 20,
                  color: Color(0xFF121212),
                ),
              ),
              const SizedBox(height: 4),
              const Text(
                'Connect and Collaborate with Peers ',
                style: TextStyle(
                  fontFamily: 'segeo',
                  fontWeight: FontWeight.w600,
                  fontSize: 14,
                  color: Color(0xFF666666),
                ),
              ),

              const SizedBox(height: 24),
              Container(
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  color: const Color(0xFFE4EEFF),
                  borderRadius: BorderRadius.circular(24),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: FilterButton(
                        text: 'On Campus',
                        isSelected: selectedFilter == 'On Campus',
                        onPressed: () {
                          setState(() {
                            selectedFilter = 'On Campus';
                          });
                        },
                      ),
                    ),
                    Expanded(
                      child: FilterButton(
                        text: 'Beyond Campus',
                        isSelected: selectedFilter == 'Beyond Campus',
                        onPressed: () {
                          setState(() {
                            selectedFilter = 'Beyond Campus';
                          });
                        },
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Posts',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF121212),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      context.push("/addpostscreen");
                    },
                    child: Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 8,
                      ),
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [
                            Color(0xFFD1A9F0), // Lighter purple start
                            Color(0xFFE6C4F5), // Even lighter purple end
                          ],
                          begin: Alignment.centerLeft,
                          end: Alignment.centerRight,
                        ),
                        borderRadius: BorderRadius.circular(24),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        spacing: 10,
                        children: [
                          const Icon(
                            Icons.add_box_outlined,
                            size: 24,
                            color: Colors.white,
                          ),
                          const Text(
                            'Add',
                            style: TextStyle(
                              fontFamily: 'Segoe',
                              fontSize: 16,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 10),
              SizedBox(
                height: 32,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  itemCount: _filters.length,
                  separatorBuilder: (_, __) => const SizedBox(width: 8),
                  itemBuilder: (context, i) {
                    final selected = i == _selectedFilter;
                    return ChoiceChip(
                      showCheckmark: false,
                      labelPadding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 0,
                      ),
                      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      visualDensity: VisualDensity.compact,
                      label: Text(
                        _filters[i],
                        style: TextStyle(
                          fontFamily: 'segeo',
                          fontWeight: FontWeight.w700,
                          fontSize: 12,
                          color: selected ? Color(0xFF4076ED) : Colors.black54,
                        ),
                      ),
                      selected: selected,
                      onSelected: (_) {
                        setState(() => _selectedFilter = i);
                      },
                      selectedColor: const Color(0xFF4076ED).withOpacity(0.1),
                      backgroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(24),
                        side: selected
                            ? const BorderSide(
                                color: Color(0xFF4076ED),
                              ) // 10% opacity
                            : const BorderSide(color: Colors.transparent),
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
