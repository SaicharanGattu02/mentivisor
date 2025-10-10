import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:mentivisor/Components/CustomAppButton.dart';
import 'package:mentivisor/Components/CustomSnackBar.dart';
import 'package:mentivisor/Mentee/data/cubits/AddResource/add_resource_cubit.dart';
import 'package:mentivisor/Mentee/data/cubits/AddResource/add_resource_states.dart';
import 'package:mentivisor/Mentee/data/cubits/StudyZoneCampus/StudyZoneCampusCubit.dart';
import 'package:mentivisor/Mentee/data/cubits/StudyZoneCampus/StudyZoneCampusState.dart';
import 'package:mentivisor/Mentee/data/cubits/Tags/tags_cubit.dart';
import 'package:mentivisor/Mentee/data/cubits/Tags/tags_states.dart';
import 'package:mentivisor/services/AuthService.dart';
import 'package:mentivisor/utils/AppLogger.dart';
import 'package:mentivisor/utils/media_query_helper.dart';
import '../../../Components/CommonLoader.dart';
import '../../../utils/color_constants.dart';
import '../../../utils/spinkittsLoader.dart';

import '../Widgets/FilterButton.dart';

class MenteeStudyZone extends StatefulWidget {
  const MenteeStudyZone({Key? key}) : super(key: key);

  @override
  _MenteeStudyZoneState createState() => _MenteeStudyZoneState();
}

class _MenteeStudyZoneState extends State<MenteeStudyZone> {
  final ValueNotifier<bool> onCampusNotifier = ValueNotifier<bool>(true);
  final ValueNotifier<int> _selectedTagIndex = ValueNotifier<int>(-1);

  final ValueNotifier<bool> _fabVisible = ValueNotifier<bool>(true);

  String? selectedTag;

  Timer? _debounce;

  @override
  void initState() {
    super.initState();
    context.read<TagsCubit>().getStudyZoneTags();
    context.read<StudyZoneCampusCubit>().fetchStudyZoneCampus("", "", "");
  }

  @override
  void dispose() {
    _debounce?.cancel();
    _selectedTagIndex.dispose();
    searchController.dispose();
    _fabVisible.dispose();
    super.dispose();
  }

