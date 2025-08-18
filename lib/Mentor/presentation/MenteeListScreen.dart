import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mentivisor/Components/CutomAppBar.dart';
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
          }else if(state is MyMenteeLoaded){
              return ListView.separated(
              itemCount: state.myMenteesModel.data?.length??0,
              separatorBuilder: (_, __) => const SizedBox(height: 8),
              itemBuilder: (context, index) {
                final menteeList =state.myMenteesModel.data?[index];
                return MenteeCard(mentee: menteeList!);
              },
            );

          }else if (state is MyMenteeFailure){
            return Text(state.error);
          }
          return Center(child: Text("No Data"),);

        },
      ),
    );
  }
}

