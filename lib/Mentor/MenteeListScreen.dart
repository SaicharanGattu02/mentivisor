import 'package:flutter/material.dart';
import 'package:mentivisor/Components/CutomAppBar.dart';

import '../Widgets/Mentor/MenteeCard.dart';

class MenteeListScreen extends StatelessWidget {
  final List<Mentee> mentees = [
    Mentee(
      name: 'Ramesh',
      email: 'ramesh@gmail.com',
      interactionDate: '12th Jun 25',
      rating: 4.5,
    ),
    Mentee(
      name: 'John',
      email: 'john@gmail.com',
      interactionDate: '11th Jun 25',
      rating: 4.2,
    ),
    Mentee(
      name: 'Sarah',
      email: 'sarah@gmail.com',
      interactionDate: '10th Jun 25',
      rating: 4.8,
    ),
    Mentee(
      name: 'Michael',
      email: 'michael@gmail.com',
      interactionDate: '9th Jun 25',
      rating: 4.1,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar1(title: "My Mentee", actions: []),
      body: ListView.builder(
        itemCount: mentees.length,
        itemBuilder: (context, index) {
          return MenteeCard(mentee: mentees[index]);
        },
      ),
    );
  }
}

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
