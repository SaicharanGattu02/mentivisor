import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:mentivisor/Components/CommonLoader.dart';

import '../Models/ExpertisesModel.dart';
import '../data/Cubits/Expertises/ApprovedExpertiseCubit.dart';
import '../data/Cubits/Expertises/ExpertiseState.dart';
import '../data/Cubits/Expertises/PendingExpertiseCubit.dart';
import '../data/Cubits/Expertises/RejectedExpertiseCubit.dart';

class ExpertiseScreen extends StatefulWidget {
  const ExpertiseScreen({super.key});

  @override
  State<ExpertiseScreen> createState() => _ExpertiseScreenState();
}

class _ExpertiseScreenState extends State<ExpertiseScreen>
    with SingleTickerProviderStateMixin {
  late final TabController _tab;

  @override
  void initState() {
    super.initState();
    _tab = TabController(length: 3, vsync: this);
    context.read<ApprovedExpertiseCubit>().fetch();
    _tab.addListener(_onTabChanged);
  }

  void _onTabChanged() {
    if (_tab.indexIsChanging) return;

    if (_tab.index == 0) {
      // final st = context.read<ApprovedExpertiseCubit>().state;
      // if (st is ExpertiseInitially || st is ExpertiseFailure) {
      context.read<ApprovedExpertiseCubit>().fetch();
      // }
    } else if (_tab.index == 1) {
      // final st = context.read<PendingExpertiseCubit>().state;
      // if (st is ExpertiseInitially || st is ExpertiseFailure) {
      context.read<PendingExpertiseCubit>().fetch();
      // }
    } else if (_tab.index == 2) {
      // final st = context.read<RejectedExpertiseCubit>().state;
      // if (st is ExpertiseInitially || st is ExpertiseFailure) {
      context.read<RejectedExpertiseCubit>().fetch();
      // }
    }
  }

  @override
  void dispose() {
    _tab.removeListener(_onTabChanged);
    _tab.dispose();
    super.dispose();
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
        child: Column(
          children: [
            const SizedBox(height: 6),
            _SegmentedTabs(controller: _tab),
            const SizedBox(height: 14),
            Expanded(
              child: TabBarView(
                controller: _tab,
                children: [
                  // APPROVED
                  BlocBuilder<ApprovedExpertiseCubit, ExpertiseState>(
                    builder: (context, state) {
                      final showAddButton = state is ExpertiseLoaded
                          ? state.model.data?.has_request
                          : false;
                      return ExpertiseTabFromState(
                        title: 'List',
                        variant: TileVariant.approved,
                        state: state,
                        onRetry: () =>
                            context.read<ApprovedExpertiseCubit>().fetch(),
                        showAddButton: !(showAddButton ?? false),
                        onItemTap: (label) {
                          context.push(
                            "/expertise_details?id=${label.id}&categoryTitle=${label.name}",
                          );
                        },
                      );
                    },
                  ),

                  // PENDING
                  BlocBuilder<PendingExpertiseCubit, ExpertiseState>(
                    builder: (context, state) {
                      return ExpertiseTabFromState(
                        title: 'List',
                        variant: TileVariant.pending,
                        state: state,
                        onRetry: () =>
                            context.read<PendingExpertiseCubit>().fetch(),
                        onItemTap: (label) {
                          context.push(
                            "/pending_sub_expertise?id=${label.id}&categoryTitle=${label.name}&status=requested",
                          );
                        },
                      );
                    },
                  ),

                  // REJECTED
                  BlocBuilder<RejectedExpertiseCubit, ExpertiseState>(
                    builder: (context, state) {
                      return ExpertiseTabFromState(
                        title: 'List',
                        variant: TileVariant.rejected,
                        state: state,
                        onRetry: () =>
                            context.read<RejectedExpertiseCubit>().fetch(),
                        onItemTap: (label) {
                          context.push(
                            "/pending_sub_expertise?id=${label.id}&categoryTitle=${label.name}&status=rejected",
                          );
                        },
                      );
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SegmentedTabs extends StatelessWidget {
  const _SegmentedTabs({required this.controller});
  final TabController controller;

  @override
  Widget build(BuildContext context) {
    const segBg = Color(0xFFEFF2FF);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Container(
        height: 53,
        decoration: BoxDecoration(
          color: segBg,
          borderRadius: BorderRadius.circular(100),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
          child: TabBar(
            controller: controller,
            overlayColor: WidgetStateProperty.all(Colors.transparent),
            indicatorSize: TabBarIndicatorSize.tab,
            dividerColor: Colors.transparent,
            labelStyle: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w700,
            ),
            unselectedLabelStyle: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
            ),
            labelColor: const Color(0xff4076ED),
            unselectedLabelColor: const Color(0xFF666666),
            indicator: BoxDecoration(
              color: const Color(0xff4076ED).withOpacity(0.1),
              borderRadius: BorderRadius.circular(100),
            ),
            tabs: const [
              Tab(text: 'Approved'),
              Tab(text: 'Pending'),
              Tab(text: 'Rejected'),
            ],
          ),
        ),
      ),
    );
  }
}

List<String> _expertiseNames(ExpertisesModel m) =>
    m.data?.expertises
        ?.map((e) => e.name ?? '')
        .where((s) => s.isNotEmpty)
        .toList() ??
    const [];

class ExpertiseTabFromState extends StatelessWidget {
  const ExpertiseTabFromState({
    super.key,
    required this.title,
    required this.variant,
    required this.state,
    required this.onRetry,
    required this.onItemTap, // void Function(Expertises)
    this.showAddButton = false,
    this.onAdd,
  });

  final String title;
  final TileVariant variant;
  final ExpertiseState state;
  final Future<void> Function() onRetry;
  final void Function(Expertises) onItemTap; // ⬅️ changed
  final bool showAddButton;
  final VoidCallback? onAdd;

  @override
  Widget build(BuildContext context) {
    if (state is ExpertiseInitially || state is ExpertiseLoading) {
      return const Center(child: DottedProgressWithLogo());
    }
    if (state is ExpertiseFailure) {
      final msg = (state as ExpertiseFailure).message;
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              msg.isNotEmpty ? msg : 'Failed to load',
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 13, color: Colors.red),
            ),
            const SizedBox(height: 10),
            ElevatedButton(onPressed: onRetry, child: const Text('Retry')),
          ],
        ),
      );
    }

    final model = (state as ExpertiseLoaded).model;
    final items = model.data?.expertises ?? []; // ⬅️ now objects

    if (items.isEmpty) {
      return RefreshIndicator(
        onRefresh: onRetry,
        child: ListView(
          children: const [
            SizedBox(height: 120),
            Center(
              child: Text(
                'No items found',
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
              ),
            ),
          ],
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: onRetry,
      child: _ExpertiseListTab(
        title: title,
        items: items, // ⬅️ pass objects
        variant: variant,
        showAddButton: showAddButton,
        onAdd: onAdd,
        onItemTap: onItemTap, // ⬅️ callback with object
      ),
    );
  }
}

enum TileVariant { approved, pending, rejected }

class _ExpertiseListTab extends StatelessWidget {
  const _ExpertiseListTab({
    required this.title,
    required this.items, // ← List<Expertises>
    required this.variant,
    required this.onItemTap, // ← void Function(Expertises)
    this.showAddButton = false,
    this.onAdd,
  });

  final String title;
  final List<Expertises> items; // ⬅️ changed
  final TileVariant variant;
  final bool showAddButton;
  final VoidCallback? onAdd;
  final void Function(Expertises) onItemTap; // ⬅️ changed

  Color _tileColor() {
    switch (variant) {
      case TileVariant.approved:
        return Colors.white;
      case TileVariant.pending:
        return const Color(0xFFFFEFD5);
      case TileVariant.rejected:
        return const Color(0xFFFFD7D7);
    }
  }

  BoxBorder? _tileBorder() => variant == TileVariant.approved
      ? Border.all(color: const Color(0xFFE6E6E9))
      : null;

  @override
  Widget build(BuildContext context) {
    final tileColor = _tileColor();

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        children: [
          Row(
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF121212),
                ),
              ),
              const Spacer(),
              if (showAddButton) const SizedBox(width: 8),
              if (showAddButton)
                AddChip(
                  onPressed:
                      onAdd ??
                      () {
                        context.push("/add_expertise");
                      },
                ),
            ],
          ),
          const SizedBox(height: 10),
          Expanded(
            child: ListView.separated(
              itemCount: items.length,
              padding: const EdgeInsets.only(bottom: 8),
              separatorBuilder: (_, __) => const SizedBox(height: 10),
              itemBuilder: (context, i) {
                final item = items[i]; // ⬅️ an Expertises
                final label = item.name ?? ''; // for display
                return InkWell(
                  borderRadius: BorderRadius.circular(12),
                  onTap: () => onItemTap(item), // ⬅️ pass object
                  child: Container(
                    height: 52,
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    decoration: BoxDecoration(
                      color: tileColor,
                      borderRadius: BorderRadius.circular(12),
                      border: _tileBorder(),
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: Text(
                            label,
                            style: const TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                        const Icon(Icons.chevron_right_rounded, size: 18),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

/// Small rounded “Add new” button used in the list header.
class AddChip extends StatelessWidget {
  const AddChip({super.key, required this.onPressed});
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    const primary = Color(0xFF9C5BF7);
    return Material(
      color: primary,
      borderRadius: BorderRadius.circular(16),
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(16),
        child: const Padding(
          padding: EdgeInsets.symmetric(horizontal: 10, vertical: 6),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.add_rounded, size: 16, color: Colors.white),
              SizedBox(width: 6),
              Text(
                'Add new',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 12,
                  fontFamily: "segeo",
                  fontWeight: FontWeight.w800,
                  letterSpacing: .2,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
