import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:mentivisor/Components/CommonLoader.dart';
import 'package:mentivisor/Components/CutomAppBar.dart';

import '../../../utils/constants.dart';
import '../../Models/MentorProfileModel.dart';
import '../../data/Cubits/MentorProfile/mentor_profile_cubit.dart';
import '../../data/Cubits/MentorProfile/mentor_profile_states.dart';

class MentorProfileScreen1 extends StatefulWidget {
  const MentorProfileScreen1({super.key});

  @override
  State<MentorProfileScreen1> createState() => _MentorProfileScreenState();
}

class _MentorProfileScreenState extends State<MentorProfileScreen1> {
  @override
  void initState() {
    super.initState();
    context.read<MentorProfileCubit1>().getMentorProfile();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Color(0xFFEFF6FF), Color(0xFFF5F6FF),Color(0xffFAF5FF )],
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: CustomAppBar1(title: "Profile", actions: []),
        body: SafeArea(
          child: Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Color(0xFFEFF6FF), Color(0xFFF5F6FF),Color(0xffFAF5FF )],
              ),
            ),
            child: BlocBuilder<MentorProfileCubit1, MentorProfileStates>(
              builder: (context, state) {
                if (state is MentorProfileLoading ||
                    state is MentorProfileInitially) {
                  return const Center(child: DottedProgressWithLogo());
                }
                if (state is MentorProfileFailure) {
                  return Center(child: Text(state.error));
                }
                final data =
                    (state as MentorProfile1Loaded).mentorProfileModel.data!;
                return _ProfileBody(data: data);
              },
            ),
          ),
        ),
      ),
    );
  }
}

class _ProfileBody extends StatelessWidget {
  final Data data;
  const _ProfileBody({required this.data});

