import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SuccessScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Become Mentor'),
        backgroundColor: Color(0xffFAF5FF),
      ),
      body: Column(
       
        children: [
         Image.asset("assets/images/sucessscreenimg.png",width: 300,height: 300),
          SizedBox(height: 20),
          Text(
            "That's all! We've got what we need, we'll update you shortly.",
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 20,color: Color(0xff2563EC), fontFamily:'segeo',

              fontWeight: FontWeight.w700),
          ),

        ],
      ),


      bottomNavigationBar: Column(mainAxisSize: MainAxisSize.min
        ,
        children: [

          SafeArea(
            child: Padding(
              padding: EdgeInsets.fromLTRB(16, 0, 16, 20),
              child: InkWell(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => SuccessScreen()),
                  );
                },
                borderRadius: BorderRadius.circular(24),
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [
                        Color(0xFFA258F7),
                        Color(0xFF726CF7),
                        Color(0xFF4280F6),
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(24),
                  ),
                  child: const Center(
                    child: Text(
                      'Done',

                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                        fontFamily: 'segeo',

                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),



    );
  }
}
