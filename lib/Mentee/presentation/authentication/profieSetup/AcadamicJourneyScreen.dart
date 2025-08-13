import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:mentivisor/Components/CustomSnackBar.dart';
import 'package:mentivisor/Mentee/data/cubits/Register/Register_Cubit.dart';
import 'package:mentivisor/Mentee/data/cubits/Register/Registor_State.dart';

import '../../../../Components/CustomAppButton.dart';
import '../../../../utils/color_constants.dart';
import '../../../data/cubits/Campuses/campuses_cubit.dart';
import '../../../data/cubits/Campuses/campuses_states.dart';
import '../../../data/cubits/Years/years_cubit.dart';
import '../../../data/cubits/Years/years_states.dart';

class Acadamicjourneyscreen extends StatefulWidget {
  final Map<String, dynamic> data;
  const Acadamicjourneyscreen({required this.data, Key? key}) : super(key: key);
  @override
  _Acadamicjourneyscreen createState() => _Acadamicjourneyscreen();
}

class _Acadamicjourneyscreen extends State<Acadamicjourneyscreen> {
  final _formKey = GlobalKey<FormState>();
  final _collegeController = TextEditingController();
  final _yearController = TextEditingController();
  final _steamController = TextEditingController();

  @override
  void initState() {
    super.initState();
    context.read<CampusesCubit>().getCampuses();
    context.read<YearsCubit>().getYears();
  }

  @override
  void dispose() {
    _collegeController.dispose();
    _steamController.dispose();
    super.dispose();
  }

