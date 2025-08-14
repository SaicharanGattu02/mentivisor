import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:mentivisor/Components/CustomSnackBar.dart';
import 'package:mentivisor/Mentee/data/cubits/BecomeMentor/become_mentor_state.dart';

import '../../../Components/CustomAppButton.dart';
import '../../../Components/CutomAppBar.dart';
import '../../data/cubits/BecomeMentor/become_mentor_cubit.dart';

class CostPerMinuteScreen extends StatefulWidget {
  final Map<String, dynamic> data;
  CostPerMinuteScreen({super.key, required this.data});
  @override
  State<CostPerMinuteScreen> createState() => _CostPerMinuteScreenState();
}

class _CostPerMinuteScreenState extends State<CostPerMinuteScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar1(title: 'Cost Per Minute', actions: []),

      body: Padding(
        padding: const EdgeInsets.all(8.0),

        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Center(
              child: Image.asset(
                "assets/images/clockimg.png",
                height: 220,
                width: 220,
              ),
            ),
            SizedBox(height: 20),
            Text(
              'Your cost per minute will be',

              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                fontFamily: 'segeo',
              ),
            ),
            SizedBox(height: 10),
            Text(
              '20 Coins',
              style: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.w700,
                color: Color(0xff994DF8),
                fontFamily: 'segeo',
              ),
            ),
            SizedBox(height: 20),
          ],
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.fromLTRB(16, 0, 16, 20),
        child: Column(
          spacing: 10,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              '**Note: 5 coins 1 rupee',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w300,
                color: Color(0xff555555),
                fontFamily: 'segeo',
              ),
            ),
            BlocConsumer<BecomeMentorCubit, BecomeMentorStates>(
              listener: (context, state) {
                if (state is BecomeMentorSuccess) {
                  context.go('/mentor_review');
                } else if (state is BecomeMentorFailure) {
                  CustomSnackBar1.show(context, state.error);
                }
              },
              builder: (context, state) {
                return CustomAppButton1(
                  isLoading: state is BecomeMentorLoading,
                  text: "Okay",
                  onPlusTap: () {
                    context.read<BecomeMentorCubit>().becomeMentor(widget.data);
                  },
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
