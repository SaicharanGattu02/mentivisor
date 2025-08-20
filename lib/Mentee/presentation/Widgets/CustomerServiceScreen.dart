import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mentivisor/utils/media_query_helper.dart'; // Ensure you have this helper file
import 'package:mentivisor/Mentee/Models/MenteeCustmor_supportModel.dart'; // Your model
import '../../../Components/CutomAppBar.dart';
import '../../data/cubits/CustomerSupport/Mentee_Customersupport_Cubit.dart';
import '../../data/cubits/CustomerSupport/Mentee_Customersupport_States.dart'; // Ensure correct import

class CustomerServiceScreen extends StatelessWidget {
  const CustomerServiceScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Triggering the fetch operation when the screen is built
    context.read<MenteeCustomersupportCubit>().exclusiveServiceDetails(
      1,
    ); // Example ID

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: CustomAppBar1(title: "Customer Service", actions: []),
      body: SafeArea(
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              BlocBuilder<
                MenteeCustomersupportCubit,
                MenteeCustomersupportStates
              >(
                builder: (context, state) {
                  if (state is MenteeCustomersupportLoading) {
                    return Center(child: CircularProgressIndicator());
                  }

                  if (state is MenteeCustomersupportFailure) {
                    return Center(child: Text('Error: ${state.msg}'));
                  }

                  if (state is MenteeCustomersupportLoaded) {
                    final customerSupport =
                        state.menteeCustmor_supportModel.data;

                    return Column(


                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Image.asset(
                          "assets/images/customer_service.png",
                          height: SizeConfig.screenHeight * 0.5,
                          width: SizeConfig.screenWidth,
                        ),
                        SizedBox(height: 32),
                        Text(
                          'Description',
                          style: TextStyle(
                            color: Color(0xff000000),
                            fontFamily: 'segeo',
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        SizedBox(height: 10),
                        Text(
                          customerSupport?.description ??
                              'No description available',
                          style: TextStyle(
                            color: Color(0xff575757),
                            fontFamily: 'segeo',
                            fontSize: 13,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                        SizedBox(height: 32),
                        Row(
                          children: [
                            Image.asset(
                              "assets/images/telephoneimg.png",
                              width: 20,
                              height: 20,
                            ),
                            SizedBox(width: 10),
                            Text(
                              customerSupport?.phone ??
                                  'No phone number available',
                              style: TextStyle(
                                color: Color(0xff3D3D3D),
                                fontFamily: 'segeo',
                                fontSize: 14,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 24,),
                        Row(
                          children: [
                            Image.asset(
                              "assets/images/gmailimg.png",
                              width: 20,
                              height: 20,
                            ),
                            SizedBox(width: 10),
                            Text(
                              customerSupport?.email ?? 'No email available',
                              style: TextStyle(
                                color: Color(0xff3D3D3D),
                                fontFamily: 'segeo',
                                fontSize: 14,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ],
                        ),
                      ],
                    );
                  }

                  return Center(child: Text('Unexpected state'));
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
