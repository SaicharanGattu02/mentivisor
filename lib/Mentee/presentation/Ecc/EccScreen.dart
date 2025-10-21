import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:mentivisor/Mentee/data/cubits/ECC/ecc_cubit.dart';
import 'package:mentivisor/Mentee/data/cubits/ECC/ecc_states.dart';
import 'package:mentivisor/utils/color_constants.dart';
import 'package:mentivisor/utils/constants.dart';
import 'package:mentivisor/utils/media_query_helper.dart';
import '../../../Components/CommonLoader.dart';
import '../../../Components/Shimmers.dart';
import '../../../services/AuthService.dart';
import '../../data/cubits/EccTags/tags_cubit.dart';
import '../../data/cubits/EccTags/tags_states.dart';
import '../Widgets/CommonChoiceChip.dart';
import '../Widgets/EventCard.dart';
import '../Widgets/FilterButton.dart';

class EccScreen extends StatefulWidget {
  const EccScreen({Key? key}) : super(key: key);

  @override
  _EccScreenState createState() => _EccScreenState();
}

class _EccScreenState extends State<EccScreen> {
  final TextEditingController _searchController = TextEditingController();
  final ValueNotifier<bool> onCampusNotifier = ValueNotifier<bool>(true);
  final ValueNotifier<bool> _fabVisible = ValueNotifier<bool>(true); // NEW
  String selectedFilter = 'On Campuses';
  final ValueNotifier<int> _selectedTagIndex = ValueNotifier<int>(-1);

  Timer? _debounce;

  @override
  void initState() {
    super.initState();
    context.read<EccTagsCubit>().getEccTags();
    context.read<ECCCubit>().getECC("", "", "");
  }

