import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../data/cubits/Campuses/campuses_cubit.dart';
import '../../data/cubits/Campuses/campuses_states.dart';

class CollegeSelectionSheet extends StatelessWidget {
  final Function(String name, int id) onSelect;

  const CollegeSelectionSheet({super.key, required this.onSelect});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.6,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: BlocBuilder<CampusesCubit, CampusesStates>(
          builder: (context, state) {
            if (state is CampusesLoading) {
              return const Center(child: CircularProgressIndicator());
            }

            if (state is CampusesFailure) {
              return Center(
                child: Text(
                  state.error,
                  style: const TextStyle(color: Colors.red),
                ),
              );
            }

            if (state is CampusesLoaded) {
              final campuses = state.campusesModel.data?.campuses??[];

              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Select College",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 16),

                  /// ⭐ CustomScrollView instead of ListView.builder
                  Expanded(
                    child: CustomScrollView(
                      slivers: [
                        SliverList.builder(
                          itemCount: campuses.length,
                          itemBuilder: (context, index) {
                            final item = campuses[index];
                            return ListTile(
                              title: Text(
                                item.name!,
                                style: const TextStyle(fontSize: 16),
                              ),
                              onTap: () {
                                onSelect(item.name!, item.id!);
                                Navigator.pop(context);
                              },
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                ],
              );
            }

            return const SizedBox();
          },
        ),
      ),
    );
  }
}
