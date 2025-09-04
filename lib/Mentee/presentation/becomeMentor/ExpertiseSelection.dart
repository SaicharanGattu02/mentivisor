import 'dart:async';
import 'dart:developer' as AppLogger;
import 'package:flutter/material.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:mentivisor/Mentee/data/cubits/Expertise/ExpertiseCategory/expertise_category_cubit.dart';
import '../../../Components/CustomAppButton.dart';
import '../../../Components/CustomSnackBar.dart';
import '../../../Components/CutomAppBar.dart';
import '../../../utils/color_constants.dart';
import '../../Models/GetExpertiseModel.dart';
import '../../data/cubits/BecomeMentor/become_mentor_cubit.dart';
import '../../data/cubits/BecomeMentor/become_mentor_state.dart';
import '../../data/cubits/Expertise/ExpertiseCategory/expertise_category_state.dart';
import '../../data/cubits/Expertise/ExpertiseSubCategory/expertise_sub_category_cubit.dart';
import '../../data/cubits/Expertise/ExpertiseSubCategory/expertise_sub_category_state.dart';

class SubTopicSelectionScreen extends StatefulWidget {
  final Map<String, dynamic> data;
  const SubTopicSelectionScreen({super.key, required this.data});

  @override
  State<SubTopicSelectionScreen> createState() =>
      _SubTopicSelectionScreenState();
}

class _SubTopicSelectionScreenState extends State<SubTopicSelectionScreen> {
  final Set<int> selectedCategoryIds = {};

  final Set<int> selectedSubCategoryIds = {};

  final Map<int, Set<String>> pickedSubTopicsPerCategory = {};

  final TextEditingController searchController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  Timer? _debounce;

  List<ExpertiseData> expertiseCategories = [];

  @override
  void initState() {
    super.initState();
    AppLogger.log("BecomeMentorData: ${widget.data}");
    context.read<ExpertiseCategoryCubit>().getExpertiseCategories("");

    _scrollController.addListener(() {
      final cubit = context.read<ExpertiseCategoryCubit>();
      final state = cubit.state;
      bool hasNextPage = false;

      if (state is ExpertiseCategoryLoaded) {
        hasNextPage = state.hasNextPage;
      } else if (state is ExpertiseCategoryLoadingMore) {
        hasNextPage = state.hasNextPage;
      }

      if (hasNextPage &&
          _scrollController.position.pixels >=
              _scrollController.position.maxScrollExtent - 200) {
        cubit.fetchMoreExpertiseCategories("");
      }
    });
  }

  @override
  void dispose() {
    searchController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFAF5FF),
      appBar: CustomAppBar1(title: "", actions: []),
      body: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFFFAF5FF), Color(0xFFF5F6FF), Color(0xFFEFF6FF)],
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Padding(
              padding: EdgeInsets.fromLTRB(16, 0, 16, 8),
              child: Text(
                'Now Select topic you want to\nmentor',
                style: TextStyle(
                  fontSize: 22,
                  height: 1.25,
                  fontWeight: FontWeight.w600,
                  fontFamily: 'segeo',
                  color: Color(0xFF2563EC),
                ),
              ),
            ),
            const SizedBox(height: 20),
            SizedBox(
              height: 48,
              child: TextField(
                controller: searchController,
                cursorColor: primarycolor,
                onChanged: (query) {
                  if (_debounce?.isActive ?? false) _debounce!.cancel();
                  _debounce = Timer(const Duration(milliseconds: 300), () {
                    context
                        .read<ExpertiseCategoryCubit>()
                        .getExpertiseCategories(query);
                  });
                },
                style: const TextStyle(fontFamily: "Poppins", fontSize: 15),
                decoration: const InputDecoration(
                  hintText: 'Search by topic ',
                  prefixIcon: Icon(Icons.search),
                ),
              ),
            ),
            const SizedBox(height: 20),

            Expanded(
              child: BlocBuilder<ExpertiseCategoryCubit, ExpertiseCategoryStates>(
                builder: (context, state) {
                  return CategorySelectionFromState(
                    state: state,
                    selectedCategoryIds: selectedCategoryIds,
                    selectedSubCategoryIds: selectedSubCategoryIds,
                    pickedSubTopicsPerCategory: pickedSubTopicsPerCategory,
                    onCategorySelected: (catId) {
                      setState(() {
                        selectedCategoryIds.add(catId);
                        context
                            .read<ExpertiseSubCategoryCubit>()
                            .getExpertiseSubCategories(catId);
                      });
                    },
                    onSubCategoryToggle: (catId, subName, subId, isPicked) {
                      setState(() {
                        final setForCat =
                        pickedSubTopicsPerCategory.putIfAbsent(catId, () => {});
                        if (isPicked) {
                          setForCat.remove(subName);
                          selectedSubCategoryIds.remove(subId);
                        } else {
                          setForCat.add(subName);
                          selectedSubCategoryIds.add(subId);
                        }
                      });
                    },
                    onCategoryClear: (catId) {
                      setState(() {
                        selectedCategoryIds.remove(catId);
                        pickedSubTopicsPerCategory.remove(catId);
                      });
                    },
                  );
                },
              ),
            ),

          ],
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.fromLTRB(16, 0, 16, 20),
        child: BlocConsumer<BecomeMentorCubit, BecomeMentorStates>(
          listener: (context, state) {
            if (state is BecomeMentorSuccess) {
              context.go('/cost_per_minute_screen?coins=${state.becomeMentorSuccessModel.coinsPerMinute??""}');
            } else if (state is BecomeMentorFailure) {
              CustomSnackBar1.show(context, state.error);
            }
          },
          builder: (context, state) {
            return CustomAppButton1(
              isLoading: state is BecomeMentorLoading,
              text: "Done",
              onPlusTap: () {
                if (selectedSubCategoryIds.isEmpty &&
                    selectedCategoryIds.isEmpty) {
                  CustomSnackBar1.show(
                    context,
                    "Please tell us about your achievements to continue.",
                  );
                } else {
                  final Map<String, dynamic> data = {
                    ...widget.data,
                    "expertise_ids[]": selectedCategoryIds.toList(),
                    "sub_expertise_ids[]": selectedSubCategoryIds.toList(),
                  };
                  context.read<BecomeMentorCubit>().becomeMentor(data);
                }
              },
            );
          },
        ),
      ),
    );
  }
}

