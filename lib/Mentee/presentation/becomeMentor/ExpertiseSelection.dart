import 'dart:async';
import 'dart:developer' as AppLogger;
import 'package:dotted_line/dotted_line.dart';
import 'package:flutter/material.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:mentivisor/Mentee/data/cubits/Expertise/ExpertiseCategory/expertise_category_cubit.dart';
import '../../../Components/CommonLoader.dart';
import '../../../Components/CustomAppButton.dart';
import '../../../Components/CustomSnackBar.dart';
import '../../Models/GetExpertiseModel.dart';
import '../../data/cubits/BecomeMentor/become_mentor_cubit.dart';
import '../../data/cubits/BecomeMentor/become_mentor_state.dart';
import '../../data/cubits/Expertise/ExpertiseCategory/expertise_category_state.dart';

import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:dotted_line/dotted_line.dart';
import 'package:go_router/go_router.dart';

// === Your imports (models/cubits/utils) ===
// import 'package:mentivisor/.../expertise_category_cubit.dart';
// import 'package:mentivisor/.../become_mentor_cubit.dart';
// import 'package:mentivisor/.../models/get_expertise_model.dart';
// import 'package:mentivisor/.../widgets/custom_app_button_1.dart';
// import 'package:mentivisor/.../widgets/custom_snackbar_1.dart';
// import 'package:mentivisor/.../widgets/dotted_progress_with_logo.dart';
// import 'package:mentivisor/.../utils/app_logger.dart';

class SubTopicSelection extends StatefulWidget {
  final Map<String, dynamic> data; // carry-over from previous step
  const SubTopicSelection({super.key, required this.data});

  @override
  State<SubTopicSelection> createState() => _SubTopicSelectionV2State();
}

class _SubTopicSelectionV2State extends State<SubTopicSelection> {
  /// Selection state
  final Set<int> selectedCategoryIds = <int>{};
  final Map<int, Set<int>> selectedSubIds = <int, Set<int>>{};

  /// Cache selected category objects so they survive filtered searches
  final Map<int, ExpertiseData> _selectedCatCache = <int, ExpertiseData>{};

  /// Search & pagination
  final TextEditingController searchController = TextEditingController();
  final ScrollController _scroll = ScrollController();
  Timer? _debounce;

  @override
  void initState() {
    super.initState();

    // Initial load
    context.read<ExpertiseCategoryCubit>().getExpertiseCategories("");

    // Debounced server search
    searchController.addListener(_onSearchChanged);

    // Infinite scroll
    _scroll.addListener(_onScroll);
  }

