import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:fusers_app/Models/user_model.dart';

final FirebaseAuth fireAuth = FirebaseAuth.instance;

final DatabaseReference usersRef =
    FirebaseDatabase.instance.ref().child("users");

User? currentFirebaseUser;

//from our users model:
UserModel? userModelCurrentInfo;
