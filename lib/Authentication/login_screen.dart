import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:fusers_app/Authentication/registration_screen.dart';

import '../Global/global.dart';
import '../Screens/spalsh _screen.dart';
import '../Widgets/progress_dialog.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailTextEditingController =
      TextEditingController();

  final TextEditingController _passwordTextEditingController =
      TextEditingController();

  //to save the driver information to firebase datasbase we:
  loginUserNow() async {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: ((context) {
        return const ProgressDialog(
          message: "Processing, Please wait...",
        );
      }),
    );

    final User? firebaseUser = (await fireAuth
            .signInWithEmailAndPassword(
      email: _emailTextEditingController.text.trim(),
      password: _passwordTextEditingController.text.trim(),
    )
            .catchError((eMsg) {
      Navigator.pop(context);
      //show the error message
      Fluttertoast.showToast(
          msg: "⚠️ Error: \n$eMsg",
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.TOP,
          backgroundColor: Colors.red);
    }))
        .user;

    //To get the credentials from firebase:
    if (firebaseUser != null) {
      //get the database ref:
      //and make sure only users can login
      // usersRef.child("users");
      //this specific driver can login:
      usersRef.child(firebaseUser.uid).once().then((usersKey) {
        final snap = usersKey.snapshot;
        //if the user exist:
        if (snap.value != null) {
          //conncet users
          currentFirebaseUser = firebaseUser;
          Fluttertoast.showToast(
              msg: "Login Success!",
              toastLength: Toast.LENGTH_LONG,
              gravity: ToastGravity.TOP,
              backgroundColor: Colors.green);

          // ignore: use_build_context_synchronously
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => const MySplashScreen()));
        } else {
          //making sure only drives are allowed
          Fluttertoast.showToast(msg: "No User exist with this record");
          fireAuth.signOut();
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => const MySplashScreen()));
        }
      });
    } else {
      // ignore: use_build_context_synchronously
      Navigator.pop(context);
      Fluttertoast.showToast(msg: "⚠️ User not found");
    }
  }

//to validate  our form before saving data:
  validatForm() {
    if (!_emailTextEditingController.text.contains("@")) {
      Fluttertoast.showToast(
          msg: "⚠️ Email is badly formatted",
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.TOP,
          backgroundColor: Colors.red);
    } else if (_passwordTextEditingController.text.isEmpty) {
      Fluttertoast.showToast(
          msg: "⚠️ Password field can't be empty",
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.TOP,
          backgroundColor: Colors.red);
    } else {
      //login the user:
      loginUserNow();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 52, 42, 245),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(
              height: 40,
            ),
            Image.asset(
              'Assets/images/useback.png',
              height: 350,
              width: 350,
            ),
            const Text(
              'Flash Ryde ⚡️',
              style: TextStyle(
                  fontSize: 44,
                  fontWeight: FontWeight.bold,
                  fontStyle: FontStyle.italic,
                  color: Colors.pink),
            ),
            const SizedBox(
              height: 10,
            ),
            const Text(
              'Login as a User',
              style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  fontStyle: FontStyle.italic,
                  color: Colors.black45),
            ),
            const SizedBox(
              height: 10,
            ),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: TextField(
                keyboardType: TextInputType.emailAddress,
                controller: _emailTextEditingController,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Email',
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: TextField(
                keyboardType: TextInputType.text,
                obscureText: true,
                controller: _passwordTextEditingController,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Password',
                ),
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            ElevatedButton(
              onPressed: () {
                validatForm();
              },
              child: const Text(
                'Login',
                style: TextStyle(color: Colors.black),
              ),
            ),
            TextButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const RegistrationScreen(),
                  ),
                );
              },
              child: const Text("Don't have an account?  Register"),
            )
          ],
        ),
      ),
    );
  }
}