  @override
  void dispose() {
    super.dispose();
    _searchController.dispose();
    _fabVisible.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFFFAF5FF), Color(0xFFF5F6FF), Color(0xFFEFF6FF)],
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Event, Competitions & Challenges',
                  style: TextStyle(
                    fontFamily: 'segeo',
                    fontWeight: FontWeight.w700,
                    height: 1,
                    fontSize: 18,
                    color: Color(0xFF121212),
                  ),
                ),
                const SizedBox(height: 4),
                const Text(
                  'Participate and Showcase Your Talents',
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
                          Container(
                            decoration: BoxDecoration(
                              color: const Color(0xFFE8EBF7),
                              borderRadius: BorderRadius.circular(30),
                            ),
                            padding: const EdgeInsets.all(4),
                            child: ValueListenableBuilder<bool>(
                              valueListenable: onCampusNotifier,
                              builder: (context, isOnCampus, _) {
                                return Row(
                                  children: [
                                    Expanded(
                                      child: FilterButton(
                                        text: 'On Campus',
                                        isSelected: isOnCampus,
                                        onPressed: () {
                                          _searchController.clear();
                                          final tagsState = context
                                              .read<EccTagsCubit>()
                                              .state;
                                          String selectedUpdate = "";
                                          if (tagsState is EccTagsLoaded &&
                                              _selectedTagIndex.value >= 0 &&
                                              _selectedTagIndex.value <
                                                  (tagsState
                                                          .tagsModel
                                                          .data
                                                          ?.length ??
                                                      0)) {
                                            selectedUpdate = tagsState
                                                .tagsModel
                                                .data![_selectedTagIndex.value];
                                          }

                                          context.read<ECCCubit>().getECC(
                                            "",
                                            selectedUpdate,
                                            _searchController.text,
                                          );
                                          onCampusNotifier.value =
                                              true; // update state
                                        },
                                      ),
                                    ),
                                    Expanded(
                                      child: FilterButton(
                                        text: 'Beyond Campus',
                                        isSelected: !isOnCampus,
                                        onPressed: () {
                                          _searchController.clear();
                                          final tagsState = context
                                              .read<EccTagsCubit>()
                                              .state;
                                          String selectedUpdate = "";
                                          if (tagsState is EccTagsLoaded &&
                                              _selectedTagIndex.value >= 0 &&
                                              _selectedTagIndex.value <
                                                  (tagsState
                                                          .tagsModel
                                                          .data
                                                          ?.length ??
                                                      0)) {
                                            selectedUpdate = tagsState
                                                .tagsModel
                                                .data![_selectedTagIndex.value];
                                          }
                                          context.read<ECCCubit>().getECC(
                                            "beyond",
                                            selectedUpdate,
                                            _searchController.text,
                                          );
                                          onCampusNotifier.value =
                                              false; // update state
                                        },
                                      ),
                                    ),
                                  ],
                                );
                              },
                            ),
                          ),
                        ],
                      );
                    } else {
                      return SizedBox.shrink();
                    }
                  },
                ),

                // const SizedBox(height: 20),
                // const Text(
                //   'Updates',
                //   style: TextStyle(
                //     fontFamily: 'segeo',
                //     fontWeight: FontWeight.w700,
                //     fontSize: 16,
                //     color: Colors.black,
                //   ),
                // ),
                SizedBox(height: 16),
                SizedBox(
                  height: 48,
                  child: TextField(
                    controller: _searchController,
                    cursorColor: primarycolor,
                    onChanged: (query) {
                      // Cancel any active debounce
                      if (_debounce?.isActive ?? false) _debounce!.cancel();

                      _debounce = Timer(const Duration(milliseconds: 300), () {
                        final tagsState = context.read<EccTagsCubit>().state;
                        String selectedTag = "";

                        // 🔹 Get currently selected tag
                        if (tagsState is EccTagsLoaded &&
                            _selectedTagIndex.value >= 0 &&
                            _selectedTagIndex.value <
                                (tagsState.tagsModel.data?.length ?? 0)) {
                          selectedTag = tagsState
                              .tagsModel
                              .data![_selectedTagIndex.value];
                        }

                        // 🔹 CASE 1: When search query is empty → fetch initial data
                        if (query.trim().isEmpty) {
                          if (onCampusNotifier.value) {
                            context.read<ECCCubit>().getECC(
                              "",
                              selectedTag,
                              "",
                            );
                          } else {
                            context.read<ECCCubit>().getECC(
                              "beyond",
                              selectedTag,
                              "",
                            );
                          }
                          return;
                        }

                        // 🔹 CASE 2: When user types something → perform filtered search
                        if (onCampusNotifier.value) {
                          context.read<ECCCubit>().getECC(
                            "",
                            selectedTag,
                            query,
                          );
                        } else {
                          context.read<ECCCubit>().getECC(
                            "beyond",
                            selectedTag,
                            query,
                          );
                        }
                      });
                    },
                    style: const TextStyle(fontFamily: "Poppins", fontSize: 15),
                    decoration: InputDecoration(
                      hoverColor: Colors.white,
                      hintText: 'Search by name or location',
                      hintStyle: const TextStyle(color: Colors.grey),
                      prefixIcon: const Icon(
                        Icons.search,
                        color: Color(0xff666666),
                      ),
                      fillColor: Colors.white,
                      filled: true,
                      contentPadding: const EdgeInsets.only(
                        right: 33,
                        left: 20,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 12),
                BlocBuilder<EccTagsCubit, EccTagsState>(
                  builder: (context, state) {
                    if (state is EccTagsFailure) {
                      return Center(child: Text(state.error));
                    } else if (state is EccTagsLoaded) {
                      final tags = state.tagsModel.data;
                      if (_selectedTagIndex.value == -1 &&
                          tags != null &&
                          tags.isNotEmpty) {
                        final allIndex = tags.indexWhere(
                          (tag) => tag.toLowerCase() == "all",
                        );
                        if (allIndex != -1) {
                          _selectedTagIndex.value = allIndex;
                        }
                      }
                      return SizedBox(
                        height: 30,
                        child: ValueListenableBuilder<int>(
                          valueListenable: _selectedTagIndex,
                          builder: (context, selectedIndex, _) {
                            if (tags == null || tags.isEmpty) {
                              return Container(
                                height: 40,
                                alignment: Alignment.center,
                                child: Text(
                                  "No tags available",
                                  style: TextStyle(
                                    color: Colors.grey,
                                    fontSize: 14,
                                    fontFamily: 'segeo',
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              );
                            }
                            return ListView.separated(
                              scrollDirection: Axis.horizontal,
                              physics: const BouncingScrollPhysics(),
                              padding: const EdgeInsets.symmetric(
                                horizontal: 16,
                              ),
                              itemCount: tags.length,
                              separatorBuilder: (_, __) =>
                                  const SizedBox(width: 8),
                              itemBuilder: (context, index) {
                                final tagItem = tags[index];
                                final isSelected = index == selectedIndex;
                                return GestureDetector(
                                  onTap: () {
                                    if (isSelected) {
                                      _selectedTagIndex.value = -1;
                                      if (onCampusNotifier.value) {
                                        context.read<ECCCubit>().getECC(
                                          "",
                                          "",
                                          _searchController.text,
                                        );
                                      } else {
                                        context.read<ECCCubit>().getECC(
                                          "beyond",
                                          "",
                                          _searchController.text,
                                        );
                                      }
                                    } else {
                                      _selectedTagIndex.value = index;

                                      // Check if tagItem is "All", then use an empty string instead
                                      final selectedTag =
                                          (tagItem.toLowerCase() == "all")
                                          ? ""
                                          : tagItem;

                                      if (onCampusNotifier.value) {
                                        context.read<ECCCubit>().getECC(
                                          "",
                                          selectedTag,
                                          _searchController.text,
                                        );
                                      } else {
                                        context.read<ECCCubit>().getECC(
                                          "beyond",
                                          selectedTag,
                                          _searchController.text,
                                        );
                                      }
                                    }
                                  },
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 16,
                                      vertical: 4,
                                    ),
                                    decoration: BoxDecoration(
                                      color: isSelected
                                          ? const Color(0xffD4E0FB)
                                          : const Color(0xffffffff),
                                      borderRadius: BorderRadius.circular(24),
                                    ),
                                    child: Text(
                                      capitalize(tagItem),
                                      style: TextStyle(
                                        fontWeight: FontWeight.w500,
                                        fontSize: 12,
                                        color: isSelected
                                            ? const Color(0xFF2563EB)
                                            : const Color(0xFF555555),
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
                    return const SizedBox.shrink();
                  },
                ),
                const SizedBox(height: 24),
                BlocBuilder<ECCCubit, ECCStates>(
                  builder: (context, state) {
                    if (state is ECCLoading) {
                      return Expanded(child: ECCShimmer());
                    } else if (state is ECCLoaded || state is ECCLoadingMore) {
                      final ecc_model = (state is ECCLoaded)
                          ? (state as ECCLoaded).eccModel
                          : (state as ECCLoadingMore).eccModel;
                      final ecclist = ecc_model.data?.ecclist;

                      if (ecclist == null || ecclist.isEmpty) {
                        return Expanded(
                          child: Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                SizedBox(
                                  height: 200,
                                  width: 200,
                                  child: Center(
                                    child: Image.asset(
                                      "assets/nodata/no_data.png",
                                    ),
                                  ),
                                ),
                                Text(
                                  'No Data Found!',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    color: primarycolor,
                                    fontSize: 18,
                                    fontWeight: FontWeight.w400,
                                    fontFamily: 'Poppins',
                                  ),
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
                              if (state is ECCLoaded && state.hasNextPage) {
                                final tagsState = context
                                    .read<EccTagsCubit>()
                                    .state;
                                String selectedTag = "";

                                if (tagsState is EccTagsLoaded &&
                                    _selectedTagIndex.value >= 0 &&
                                    _selectedTagIndex.value <
                                        (tagsState.tagsModel.data?.length ??
                                            0)) {
                                  selectedTag = tagsState
                                      .tagsModel
                                      .data![_selectedTagIndex.value];
                                }
                                if (onCampusNotifier.value == true) {
                                  context.read<ECCCubit>().fetchMoreECC(
                                    "",
                                    selectedTag,
                                    "",
                                  );
                                } else {
                                  context.read<ECCCubit>().fetchMoreECC(
                                    "beyond",
                                    selectedTag,
                                    "",
                                  );
                                }
                              }
                            }
                            return false;
                          },
                          child: NotificationListener<UserScrollNotification>(
                            onNotification: (n) {
                              if (n.direction == ScrollDirection.reverse &&
                                  _fabVisible.value) {
                                _fabVisible.value = false;
                              } else if (n.direction ==
                                      ScrollDirection.forward &&
                                  !_fabVisible.value) {
                                _fabVisible.value = true;
                              } else if (n.direction == ScrollDirection.idle) {
                                if (n.metrics.pixels <= 8 &&
                                    !_fabVisible.value) {
                                  _fabVisible.value = true;
                                }
                              }
                              return false;
                            },
                            child: CustomScrollView(
                              slivers: [
                                SliverPadding(
                                  padding: const EdgeInsets.all(8.0),
                                  sliver: SliverGrid(
                                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                                      crossAxisCount: MediaQuery.of(context).size.width < 600 ? 1 : 2, // 👈 Responsive layout
                                      crossAxisSpacing: 16,
                                      mainAxisSpacing: 16,
                                      childAspectRatio: _getChildAspectRatio(context), // 👈 Maintains proportion
                                    ),
                                    delegate: SliverChildBuilderDelegate(
                                          (context, index) {
                                        return EventCard(
                                          eccList: ecclist[index],
                                          scope: onCampusNotifier.value ? "" : "beyond",
                                        );
                                      },
                                      childCount: ecclist.length,
                                    ),
                                  ),
                                ),

                                if (state is ECCLoadingMore)
                                  const SliverToBoxAdapter(
                                    child: Padding(
                                      padding: EdgeInsets.all(25.0),
                                      child: Center(
                                        child: CircularProgressIndicator(
                                          strokeWidth: 0.8,
                                          color: Colors.blue,
                                        ),
                                      ),
                                    ),
                                  ),
                              ],
                            )
                          ),
                        ),
                      );
                    } else {
                      return Expanded(child: Center(child: Text("No Data")));
                    }
                  },
                ),
              ],
            ),
          ),
        ),
      ),
      floatingActionButton: ValueListenableBuilder<bool>(
        valueListenable: onCampusNotifier,
        builder: (context, isOnCampus, _) {
          if (!isOnCampus) return const SizedBox.shrink();
          return FutureBuilder(
            future: AuthService.isGuest,
            builder: (context, snapshot) {
              final isGuest = snapshot.data ?? false;
              return ValueListenableBuilder<bool>(
                valueListenable: _fabVisible,
                builder: (context, visible, __) {
                  return AnimatedSlide(
                    duration: const Duration(milliseconds: 180),
                    curve: Curves.easeOut,
                    offset: visible ? Offset.zero : const Offset(0, 1.2),
                    child: AnimatedOpacity(
                      duration: const Duration(milliseconds: 180),
                      opacity: visible ? 1 : 0,
                      child: FloatingActionButton(
                        onPressed: () {
                          if (isGuest) {
                            context.push('/auth_landing');
                          } else {
                            final tagsState = context
                                .read<EccTagsCubit>()
                                .state;
                            String selectedTag = "";

                            if (tagsState is EccTagsLoaded &&
                                _selectedTagIndex.value >= 0 &&
                                _selectedTagIndex.value <
                                    (tagsState.tagsModel.data?.length ?? 0)) {
                              selectedTag = tagsState
                                  .tagsModel
                                  .data![_selectedTagIndex.value];
                            }

                            context.push("/addeventscreen?type=$selectedTag");
                          }
                        },
                        backgroundColor: Colors.transparent,
                        child: Container(
                          width: 56,
                          height: 56,
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                            gradient: LinearGradient(
                              colors: [
                                Color(0xFF9B40EF), // #9B40EF at 0%
                                Color(0xFF5B4BEB), // #5B4BEB at 50%
                                Color(0xFF315DEA),
                              ],
                              begin: Alignment.centerLeft,
                              end: Alignment.centerRight,
                            ),
                          ),
                          child: const Icon(
                            Icons.add,
                            size: 32,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}

double _getChildAspectRatio(BuildContext context) {
  final size = MediaQuery.of(context).size;
  final width = size.width;
  final height = size.height;

  // You can tweak this formula to your layout preference
  // This keeps the card roughly proportional to screen width
  double baseRatio = width / height;

  // Adjust a bit to avoid overly tall/narrow cards
  if (width < 600) {
    // Mobile – single column
    return baseRatio * 2.1; // taller cards
  } else if (width > 600) {
    // Tablet – 2 columns
    return baseRatio * 1.4;
  } else {
    // Desktop – 3+ columns maybe
    return baseRatio * 2.2;
  }
}


class ECCShimmer extends StatefulWidget {
  const ECCShimmer({super.key});
  @override
  State<ECCShimmer> createState() => _ECCShimmerState();
}

class _ECCShimmerState extends State<ECCShimmer> {
  @override
  Widget build(BuildContext context) {
    final width = SizeConfig.screenWidth;
    final crossAxisCount = width < 600 ? 1 : 2;

    return GridView.builder(
      shrinkWrap: true,
      physics: const AlwaysScrollableScrollPhysics(),
      itemCount: 6,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: crossAxisCount,
        crossAxisSpacing: 12,
        mainAxisSpacing: 16,
        childAspectRatio: () {
          final screenHeight = MediaQuery.of(context).size.height;
          final size = MediaQuery.of(context).size;
          final screenWidth = size.width;
          double aspectRatio = screenWidth / (screenHeight * 0.5);
          if (screenWidth < 600) {
            aspectRatio = screenWidth / (screenHeight * 0.42);
          } else if (screenWidth > 600) {
            aspectRatio = screenWidth / (screenHeight * 0.6);
          } else {
            aspectRatio = screenWidth / (screenHeight * 0.6);
          }
          return aspectRatio;
        }(),
      ),
      itemBuilder: (context, index) {
        return Container(
          margin: EdgeInsets.symmetric(horizontal: 0),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Stack(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: 16.0,
                      vertical: 10,
                    ),
                    child: SizedBox(
                      width: double.infinity,
                      child: shimmerContainer(
                        SizeConfig.screenWidth,
                        160,
                        context,
                      ),
                    ),
                  ),

                  // Title
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16),
                    child: shimmerText(110, 12, context),
                  ),
                  const SizedBox(height: 10),

                  // Details
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        shimmerText(60, 12, context),
                        const SizedBox(height: 8),
                        shimmerText(SizeConfig.screenWidth, 12, context),
                        const SizedBox(height: 8),
                        shimmerText(60, 12, context),
                      ],
                    ),
                  ),
                  SizedBox(height: 15),
                  Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: 16.0,
                      vertical: 10,
                    ),
                    child: shimmerContainer(
                      SizeConfig.screenWidth,
                      40,
                      context,
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}
