// ignore_for_file: file_names

import 'dart:async';

// import 'package:drivers_app/Global/global.dart';
// import 'package:drivers_app/Screens/bottom_navigation.dart';

// import 'package:drivers_app/Screens/bottom_navigation.dart';
// import 'package:drivers_app/Screens/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:fusers_app/Authentication/registration_screen.dart';
import 'package:fusers_app/Global/global.dart';
import 'package:fusers_app/Screens/home_page.dart';
import 'package:google_fonts/google_fonts.dart';

import '../Authentication/login_screen.dart';

class MySplashScreen extends StatefulWidget {
  const MySplashScreen({Key? key}) : super(key: key);

  @override
  State<MySplashScreen> createState() => _MySplashScreenState();
}

class _MySplashScreenState extends State<MySplashScreen> {
  //set timer for the app to get the user or not:
  startTimer() {
    Timer(const Duration(seconds: 4), () async {
      // ignore: await_only_futures
      if (await fireAuth.currentUser != null) {
        //then assign the user to the current user:
        currentFirebaseUser = fireAuth.currentUser;
        //send the user to the home page
        Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(builder: (context) => const MyHomePage()),
            (Route<dynamic> route) => false);
      } else {
        //Send the uuser to the login Screen:
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => const RegistrationScreen()));
      }
    });
  }

  @override
  void initState() {
    super.initState();
    startTimer();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Container(
          color: Colors.grey,
          child: Center(
              child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                'Assets/images/logo22.png',
                height: 180,
                width: 220,
              ),
              const SizedBox(
                height: 15,
              ),
              Text(
                'Flash Ryder for Users',
                style: GoogleFonts.getFont('Pacifico',
                    textStyle:
                        const TextStyle(fontSize: 20, color: Colors.pink)),
              )
            ],
          )),
        ),
      ),
    );
  }
}
