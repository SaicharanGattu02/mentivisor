import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:mentivisor/Components/CommonLoader.dart';
import 'package:mentivisor/Components/CustomAppButton.dart';
import 'package:mentivisor/Components/CustomSnackBar.dart';
import 'package:mentivisor/Mentor/data/Cubits/UpdateExpertise/UpdateExpertiseCubit.dart';
import 'package:mentivisor/Mentor/data/Cubits/UpdateExpertise/UpdateExpertiseStates.dart';
import 'package:mentivisor/Mentor/presentation/widgets/AddChipPill.dart';
import 'package:mentivisor/Mentor/presentation/widgets/ChipPill.dart';
import 'package:mentivisor/Mentor/presentation/widgets/ErrorView.dart';
import 'package:mentivisor/Mentor/presentation/widgets/SelectableChip.dart';
import '../Models/MentorExpertiseModel.dart';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../data/Cubits/ExpertiseDetails/expertise_detaill_states.dart';
import '../data/Cubits/ExpertiseDetails/expertise_details_cubit.dart';

class SubExpertisesScreen extends StatefulWidget {
  const SubExpertisesScreen({
    super.key,
    required this.categoryTitle,
    required this.id,
  });

  final String categoryTitle;
  final int id;

  @override
  State<SubExpertisesScreen> createState() => _SubExpertisesScreenState();
}

class _SubExpertisesScreenState extends State<SubExpertisesScreen> {
  // Local working lists
  final List<SubExpertise> _attached = [];
  final List<SubExpertise> _unattached = [];
  bool _seeded = false; // ensure we seed only once per successful load

  // below your existing lists
  final Set<int> _selectedUnattached = {};
  bool _showUnattached = false;

  @override
  void initState() {
    super.initState();
    // trigger the load
    context.read<MentorExpertiseCubit>().getMentorExpertise(widget.id);
  }

  void _seedLists(MentorExpertiseData data) {
    _attached
      ..clear()
      ..addAll(data.subExpertises ?? []);
    _unattached
      ..clear()
      ..addAll(data.notAttachedSubExpertises ?? []);
    _seeded = true;
  }

  @override
  Widget build(BuildContext context) {
    const bg = LinearGradient(
      colors: [Color(0xFFF6F7FF), Color(0xFFFFF5FF)],
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    );

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        surfaceTintColor: Colors.transparent,
        leadingWidth: 44,
        leading: const Padding(
          padding: EdgeInsets.only(left: 8),
          child: BackButton(),
        ),
        centerTitle: true,
        title: const Text(
          'Expertise',
          style: TextStyle(
            fontSize: 18,
            fontFamily: "segeo",
            color: Color(0xff121212),
            fontWeight: FontWeight.w700,
            letterSpacing: .1,
          ),
        ),
      ),
      body: Container(
        decoration: const BoxDecoration(gradient: bg),
        width: double.infinity,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          child: BlocBuilder<MentorExpertiseCubit, MentorExpertiseStates>(
            builder: (context, state) {
              if (state is MentorExpertiseLoading) {
                return const Center(child: DottedProgressWithLogo());
              }
              if (state is MentorExpertiseFailure) {
                return ErrorView(
                  message: state.error,
                  onRetry: () {
                    _seeded = false; // allow reseed on next success
                    context.read<MentorExpertiseCubit>().getMentorExpertise(
                      widget.id,
                    );
                  },
                );
              }

              if (state is MentorExpertiseLoaded) {
                final model = state.mentorExpertiseModel;
                final data = model.data;

                if (model.status != true || data == null) {
                  return ErrorView(
                    message: model.message ?? 'Failed to load',
                    onRetry: () {
                      _seeded = false;
                      context.read<MentorExpertiseCubit>().getMentorExpertise(
                        widget.id,
                      );
                    },
                  );
                }

                // Seed once after the first successful load
                if (!_seeded) _seedLists(data);
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 6),
                    Text(
                      'IN-${widget.categoryTitle}',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF121212),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Expanded(
                      child: SingleChildScrollView(
                        padding: const EdgeInsets.only(bottom: 24),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // ATTACHED chips first
                            Wrap(
                              spacing: 10,
                              runSpacing: 10,
                              children: [
                                for (final item in _attached)
                                  ChipPill(label: item.name ?? ''),
                              ],
                            ),

                            const SizedBox(height: 16),

                            // "Add" button (only when there are unattached and the picker is hidden)
                            if (_unattached.isNotEmpty && !_showUnattached)
                              AddChipPill(
                                onTap: () =>
                                    setState(() => _showUnattached = true),
                              ),

                            // Inline UNATTACHED picker (shown after tapping Add)
                            if (_showUnattached) ...[
                              const SizedBox(height: 8),
                              const Text(
                                "Add New",
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Wrap(
                                spacing: 10,
                                runSpacing: 10,
                                children: [
                                  for (final item in _unattached)
                                    SelectableChip(
                                      label: item.name ?? '',
                                      selected: _selectedUnattached.contains(
                                        item.id,
                                      ),
                                      onTap: () {
                                        setState(() {
                                          final id = item.id ?? -1;
                                          if (_selectedUnattached.contains(
                                            id,
                                          )) {
                                            _selectedUnattached.remove(id);
                                          } else {
                                            _selectedUnattached.add(id);
                                          }
                                        });
                                      },
                                    ),
                                ],
                              ),
                              const SizedBox(height: 16),
                            ],
                          ],
                        ),
                      ),
                    ),
                  ],
                );
              }
              return const SizedBox.shrink();
            },
          ),
        ),
      ),
      bottomNavigationBar: _showUnattached
          ? SafeArea(
              child: Padding(
                padding: EdgeInsets.all(16),
                child: BlocConsumer<UpdateExpertiseCubit, UpdateExpertiseStates>(
                  listener: (context, state) {
                    if (state is UpdateExpertiseLoaded) {
                      context.push(
                        "/cost_per_minute_screen?coins=${state.updateSubExpertiseModel.data?.coinsPerMinute ?? ""}&path=${"mentor_dashboard"}",
                      );
                    } else if (state is UpdateExpertiseFailure) {
                      CustomSnackBar1.show(context, state.error);
                    }
                  },
                  builder: (context, state) {
                    final isLoading = state is UpdateExpertiseLoading;
                    return CustomAppButton1(
                      text: "Save",
                      isLoading: isLoading,
                      onPlusTap: () {
                        final Map<String, dynamic> data = {
                          "mode": "add",
                          "sub_expertise_ids": _selectedUnattached.toList(),
                        };
                        context.read<UpdateExpertiseCubit>().updateExpertise(
                          data,
                        );
                      },
                    );
                  },
                ),
              ),
            )
          : SizedBox.shrink(),
    );
  }
}
