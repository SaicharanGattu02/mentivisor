import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:mentivisor/Components/CustomAppButton.dart';
import 'package:mentivisor/Components/CutomAppBar.dart';
import 'package:mentivisor/Mentee/data/cubits/StudyZoneCampus/StudyZoneCampusCubit.dart';
import 'package:mentivisor/Mentee/data/cubits/StudyZoneCampus/StudyZoneCampusState.dart';
import 'package:mentivisor/utils/media_query_helper.dart';

import '../../../utils/color_constants.dart';
import '../../../utils/spinkittsLoader.dart';
import '../../data/cubits/StudyZoneTags/StudyZoneTagsCubit.dart';
import '../../data/cubits/StudyZoneTags/StudyZoneTagsState.dart';

class MenteeStudyZone extends StatefulWidget {
  const MenteeStudyZone({Key? key}) : super(key: key);

  @override
  _MenteeStudyZoneState createState() => _MenteeStudyZoneState();
}

class _MenteeStudyZoneState extends State<MenteeStudyZone> {
  bool _onCampus = true;
  final ValueNotifier<int> _selectedTagIndex = ValueNotifier<int>(-1);

  final TextEditingController _searchController = TextEditingController();
  Timer? _debounce;
  @override
  void initState() {
    super.initState();
    context.read<StudyZoneTagsCubit>().fetchStudyZoneTags();
    context.read<StudyZoneCampusCubit>().fetchStudyZoneCampus("", "");
  }

  @override
  void dispose() {
    _selectedTagIndex.dispose();
    _searchController.dispose();
    super.dispose();
  }

