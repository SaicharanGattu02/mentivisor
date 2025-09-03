import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:mentivisor/Components/CommonLoader.dart';
import 'package:mentivisor/Components/CustomAppButton.dart';
import 'package:mentivisor/Components/CustomSnackBar.dart';
import 'package:mentivisor/Mentor/data/Cubits/PendingSubExpertise/PendingSubExpertisesStates.dart';
import 'package:mentivisor/Mentor/data/Cubits/UpdateExpertise/UpdateExpertiseCubit.dart';
import 'package:mentivisor/Mentor/data/Cubits/UpdateExpertise/UpdateExpertiseStates.dart';
import 'package:mentivisor/Mentor/presentation/widgets/ChipPill.dart';
import 'package:mentivisor/Mentor/presentation/widgets/ErrorView.dart';
import '../Models/PendingSubExpertisesModel.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../data/Cubits/ExpertiseDetails/expertise_details_cubit.dart';
import '../data/Cubits/PendingSubExpertise/PendingSubExpertiseCubit.dart';

class PendingSubExpertisesScreen extends StatefulWidget {
  const PendingSubExpertisesScreen({
    super.key,
    required this.categoryTitle,
    required this.id,
    required this.status,
  });

  final String categoryTitle;
  final String status;
  final int id;

  @override
  State<PendingSubExpertisesScreen> createState() =>
      _PendingExpertisesScreenState();
}

class _PendingExpertisesScreenState extends State<PendingSubExpertisesScreen> {
  // Local working lists
  final List<SubExpertises> _attached = [];
  bool _seeded = false;
  // below your existing lists
  final Set<int> _selectedUnattached = {};

  @override
  void initState() {
    super.initState();
    // trigger the load
    context.read<PendingSubExpertisesCubit>().getPendingSubExpertises(
      widget.id,
      widget.status,
    );
  }

  void _seedLists(Data data) {
    _attached
      ..clear()
      ..addAll(data.subExpertises ?? []);
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
          child:
              BlocBuilder<
                PendingSubExpertisesCubit,
                PendingSubExpertisesStates
              >(
                builder: (context, state) {
                  if (state is PendingSubExpertisesLoading) {
                    return const Center(child: DottedProgressWithLogo());
                  }
                  if (state is PendingSubExpertisesFailure) {
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

                  if (state is PendingSubExpertisesLoaded) {
                    final model = state.pendingSubExpertisesModel;
                    final data = model.data;

                    if (model.status != true || data == null) {
                      return ErrorView(
                        message: 'Failed to load',
                        onRetry: () {
                          _seeded = false;
                          context
                              .read<MentorExpertiseCubit>()
                              .getMentorExpertise(widget.id);
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

                        // Chips area
                        // Chips area
                        Expanded(
                          child: SingleChildScrollView(
                            padding: const EdgeInsets.only(bottom: 24),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Wrap(
                                  spacing: 10,
                                  runSpacing: 10,
                                  children: [
                                    for (final item in _attached)
                                      ChipPill(label: item.name ?? ''),
                                  ],
                                ),
                                const SizedBox(height: 16),
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
    );
  }
}
