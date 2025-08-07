import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
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
  int _selectedTagIndex = -1;

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
                        "",
                        "beyond",
                      );
                    }),
                  ],
                ),
              ),
              const SizedBox(height: 12),

              // Search Field
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
                      height: 42,
                      child: ListView.separated(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        scrollDirection: Axis.horizontal,
                        itemCount: tags?.length ?? 0,
                        separatorBuilder: (_, __) => const SizedBox(width: 8),
                        itemBuilder: (ctx, i) {
                          final tagItem = tags![i];
                          final isSelected = _selectedTagIndex == i;
                          return AnimatedContainer(
                            duration: const Duration(milliseconds: 200),
                            padding: const EdgeInsets.symmetric(
                              horizontal: 14,
                              vertical: 8,
                            ),
                            decoration: BoxDecoration(
                              color: isSelected
                                  ? const Color(0xFFEDEBFF)
                                  : Colors.white,
                              borderRadius: BorderRadius.circular(24),
                              border: Border.all(
                                color: isSelected
                                    ? Colors.transparent
                                    : const Color(0xFFE0E0E0),
                              ),
                              boxShadow: isSelected
                                  ? [
                                      const BoxShadow(
                                        color: Color(0xFFDDDFFF),
                                        blurRadius: 8,
                                        offset: Offset(0, 2),
                                      ),
                                    ]
                                  : null,
                            ),
                            child: GestureDetector(
                              onTap: () {
                                setState(() {
                                  _selectedTagIndex = i;
                                });
                              },
                              child: Center(
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
                            ),
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
                  } else if (state is StudyZoneCampusLoaded) {
                    return Expanded(
                      child: CustomScrollView(
                        slivers: [
                          SliverPadding(
                            padding: EdgeInsets.all(12),
                            sliver: SliverList(
                              delegate: SliverChildBuilderDelegate(
                                (context, index) {
                                  final campusList = state
                                      .studyZoneCampusModel
                                      .studyZoneData
                                      ?.data![index];
                                  return Container(
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
                                  );
                                },
                                childCount: state
                                    .studyZoneCampusModel
                                    .studyZoneData
                                    ?.data
                                    ?.length,
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

      floatingActionButton: Container(
        height: 64,
        width: 64,
        decoration: const BoxDecoration(
          shape: BoxShape.circle,
          gradient: LinearGradient(
            colors: [],
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
          child: const Icon(Icons.add, size: 32),
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

class _ResourceCard extends StatelessWidget {
  final Map<String, String> data;
  const _ResourceCard({Key? key, required this.data}) : super(key: key);

  static const Color grad1 = Color(0xFFA258F7);
  static const Color grad2 = Color(0xFF726CF7);
  static const Color grad3 = Color(0xFF4280F6);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFFF7F8FD),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          // Image
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Image.asset(
              "images/download.jpg",
              height: 144,
              width: 144,
              fit: BoxFit.cover,
              errorBuilder: (_, __, ___) => Container(
                height: 144,
                width: 144,
                color: Colors.grey.shade200,
              ),
            ),
          ),
          const SizedBox(width: 10),
          // Text & buttons
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    data['title']!,
                    style: const TextStyle(
                      fontFamily: 'segeo',
                      fontWeight: FontWeight.w700,
                      fontSize: 14,
                      color: Color(0xFF222222),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    data['subtitle']!,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontFamily: 'segeo',
                      fontWeight: FontWeight.w400,
                      fontSize: 12,
                      color: Color(0xFF666666),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xFFEDEBFF),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      data['tag']!,
                      style: const TextStyle(
                        fontFamily: 'segeo',
                        fontWeight: FontWeight.w600,
                        fontSize: 12,
                        color: Color(0xFF7F00FF),
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      // View button
                      SizedBox(
                        height: 36,
                        width: 100,
                        child: OutlinedButton(
                          onPressed: () {},
                          style: OutlinedButton.styleFrom(
                            side: const BorderSide(
                              width: 1.5,
                              color: Color(0xFF7F00FF),
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(24),
                            ),
                            padding: const EdgeInsets.symmetric(vertical: 8),
                            backgroundColor: Colors.white,
                          ),
                          child: const Text(
                            'View',
                            style: TextStyle(
                              fontFamily: 'segeo',
                              fontWeight: FontWeight.w600,
                              fontSize: 12,
                              color: Color(0xFF7F00FF),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 28),
                      // Download button
                      SizedBox(
                        height: 36,
                        width: 100,
                        child: DecoratedBox(
                          decoration: BoxDecoration(
                            gradient: const LinearGradient(
                              colors: [grad1, grad2, grad3],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                            borderRadius: BorderRadius.circular(24),
                          ),
                          child: ElevatedButton(
                            onPressed: () {},
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.transparent,
                              shadowColor: Colors.transparent,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(24),
                              ),
                              padding: EdgeInsets.zero,
                            ),
                            child: const Center(
                              child: Text(
                                'Download',
                                style: TextStyle(
                                  fontFamily: 'segeo',
                                  fontWeight: FontWeight.w600,
                                  fontSize: 12,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
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
    );
  }
}
