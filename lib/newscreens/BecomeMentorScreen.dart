import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:mentivisor/Mentee/presentation/Widgets/CommonBackground.dart';

class BecomeMentorScreen extends StatelessWidget {
  const BecomeMentorScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xffFAF5FF),
      appBar: AppBar(
        backgroundColor: Color(0xffFAF5FF),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Text(
          'Become mentor',
          style: TextStyle(color: Color(0xff222222), fontWeight: FontWeight.w600, fontSize: 16, fontFamily: 'segeo',),
        ),
        centerTitle: true,
      ),
      body: Background(
        child: Padding(
        
        
          padding: const EdgeInsets.all(16),
        
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
        
              SizedBox(
                height: 380,
                width: 380,
                child: Image.asset('images/becomementorimg.png'),
              ),
              const SizedBox(height: 24),
              const Text(
                'Hey Shivaji',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.w600, fontFamily: 'segeo',color: Color(0xff2563EC)),
              ),
              const SizedBox(height: 8),
              const Text(
                'Nice to see you become the mentor! Let’s start with these basic details',
                style: TextStyle(color: Color(0xff333333),fontSize:16, fontFamily: 'segeo',),
              ),
              const SizedBox(height: 24),
              const Text(
                'Why you want to become mentor',
                style: TextStyle(fontWeight: FontWeight.w600, fontFamily: 'segeo',fontSize: 14,color: Color(0xff444444)),
              ),
              const SizedBox(height: 18),
              Center(
                child: TextField(
                  maxLines: 4,
                  decoration: InputDecoration(
                    hintText: 'Explain here',
                    filled: true,
                    fillColor: Colors.white, // inside background
                    contentPadding: EdgeInsets.all(16), // space inside
                    // border: OutlineInputBorder(
                    //   borderRadius: BorderRadius.circular(24), // rounded corners
                    //   borderSide: BorderSide(
                    //     color: Colors.grey.shade400, // default border color
                    //     width: 1.5, // thickness
                    //   ),
                    // ),
                    // enabledBorder: OutlineInputBorder(
                    //   borderRadius: BorderRadius.circular(24),
                    //   borderSide: BorderSide(
                    //     color: Colors.grey.shade400, // inline border when not focused
                    //     width: 1.5,
                    //   ),
                    // ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(24),
                      borderSide: BorderSide(
                        color: Colors.blue, // border color when focused
                        width: 1.8,
                      ),
                    ),
                  ),
                ),
              ),
             SizedBox(height: 30,),
              InkWell(
              onTap: () {
            context.push("/InterestingScreen");
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
                      'Next',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontFamily: 'segeo',
                   
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