class _SelectedCategoryChip extends StatelessWidget {
  final String categoryName;
  final VoidCallback onClear;
  const _SelectedCategoryChip({
    required this.categoryName,
    required this.onClear,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(8, 4, 8, 4),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [Color(0xFF7F00FF), Color(0xFF00BFFF)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(18),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              categoryName,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 13.5,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(width: 8),
            GestureDetector(
              onTap: onClear,
              child: Container(
                width: 20,
                height: 20,
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(.2),
                  border: Border.all(color: Colors.white, width: 1),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.close, size: 14, color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
class CategorySelectionFromState extends StatelessWidget {
  final ExpertiseCategoryStates state;
  final Set<int> selectedCategoryIds;
  final Set<int> selectedSubCategoryIds;
  final Map<int, Set<String>> pickedSubTopicsPerCategory;
  final Function(int) onCategorySelected;
  final Function(int, String, int, bool) onSubCategoryToggle;
  final Function(int) onCategoryClear;

  const CategorySelectionFromState({
    super.key,
    required this.state,
    required this.selectedCategoryIds,
    required this.selectedSubCategoryIds,
    required this.pickedSubTopicsPerCategory,
    required this.onCategorySelected,
    required this.onSubCategoryToggle,
    required this.onCategoryClear,
  });

  @override
  Widget build(BuildContext context) {
    if (state is ExpertiseCategoryLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (state is ExpertiseCategoryFailure) {
      final failure = state as ExpertiseCategoryFailure;
      return Center(child: Text(failure.error));
    }

    final categoryList = (state is ExpertiseCategoryLoaded)
        ? (state as ExpertiseCategoryLoaded).expertiseModel.data?.data ?? []
        : (state is ExpertiseCategoryLoadingMore)
        ? (state as ExpertiseCategoryLoadingMore).expertiseModel.data?.data ?? []
        : [];

    if (categoryList.isEmpty) {
      return const Center(child: Text("No Data Found"));
    }

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Available categories
          Wrap(
            spacing: 10,
            runSpacing: 10,
            children: categoryList
                .where((cat) => !selectedCategoryIds.contains(cat.id))
                .map((cat) => _PillChip(
              text: cat.name ?? "",
              selected: false,
              onTap: () => onCategorySelected(cat.id ?? -1),
            ))
                .toList(),
          ),

          // Selected categories with subs
          ...selectedCategoryIds.map((catId) {
            final category = categoryList.firstWhere(
                  (c) => c.id == catId,
              orElse: () => ExpertiseData(subExpertises: []),
            );
            final subs = category.subExpertises ?? [];
            final pickedSubs = pickedSubTopicsPerCategory[catId] ?? {};

            return Padding(
              padding: const EdgeInsets.only(top: 16),
              child: DottedBorder(
                color: const Color(0xFFD9BFC4),
                dashPattern: const [6, 4],
                borderType: BorderType.RRect,
                radius: const Radius.circular(16),
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _SelectedCategoryChip(
                      categoryName: category.name ?? "",
                      onClear: () => onCategoryClear(catId),
                    ),
                    const SizedBox(height: 12),
                    if (subs.isNotEmpty)
                      Wrap(
                        spacing: 10,
                        runSpacing: 10,
                        children: subs.map((sub) {
                          final isPicked = pickedSubs.contains(sub.name ?? "");
                          return _PillChip(
                            text: sub.name ?? "",
                            selected: isPicked,
                            onTap: () => onSubCategoryToggle(
                              catId,
                              sub.name ?? "",
                              sub.id ?? 0,
                              isPicked,
                            ),
                          );
                        }).toList(),
                      )
                    else
                      const Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Text("No Subcategories Found"),
                      ),
                  ],
                ),
              ),
            );
          }),
        ],
      ),
    );
  }
}


class _PillChip extends StatelessWidget {
  final String text;
  final bool selected;
  final VoidCallback onTap;
  final Color selectedBorder;
  final Color selectedText;

  const _PillChip({
    required this.text,
    required this.selected,
    required this.onTap,
    this.selectedBorder = const Color(0xFF7F00FF),
    this.selectedText = const Color(0xFF7F00FF),
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: selected ? selectedBorder : Colors.transparent,
            width: 1,
          ),
        ),
        child: Text(
          text,
          style: TextStyle(
            fontFamily: 'segeo',
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: selected ? selectedText : const Color(0xFF2F3B52),
          ),
        ),
      ),
    );
  }
}
