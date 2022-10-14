import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:fusers_app/Models/user_model.dart';

import '../Models/direction_details.dart';

final FirebaseAuth fireAuth = FirebaseAuth.instance;

final DatabaseReference usersRef =
    FirebaseDatabase.instance.ref().child("users");

final DatabaseReference driversRef =
    FirebaseDatabase.instance.ref().child("drivers");

User? currentFirebaseUser;

//from our users model:
UserModel? userModelCurrentInfo;

// online / active drivers key infomation List:
List dList = [];

// to get our trip direction details info
DirectionDetailsInfo? tripDirectiondetailsInfo;