  void _onSearchChanged() {
    _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 300), () {
      final q = searchController.text.trim();
      context.read<ExpertiseCategoryCubit>().getExpertiseCategories(q);
    });
  }

  void _onScroll() {
    final cubit = context.read<ExpertiseCategoryCubit>();
    final s = cubit.state;
    bool hasNext = false;
    if (s is ExpertiseCategoryLoaded) hasNext = s.hasNextPage;
    if (s is ExpertiseCategoryLoadingMore) hasNext = s.hasNextPage;

    if (hasNext &&
        _scroll.position.pixels >= _scroll.position.maxScrollExtent - 200) {
      cubit.fetchMoreExpertiseCategories(searchController.text.trim());
    }
  }

  @override
  void dispose() {
    _debounce?.cancel();
    searchController.dispose();
    _scroll.dispose();
    super.dispose();
  }

  /// Toggle a parent category. Cache the object when selecting.
  void _toggleCategory(ExpertiseData cat) {
    final id = cat.id ?? -1;
    if (id == -1) return;

    setState(() {
      if (selectedCategoryIds.contains(id)) {
        // Unselect: also clear its sub picks and cache
        selectedCategoryIds.remove(id);
        selectedSubIds.remove(id);
        _selectedCatCache.remove(id);
      } else {
        selectedCategoryIds.add(id);
        selectedSubIds.putIfAbsent(id, () => <int>{});
        // Cache for survival across searches
        _selectedCatCache[id] = cat;
      }
    });
  }

  void _clearCategory(int id) {
    setState(() {
      selectedCategoryIds.remove(id);
      selectedSubIds.remove(id);
      _selectedCatCache.remove(id);
    });
  }

  void _toggleSub(int parentId, SubExpertises sub) {
    if (sub.id == null) return;
    final set = selectedSubIds.putIfAbsent(parentId, () => <int>{});
    setState(() {
      if (set.contains(sub.id)) {
        set.remove(sub.id);
      } else {
        set.add(sub.id!);
      }
    });
  }

  void _submit() {
    // Flatten selected
    final expertiseIds = selectedCategoryIds.toList();
    final subIds = <int>[];
    selectedSubIds.forEach((_, s) => subIds.addAll(s));

    if (expertiseIds.isEmpty) {
      CustomSnackBar1.show(context, "Please select at least one expertise");
      return;
    }
    if (subIds.isEmpty) {
      CustomSnackBar1.show(context, "Please select at least one sub-expertise");
      return;
    }

    final payload = <String, dynamic>{
      ...widget.data,
      "expertise_ids[]": expertiseIds,
      "sub_expertise_ids[]": subIds,
    };

    AppLogger.log("BecomeMentor payload (single cubit): $payload");
    context.read<BecomeMentorCubit>().becomeMentor(payload);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F8FF),
      body: MultiBlocListener(
        listeners: [
          BlocListener<BecomeMentorCubit, BecomeMentorStates>(
            listener: (context, state) {
              if (state is BecomeMentorSuccess) {
                context.go(
                  '/cost_per_minute_screen?coins=${state.becomeMentorSuccessModel.coinsPerMinute ?? ""}',
                );
              } else if (state is BecomeMentorFailure) {
                CustomSnackBar1.show(context, state.error);
              }
            },
          ),
        ],
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            SafeArea(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
                child: Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.arrow_back, color: Colors.black),
                      onPressed: () => Navigator.pop(context),
                    ),
                    const Expanded(
                      child: Center(
                        child: Text(
                          'Add Expertise',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Search
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: TextField(
                controller: searchController,
                decoration: InputDecoration(
                  hintText: 'Search',
                  hintStyle: const TextStyle(color: Colors.grey),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(36),
                    borderSide: BorderSide.none,
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(36),
                    borderSide: BorderSide.none,
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(36),
                    borderSide: BorderSide.none,
                  ),
                  filled: true,
                  fillColor: Colors.white,
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 10,
                  ),
                ),
              ),
            ),

            const SizedBox(height: 16),

            // BODY
            Expanded(
              child: BlocBuilder<ExpertiseCategoryCubit, ExpertiseCategoryStates>(
                builder: (context, state) {
                  if (state is ExpertiseCategoryLoading &&
                      (state is! ExpertiseCategoryLoadingMore)) {
                    return const Center(child: DottedProgressWithLogo());
                  }
                  if (state is ExpertiseCategoryFailure) {
                    // If failure during search, still show selected section using cache
                    return _buildScrollBody(
                      categories: const <ExpertiseData>[],
                      showAvailable: false,
                      searching: searchController.text.trim().isNotEmpty,
                    );
                  }

                  // Combine for both loaded/loadingMore
                  final model = (state is ExpertiseCategoryLoaded)
                      ? state.expertiseModel
                      : (state is ExpertiseCategoryLoadingMore)
                      ? state.expertiseModel
                      : GetExpertiseModel();

                  final categories = model.data?.data ?? <ExpertiseData>[];
                  final q = searchController.text.trim();

                  // Build lookup of items present on current page
                  final Map<int, ExpertiseData> currentPageMap = {
                    for (final c in categories.where((c) => c.id != null))
                      c.id!: c,
                  };

                  // Refresh cache names/subs when item reappears (optional but nice)
                  for (final id in selectedCategoryIds) {
                    final updated = currentPageMap[id];
                    if (updated != null) {
                      _selectedCatCache[id] = updated;
                    }
                  }

                  // Available (not selected) chips for current filtered page
                  final unselected = categories.where(
                    (c) => c.id != null && !selectedCategoryIds.contains(c.id!),
                  );

                  // While searching, if zero matches, DON'T show "No Data Found"
                  final showAvailable = !(q.isNotEmpty && unselected.isEmpty);

                  // When not searching and there's truly no data at all, show empty state
                  if (q.isEmpty &&
                      categories.isEmpty &&
                      selectedCategoryIds.isEmpty) {
                    return const Center(child: Text("No Data Found"));
                  }

                  return _buildScrollBody(
                    categories: categories,
                    showAvailable: showAvailable,
                    searching: q.isNotEmpty,
                    unselectedOverride: unselected.toList(),
                    currentPageMap: currentPageMap,
                  );
                },
              ),
            ),
          ],
        ),
      ),

      // Done button -> BecomeMentor
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: BlocBuilder<BecomeMentorCubit, BecomeMentorStates>(
            builder: (context, state) {
              final isLoading = state is BecomeMentorLoading;
              return CustomAppButton1(
                isLoading: isLoading,
                text: "Done",
                onPlusTap: isLoading ? null : _submit,
              );
            },
          ),
        ),
      ),
    );
  }

  /// Builds the scrollable body with (optional) available chips + always-visible selected section.
  Widget _buildScrollBody({
    required List<ExpertiseData> categories,
    required bool showAvailable,
    required bool searching,
    List<ExpertiseData>? unselectedOverride,
    Map<int, ExpertiseData>? currentPageMap,
  }) {
    final unselected =
        (unselectedOverride ??
        categories
            .where((c) => c.id != null && !selectedCategoryIds.contains(c.id!))
            .toList());

    final pageMap =
        currentPageMap ??
        {for (final c in categories.where((c) => c.id != null)) c.id!: c};

    return CustomScrollView(
      controller: _scroll,
      slivers: [
        if (showAvailable)
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            sliver: SliverToBoxAdapter(
              child: Wrap(
                spacing: 8,
                runSpacing: 8,
                children: unselected.map((cat) {
                  final isSel = selectedCategoryIds.contains(cat.id);
                  return GestureDetector(
                    onTap: () => _toggleCategory(cat),
                    child: Chip(
                      label: Text(cat.name ?? ''),
                      backgroundColor: Colors.white,
                      labelStyle: const TextStyle(color: Colors.black),
                      shape: StadiumBorder(
                        side: BorderSide(
                          color: isSel ? const Color(0xff726CF7) : Colors.white,
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
          ),

        // Selected categories (ALWAYS visible, from current page OR cache)
        SliverList.separated(
          itemCount: selectedCategoryIds.length,
          separatorBuilder: (_, __) => const SizedBox(height: 12),
          itemBuilder: (_, idx) {
            final catId = selectedCategoryIds.elementAt(idx);

            final cat =
                pageMap[catId] ??
                _selectedCatCache[catId] ??
                ExpertiseData(subExpertises: []);
            final subs = cat.subExpertises ?? <SubExpertises>[];

            return Padding(
              padding: const EdgeInsets.only(top: 16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Selected parent chip + clear
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Chip(
                          label: Text(cat.name ?? ''),
                          backgroundColor: const Color(0xff726CF7),
                          labelStyle: const TextStyle(color: Colors.white),
                          shape: const StadiumBorder(
                            side: BorderSide(color: Color(0xff726CF7)),
                          ),
                        ),
                        const SizedBox(width: 8),
                        IconButton(
                          visualDensity: VisualDensity.compact,
                          icon: const Icon(Icons.close, size: 18),
                          onPressed: () => _clearCategory(catId),
                        ),
                      ],
                    ),
                  ),

                  const Padding(
                    padding: EdgeInsets.only(left: 32.0),
                    child: DottedLine(
                      direction: Axis.vertical,
                      lineLength: 20.0,
                      dashLength: 4.0,
                      dashGapLength: 4.0,
                      dashColor: Colors.grey,
                    ),
                  ),

                  // Sub chips (from cat.subExpertises; stays visible even if searching)
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: DottedBorder(
                      color: Colors.grey[400]!,
                      strokeWidth: 1.5,
                      borderType: BorderType.RRect,
                      radius: const Radius.circular(12),
                      dashPattern: const [6, 3],
                      child: Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(8.0),
                        child: Wrap(
                          spacing: 8,
                          runSpacing: 8,
                          children: subs.map((sub) {
                            final picked =
                                selectedSubIds[catId]?.contains(sub.id) ??
                                false;
                            return GestureDetector(
                              onTap: () => _toggleSub(catId, sub),
                              child: Chip(
                                label: Text(sub.name ?? 'Unnamed'),
                                backgroundColor: picked
                                    ? const Color(0xff726CF7).withOpacity(0.3)
                                    : const Color(0xffF5F5F5),
                                labelStyle: const TextStyle(
                                  color: Colors.black,
                                ),
                                shape: StadiumBorder(
                                  side: BorderSide(
                                    color: picked
                                        ? const Color(
                                            0xff726CF7,
                                          ).withOpacity(0.3)
                                        : const Color(0xffF5F5F5),
                                  ),
                                ),
                              ),
                            );
                          }).toList(),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        ),

        // Bottom padding for FAB/CTA spacing
        const SliverToBoxAdapter(child: SizedBox(height: 120)),
      ],
    );
  }
}
