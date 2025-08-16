import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mentivisor/Components/CutomAppBar.dart';

import '../data/cubits/ExclusiveServiceDetails/ExclusiveServiceDetails_Cubit.dart';
import 'Widgets/CommonBackground.dart';

class ExclusiveServiceDetails extends StatefulWidget {
  final int id;
  const ExclusiveServiceDetails({super.key, required this.id});

  @override
  State<ExclusiveServiceDetails> createState() =>
      _ExclusiveServiceDetailsState();
}

class _ExclusiveServiceDetailsState extends State<ExclusiveServiceDetails> {
  @override
  void initState() {
    context.read<ExclusiveservicedetailsCubit>().exclusiveServiceDetails(
      widget.id,
    );
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar1(title: "Exclusive Service Details", actions: []),
      body: Background(
        child: SafeArea(
          child: Column(
            children: [

              Expanded(
                child: SingleChildScrollView(
                  padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: GestureDetector(
                    onTap: () {},
                    child: Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      elevation: 2,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Banner image
                          ClipRRect(
                            borderRadius: BorderRadius.vertical(
                              top: Radius.circular(12),
                            ),
                            child: Image.asset(
                              "assets/images/bannerimg.png",

                              height: 192,

                              width: 480,
                              fit: BoxFit.cover,
                            ),
                          ),

                          Padding(
                            padding: const EdgeInsets.all(12.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // Avatar + name
                                Row(
                                  children: [
                                    CircleAvatar(
                                      radius: 16,
                                      backgroundImage: AssetImage(
                                        'assets/images/bannerimg.png',
                                      ),
                                    ),
                                    SizedBox(width: 8),
                                    Text(
                                      "userName",
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 14,
                                        fontFamily: 'segeo',
                                      ),
                                    ),
                                  ],
                                ),

                                SizedBox(height: 12),

                                // Title
                                Text(
                                  "title",
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Color(0xff222222),
                                    fontWeight: FontWeight.w700,
                                    fontFamily: 'segeo',
                                  ),
                                ),

                                SizedBox(height: 8),

                                // Description text
                                Text(
                                  "description",
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Color(0xff666666),
                                    fontWeight: FontWeight.w400,
                                    fontFamily: 'segeo',
                                  ),
                                ),

                                SizedBox(height: 12),

                                // Clickable link
                                GestureDetector(
                                  onTap: () {

                                  },
                                  child: Text(
                                    'Visit this link to access the exclusive service.\nClick here',
                                    style: TextStyle(
                                      decoration: TextDecoration.underline,
                                      fontSize: 14,
                                      color: Color(0xff9D5AF7),
                                      fontWeight: FontWeight.w700,
                                      fontFamily: 'segeo',
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),

              // Footer info
              Padding(
                padding: const EdgeInsets.symmetric(
                  vertical: 12.0,
                  horizontal: 16.0,
                ),
                child: Text(
                  'To post your services mail to rohit@gmail.com',
                  style: TextStyle(fontSize: 14, color: Colors.black54),
                  textAlign: TextAlign.center,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
