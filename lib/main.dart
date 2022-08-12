import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:fusers_app/Screens/spalsh%20_screen.dart';

import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(
    MyApp(
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Flash Ryde Users',
        theme: ThemeData(primarySwatch: Colors.pink),
        home: const MySplashScreen(),
      ),
    ),
  );
}

class MyApp extends StatefulWidget {
  final Widget? child;

  const MyApp({Key? key, this.child}) : super(key: key);

  //restart app function
  static void restartApp(BuildContext context) {
    context.findAncestorStateOfType<_MyAppState>()!.restartApp();
  }

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  Key key = UniqueKey();
  void restartApp() {
    setState(() {
      key = UniqueKey();
    });
  }

  @override
  Widget build(BuildContext context) {
    return KeyedSubtree(child: widget.child!);
  }
}
