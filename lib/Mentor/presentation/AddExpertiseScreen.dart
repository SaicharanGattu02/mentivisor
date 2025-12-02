import 'package:dotted_border/dotted_border.dart';
import 'package:dotted_line/dotted_line.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:mentivisor/Components/CommonLoader.dart';
import 'package:mentivisor/Components/CustomAppButton.dart';
import 'package:mentivisor/Components/CustomSnackBar.dart';
import 'package:mentivisor/utils/AppLogger.dart';
import '../Models/NonAttachedExpertisesModel.dart';
import '../Models/NonAttachedExpertiseDetailsModel.dart';
import '../data/Cubits/NonAttachedExpertiseDetails/NonAttachedExpertiseDetailsCubit.dart';
import '../data/Cubits/NonAttachedExpertiseDetails/NonAttachedExpertiseDetailsStates.dart';
import '../data/Cubits/NonAttachedExpertises/NonAttachedExpertisesCubit.dart';
import '../data/Cubits/NonAttachedExpertises/NonAttachedExpertisesStates.dart';

class AddExpertiseScreen extends StatelessWidget {
  const AddExpertiseScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return AddExpertiseView();
  }
}

class AddExpertiseView extends StatefulWidget {
  const AddExpertiseView({super.key});

  @override
  State<AddExpertiseView> createState() => _AddExpertiseViewState();
}

class _AddExpertiseViewState extends State<AddExpertiseView> {
  List<NotAttachedExpertises> availableExpertises = [];
  List<NotAttachedExpertises> selectedExpertises = [];
  Map<int, List<Data>> subExpertises = {};
  Map<int, Set<int>> selectedSubIds = {};
  int? lastRequestedId;
  final TextEditingController searchController = TextEditingController();
  List<NotAttachedExpertises> filteredExpertises = [];

  final ScrollController scrollController = ScrollController();
  Map<int, GlobalKey> expertiseKeys = {};

  void _scrollToExpertise(int id) {
    final key = expertiseKeys[id];
    if (key == null) return;

    final ctx = key.currentContext;
    if (ctx == null) return;

    // Get the position of the widget on the screen
    final box = ctx.findRenderObject() as RenderBox?;
    if (box == null) return;

    final offset = box.localToGlobal(Offset.zero);

    // The SingleChildScrollView padding starts AFTER app bar + status bar.
    final targetOffset =
        scrollController.offset + offset.dy - 120; // Adjust as needed

    scrollController.animateTo(
      targetOffset.clamp(0.0, scrollController.position.maxScrollExtent),
      duration: const Duration(milliseconds: 500),
      curve: Curves.easeInOutCubic,
    );
  }




  @override
  void initState() {
    super.initState();
    context.read<NonAttachedExpertisesCubit>().getNonAttachedExpertises();
    searchController.addListener(_filterExpertises);
  }

  void _filterExpertises() {
    final query = searchController.text.toLowerCase();
    setState(() {
      filteredExpertises = availableExpertises
          .where((exp) => exp.name!.toLowerCase().contains(query))
          .toList();
    });
  }