  String searchQuery = '';
  final TextEditingController searchController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar1(title: "Study Zone", actions: []),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Column(
            children: [
              Container(
                decoration: BoxDecoration(
                  color: const Color(0xFFE8EBF7),
                  borderRadius: BorderRadius.circular(30),
                ),
                padding: const EdgeInsets.all(4),
                child: Row(
                  mainAxisAlignment:
                      MainAxisAlignment.center, // Ensures the row is centered
                  children: [
                    _buildToggle('On Campus', _onCampus, () {
                      setState(() {
                        _onCampus = true;
                      });
                      context.read<StudyZoneCampusCubit>().fetchStudyZoneCampus(
                        "",
                        "",
                      );
                    }),
                    const SizedBox(width: 8),
                    _buildToggle('Beyond Campus', !_onCampus, () {
                      setState(() {
                        _onCampus = false;
                      });
                      context.read<StudyZoneCampusCubit>().fetchStudyZoneCampus(
                        "beyond",
                        "",
                      );
                    }),
                  ],
                ),
              ),
              const SizedBox(height: 12),
              SizedBox(
                height: 48,
                child: TextField(
                  controller: searchController,
                  cursorColor: primarycolor,
                  onChanged: (query) {
                    if (_debounce?.isActive ?? false) _debounce!.cancel();
                    _debounce = Timer(const Duration(milliseconds: 300), () {
                      context.read<StudyZoneCampusCubit>().fetchStudyZoneCampus(
                        "",
                        "",
                      );
                    });
                  },
                  style: const TextStyle(fontFamily: "Poppins", fontSize: 15),
                  decoration: InputDecoration(
                    hintText: 'Search by employee name, phone',
                    prefixIcon: const Icon(Icons.search),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(100),
                      borderSide: BorderSide(color: primarycolor, width: 0.5),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(100),
                      borderSide: BorderSide(color: primarycolor, width: 0.5),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 12),
              BlocBuilder<StudyZoneTagsCubit, StudyZoneTagsState>(
                builder: (context, state) {
                  if (state is StudyZoneTagsLoading) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (state is StudyZoneTagsFailure) {
                    return Center(child: Text(state.msg));
                  } else if (state is StudyZoneTagsLoaded) {
                    final tags = state.studyZoneTagsModel.tags;
                    return SizedBox(
                      height: 30,
                      child: ValueListenableBuilder<int>(
                        valueListenable: _selectedTagIndex,
                        builder: (context, selectedIndex, _) {
                          return ListView.separated(
                            scrollDirection: Axis.horizontal,
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            itemCount: tags?.length ?? 0,
                            separatorBuilder: (_, __) =>
                                const SizedBox(width: 8),
                            itemBuilder: (context, index) {
                              final tagItem = tags![index];
                              final isSelected = index == selectedIndex;

                              return GestureDetector(
                                onTap: () {
                                  _selectedTagIndex.value = index;
                                  context
                                      .read<StudyZoneCampusCubit>()
                                      .fetchStudyZoneCampus("", tagItem);
                                },
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 8,
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
                                      fontFamily: 'segeo',
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

              const SizedBox(height: 12),
              BlocBuilder<StudyZoneCampusCubit, StudyZoneCampusState>(
                builder: (context, state) {
                  if (state is StudyZoneCampusLoading) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (state is StudyZoneCampusFailure) {
                    return Center(child: Text(state.message));
                  } else if (state is StudyZoneCampusLoaded ||
                      state is StudyZoneCampusLoadingMore) {
                    final studyZoneCampusModel =
                        (state is StudyZoneCampusLoaded)
                        ? (state as StudyZoneCampusLoaded).studyZoneCampusModel
                        : (state as StudyZoneCampusLoadingMore)
                              .studyZoneCampusModel;
                    final studyZoneData = studyZoneCampusModel.studyZoneData;
                    return Expanded(
                      child: CustomScrollView(
                        slivers: [
                          SliverPadding(
                            padding: EdgeInsets.all(12),
                            sliver: SliverList(
                              delegate: SliverChildBuilderDelegate((
                                context,
                                index,
                              ) {
                                final campusList = studyZoneData?.studyZoneCampusData![index];
                                return GestureDetector(
                                  onTap: () {
                                    context.push(
                                      '/resource_details_screen',
                                      extra: campusList,
                                    );
                                  },
                                  child: Container(
                                    padding: EdgeInsets.only(left: 12),
                                    margin: const EdgeInsets.only(bottom: 16),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(24),
                                    ),
                                    child: Row(
                                      children: [
                                        ClipRRect(
                                          borderRadius:
                                              BorderRadiusGeometry.circular(4),
                                          child: CachedNetworkImage(
                                            width: SizeConfig.screenWidth * 0.3,
                                            height: 144,
                                            imageUrl: campusList?.image ?? "",
                                            fit: BoxFit.cover,
                                            placeholder: (context, url) =>
                                                SizedBox(
                                                  width: 120,
                                                  height: 120,
                                                  child: Center(
                                                    child: spinkits
                                                        .getSpinningLinespinkit(),
                                                  ),
                                                ),
                                            errorWidget:
                                                (context, url, error) =>
                                                    Container(
                                                      width: 120,
                                                      height: 120,
                                                      color: const Color(
                                                        0xffF8FAFE,
                                                      ),
                                                      child: const Icon(
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
                                            padding: const EdgeInsets.all(16.0),
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  campusList?.name ?? "",
                                                  style: TextStyle(
                                                    fontFamily: 'segeo',
                                                    fontWeight: FontWeight.w700,
                                                    fontSize: 12,
                                                    height: 1,
                                                    letterSpacing: 0.5,
                                                  ),
                                                ),
                                                const SizedBox(height: 8),
                                                Text(
                                                  campusList?.description ?? "",
                                                  style: TextStyle(
                                                    fontFamily: 'segeo',
                                                    fontWeight: FontWeight.w400,
                                                    fontSize: 11,
                                                    height: 1,
                                                  ),
                                                ),
                                                const SizedBox(height: 12),
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
                                                              horizontal: 12,
                                                              vertical: 6,
                                                            ),
                                                        decoration: BoxDecoration(
                                                          color: Colors.white,
                                                          borderRadius:
                                                              BorderRadius.circular(
                                                                20,
                                                              ),
                                                        ),
                                                        child: Text(
                                                          tag,
                                                          style:
                                                              const TextStyle(
                                                                fontFamily:
                                                                    'segeo',
                                                                fontSize: 12,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w600,
                                                              ),
                                                        ),
                                                      );
                                                    }).toList(),
                                                  ),

                                                const SizedBox(height: 16),
                                                Row(
                                                  children: [
                                                    Expanded(
                                                      child:
                                                          CustomOutlinedButton(
                                                            radius: 24,
                                                            text: "View",
                                                            onTap: () {},
                                                          ),
                                                    ),
                                                    const SizedBox(width: 12),
                                                    Expanded(
                                                      child: CustomAppButton1(
                                                        radius: 24,
                                                        text: "Download",
                                                        onPlusTap: () {},
                                                      ),
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
                              }, childCount: studyZoneData?.studyZoneCampusData?.length),
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
                    );
                  } else {
                    return SizedBox.shrink();
                  }
                },
              ),
            ],
          ),
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
                fontFamily: 'segeosegeo',
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
