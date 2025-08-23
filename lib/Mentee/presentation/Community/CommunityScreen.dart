import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:mentivisor/Mentee/data/cubits/CommunityPosts/CommunityPostsCubit.dart';
import 'package:mentivisor/Mentee/data/cubits/CommunityPosts/CommunityPostsStates.dart';
import 'package:mentivisor/utils/color_constants.dart';

import '../../../services/AuthService.dart';
import '../../Models/CommunityPostsModel.dart';
import '../Widgets/FilterButton.dart';
import '../Widgets/PostCard.dart';

class Communityscreen extends StatefulWidget {
  const Communityscreen({Key? key}) : super(key: key);

  @override
  _CommunityScreenState createState() => _CommunityScreenState();
}

class _CommunityScreenState extends State<Communityscreen> {
  final ValueNotifier<bool> _onCampus = ValueNotifier<bool>(true);
  final ValueNotifier<int> _selectedFilter = ValueNotifier<int>(0);
  final List<String> _filters = ['All', 'Upcoming', 'Highlighted'];
  String selectedFilter = 'On Campuses';

  @override
  void initState() {
    super.initState();
    context.read<CommunityPostsCubit>().getCommunityPosts("", "");
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFE0F0FF),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFFFAF5FF), Color(0xFFF5F6FF), Color(0xFFEFF6FF)],
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
              FutureBuilder(
                future: AuthService.isGuest,
                builder: (context, snapshot) {
                  final isGuest = snapshot.data ?? false;
                  if (!isGuest) {
                    return Column(
                      children: [
                        const SizedBox(height: 24),
                        ValueListenableBuilder<bool>(
                          valueListenable: _onCampus,
                          builder: (context, onCampus, _) {
                            return Container(
                              decoration: BoxDecoration(
                                color: const Color(0xFFE8EBF7),
                                borderRadius: BorderRadius.circular(30),
                              ),
                              padding: const EdgeInsets.all(4),
                              child: Row(
                                spacing: 10,
                                children: [
                                  Expanded(
                                    child: FilterButton(
                                      text: 'On Campus',
                                      isSelected: onCampus,
                                      onPressed: () {
                                        final selectedUpdate =
                                            _filters[_selectedFilter.value]
                                                .toLowerCase();
                                        context
                                            .read<CommunityPostsCubit>()
                                            .getCommunityPosts(
                                              "",
                                              selectedUpdate,
                                            );
                                        _onCampus.value = true;
                                      },
                                    ),
                                  ),
                                  Expanded(
                                    child: FilterButton(
                                      text: 'Beyond Campus',
                                      isSelected: !onCampus,
                                      onPressed: () {
                                        final selectedUpdate =
                                            _filters[_selectedFilter.value]
                                                .toLowerCase();
                                        context
                                            .read<CommunityPostsCubit>()
                                            .getCommunityPosts(
                                              "beyond",
                                              selectedUpdate,
                                            );
                                        _onCampus.value = false;
                                      },
                                    ),
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                      ],
                    );
                  } else {
                    return const SizedBox.shrink();
                  }
                },
              ),

              SizedBox(height: 20),
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
                  FutureBuilder(
                    future: AuthService.isGuest,
                    builder: (context, snapshot) {
                      final isGuest = snapshot.data ?? false;
                      return ElevatedButton.icon(
                        onPressed: () {
                          if (isGuest) {
                            context.push('/auth_landing');
                          } else {
                            context.push("/addpostscreen");
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 8,
                          ),
                          backgroundColor: Color(0xffEDD9FF),
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(24),
                          ),
                          elevation: 0,
                          shadowColor: Colors.transparent,
                          surfaceTintColor: Colors.transparent,
                        ),
                        icon: Container(
                          padding: EdgeInsets.symmetric(),
                          width: 20,
                          height: 20,
                          decoration: BoxDecoration(
                            color: Color(0xff9B40EF),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Icon(Icons.add, size: 16, color: Colors.white),
                        ),
                        label: const Text(
                          'Add',
                          style: TextStyle(
                            fontFamily: 'segeo',
                            fontSize: 14,
                            fontWeight: FontWeight.w400,
                            color: Color(0xff9B40EF),
                          ),
                        ),
                      );
                    },
                  ),
                ],
              ),
              SizedBox(height: 10),
              SizedBox(
                height: 32,
                child: ValueListenableBuilder<int>(
                  valueListenable: _selectedFilter,
                  builder: (context, value, child) {
                    return ListView.separated(
                      scrollDirection: Axis.horizontal,
                      itemCount: _filters.length,
                      separatorBuilder: (_, __) => const SizedBox(width: 8),
                      itemBuilder: (context, i) {
                        final selected = i == _selectedFilter.value;
                        return ChoiceChip(
                          showCheckmark: false,
                          labelPadding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 0,
                          ),
                          materialTapTargetSize:
                              MaterialTapTargetSize.shrinkWrap,
                          visualDensity: VisualDensity.compact,
                          label: Text(
                            _filters[i],
                            style: TextStyle(
                              fontFamily: 'segeo',
                              fontWeight: FontWeight.w700,
                              fontSize: 12,
                              color: selected
                                  ? Color(0xFF4076ED)
                                  : Colors.black54,
                            ),
                          ),
                          selected: selected,
                          onSelected: (_) {
                            _selectedFilter.value = i;
                            if (_onCampus.value) {
                              context
                                  .read<CommunityPostsCubit>()
                                  .getCommunityPosts(
                                    "",
                                    _filters[i].toLowerCase(),
                                  );
                            } else {
                              context
                                  .read<CommunityPostsCubit>()
                                  .getCommunityPosts(
                                    "beyond",
                                    _filters[i].toLowerCase(),
                                  );
                            }
                          },
                          selectedColor: const Color(
                            0xFF4076ED,
                          ).withOpacity(0.1),
                          backgroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(24),
                            side: selected
                                ? const BorderSide(color: Color(0xFF4076ED))
                                : const BorderSide(color: Colors.transparent),
                          ),

                        );
                      },
                    );
                  },
                ),
              ),

              const SizedBox(height: 12),
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
                    if (communityposts?.length == 0) {
                      return
                        Center(
                        child: Column(
                          spacing: 10,
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            SizedBox(
                              height: 200,
                              width: 200,
                              child: Center(
                                child: Image.asset("assets/nodata/no_data.png"),
                              ),
                            ),
                            Text(
                              textAlign: TextAlign.center,
                              'No Data Found!',
                              style: TextStyle(
                                color: primarycolor,
                                fontSize: 18,
                                fontWeight: FontWeight.w400,
                                fontFamily: 'Poppins',
                              ),
                            ),
                          ],
                        ),
                      );
                    }
                    return Expanded(
                      child: NotificationListener<ScrollNotification>(
                        onNotification: (scrollInfo) {
                          if (scrollInfo.metrics.pixels >=
                              scrollInfo.metrics.maxScrollExtent * 0.9) {
                            if (state is CommunityPostsLoaded &&
                                state.hasNextPage) {
                              final selectedUpdate =
                                  _filters[_selectedFilter.value].toLowerCase();
                              if (_onCampus.value == true) {
                                context
                                    .read<CommunityPostsCubit>()
                                    .fetchMoreCommunityPosts(
                                      "",
                                      selectedUpdate,
                                    );
                              } else {
                                context
                                    .read<CommunityPostsCubit>()
                                    .fetchMoreCommunityPosts(
                                      "beyond",
                                      selectedUpdate,
                                    );
                              }
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
                                  communityPosts: communitypost ?? CommunityPosts(),
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

      floatingActionButton: FutureBuilder(
        future: AuthService.isGuest,
        builder: (context, snapshot) {
          final isGuest = snapshot.data ?? false;
          return Container(
            height: 64,
            width: 64,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              gradient: kCommonGradient,
            ),
            child: FloatingActionButton(
              shape: CircleBorder(),
              onPressed: () {
                if (isGuest) {
                } else {}
              },
              backgroundColor: Colors.transparent,
              elevation: 0,
              child:  Image.asset("images/ChatCircleDots.png",width:28,height: 28,),
            ),
          );
        },
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
                fontFamily: 'segeo',
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