  void _continue() async {
    final expertiseIds = selectedExpertises.map((e) => e.id!).toList();
    final subExpertiseIds = <int>[];
    selectedSubIds.forEach((_, subs) => subExpertiseIds.addAll(subs));

    if (expertiseIds.isEmpty) {
      CustomSnackBar1.show(context, "Please select at least one expertise");
      return;
    }

    // If you also require sub-expertises
    if (subExpertiseIds.isEmpty) {
      CustomSnackBar1.show(context, "Please select at least one sub-expertise");
      return;
    }

    final data = <String, dynamic>{
      'expertise_id': expertiseIds,
      'sub_expertise_ids': subExpertiseIds,
    };

    context.push("/proof_expertise", extra: data);
    AppLogger.info("data:$data");
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F8FF),
      body: MultiBlocListener(
        listeners: [
          BlocListener<NonAttachedExpertisesCubit, NonAttachedExpertisesStates>(
            listener: (context, state) {
              if (state is NonAttachedExpertisesLoaded) {
                setState(() {
                  availableExpertises =
                      state
                          .nonAttachedExpertisesModel
                          .data
                          ?.notAttachedExpertises ??
                      [];
                  filteredExpertises = availableExpertises;
                });
              }
            },
          ),
          BlocListener<
            NonAttachedExpertiseDetailsCubit,
            NonAttachedExpertiseDetailsStates
          >(
            listener: (context, state) {
              if (state is NonAttachedExpertiseDetailsLoaded &&
                  lastRequestedId != null) {
                final modelData = state.nonAttachedExpertiseDetailsModel.data;
                print(
                  'Model Data Type: ${modelData?.runtimeType}, Data: $modelData',
                );
                setState(() {
                  subExpertises[lastRequestedId!] = (modelData ?? [])
                      .whereType<Data>()
                      .map((data) => data)
                      .toList();
                });
              }
            },
          ),
        ],
        child: SingleChildScrollView(
          controller: scrollController,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SafeArea(
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16.0,
                    vertical: 8.0,
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
                    errorBorder: OutlineInputBorder(
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
              BlocBuilder<
                NonAttachedExpertisesCubit,
                NonAttachedExpertisesStates
              >(
                builder: (context, state) {
                  if (state is NonAttachedExpertisesLoading) {
                    return const Center(child: DottedProgressWithLogo());
                  }
                  if (state is NonAttachedExpertisesFailure) {
                    return Center(child: Text(state.error));
                  }
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Wrap(
                      spacing: 8.0,
                      runSpacing: 8.0,
                      children: filteredExpertises.map((exp) {
                        final isSelected = selectedExpertises.any(
                          (s) => s.id == exp.id,
                        );
                        return GestureDetector(
                          // onTap: () {
                          //   setState(() {
                          //     if (isSelected) {
                          //       selectedExpertises.removeWhere(
                          //         (s) => s.id == exp.id,
                          //       );
                          //       subExpertises.remove(exp.id);
                          //       selectedSubIds.remove(exp.id);
                          //     } else {
                          //       selectedExpertises.add(exp);
                          //       if (!subExpertises.containsKey(exp.id)) {
                          //         lastRequestedId = exp.id;
                          //         context
                          //             .read<NonAttachedExpertiseDetailsCubit>()
                          //             .getNonAttachedExpertiseDetails(exp.id!);
                          //       }
                          //     }
                          //   });
                          // },
                          onTap: () {
                            final wasSelected = isSelected; // before setState

                            setState(() {
                              if (wasSelected) {
                                selectedExpertises.removeWhere((s) => s.id == exp.id);
                                subExpertises.remove(exp.id);
                                selectedSubIds.remove(exp.id);
                              } else {
                                selectedExpertises.add(exp);

                                if (!subExpertises.containsKey(exp.id)) {
                                  lastRequestedId = exp.id;

                                  context
                                      .read<NonAttachedExpertiseDetailsCubit>()
                                      .getNonAttachedExpertiseDetails(exp.id!);
                                }
                              }
                            });

                            // 👉 Only scroll when selecting (not unselecting)
                            if (!wasSelected) {
                              WidgetsBinding.instance.addPostFrameCallback((_) {
                                _scrollToExpertise(exp.id!);
                              });
                            }
                          },
                          child: Chip(
                            label: Text(exp.name ?? ''),
                            backgroundColor: Colors.white,
                            labelStyle: TextStyle(color: Colors.black),
                            shape: StadiumBorder(
                              side: BorderSide(
                                color: isSelected
                                    ? Color(0xff726CF7)
                                    : Colors.white,
                              ),
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  );
                },
              ),
              selectedExpertises.isEmpty
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image.asset(
                            "assets/nodata/no_data.png",
                            width: 200,
                            height: 160,
                          ),
                          const SizedBox(height: 8),
                          const Text(
                            'No expertise selected',
                            style: TextStyle(
                              color: Colors.grey,
                              fontSize: 16,
                            ),
                          ),
                        ],
                      ),
                    )
                  : ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      padding: const EdgeInsets.only(top: 16.0),
                      itemCount: selectedExpertises.length,
                      itemBuilder: (context, index) {
                        final exp = selectedExpertises[index];
                        return BlocBuilder<
                          NonAttachedExpertiseDetailsCubit,
                          NonAttachedExpertiseDetailsStates
                        >(
                          builder: (context, state) {
                            List<Data> subs = subExpertises[exp.id] ?? [];
                            // if (state is NonAttachedExpertiseDetailsLoading) {
                            //   return const Padding(
                            //     padding: EdgeInsets.symmetric(
                            //       horizontal: 16.0,
                            //     ),
                            //     child: Center(
                            //       child: DottedProgressWithLogo(),
                            //     ),
                            //   );
                            // }
                            if (state is NonAttachedExpertiseDetailsFailure) {
                              return Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 16.0,
                                ),
                                child: Center(child: Text(state.error)),
                              );
                            }
                            if (state is NonAttachedExpertiseDetailsLoaded &&
                                !subExpertises.containsKey(exp.id)) {
                              final modelData =
                                  state.nonAttachedExpertiseDetailsModel.data;
                              subs = (modelData ?? [])
                                  .whereType<Data>()
                                  .toList();
                              subExpertises[exp.id!] = subs;
                            }
                            return Container(
                              key: expertiseKeys.putIfAbsent(exp.id!, () => GlobalKey()),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 16.0,
                                    ),
                                    child: Chip(
                                      label: Text(exp.name ?? ''),
                                      backgroundColor: Color(0xff726CF7),
                                      labelStyle: const TextStyle(
                                        color: Colors.white,
                                      ),
                                      shape: StadiumBorder(
                                        side: const BorderSide(
                                          color: Color(0xff726CF7),
                                        ),
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(left: 32.0),
                                    child: DottedLine(
                                      direction: Axis.vertical,
                                      lineLength: 20.0,
                                      dashLength: 4.0,
                                      dashGapLength: 4.0,
                                      dashColor: Colors.grey,
                                    ),
                                  ),

                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 16.0,
                                    ),
                                    child: DottedBorder(
                                      color: Colors.grey[400]!,
                                      strokeWidth: 1.5,
                                      borderType: BorderType.RRect,
                                      radius: const Radius.circular(12),
                                      dashPattern: const [
                                        6,
                                        3,
                                      ], // 6px line, 3px space
                                      child: Container(
                                        width: double.infinity,
                                        padding: const EdgeInsets.all(8.0),
                                        child: Wrap(
                                          spacing: 8.0,
                                          runSpacing: 8.0,
                                          children: subs.map((sub) {
                                            if (sub != null) {
                                              final isSubSelected =
                                                  selectedSubIds[exp.id]
                                                      ?.contains(sub.id) ??
                                                  false;
                                              return GestureDetector(
                                                onTap: () {
                                                  setState(() {
                                                    selectedSubIds.putIfAbsent(
                                                      exp.id!,
                                                      () => {},
                                                    );
                                                    if (isSubSelected) {
                                                      selectedSubIds[exp.id!]!
                                                          .remove(sub.id);
                                                    } else {
                                                      selectedSubIds[exp.id!]!
                                                          .add(sub.id!);
                                                    }
                                                  });
                                                },
                                                child: Chip(
                                                  label: Text(
                                                    sub.name ?? 'Unnamed',
                                                  ),
                                                  backgroundColor: isSubSelected
                                                      ? const Color(
                                                          0xff726CF7,
                                                        ).withOpacity(0.3)
                                                      : const Color(0xffF5F5F5),
                                                  labelStyle: const TextStyle(
                                                    color: Colors.black,
                                                  ),
                                                  shape: StadiumBorder(
                                                    side: BorderSide(
                                                      color: isSubSelected
                                                          ? Color(
                                                              0xff726CF7,
                                                            ).withOpacity(0.3)
                                                          : Color(0xffF5F5F5),
                                                    ),
                                                  ),
                                                ),
                                              );
                                            }
                                            return const SizedBox.shrink();
                                          }).toList(),
                                        ),
                                      ),
                                    ),
                                  ),

                                  const SizedBox(height: 16.0),
                                ],
                              ),
                            );
                          },
                        );
                      },
                    ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: CustomAppButton1(text: "Continue", onPlusTap: _continue),
        ),
      ),
    );
  }
}
