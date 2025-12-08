import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:go_router/go_router.dart';
import 'package:mentivisor/Components/CustomSnackBar.dart';
import 'package:mentivisor/Mentee/data/cubits/CommunityPosts/CommunityPostsCubit.dart';
import 'package:mentivisor/Mentee/data/cubits/CommunityPosts/CommunityPostsStates.dart';
import 'package:mentivisor/utils/color_constants.dart';
import 'package:mentivisor/utils/media_query_helper.dart';

import '../../../Components/CommonLoader.dart';
import '../../../services/AuthService.dart';
import '../../Models/CommunityPostsModel.dart';
import '../Widgets/CommonChoiceChip.dart';
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
  final ValueNotifier<bool> _fabVisible = ValueNotifier<bool>(true);
  final List<String> _filters = ['All', 'Recent', 'Trending', 'Highlighted'];
  String selectedFilter = 'On Campuses';

  @override
  void initState() {
    super.initState();
    context.read<CommunityPostsCubit>().getCommunityPosts("", "");
  }

  @override
  void dispose() {
    _fabVisible.dispose();
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
                  ValueListenableBuilder<bool>(
                    valueListenable: _onCampus,
                    builder: (context, onCampus, _) {
                      if (!onCampus) {
                        return const SizedBox.shrink();
                      }
                      return FutureBuilder(
                        future: AuthService.isGuest,
                        builder: (context, snapshot) {
                          final isGuest = snapshot.data ?? false;
                          return ElevatedButton.icon(
                            onPressed: () {
                              if (isGuest) {
                                context.push('/auth_landing');
                              } else {
                                final selectedUpdate =
                                    _filters[_selectedFilter.value]
                                        .toLowerCase();
                                context.push(
                                  "/addpostscreen?type=${selectedUpdate}",
                                );
                              }
                            },
                            style: ElevatedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 8,
                              ),
                              backgroundColor: const Color(0xffEDD9FF),
                              foregroundColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(24),
                              ),
                              elevation: 0,
                              shadowColor: Colors.transparent,
                              surfaceTintColor: Colors.transparent,
                            ),
                            icon: Container(
                              width: 20,
                              height: 20,
                              decoration: BoxDecoration(
                                color: const Color(0xff9B40EF),
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: const Icon(
                                Icons.add,
                                size: 16,
                                color: Colors.white,
                              ),
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
                        return CustomChoiceChip(
                          label: _filters[i],
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
                    return Expanded(
                      child: CustomScrollView(
                        slivers: [
                          SliverPadding(
                            padding: const EdgeInsets.symmetric(horizontal: 0),
                            sliver: SliverMasonryGrid.count(
                              crossAxisCount: _getCrossAxisCount(
                                context,
                              ), // 👈 Responsive columns
                              mainAxisSpacing: 16,
                              crossAxisSpacing: 16,
                              childCount: 5, // same as before
                              itemBuilder: (context, index) {
                                return const CommunityPostShimmer();
                              },
                            ),
                          ),
                        ],
                      ),
                    );
                  } else if (state is CommunityPostsLoaded ||
                      state is CommunityPostsLoadingMore) {
                    final communityPostsModel = (state is CommunityPostsLoaded)
                        ? (state as CommunityPostsLoaded).communityPostsModel
                        : (state as CommunityPostsLoadingMore)
                              .communityPostsModel;
                    final communityposts =
                        communityPostsModel.data?.communityposts;
                    if (communityposts?.length == 0) {
                      return Expanded(
                        child: Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              SizedBox(
                                height: 200,
                                width: 200,
                                child: Image.asset("assets/nodata/no_data.png"),
                              ),
                              // const SizedBox(height: 24),
                              ValueListenableBuilder<int>(
                                valueListenable: _selectedFilter,
                                builder: (context, filterIndex, _) {
                                  final currentFilter = _filters[filterIndex];
                                  final isOnCampus = _onCampus.value;

                                  String message;

                                  if (isOnCampus) {
                                    switch (currentFilter.toLowerCase()) {
                                      case 'all':
                                        message =
                                            "No posts on campus yet.\nBe the first to share something!";
                                        break;
                                      case 'recent':
                                        message =
                                            "No recent posts on campus yet.\nBe the first to Start the conversation!";
                                        break;
                                      case 'trending':
                                        message =
                                            "Nothing trending on campus right now.\nBe the first to Share something cool!";
                                        break;
                                      case 'highlighted':
                                        message =
                                            "No highlighted posts yet.\nBe the first to Your post could be next!";
                                        break;
                                      default:
                                        message =
                                            "Be the first to post on your campus!";
                                    }
                                  } else {
                                    // Beyond Campus
                                    switch (currentFilter.toLowerCase()) {
                                      case 'all':
                                        message =
                                            "No posts from beyond campus yet.";
                                        break;
                                      case 'recent':
                                        message =
                                            "No recent posts from beyond campus.";
                                        break;
                                      case 'trending':
                                        message =
                                            "Nothing trending beyond campus right now.";
                                        break;
                                      case 'highlighted':
                                        message =
                                            "No highlighted posts from beyond campus.";
                                        break;
                                      default:
                                        message =
                                            "No posts found beyond campus.";
                                    }
                                  }
                                  return Text(
                                    message,
                                    textAlign: TextAlign.center,
                                    style: const TextStyle(
                                      color: Colors.black87,
                                      fontSize: 16,
                                      fontWeight: FontWeight.w400,
                                      fontFamily: 'Poppins',
                                    ),
                                  );
                                },
                              ),
                            ],
                          ),
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
                          }

                          // NEW: Hide/show FAB based on scroll direction
                          if (scrollInfo is UserScrollNotification) {
                            if (scrollInfo.direction ==
                                    ScrollDirection.reverse &&
                                _fabVisible.value) {
                              _fabVisible.value =
                                  false; // scrolling down -> hide
                            } else if (scrollInfo.direction ==
                                    ScrollDirection.forward &&
                                !_fabVisible.value) {
                              _fabVisible.value = true; // scrolling up -> show
                            } else if (scrollInfo.direction ==
                                ScrollDirection.idle) {
                              // optional: when near top, ensure visible
                              if (scrollInfo.metrics.pixels <= 8 &&
                                  !_fabVisible.value) {
                                _fabVisible.value = true;
                              }
                            }
                          }
                          return false;
                        },
                        child: CustomScrollView(
                          slivers: [
                            SliverPadding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 0,
                              ),
                              sliver: SliverMasonryGrid.count(
                                crossAxisCount: _getCrossAxisCount(
                                  context,
                                ), // 👈 dynamic responsive logic
                                mainAxisSpacing: 16,
                                crossAxisSpacing: 16,
                                childCount: communityposts?.length ?? 0,
                                itemBuilder: (context, index) {
                                  final communitypost = communityposts?[index];
                                  return PostCard(
                                    scope: _onCampus.value ? "" : "beyond",
                                    communityPosts:
                                        communitypost ?? CommunityPosts(),
                                  );
                                },
                              ),
                            ),
                            if (state is CommunityPostsLoadingMore)
                              const SliverToBoxAdapter(
                                child: Padding(
                                  padding: EdgeInsets.all(25.0),
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
        future: AuthService.isGuest, // Check if the user is a guest
        builder: (context, snapshot) {
          final isGuest = snapshot.data ?? false; // If the user is a guest
          // Check if the FAB should be visible
          return ValueListenableBuilder<bool>(
            valueListenable: _fabVisible, // Listen to FAB visibility
            builder: (context, isVisible, child) {
              // If the user is not a guest, show the FAB based on scroll
              return AnimatedSlide(
                duration: const Duration(milliseconds: 180),
                curve: Curves.easeOut,
                offset: isVisible ? Offset.zero : const Offset(0, 1.2),
                child: AnimatedOpacity(
                  duration: const Duration(milliseconds: 180),
                  opacity: isVisible ? 1 : 0,
                  child: Container(
                    height: 64,
                    width: 64,
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: LinearGradient(
                        colors: [
                          Color(0xFF9B40EF), // #9B40EF
                          Color(0xFF5B4BEB), // #5B4BEB
                          Color(0xFF315DEA), // #315DEA
                        ],
                        begin: Alignment.centerLeft,
                        end: Alignment.centerRight,
                      ),
                    ),
                    child: FloatingActionButton(
                      shape: const CircleBorder(),
                      onPressed: () {
                        if (isGuest) {
                          // Do guest action
                        } else {
                          if (_onCampus.value) {
                            context.push(
                              '/group_chat?campus_type=On Campus Chat',
                            );
                          } else {
                            context.push(
                              '/group_chat?campus_type=Beyond Campus Chat',
                            );
                          }
                        }
                      },
                      backgroundColor: Colors.transparent, // Keep transparent
                      elevation: 0, // So gradient is visible
                      child: Image.asset(
                        "assets/images/ChatCircleDots.png",
                        width: 28,
                        height: 28,
                      ),
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }

  int _getCrossAxisCount(BuildContext context) {
    final width = MediaQuery.of(context).size.width;

    if (width < 600) {
      return 1; // Mobile
    } else if (width < 900) {
      return 2; // Tablet
    } else {
      return 3; // Larger screens
    }
  }

  double _getChildAspectRatio(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final width = size.width;
    final height = size.height;

    // base ratio derived from screen proportions
    double baseRatio = width / height;

    if (width < 600) {
      // Mobile – taller cards
      return baseRatio * 2;
    } else if (width > 600) {
      // Tablet – more square
      return baseRatio * 1.6;
    } else {
      // Desktop or large tablet
      return baseRatio * 2.2;
    }
  }
}
