import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mentivisor/Components/CutomAppBar.dart';

import '../../Mentor/Models/MentorProfileModel.dart';
import '../data/Cubits/MentorProfile/mentor_profile_cubit.dart';
import '../data/Cubits/MentorProfile/mentor_profile_states.dart';

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
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Color(0xFFF3F7FF), Color(0xFFF7F3FF)],
        ),
      ),
      child: Scaffold(
          backgroundColor: Colors.transparent,
          appBar: CustomAppBar1(title: "Profile", actions: []),
          body: SafeArea(
            child: Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Color(0xFFF3F7FF), Color(0xFFF7F3FF)],
                ),
              ),
              child: BlocBuilder<MentorProfileCubit1, MentorProfileStates>(
                builder: (context, state) {
                  if (state is MentorProfileLoading || state is MentorProfileInitially) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  if (state is MentorProfileFailure) {
                    return Center(child: Text(state.error));
                  }
                  final data = (state as MentorProfile1Loaded).mentorProfileModel.data!;
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
    final year = _toOrdinalYear(data.year);
    final stream = data.stream ?? '';
    final bio = data.reasonForBecomeMentor ?? data.bio ?? '';
    final cost = data.coinsPerMinute ?? '0';
    final langs = (data.languages ?? []).map(_titleCase).toList();

    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const SizedBox(height: 12),
          Stack(
            children: [
              Align(
                alignment: Alignment.center,
                child: CircleAvatar(
                  radius: 70,
                  backgroundColor: Colors.white,
                  child: CircleAvatar(
                    radius: 72,
                    backgroundColor: const Color(0xFFE5E7EB),
                    backgroundImage: photo != null ? NetworkImage(photo) : null,
                    child: photo == null
                        ? const Icon(Icons.person, size: 48, color: Color(0xFF6B7280))
                        : null,
                  ),
                ),
              ),
              Positioned.fill(
                child: Align(
                  alignment: Alignment.topRight,
                  child: InkWell(
                    onTap: () {
                      // TODO: navigate to Edit
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

          const SizedBox(height: 10),

          // Name
          Text(
            name,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontFamily: 'segeo',
              fontWeight: FontWeight.w700,
              fontSize: 18,
              color: Color(0xFF111827),
            ),
          ),

          const SizedBox(height: 10),

          // College + year + stream
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

          const SizedBox(height: 10),

          // Bio / Reason
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

          const SizedBox(height: 18),
          // Per-minute cost
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
              const Icon(Icons.payments_rounded, color: Color(0xFFFFC107)),
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
                                .map((s) => Chip(
                              shape: RoundedRectangleBorder(side: BorderSide(color: Colors.grey),borderRadius: BorderRadiusGeometry.circular(8)),
                              label: Text(
                                s.name ?? '',
                                style: const TextStyle(fontFamily: 'segeo'),
                              ),
                            ))
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
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(999),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF111827).withOpacity(0.06),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
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

// ----- helpers -----
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
