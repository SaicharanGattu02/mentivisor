import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mentivisor/Components/CommonLoader.dart';
import 'package:mentivisor/utils/AppLauncher.dart';
import 'package:mentivisor/utils/media_query_helper.dart';
import '../../../Components/CutomAppBar.dart';
import '../../../Components/Shimmers.dart';
import '../../data/cubits/CustomerSupport/Mentee_Customersupport_Cubit.dart';
import '../../data/cubits/CustomerSupport/Mentee_Customersupport_States.dart';

class CustomerServiceScreen extends StatelessWidget {
  const CustomerServiceScreen({super.key});

  @override
  Widget build(BuildContext context) {
    context.read<MenteeCustomersupportCubit>().CustomersupportDetails(
      1,
    );

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
                    return const CustomerSupportShimmer();
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
                            GestureDetector(
                              onTap: () {
                                AppLauncher.call(customerSupport?.phone ?? "");
                              },
                              child: Text(
                                customerSupport?.phone ??
                                    'No phone number available',
                                style: TextStyle(
                                  color: Color(0xff3D3D3D),
                                  fontFamily: 'segeo',
                                  fontSize: 14,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 24),
                        Row(
                          children: [
                            Image.asset(
                              "assets/images/gmailimg.png",
                              width: 20,
                              height: 20,
                            ),
                            SizedBox(width: 10),
                            GestureDetector(
                              onTap: () {
                                AppLauncher.email(customerSupport?.email ?? "");
                              },
                              child: Text(
                                customerSupport?.email ?? 'No email available',
                                style: TextStyle(
                                  color: Color(0xff3D3D3D),
                                  fontFamily: 'segeo',
                                  fontSize: 14,
                                  fontWeight: FontWeight.w400,
                                ),
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

class CustomerSupportShimmer extends StatelessWidget {
  const CustomerSupportShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // 🔹 Placeholder for top image
        ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: shimmerContainer(
            MediaQuery.of(context).size.width,
            MediaQuery.of(context).size.height * 0.5,
            context,
          ),
        ),
        const SizedBox(height: 32),

        // 🔹 Section title shimmer
        shimmerText(120, 16, context),
        const SizedBox(height: 10),

        // 🔹 Description shimmer (3 lines)
        shimmerText(double.infinity, 12, context),
        const SizedBox(height: 6),
        shimmerText(250, 12, context),
        const SizedBox(height: 6),
        shimmerText(200, 12, context),

        const SizedBox(height: 32),

        // 🔹 Phone shimmer row
        Row(
          children: [
            shimmerCircle(20, context),
            const SizedBox(width: 10),
            shimmerText(140, 14, context),
          ],
        ),
        const SizedBox(height: 24),

        // 🔹 Email shimmer row
        Row(
          children: [
            shimmerCircle(20, context),
            const SizedBox(width: 10),
            shimmerText(180, 14, context),
          ],
        ),
      ],
    );
  }
}
