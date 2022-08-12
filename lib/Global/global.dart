import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';

final FirebaseAuth fireAuth = FirebaseAuth.instance;

final DatabaseReference driversRef = FirebaseDatabase.instance.ref();

User? currentFirebaseUser;
