import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class Splash extends StatefulWidget {
  const Splash({super.key});

  @override
  State<Splash> createState() => _SplashState();
}

class _SplashState extends State<Splash> {
  String token = "";

  @override
  void initState() {
    super.initState();
    fetchDetails();
  }

  fetchDetails() async {
    Future.delayed(Duration(seconds: 2), () {
      // if (token.isEmpty) {
      // context.pushReplacement('/login');
      // } else {
      context.pushReplacement('/dashboard');
      // }
    });
  }

  @override
  Widget build(BuildContext context) {
    var h = MediaQuery.of(context).size.height;
    var w = MediaQuery.of(context).size.width;
    return Scaffold(
      body: Center(child: Center(child: Text('Mentee'))),
    );
  }
}