  String searchQuery = '';
  final TextEditingController searchController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: AuthService.isGuest,
      builder: (context, snapshot) {
        final isGuest = snapshot.data ?? false;
        return Scaffold(
          resizeToAvoidBottomInset: true,
          body: Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFFF7F8FC), Color(0xFFEFF4FF)],
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
              ),
            ),
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            child: SafeArea(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Study Zone',
                    style: TextStyle(
                      fontWeight: FontWeight.w700,
                      height: 1,
                      fontSize: 20,
                      color: Color(0xFF121212),
                    ),
                  ),
                  const SizedBox(height: 4),
                  const Text(
                    'Download and share your study resources',
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 14,
                      color: Color(0xFF666666),
                    ),
                  ),

                  if (!isGuest) ...[
                    Column(
                      children: [
                        SizedBox(height: 24),
                        Container(
                          padding: const EdgeInsets.all(4),
                          decoration: BoxDecoration(
                            color: const Color(0xFFE8EBF7),
                            borderRadius: BorderRadius.circular(30),
                          ),
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
                                        searchController.clear();
                                        onCampusNotifier.value = true;

                                        final tagsState = context
                                            .read<TagsCubit>()
                                            .state;
                                        String tag = "";
                                        if (tagsState is TagsLoaded &&
                                            _selectedTagIndex.value >= 0 &&
                                            _selectedTagIndex.value <
                                                (tagsState
                                                        .tagsModel
                                                        .data
                                                        ?.length ??
                                                    0)) {
                                          tag = tagsState
                                              .tagsModel
                                              .data![_selectedTagIndex.value];
                                        }

                                        context
                                            .read<StudyZoneCampusCubit>()
                                            .fetchStudyZoneCampus(
                                              "",
                                              tag,
                                              searchController.text,
                                            );
                                      },
                                    ),
                                  ),
                                  Expanded(
                                    child: FilterButton(
                                      text: 'Beyond Campus',
                                      isSelected: !isOnCampus,
                                      onPressed: () {
                                        searchController.clear();
                                        onCampusNotifier.value = false;

                                        final tagsState = context
                                            .read<TagsCubit>()
                                            .state;
                                        String tag = "";
                                        if (tagsState is TagsLoaded &&
                                            _selectedTagIndex.value >= 0 &&
                                            _selectedTagIndex.value <
                                                (tagsState
                                                        .tagsModel
                                                        .data
                                                        ?.length ??
                                                    0)) {
                                          tag = tagsState
                                              .tagsModel
                                              .data![_selectedTagIndex.value];
                                        }

                                        context
                                            .read<StudyZoneCampusCubit>()
                                            .fetchStudyZoneCampus(
                                              "beyond",
                                              tag,
                                              searchController.text,
                                            );
                                      },
                                    ),
                                  ),
                                ],
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  ] else ...[
                    SizedBox.shrink(),
                  ],

                  const SizedBox(height: 12),
                  SizedBox(
                    height: 48,
                    child: TextField(
                      controller: searchController,
                      cursorColor: primarycolor,
                      onChanged: (query) {
                        if (_debounce?.isActive ?? false) _debounce!.cancel();
                        _debounce = Timer(
                          const Duration(milliseconds: 300),
                          () {
                            final tagsState = context.read<TagsCubit>().state;
                            String selectedTag = "";

                            if (tagsState is TagsLoaded &&
                                _selectedTagIndex.value >= 0 &&
                                _selectedTagIndex.value <
                                    (tagsState.tagsModel.data?.length ?? 0)) {
                              selectedTag = tagsState
                                  .tagsModel
                                  .data![_selectedTagIndex.value];
                            }

                            if (onCampusNotifier.value) {
                              context
                                  .read<StudyZoneCampusCubit>()
                                  .fetchStudyZoneCampus("", selectedTag, query);
                            } else {
                              context
                                  .read<StudyZoneCampusCubit>()
                                  .fetchStudyZoneCampus(
                                    "beyond",
                                    selectedTag,
                                    query,
                                  );
                            }
                          },
                        );
                      },
                      style: TextStyle(fontFamily: "segeo", fontSize: 15),
                      decoration: InputDecoration(
                        hoverColor: Colors.white,
                        hintText: 'Search for any thing',
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
                  const SizedBox(height: 12),
                  BlocBuilder<TagsCubit, TagsState>(
                    builder: (context, state) {
                      if (state is TagsFailure) {
                        return Center(child: Text(state.error));
                      } else if (state is TagsLoaded) {
                        final tags = state.tagsModel.data;
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
                                          context
                                              .read<StudyZoneCampusCubit>()
                                              .fetchStudyZoneCampus(
                                                "",
                                                "",
                                                searchController.text,
                                              );
                                        } else {
                                          context
                                              .read<StudyZoneCampusCubit>()
                                              .fetchStudyZoneCampus(
                                                "beyond",
                                                "",
                                                searchController.text,
                                              );
                                        }
                                      } else {
                                        _selectedTagIndex.value = index;

                                        if (onCampusNotifier.value) {
                                          context
                                              .read<StudyZoneCampusCubit>()
                                              .fetchStudyZoneCampus(
                                                "",
                                                tagItem,
                                                searchController.text,
                                              );
                                        } else {
                                          context
                                              .read<StudyZoneCampusCubit>()
                                              .fetchStudyZoneCampus(
                                                "beyond",
                                                tagItem,
                                                searchController.text,
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
                                        tagItem,
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
                      return SizedBox.shrink();
                    },
                  ),

                  const SizedBox(height: 12),
                  Expanded(
                    child: BlocBuilder<StudyZoneCampusCubit, StudyZoneCampusState>(
                      builder: (context, state) {
                        if (state is StudyZoneCampusLoading) {
                          return Center(
                            child: SizedBox(
                              height: SizeConfig.screenWidth * 1,
                              child: DottedProgressWithLogo(),
                            ),
                          );
                        } else if (state is StudyZoneCampusFailure) {
                          return Center(child: Text(state.message));
                        } else if (state is StudyZoneCampusLoaded ||
                            state is StudyZoneCampusLoadingMore) {
                          final studyZoneCampusModel =
                              (state is StudyZoneCampusLoaded)
                              ? (state as StudyZoneCampusLoaded)
                                    .studyZoneCampusModel
                              : (state as StudyZoneCampusLoadingMore)
                                    .studyZoneCampusModel;
                          final studyZoneData =
                              studyZoneCampusModel.studyZoneData;
                          if ((studyZoneData?.studyZoneCampusData?.length ??
                                  0) ==
                              0) {
                            return Center(
                              child: SingleChildScrollView(
                                physics: const AlwaysScrollableScrollPhysics(),
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    SizedBox(
                                      height: 200,
                                      width: 200,
                                      child: Image.asset(
                                        "assets/nodata/no_data.png",
                                      ),
                                    ),
                                    const SizedBox(height: 10),
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
                          return NotificationListener<ScrollNotification>(
                            onNotification: (scrollInfo) {
                              if (scrollInfo.metrics.pixels >=
                                  scrollInfo.metrics.maxScrollExtent * 0.9) {
                                if (state is StudyZoneCampusLoaded &&
                                    state.hasNextPage) {
                                  context
                                      .read<StudyZoneCampusCubit>()
                                      .fetchMoreStudyZoneCampus("", "", "");
                                }
                              }
                              return false;
                            },
                            child: NotificationListener<UserScrollNotification>(
                              onNotification: (notification) {
                                // Hide when scrolling down, show when scrolling up
                                if (notification.direction ==
                                        ScrollDirection.reverse &&
                                    _fabVisible.value) {
                                  _fabVisible.value = false;
                                } else if (notification.direction ==
                                        ScrollDirection.forward &&
                                    !_fabVisible.value) {
                                  _fabVisible.value = true;
                                }
                                return false; // let the notification continue to bubble
                              },
                              child: CustomScrollView(
                                slivers: [
                                  SliverList(
                                    delegate: SliverChildBuilderDelegate(
                                      (context, index) {
                                        final campusList = studyZoneData
                                            ?.studyZoneCampusData![index];
                                        return InkWell(
                                          onTap: () {
                                            if (isGuest) {
                                              context.push('/auth_landing');
                                            } else {
                                              AppLogger.info(
                                                "Scopes=${onCampusNotifier.value}",
                                              );
                                              context.push(
                                                '/resource_details_screen/${campusList?.id}?scope=${onCampusNotifier.value ? "" : "beyond"}',
                                              );
                                            }
                                          },
                                          child: Container(
                                            margin: const EdgeInsets.only(
                                              bottom: 16,
                                            ),
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(24),
                                            ),
                                            child: Row(
                                              spacing: 10,
                                              children: [
                                                ClipRRect(
                                                  borderRadius:
                                                      BorderRadiusGeometry.circular(
                                                        8,
                                                      ),
                                                  child: CachedNetworkImage(
                                                    width:
                                                        SizeConfig.screenWidth *
                                                        0.3,
                                                    height: 144,
                                                    imageUrl:
                                                        campusList?.image ?? "",
                                                    fit: BoxFit.cover,
                                                    placeholder:
                                                        (
                                                          context,
                                                          url,
                                                        ) => SizedBox(
                                                          width: 120,
                                                          height: 120,
                                                          child: Center(
                                                            child: spinkits
                                                                .getSpinningLinespinkit(),
                                                          ),
                                                        ),
                                                    errorWidget:
                                                        (
                                                          context,
                                                          url,
                                                          error,
                                                        ) => Container(
                                                          width: 120,
                                                          height: 120,
                                                          color: Color(
                                                            0xffF8FAFE,
                                                          ),
                                                          child: Icon(
                                                            Icons.broken_image,
                                                            size: 40,
                                                            color: Colors.grey,
                                                          ),
                                                        ),
                                                  ),
                                                ),
                                                // Right Content
                                                Expanded(
                                                  child: Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                          top: 10.0,
                                                          bottom: 10,
                                                          left: 5,
                                                        ),
                                                    child: Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        Text(
                                                          campusList?.name ??
                                                              "",
                                                          style: TextStyle(
                                                            fontFamily: 'segeo',
                                                            fontWeight:
                                                                FontWeight.w700,
                                                            fontSize: 12,
                                                            height: 1,
                                                            letterSpacing: 0.5,
                                                          ),
                                                        ),
                                                        const SizedBox(
                                                          height: 8,
                                                        ),
                                                        Text(
                                                          campusList
                                                                  ?.description ??
                                                              "",
                                                          maxLines: 3,
                                                          overflow: TextOverflow
                                                              .ellipsis,
                                                          style: TextStyle(
                                                            fontFamily: 'segeo',
                                                            fontWeight:
                                                                FontWeight.w400,
                                                            fontSize: 11,
                                                            height: 1,
                                                          ),
                                                        ),
                                                        const SizedBox(
                                                          height: 12,
                                                        ),
                                                        if ((campusList
                                                                ?.tag
                                                                ?.isNotEmpty ??
                                                            false))
                                                          Wrap(
                                                            spacing: 8,
                                                            runSpacing: 8,
                                                            children: campusList!.tag!.map((
                                                              tag,
                                                            ) {
                                                              return Container(
                                                                padding:
                                                                    const EdgeInsets.symmetric(
                                                                      horizontal:
                                                                          12,
                                                                      vertical:
                                                                          6,
                                                                    ),
                                                                decoration: BoxDecoration(
                                                                  color: Colors
                                                                      .white,
                                                                  borderRadius:
                                                                      BorderRadius.circular(
                                                                        20,
                                                                      ),
                                                                ),
                                                                child: Text(
                                                                  tag,
                                                                  style: const TextStyle(
                                                                    fontFamily:
                                                                        'segeo',
                                                                    fontSize:
                                                                        12,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w600,
                                                                  ),
                                                                ),
                                                              );
                                                            }).toList(),
                                                          ),
                                                        SizedBox(height: 16),
                                                        Row(
                                                          spacing: 4,
                                                          children: [
                                                            Expanded(
                                                              child: CustomOutlinedButton(
                                                                radius: 24,
                                                                height: 38,
                                                                text: "View",
                                                                onTap: () {
                                                                  if (isGuest) {
                                                                    context.push(
                                                                      '/auth_landing',
                                                                    );
                                                                  } else {
                                                                    context.push(
                                                                      "/pdf_viewer?file_url=${campusList?.filePdf}",
                                                                    );
                                                                  }
                                                                },
                                                              ),
                                                            ),
                                                            BlocConsumer<
                                                              AddResourceCubit,
                                                              AddResourceStates
                                                            >(
                                                              listener: (context, state) {
                                                                if (state
                                                                    is AddResourceLoaded) {
                                                                  CustomSnackBar1.show(
                                                                    context,
                                                                    "Downloaded Successfully",
                                                                  );
                                                                } else if (state
                                                                    is AddResourceFailure) {
                                                                  CustomSnackBar1.show(
                                                                    context,
                                                                    state
                                                                            .error
                                                                            .isNotEmpty
                                                                        ? state
                                                                              .error
                                                                        : "Download Failed",
                                                                  );
                                                                }
                                                              },
                                                              builder: (context, state) {
                                                                final currentId =
                                                                    campusList
                                                                        ?.id
                                                                        .toString() ??
                                                                    "";
                                                                final isLoading =
                                                                    state
                                                                        is AddResourceLoading &&
                                                                    state.resourceId ==
                                                                        currentId;

                                                                return Expanded(
                                                                  child: CustomAppButton1(
                                                                    radius: 24,
                                                                    height: 38,
                                                                    isLoading:
                                                                        isLoading,
                                                                    text:
                                                                        "Download",
                                                                    textSize:
                                                                        14,
                                                                    onPlusTap: () {
                                                                      if (isGuest) {
                                                                        context.push(
                                                                          '/auth_landing',
                                                                        );
                                                                      } else {
                                                                        context
                                                                            .read<
                                                                              AddResourceCubit
                                                                            >()
                                                                            .resourceDownload(
                                                                              currentId,
                                                                            );
                                                                      }
                                                                    },
                                                                  ),
                                                                );
                                                              },
                                                            ),
                                                          ],
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        );
                                      },
                                      childCount: studyZoneData
                                          ?.studyZoneCampusData
                                          ?.length,
                                    ),
                                  ),
                                  if (state is StudyZoneCampusLoadingMore)
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
                          return SizedBox.shrink();
                        }
                      },
                    ),
                  ),
                ],
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
                        offset: visible ? Offset.zero : const Offset(0, 1.2),
                        curve: Curves.easeOut,
                        child: AnimatedOpacity(
                          duration: const Duration(milliseconds: 180),
                          opacity: visible ? 1 : 0,
                          child: FloatingActionButton(
                            onPressed: () {
                              if (isGuest) {
                                context.push('/auth_landing');
                              } else {
                                context.push("/add_resource");
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
      },
    );
  }
}
