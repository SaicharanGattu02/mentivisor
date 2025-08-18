import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mentivisor/Components/CutomAppBar.dart';

// import your cubit/repo/model files
// import 'path_to/my_mentee_cubit.dart';
// import 'path_to/my_mentee_states.dart';
// import 'path_to/my_mentees_repo.dart';
// import 'path_to/my_mentees_model.dart';
// import 'path_to/mentor_remote_data_source.dart';

import '../Models/MyMenteesModel.dart';
import '../data/Cubits/MyMentees/mymentees_cubit.dart';
import '../data/Cubits/MyMentees/mymentees_states.dart';
import 'widgets/MenteeCard.dart';

class MenteeListScreen extends StatefulWidget {
  const MenteeListScreen({super.key});

  @override
  State<MenteeListScreen> createState() => _MenteeListScreenState();
}

class _MenteeListScreenState extends State<MenteeListScreen> {
  @override
  void initState() {
    super.initState();
    // Cubit must be provided above this widget via BlocProvider
    context.read<MyMenteeCubit>().getMyMentees();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar1(title: "My Mentee", actions: const []),
      body: BlocBuilder<MyMenteeCubit, MyMenteeStates>(
        builder: (context, state) {
          if (state is MyMenteeLoading || state is MyMenteeInitially) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is MyMenteeFailure) {
            return Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    state.error,
                    style: const TextStyle(fontFamily: 'segeo'),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 12),
                  ElevatedButton(
                    onPressed: () => context.read<MyMenteeCubit>().getMyMentees(),
                    child: const Text("Retry"),
                  ),
                ],
              ),
            );
          }

          // Loaded
          final model = (state as MyMenteeLoaded).myMenteesModel;
          final items = model.data ?? [];

          if (items.isEmpty) {
            return const Center(
              child: Text(
                "No mentees found",
                style: TextStyle(fontFamily: 'segeo'),
              ),
            );
          }

          // Map API Data -> your UI Mentee model for MenteeCard
          final mentees = items.map(_mapDataToUiMentee).toList();

          return ListView.separated(
            itemCount: mentees.length,
            separatorBuilder: (_, __) => const SizedBox(height: 8),
            itemBuilder: (context, index) {
              return MenteeCard(mentee: mentees[index]);
            },
          );
        },
      ),
    );
  }

  // ---------- Adapter: API Data -> your UI Mentee ----------
  Mentee _mapDataToUiMentee(Data d) {
    final last = d.lastSession;
    return Mentee(
      name: d.name ?? '-',
      // You don't have email in API; show menteeId or blank
      email: d.menteeId != null ? "ID: ${d.menteeId}" : "-",
      interactionDate: _formatLastSession(last),
      // No rating in API; set 0.0 or adjust your MenteeCard to not require rating
      rating: 0.0,
    );
  }

  String _formatLastSession(LastSession? s) {
    if (s == null) return "-";
    final date = (s.date ?? "").trim();
    final time = (s.time ?? "").trim();
    if (date.isEmpty && time.isEmpty) return "-";
    // Show exactly as API provides (safe, no parsing assumptions)
    if (date.isNotEmpty && time.isNotEmpty) return "$date, $time";
    return date.isNotEmpty ? date : time;
  }
}

// Keep your UI model so MenteeCard keeps working
class Mentee {
  final String name;
  final String email;
  final String interactionDate;
  final double rating;

  Mentee({
    required this.name,
    required this.email,
    required this.interactionDate,
    required this.rating,
  });
}
