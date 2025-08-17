import 'dart:ui';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mentivisor/Components/CutomAppBar.dart';
import 'package:mentivisor/utils/media_query_helper.dart';


class CustomerServiceScreen extends StatelessWidget {
  const CustomerServiceScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: CustomAppBar1(title: "Customer Service", actions: []),
      body: SafeArea(
        child: Container(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Image.asset(
                "assets/images/customer_service.png",
                height: SizeConfig.screenHeight * 0.3,
                width: SizeConfig.screenWidth,
              ),
              SizedBox(height: 32),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 16, vertical: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Description',
                      style: TextStyle(
                        color: Color(0xff000000),
                        fontFamily: 'segeo',
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    SizedBox(height: 20),
                    Text(
                      'Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry s standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book',
                      style: TextStyle(
                        color: Color(0xff575757),
                        fontFamily: 'segeo',
                        fontSize: 13,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 10, top: 32),
                      child: Row(
                        spacing: 10,
                        children: [
                          Icon(Icons.call, color: Colors.blue),
                          Text(
                            "+91 8448484848",
                            style: TextStyle(
                              color: Color(0xff3D3D3D),
                              fontFamily: 'segeo',
                              fontSize: 14,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(left: 10, top: 32),
                      child: Row(
                        spacing: 10,
                        children: [
                          Icon(Icons.email_outlined),
                          Text(
                            "Mentivisor123@gamil.com",
                            style: TextStyle(
                              color: Color(0xff3D3D3D),
                              fontFamily: 'segeo',
                              fontSize: 14,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
