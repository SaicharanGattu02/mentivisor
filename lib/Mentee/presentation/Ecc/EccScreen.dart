import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:mentivisor/Mentee/data/cubits/ECC/ecc_cubit.dart';
import 'package:mentivisor/Mentee/data/cubits/ECC/ecc_states.dart';
import 'package:mentivisor/utils/color_constants.dart';
import 'package:mentivisor/utils/media_query_helper.dart';
import '../../../Components/CommonLoader.dart';
import '../../../services/AuthService.dart';
import '../Widgets/CommonChoiceChip.dart';
import '../Widgets/EventCard.dart';
import '../Widgets/FilterButton.dart';

class EccScreen extends StatefulWidget {
  const EccScreen({Key? key}) : super(key: key);

  @override
  _EccScreenState createState() => _EccScreenState();
}

class _EccScreenState extends State<EccScreen> {
  String searchQuery = '';
  final TextEditingController _searchController = TextEditingController();
  final ValueNotifier<bool> onCampusNotifier = ValueNotifier<bool>(true);
  final ValueNotifier<bool> _fabVisible = ValueNotifier<bool>(true); // NEW

  int _selectedFilter = 0;
  String selectedFilter = 'On Campuses';
  final List<String> _filters = ['All', 'Upcoming', 'Highlighted'];
  Timer? _debounce;
  @override
  void initState() {
    super.initState();
    context.read<ECCCubit>().getECC("", "", "");
  }

  @override
  void dispose() {
    super.dispose();
    _searchController.dispose();
    _fabVisible.dispose(); // NEW
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
                                          final selectedUpdate =
                                              _filters[_selectedFilter]
                                                  .toLowerCase();
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
                                          final selectedUpdate =
                                              _filters[_selectedFilter]
                                                  .toLowerCase();
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
                const SizedBox(height: 20),
                const Text(
                  'Updates',
                  style: TextStyle(
                    fontFamily: 'segeo',
                    fontWeight: FontWeight.w700,
                    fontSize: 16,
                    color: Colors.black,
                  ),
                ),

                const SizedBox(height: 12),
                SizedBox(
                  height: 32,
                  child: ListView.separated(
                    scrollDirection: Axis.horizontal,
                    itemCount: _filters.length,
                    separatorBuilder: (_, __) => SizedBox(width: 8),
                    itemBuilder: (context, i) {
                      final selected = i == _selectedFilter;
                      return CustomChoiceChip(
                        label: _filters[i],
                        selected: selected,
                        onSelected: (_) {
                          setState(() => _selectedFilter = i);
                          if (onCampusNotifier.value == true) {
                            context.read<ECCCubit>().getECC(
                              "",
                              _filters[i].toLowerCase(),
                              "",
                            );
                          } else {
                            context.read<ECCCubit>().getECC(
                              "beyond",
                              _filters[i].toLowerCase(),
                              "",
                            );
                          }
                        },
                      );
                    },
                  ),
                ),
                SizedBox(height: 16),
                SizedBox(
                  height: 48,
                  child: TextField(
                    controller: _searchController,
                    cursorColor: primarycolor,
                    onChanged: (query) {
                      if (_debounce?.isActive ?? false) _debounce!.cancel();
                      _debounce = Timer(const Duration(milliseconds: 300), () {
                        final selectedUpdate = _filters[_selectedFilter]
                            .toLowerCase();
                        if (onCampusNotifier.value == true) {
                          context.read<ECCCubit>().getECC(
                            "",
                            selectedUpdate,
                            query,
                          );
                        } else {
                          context.read<ECCCubit>().getECC(
                            "beyond",
                            selectedUpdate,
                            query,
                          );
                        }
                      });
                    },
                    style: TextStyle(fontFamily: "Poppins", fontSize: 15),
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
                    ),
                  ),
                ),

                const SizedBox(height: 24),
                BlocBuilder<ECCCubit, ECCStates>(
                  builder: (context, state) {
                    if (state is ECCLoading) {
                      return Center(
                        child: SizedBox(
                          height: SizeConfig.screenWidth * 1,
                          child: DottedProgressWithLogo(),
                        ),
                      );
                    } else if (state is ECCLoaded || state is ECCLoadingMore) {
                      final ecc_model = (state is ECCLoaded)
                          ? (state as ECCLoaded).eccModel
                          : (state as ECCLoadingMore).eccModel;
                      final ecclist = ecc_model.data?.ecclist;
                      if (ecclist?.length == 0) {
                        return Center(
                          child: Column(
                            spacing: 10,
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
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
                              if (state is ECCLoaded && state.hasNextPage) {
                                final selectedUpdate = _filters[_selectedFilter]
                                    .toLowerCase();
                                if (onCampusNotifier.value == true) {
                                  context.read<ECCCubit>().fetchMoreECC(
                                    "",
                                    selectedUpdate,
                                    "",
                                  );
                                } else {
                                  context.read<ECCCubit>().getECC(
                                    "beyond",
                                    selectedUpdate,
                                    "",
                                  );
                                }
                              }
                              return false;
                            }
                            return false;
                          },
                          child: NotificationListener<UserScrollNotification>(
                            onNotification: (n) {
                              // Hide FAB when scrolling down, show when scrolling up
                              if (n.direction == ScrollDirection.reverse &&
                                  _fabVisible.value) {
                                _fabVisible.value = false;
                              } else if (n.direction ==
                                      ScrollDirection.forward &&
                                  !_fabVisible.value) {
                                _fabVisible.value = true;
                              } else if (n.direction == ScrollDirection.idle) {
                                // optional: when user stops, ensure FAB is visible near top
                                if (n.metrics.pixels <= 8 &&
                                    !_fabVisible.value) {
                                  _fabVisible.value = true;
                                }
                              }
                              return false;
                            },
                            child: CustomScrollView(
                              slivers: [
                                SliverList.separated(
                                  itemCount: ecclist?.length ?? 0,
                                  separatorBuilder: (_, __) =>
                                      const SizedBox(height: 16),
                                  itemBuilder: (context, index) =>
                                      EventCard(eccList: ecclist![index]),
                                ),
                                if (state is ECCLoadingMore)
                                  SliverToBoxAdapter(
                                    child: Padding(
                                      padding: const EdgeInsets.all(25.0),
                                      child: Center(
                                        child: CircularProgressIndicator(
                                          strokeWidth: 0.8,
                                          color: Colors.blue,
                                        ),
                                      ),
                                    ),
                                  ),
                              ],
                            ),
                          ),
                        ),
                      );
                    } else {
                      return Center(child: Text("No Data"));
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
                            final selectedUpdate = _filters[_selectedFilter]
                                .toLowerCase();
                            context.push(
                              "/addeventscreen?type=$selectedUpdate",
                            );
                          }
                        },
                        backgroundColor: Colors.transparent,
                        child: Container(
                          width: 56,
                          height: 56,
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                            gradient: LinearGradient(
                              colors: [Color(0xFF975CF7), Color(0xFF7A40F2)],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
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
