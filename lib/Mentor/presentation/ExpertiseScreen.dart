import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:mentivisor/Components/CommonLoader.dart';
import 'package:mentivisor/Components/CutomAppBar.dart';
import 'package:mentivisor/Mentor/data/Cubits/Expertises/ApprovedExpertise/ApprovedExpertiseState.dart';
import 'package:mentivisor/Mentor/presentation/widgets/ExpertiseShimmerLoader.dart';

import '../Models/ExpertisesModel.dart';
import '../data/Cubits/Expertises/ApprovedExpertise/ApprovedExpertiseCubit.dart';
import '../data/Cubits/Expertises/ExpertiseState.dart';
import '../data/Cubits/Expertises/PendingExpertise/PendingExpertiseCubit.dart';
import '../data/Cubits/Expertises/PendingExpertise/PendingExpertiseStates.dart';
import '../data/Cubits/Expertises/RejectedExpertise/RejectedExpertiseCubit.dart';
import '../data/Cubits/Expertises/RejectedExpertise/RejectedExpertiseStates.dart';

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

  void _onTabChanged() async {
    if (_tab.indexIsChanging) return;

    if (_tab.index == 0) {
      context.read<ApprovedExpertiseCubit>().reset();
      await Future.delayed(const Duration(milliseconds: 100));
      context.read<ApprovedExpertiseCubit>().fetch();
    } else if (_tab.index == 1) {
      context.read<PendingExpertiseCubit>().reset();
      await Future.delayed(const Duration(milliseconds: 100));
      context.read<PendingExpertiseCubit>().fetch();
    } else if (_tab.index == 2) {
      context.read<RejectedExpertiseCubit>().reset();
      await Future.delayed(const Duration(milliseconds: 100));
      context.read<RejectedExpertiseCubit>().fetch();
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
      appBar: CustomAppBar1(title: 'Expertise', actions: []),
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
                  // ✅ APPROVED TAB
                  BlocBuilder<ApprovedExpertiseCubit, ApprovedExpertiseState>(
                    builder: (context, approveState) {
                      bool showAddButton = false;
                      if (approveState is ApprovedExpertiseLoaded) {
                        showAddButton = !(approveState.model.data?.has_request ?? false);
                      }
                      return ExpertiseTabFromState(
                        title: 'List',
                        variant: TileVariant.approved,
                        state: approveState,
                        onRetry: () =>
                            context.read<ApprovedExpertiseCubit>().fetch(),
                        showAddButton: showAddButton,
                        onItemTap: (label) {
                          context.push(
                            "/expertise_details?id=${label.id}&categoryTitle=${label.name}",
                          );
                        },
                      );
                    },
                  ),

                  // ✅ PENDING TAB
                  BlocBuilder<PendingExpertiseCubit, PendingExpertiseState>(
                    builder: (context, pendingState) {
                      return ExpertiseTabFromState(
                        title: 'List',
                        variant: TileVariant.pending,
                        state: pendingState,
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

                  // ✅ REJECTED TAB
                  BlocBuilder<RejectedExpertiseCubit, RejectedExpertiseState>(
                    builder: (context, rejectedState) {
                      return ExpertiseTabFromState(
                        title: 'List',
                        variant: TileVariant.rejected,
                        state: rejectedState,
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

// List<String> _expertiseNames(ExpertisesModel m) =>
//     m.data?.expertises
//         ?.map((e) => e.name ?? '')
//         .where((s) => s.isNotEmpty)
//         .toList() ??
//     const [];
class ExpertiseTabFromState<T extends Object> extends StatelessWidget {
  const ExpertiseTabFromState({
    super.key,
    required this.title,
    required this.variant,
    required this.state,
    required this.onRetry,
    required this.onItemTap,
    this.showAddButton = false,
    this.onAdd,
  });

  final String title;
  final TileVariant variant;
  final T state;
  final Future<void> Function() onRetry;
  final void Function(Expertises) onItemTap;
  final bool showAddButton;
  final VoidCallback? onAdd;

  bool get _isLoading =>
      state is ApprovedExpertiseLoading ||
          state is PendingExpertiseLoading ||
          state is RejectedExpertiseLoading;

  bool get _isInitial =>
      state is ApprovedExpertiseInitial ||
          state is PendingExpertiseInitial ||
          state is RejectedExpertiseInitial;

  bool get _isFailure =>
      state is ApprovedExpertiseFailure ||
          state is PendingExpertiseFailure ||
          state is RejectedExpertiseFailure;

  bool get _isLoaded =>
      state is ApprovedExpertiseLoaded ||
          state is PendingExpertiseLoaded ||
          state is RejectedExpertiseLoaded;

  @override
  Widget build(BuildContext context) {
    // 🌀 Shimmer for loading / initial
    if (_isInitial || _isLoading) {
      return const ExpertiseShimmerLoader(itemCount: 6);
    }

    // ❌ Error case
    if (_isFailure) {
      final message = (state as dynamic).message ?? 'Failed to load data';
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              message,
              style: const TextStyle(fontSize: 13, color: Colors.red),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 10),
            ElevatedButton(onPressed: onRetry, child: const Text('Retry')),
          ],
        ),
      );
    }

    // ✅ Success case
    if (_isLoaded) {
      final model = (state as dynamic).model;
      final items = model.data?.expertises ?? [];

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
          items: items,
          variant: variant,
          showAddButton: showAddButton,
          onAdd: onAdd,
          onItemTap: onItemTap,
        ),
      );
    }

    return const SizedBox.shrink();
  }
}

// class ExpertiseTabFromState extends StatelessWidget {
//   const ExpertiseTabFromState({
//     super.key,
//     required this.title,
//     required this.variant,
//     required this.state,
//     required this.onRetry,
//     required this.onItemTap, // void Function(Expertises)
//     this.showAddButton = false,
//     this.onAdd,
//   });
//
//   final String title;
//   final TileVariant variant;
//   final ExpertiseState state;
//   final Future<void> Function() onRetry;
//   final void Function(Expertises) onItemTap; // ⬅️ changed
//   final bool showAddButton;
//   final VoidCallback? onAdd;
//
//   @override
//   Widget build(BuildContext context) {
//     if (state is ExpertiseInitially || state is ExpertiseLoading) {
//       return const ExpertiseShimmerLoader(itemCount: 6);
//     }
//     if (state is ExpertiseFailure) {
//       final msg = (state as ExpertiseFailure).message;
//       return Center(
//         child: Column(
//           mainAxisSize: MainAxisSize.min,
//           children: [
//             Text(
//               msg.isNotEmpty ? msg : 'Failed to load',
//               textAlign: TextAlign.center,
//               style: const TextStyle(fontSize: 13, color: Colors.red),
//             ),
//             const SizedBox(height: 10),
//             ElevatedButton(onPressed: onRetry, child: const Text('Retry')),
//           ],
//         ),
//       );
//     }
//
//     final model = (state as ExpertiseLoaded).model;
//     final items = model.data?.expertises ?? []; // ⬅️ now objects
//
//     if (items.isEmpty) {
//       return RefreshIndicator(
//         onRefresh: onRetry,
//         child: ListView(
//           children: const [
//             SizedBox(height: 120),
//             Center(
//               child: Text(
//                 'No items found',
//                 style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
//               ),
//             ),
//           ],
//         ),
//       );
//     }
//
//     return RefreshIndicator(
//       onRefresh: onRetry,
//       child: _ExpertiseListTab(
//         title: title,
//         items: items, // ⬅️ pass objects
//         variant: variant,
//         showAddButton: showAddButton,
//         onAdd: onAdd,
//         onItemTap: onItemTap, // ⬅️ callback with object
//       ),
//     );
//   }
// }

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
