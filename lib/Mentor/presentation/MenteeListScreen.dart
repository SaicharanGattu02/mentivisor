import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mentivisor/Components/CutomAppBar.dart';
import 'package:mentivisor/utils/AppLogger.dart';
import '../data/Cubits/MyMentees/mymentees_cubit.dart';
import '../data/Cubits/MyMentees/mymentees_states.dart';

class MenteeListScreen extends StatefulWidget {
  const MenteeListScreen({super.key});

  @override
  State<MenteeListScreen> createState() => _MenteeListScreenState();
}

class _MenteeListScreenState extends State<MenteeListScreen> {
  @override
  void initState() {
    super.initState();
    context.read<MyMenteeCubit>().getMyMentees();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar1(title: "My Mentee", actions: const []),
      body: BlocBuilder<MyMenteeCubit, MyMenteeStates>(
        builder: (context, state) {
          if (state is MyMenteeLoading) {
            return const Center(child: CircularProgressIndicator());
          }else if (state is MyMenteeLoaded) {
            final mentees = state.myMenteesModel.data ?? [];
            AppLogger.info("mentees data    : ${mentees}");
            return ListView.separated(
              itemCount: mentees.length,
              separatorBuilder: (_, __) => const SizedBox(height: 8),
              itemBuilder: (context, index) {
                final mentee = mentees[index];
                AppLogger.info("Name   : ${mentee.name}");
                return Card(
                  margin: const EdgeInsets.all(10),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                  elevation: 5,
                  child: ListTile(
                    leading: ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: mentee.profilePic != null
                          ? Image.network(
                        mentee.profilePic!,
                        width: 60,
                        height: 60,
                        fit: BoxFit.cover,
                      )
                          : Image.asset("assets/images/image.png", width: 60, height: 60),
                    ),
                    title: Text(mentee.name ?? ""),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(mentee.email ?? ""),
                        const SizedBox(height: 4),
                        Text(
                          "Last interaction: ${mentee.sessionDetails?.isNotEmpty == true ? mentee.sessionDetails!.last.sessionDate : "N/A"}",
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          } else if (state is MyMenteeFailure){
            return Text(state.error);
          }
          return Center(child: Text("No Data"),);
        },
      ),
    );
  }
}

