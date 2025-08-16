import 'package:flutter/material.dart';

class CouponsScreen extends StatelessWidget {
  const CouponsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Coupons"),
        centerTitle: true,
        leading: const Icon(Icons.arrow_back),
      ),
      body: Padding(

        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,

          children: [
            // Recent Header
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children:  [
                Text(
                  "Recent",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700,color: Color(0xff121212)),
                ),
                Spacer(),
                Image.asset("assets/images/filterimg.png",height: 32,width: 32),
              ],
            ),
            const SizedBox(height: 12),

            // First Coupon (New)
            Card(
              margin: const EdgeInsets.symmetric(vertical: 8),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12)),
              elevation: 2,
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Left Side
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          "500",
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 6),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: Color(0xff6595FF),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Text(
                            "New",
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w600),
                          ),
                        ),
                        const SizedBox(height: 6),
                        Row(
                          children: const [
                            Icon(Icons.calendar_month, size: 16),
                            SizedBox(width: 5),
                            Text("11 Jun 25"),
                          ],
                        )
                      ],
                    ),

                    // Right Side
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        const Text("Flipkart coupon", style: TextStyle(fontWeight: FontWeight.w600,color: Color(0xff333333),fontFamily: "segeo",fontSize: 12,),),
                        const SizedBox(height: 6),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 6),
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: const Text(
                            "MENTI 500",
                            style: TextStyle(fontWeight: FontWeight.w600,color: Color(0xff121212),fontFamily: "segeo",fontSize: 12,),
                          ),
                        ),
                        const SizedBox(height: 6),
                        const Text("Worth of ₹ 1000",style: TextStyle(color: Color(0xff575757),fontFamily: "segeo",fontSize: 12),),
                      ],
                    ),
                  ],
                ),
              ),
            ),

            // Second Coupon (Redeemed)
            Card(
              margin: const EdgeInsets.symmetric(vertical: 8),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12)),
              elevation: 2,
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Left Side
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            const Text(
                              "500",
                              style: TextStyle(
                                  fontSize: 20, fontWeight: FontWeight.bold),
                            ),

                            Image.asset("assets/images/GoldCoins.png"),



                          ],
                        ),
                        const SizedBox(height: 6),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: Colors.yellow.shade100,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Text(
                            "Redeemed",
                            style: TextStyle(
                                color: Color(0xff333333),
                                fontWeight: FontWeight.w600),
                          ),
                        ),
                        const SizedBox(height: 6),
                        Row(
                          children: const [
                            Icon(Icons.calendar_month, size: 16),
                            SizedBox(width: 5),
                            Text("11 Jun 25"),
                          ],
                        )
                      ],
                    ),

                    // Right Side
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        const Text("Flipkart coupon"),
                        const SizedBox(height: 6),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 6),
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: const Text(
                            "MENTI 500",
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ),
                        const SizedBox(height: 6),
                        const Text("Worth of ₹ 1000"),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}