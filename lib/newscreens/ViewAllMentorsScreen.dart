import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../Mentor/MentorHomeScreen.dart';
import '../bloc/TopMentors/TopMentors_Cubit.dart';
import '../bloc/TopMentors/TopMentors_State.dart';
import '../utils/color_constants.dart';

class ViewAllMentorsScreen extends StatefulWidget {
  const ViewAllMentorsScreen({super.key});

  @override
  State<ViewAllMentorsScreen> createState() => _ViewAllMentorsScreenState();
}

class _ViewAllMentorsScreenState extends State<ViewAllMentorsScreen> {
  String searchQuery = '';

  int _calculateCrossAxisCount(double width) {
    if (width >= 1000) return 4;
    if (width >= 700) return 3;
    return 2;
  }
  final TextEditingController searchController = TextEditingController();
  Timer? _debounce;

  @override
  void initState() {
    super.initState();
    context.read<TopmentorsCubit>().topmentors();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xffFAF5FF),
        elevation: 0,
        leading: const BackButton(color: Colors.black),
        centerTitle: true,
        title: const Text(
          'On campus Mentors',
          style: TextStyle(
            fontFamily: 'Sugeo',
            fontWeight: FontWeight.w600,
            fontSize: 16,
            color: Color(0xff222222),
          ),
        ),
      ),

      backgroundColor: const Color(0xFFF5F8FF),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0,vertical: 20),
        child: Column(
          children: [
            SizedBox(
              height: 48,
              child: TextField(
                controller: searchController,
                cursorColor: primarycolor,
                onChanged: (query) {
                  if (_debounce?.isActive ?? false) _debounce!.cancel();
                  _debounce = Timer(const Duration(milliseconds: 300), () {
                    context.read<TopmentorsCubit>().topmentors();
                  });
                },
                style: const TextStyle(fontFamily: "Poppins", fontSize: 15),
                decoration: InputDecoration(
                  hintText: 'Search by employee name, phone',
                  prefixIcon: const Icon(Icons.search),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(100),
                    borderSide: BorderSide(color: primarycolor, width: 0.5),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(100),
                    borderSide: BorderSide(color: primarycolor, width: 0.5),
                  ),
                ),
              ),
            ),
            BlocBuilder<TopmentorsCubit, TopmentorsState>(
              builder: (context, state) {
                if (state is TopmentorStateLoading) {
                  return const SizedBox(
                    height: 200,
                    child: Center(child: CircularProgressIndicator()),
                  );
                }
                if (state is TopmentorStateFailure) {
                  return SizedBox(
                    height: 200,
                    child: Center(child: Text(state.msg ?? 'Failed to load')),
                  );
                }
                final list =
                    (state as TopmentorStateLoaded)
                        .topmentersresponsemodel
                        .data
                        ?.mentordata ??
                        [];
                if (list.isEmpty) {
                  return const SizedBox(
                    height: 200,
                    child: Center(child: Text('No mentors found')),
                  );
                }
                return GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: list.length,
                  gridDelegate:
                  const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 16,
                    mainAxisSpacing: 16,
                    childAspectRatio: 0.75,
                  ),
                  itemBuilder: (ctx, i) {
                    final m = list[i];
                    return GestureDetector(
                      onTap: () =>
                          Navigator.pushNamed(context, '/mentor/${m.id}'),
                      child: Column(
                        children: [
                          CircleAvatar(
                            radius: 60,
                            backgroundColor: Colors.grey.shade200,
                            backgroundImage:
                            m.profilePicUrl != null &&
                                m.profilePicUrl!.isNotEmpty
                                ? CachedNetworkImageProvider(m.profilePicUrl!)
                                : null,
                            child:
                            (m.profilePicUrl == null ||
                                m.profilePicUrl!.isEmpty)
                                ? const Icon(
                              Icons.person,
                              size: 60,
                              color: Colors.grey,
                            )
                                : null,
                          ),
                          const SizedBox(height: 8),
                          Text(
                            m.name ?? '',
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              fontSize: 16,
                              fontFamily: 'segeo',
                              fontWeight: FontWeight.w400,
                              color: Color(0xff333333),
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            m.designation ?? '',
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              color: Color(0xff555555),
                              fontFamily: 'segeo',
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                          SizedBox(height: 24),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Image.asset(
                                "assets/images/starvector.png",
                                color: Colors.amber,
                                height: 14,
                                width: 14,
                              ),
                              const SizedBox(width: 4),
                              Text(
                                m.ratingsReceivedAvgRating?.toStringAsFixed(
                                  1,
                                ) ??
                                    '0.0',
                                style: const TextStyle(
                                  fontSize: 12,
                                  fontFamily: 'segeo',
                                  color: Color(0xff333333),

                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                              const SizedBox(width: 8),
                              Image.asset(
                                "assets/images/coinsgold.png",
                                height: 16,
                                width: 16,
                              ),
                              const SizedBox(width: 4),
                              Text(
                                '${m.ratingsReceivedCount ?? 0}',
                                style: const TextStyle(
                                  fontSize: 12,
                                  color: Color(0xff666666),
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    );
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