  void _onComplete() {
    if (_formKey.currentState!.validate()) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Profile completed!')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          child: Column(
            children: [
              // Top icon + title
              SizedBox(height: 16),
              // Logo/Icon
              Container(
                width: 64,
                height: 64,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [Color(0xFF9333EA), Color(0xFF3B82F6)],
                  ),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Icon(Icons.school, color: Colors.white, size: 32),
              ),
              SizedBox(height: 12),
              Text(
                'Join Mentivisor',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.w600),
              ),
              SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Profile Setup',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                  ),
                  Text(
                    '3 of 4',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),
              SizedBox(height: 8),
              ClipRRect(
                borderRadius: BorderRadius.circular(4),
                child: Stack(
                  children: [
                    Container(height: 6, color: Colors.grey.shade300),
                    LayoutBuilder(
                      builder: (context, constraints) {
                        final progress = 0.75;
                        return Container(
                          height: 6,
                          width: constraints.maxWidth * progress,
                          decoration: BoxDecoration(gradient: kCommonGradient),
                        );
                      },
                    ),
                  ],
                ),
              ),
              SizedBox(height: 24),
              // Form card
              Expanded(
                child: Form(
                  key: _formKey,
                  child: SingleChildScrollView(
                    child: Card(
                      margin: EdgeInsets.all(0),
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Card header
                            Column(
                              children: [
                                Text(
                                  'Your Academic Journey',
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                SizedBox(height: 4),
                                Text(
                                  'Tell us about your current studies and goals',
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w400,
                                    color: Colors.grey[700],
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 24),
                            // College/Institution field
                            Text(
                              'College/Institution',
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            SizedBox(height: 4),
                            TextFormField(
                              controller: _collegeController,
                              readOnly: true,
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w400,
                              ),
                              onTap: () {
                                _openCollegeSelectionBottomSheet(context);
                              },
                              decoration: InputDecoration(
                                hintText: 'Enter your college name',
                                contentPadding: EdgeInsets.symmetric(
                                  horizontal: 12,
                                  vertical: 14,
                                ),
                              ),
                              validator: (val) => val!.isEmpty
                                  ? 'Please enter your college'
                                  : null,
                            ),
                            SizedBox(height: 16),
                            Text(
                              'Current Year/Level',
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            SizedBox(height: 4),
                            TextFormField(
                              controller: _yearController,
                              readOnly: true,
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w400,
                              ),
                              onTap: () {
                                _openYearSelectionBottomSheet(context);
                              },
                              decoration: InputDecoration(
                                hintText: 'Select Year',
                                contentPadding: EdgeInsets.symmetric(
                                  horizontal: 12,
                                  vertical: 14,
                                ),
                              ),
                              validator: (val) =>
                                  val!.isEmpty ? 'Please Select Year' : null,
                            ),
                            SizedBox(height: 16),

                            // Steam field
                            Text(
                              'Stream',
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            SizedBox(height: 4),
                            TextFormField(
                              controller: _steamController,
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w400,
                              ),
                              decoration: InputDecoration(
                                hintText: 'Enter your stream',
                                contentPadding: EdgeInsets.symmetric(
                                  horizontal: 12,
                                  vertical: 14,
                                ),
                              ),
                              validator: (val) => val!.isEmpty
                                  ? 'Please enter your stream'
                                  : null,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                style: TextButton.styleFrom(
                  padding: EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  backgroundColor: Colors.transparent,
                ),
                child: Text(
                  'Back',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w400,
                    color: Color(0xff444444),
                  ),
                ),
              ),
              BlocConsumer<RegisterCubit, RegisterState>(
                listener: (context, state) {
                  if (state is RegisterSucess) {
                    CustomSnackBar1.show(
                      context,
                      state.registerModel.message ?? "",
                    );
                  } else if (state is RegisterFailure) {
                    CustomSnackBar1.show(context, state.message);
                  }
                },
                builder: (context, state) {
                  final isLoading = state is RegisterLoading;
                  return CustomAppButton1(
                    text: "Complete Setup",
                    isLoading: isLoading,
                    radius: 10,
                    width: 200,
                    height: 42,
                    onPlusTap: () {},
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _openCollegeSelectionBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      builder: (BuildContext context) {
        return Container(
          height: MediaQuery.of(context).size.height * 0.6,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: BlocBuilder<CampusesCubit, CampusesStates>(
              builder: (context, state) {
                if (state is CampusesLoading) {
                  return Center(child: CircularProgressIndicator());
                } else if (state is CampusesFailure) {
                  return Center(
                    child: Text(
                      state.error,
                      style: TextStyle(color: Colors.red),
                    ),
                  );
                } else if (state is CampusesLoaded) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Select College",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                      SizedBox(height: 16),
                      Expanded(
                        child: ListView.builder(
                          itemCount: state.campusesModel.data!.length,
                          itemBuilder: (context, index) {
                            return ListTile(
                              title: Text(
                                state.campusesModel.data![index].name!,
                                style: TextStyle(fontSize: 16),
                              ),
                              onTap: () {
                                _collegeController.text =
                                    state.campusesModel.data![index].name!;
                                Navigator.pop(context);
                              },
                            );
                          },
                        ),
                      ),
                    ],
                  );
                } else {
                  return Container();
                }
              },
            ),
          ),
        );
      },
    );
  }

  void _openYearSelectionBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      builder: (BuildContext context) {
        return Container(
          height:
              MediaQuery.of(context).size.height *
              0.6, // Set height to 60% of screen
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: BlocBuilder<YearsCubit, YearsStates>(
              builder: (context, state) {
                if (state is YearsLoading) {
                  return Center(child: CircularProgressIndicator());
                } else if (state is YearsFailure) {
                  return Center(
                    child: Text(
                      state.error,
                      style: TextStyle(color: Colors.red),
                    ),
                  );
                } else if (state is YearsLoaded) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Select Year",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                      SizedBox(height: 16),
                      Expanded(
                        child: ListView.builder(
                          itemCount: state.yearsModel.data!.length,
                          itemBuilder: (context, index) {
                            return ListTile(
                              title: Text(
                                state.yearsModel.data![index].name!,
                                style: TextStyle(fontSize: 16),
                              ),
                              onTap: () {
                                _yearController.text =
                                    state.yearsModel.data![index].name!;
                                Navigator.pop(context);
                              },
                            );
                          },
                        ),
                      ),
                    ],
                  );
                } else {
                  return Container();
                }
              },
            ),
          ),
        );
      },
    );
  }
}
