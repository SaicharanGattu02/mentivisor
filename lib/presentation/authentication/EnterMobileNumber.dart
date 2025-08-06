import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'OTPVerificationScreen.dart';
//
// class EmailInputScreen extends StatefulWidget {
//   const EmailInputScreen({Key? key}) : super(key: key);

  // @override
  // State<EmailInputScreen> createState() => _EmailInputScreenState();
// }

// class _EmailInputScreenState extends State<EmailInputScreen> {
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _passwordController = TextEditingController();
  //
  // @override
  // Widget build(BuildContext context) {
  //   return Scaffold(
  //     body: SafeArea(
  //       child: Column(
  //         children: [
  //           const SizedBox(height: 40),
  //           // Icon & Title
  //           Container(
  //             width: 64,
  //             height: 64,
  //             decoration: BoxDecoration(
  //               gradient: const LinearGradient(
  //                 colors: [Color(0xFF9333EA), Color(0xFF3B82F6)],
  //                 begin: Alignment.topLeft,
  //                 end: Alignment.bottomRight,
  //               ),
  //               borderRadius: BorderRadius.circular(16),
  //             ),
  //             child: const Icon(Icons.school, color: Colors.white, size: 32),
  //           ),
  //           const SizedBox(height: 12),
  //           const Text(
  //             'Join Mentivisor',
  //             style: TextStyle(
  //               fontSize: 20,
  //               fontWeight: FontWeight.bold,
  //               color: Colors.black87,
  //             ),
  //           ),
  //           const Spacer(),
  //           // Form Card
  //           Padding(
  //             padding: const EdgeInsets.symmetric(horizontal: 24),
  //             child: Container(
  //               width: double.infinity,
  //               padding: EdgeInsets.all(24),
  //               decoration: BoxDecoration(
  //                 color: Colors.white,
  //                 borderRadius: BorderRadius.circular(16),
  //                 boxShadow: [
  //                   BoxShadow(
  //                     color: Colors.black12,
  //                     blurRadius: 8,
  //                     offset: Offset(0, 2),
  //                   ),
  //                 ],
  //               ),
  //
  //               child: Column(
  //                 mainAxisSize: MainAxisSize.min,
  //                 children: [
  //                   Align(
  //                     alignment: Alignment.centerLeft,
  //                     child: Text(
  //                       'Email Address',
  //                       style: TextStyle(
  //                         fontSize: 12,
  //                         fontFamily: 'segeo',
  //                         fontWeight: FontWeight.w400,
  //                         color: Color(0xff666666),
  //                       ),
  //                       textAlign: TextAlign.center,
  //                     ),
  //                   ),
  //                   SizedBox(height: 5),
  //
  //                   TextField(
  //                     controller: _emailController,
  //                     decoration: InputDecoration(
  //                       hintText: 'Enter your email',
  //                       prefixIcon: const Icon(Icons.email_outlined),
  //                       border: OutlineInputBorder(
  //                         borderRadius: BorderRadius.circular(8),
  //                         borderSide: BorderSide.none,
  //                       ),
  //                       filled: true,
  //                       fillColor: const Color(0xFFF6FAFF),
  //                     ),
  //                   ),
  //                   const SizedBox(height: 12),
  //
  //                   Align(
  //                     alignment: Alignment.centerLeft,
  //                     child: Text(
  //                       'Phone no',
  //                       style: TextStyle(
  //                         fontSize: 12,
  //                         fontFamily: 'segeo',
  //                         fontWeight: FontWeight.w400,
  //                         color: Color(0xff666666),
  //                       ),
  //                       textAlign: TextAlign.center,
  //                     ),
  //                   ),
  //                   SizedBox(height: 5),
  //
  //                   TextField(
  //                     controller: _phoneController,
  //                     decoration: InputDecoration(
  //                       hintText: 'Enter Phone no',
  //                       prefixIcon: const Icon(Icons.phone_outlined),
  //                       border: OutlineInputBorder(
  //                         borderRadius: BorderRadius.circular(8),
  //                         borderSide: BorderSide.none,
  //                       ),
  //                       filled: true,
  //                       fillColor: const Color(0xFFF6FAFF),
  //                     ),
  //                   ),
  //                   const SizedBox(height: 12),
  //
  //                   Align(
  //                     alignment: Alignment.centerLeft,
  //                     child: Text(
  //                       'Password',
  //                       style: TextStyle(
  //                         fontSize: 12,
  //                         fontFamily: 'segeo',
  //                         fontWeight: FontWeight.w400,
  //                         color: Color(0xff666666),
  //                       ),
  //                       textAlign: TextAlign.center,
  //                     ),
  //                   ),
  //                   SizedBox(height: 5),
  //
  //                   TextField(
  //                     controller: _passwordController,
  //                     obscureText: true,
  //                     decoration: InputDecoration(
  //                       hintText: 'Enter Password',
  //                       prefixIcon: const Icon(Icons.lock_outline),
  //                       border: OutlineInputBorder(
  //                         borderRadius: BorderRadius.circular(8),
  //                         borderSide: BorderSide.none,
  //                       ),
  //                       filled: true,
  //                       fillColor: const Color(0xFFF6FAFF),
  //                     ),
  //                   ),
  //                 ],
  //               ),
  //             ),
  //           ),
  //           const Spacer(),
  //           // Get OTP Button
  //           Padding(
  //             padding: const EdgeInsets.all(24.0),
  //             child: GestureDetector(
  //               onTap: () {},
  //
  //               child: Container(
  //                 width: double.infinity,
  //                 padding: const EdgeInsets.symmetric(vertical: 16),
  //                 decoration: BoxDecoration(
  //                   gradient: const LinearGradient(
  //                     colors: [Color(0xFF9333EA), Color(0xFF3B82F6)],
  //                     begin: Alignment.topLeft,
  //                     end: Alignment.bottomRight,
  //                   ),
  //                   borderRadius: BorderRadius.circular(30),
  //                 ),
  //                 child: const Text(
  //                   'Get OTP',
  //                   textAlign: TextAlign.center,
  //                   style: TextStyle(
  //                     color: Colors.white,
  //                     fontSize: 16,
  //                     fontWeight: FontWeight.w600,
  //                   ),
  //                 ),
  //               ),
  //             ),
  //           ),
  //         ],
  //       ),
  //     ),
  //   );
  // }
// }