  @override
  Widget build(BuildContext context) {
    final photo = data.profilePic;
    final name = data.name ?? '—';
    final college = data.collegeName ?? '';
    final year = _toOrdinalYear(data.yearName);
    final stream = data.stream ?? '';
    final bio = data.reasonForBecomeMentor ?? data.bio ?? '';
    final cost = data.coinsPerMinute ?? '0';
    final langs = (data.languages ?? []).map(_titleCase).toList();
    return SingleChildScrollView(
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(height: 12),
          Stack(
            children: [
              Align(
                alignment: Alignment.center,
                child: CircleAvatar(
                  radius: 50,
                  backgroundColor: Colors.white,
                  child: CircleAvatar(
                    radius: 72,
                    backgroundColor: const Color(0xFFE5E7EB),
                    backgroundImage: photo != null ? NetworkImage(photo) : null,
                    child: photo == null
                        ? const Icon(
                            Icons.person,
                            size: 48,
                            color: Color(0xFF6B7280),
                          )
                        : null,
                  ),
                ),
              ),
              Positioned.fill(
                child: Align(
                  alignment: Alignment.topRight,
                  child: InkWell(
                    onTap: () {
                      context.push(
                        '/edit_mentor_profile?collegeId=${data.collegeId}',
                      );
                    },
                    child: const Padding(
                      padding: EdgeInsets.only(top: 8.0, right: 4),
                      child: _EditLink(),
                    ),
                  ),
                ),
              ),
            ],
          ),

           SizedBox(height: 10),
          Text(
            capitalize(name),
            textAlign: TextAlign.center,
            style:  TextStyle(
              fontFamily: 'segeo',
              fontWeight: FontWeight.w700,
              fontSize: 18,
              color: Color(0xFF111827),
            ),
          ),
          SizedBox(height: 3),
          Text(
            "$college $year $stream".trim(),
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontFamily: 'segeo',
              fontWeight: FontWeight.w600,
              fontSize: 16,
              color: Color(0xFF6B7280),
            ),
          ),
          SizedBox(height: 3),
          if (bio.isNotEmpty)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 6),
              child: Text(
                bio,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontFamily: 'segeo',
                  fontSize: 14,
                  height: 1.5,
                  fontWeight: FontWeight.w400,
                  color: Color(0xFF6B7280),
                ),
              ),
            ),

          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Per Minute Cost is $cost',
                style: const TextStyle(
                  fontFamily: 'segeo',
                  fontWeight: FontWeight.w700,
                  fontSize: 16,
                  color: Color(0xFF7C3AED),
                ),
              ),
              const SizedBox(width: 8),
              Image.asset(
                "assets/images/GoldCoins.png",
                height: 24,
                width: 24,
                color: Color(0xffFFCC00),
              ),
            ],
          ),
          const SizedBox(height: 30),
          // Languages
          Align(
            alignment: Alignment.centerLeft,
            child: Text(
              'Languages',
              style: const TextStyle(
                fontFamily: 'segeo',
                fontWeight: FontWeight.w700,
                fontSize: 18,
                color: Color(0xFF111827),
              ),
            ),
          ),
          const SizedBox(height: 14),
          Align(
            alignment: Alignment.centerLeft,
            child: Wrap(
              spacing: 12,
              runSpacing: 12,
              children: (langs.isEmpty ? ['English'] : langs)
                  .map((e) => _LangChip(text: e))
                  .toList(),
            ),
          ),

          const SizedBox(height: 30),

          // Expertise (extra section if needed)
          if ((data.expertise ?? []).isNotEmpty) ...[
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Expertise',
                style: const TextStyle(
                  fontFamily: 'segeo',
                  fontWeight: FontWeight.w700,
                  fontSize: 18,
                  color: Color(0xFF111827),
                ),
              ),
            ),
            const SizedBox(height: 14),
            Align(
              alignment: Alignment.centerLeft,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: data.expertise!.map((ex) {
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 8.0),
                    child: Column(
                      spacing: 10,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          ex.name ?? '',
                          style: const TextStyle(
                            fontFamily: 'segeo',
                            fontSize: 18,
                            fontWeight: FontWeight.w700,
                            color: Color(0xFF6B7280),
                          ),
                        ),
                        if ((ex.subExpertises ?? []).isNotEmpty)
                          Wrap(
                            spacing: 8,
                            children: ex.subExpertises!
                                .map(
                                  (s) => Chip(
                                    labelPadding: EdgeInsets.symmetric(horizontal: 16),
                                    shape: RoundedRectangleBorder(
                                      side: BorderSide(color: Colors.white),
                                      borderRadius: BorderRadiusGeometry.circular(36),
                                    ),
                                    label: Text(
                                      s.name ?? '',
                                      style: const TextStyle(
                                        fontFamily: 'segeo',
                                      ),
                                    ),
                                  ),
                                )
                                .toList(),
                          ),
                      ],
                    ),
                  );
                }).toList(),
              ),
            ),
          ],
        ],
      ),
    );
  }
}

// ----- small widgets -----

class _EditLink extends StatelessWidget {
  const _EditLink();

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: const [
        Icon(Icons.edit, size: 18, color: Color(0xFF2563EB)),
        SizedBox(width: 6),
        Text(
          'Edit',
          style: TextStyle(
            fontFamily: 'segeo',
            fontWeight: FontWeight.w800,
            fontSize: 16,
            color: Color(0xFF2563EB),
            decoration: TextDecoration.underline,
            decorationColor: Color(0xFF2563EB),
          ),
        ),
      ],
    );
  }
}

class _LangChip extends StatelessWidget {
  final String text;
  const _LangChip({required this.text});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(100),
      ),
      child: Text(
        text,
        style: const TextStyle(
          fontFamily: 'segeo',
          fontWeight: FontWeight.w400,
          fontSize: 15,
          color: Color(0xFF6B7280),
        ),
      ),
    );
  }
}

String _toOrdinalYear(String? yearRaw) {
  if (yearRaw == null || yearRaw.isEmpty) return '';
  final n = int.tryParse(yearRaw) ?? 0;
  if (n == 0) return '';
  if (n % 100 >= 11 && n % 100 <= 13) return '${n}th year';
  switch (n % 10) {
    case 1:
      return '${n}st year';
    case 2:
      return '${n}nd year';
    case 3:
      return '${n}rd year';
    default:
      return '${n}th year';
  }
}

String _titleCase(String s) {
  if (s.isEmpty) return s;
  return s[0].toUpperCase() + s.substring(1).toLowerCase();
}
