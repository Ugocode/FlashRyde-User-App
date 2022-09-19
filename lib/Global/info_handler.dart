//for use to get the real ti,e address always in the app we user Provider:

import 'package:flutter/material.dart';

import '../Models/address_models.dart';

class AppInfo extends ChangeNotifier {
  Directions? userPickUpLocation;
  Directions? userDropOffLocation;

  void updatePickUpLocationAddress(Directions userPickupAddress) {
    userPickUpLocation = userPickupAddress;
    notifyListeners();
  }

  // for the drop off address and location:
  void dropOffLocationAddress(Directions dropOffAddress) {
    userDropOffLocation = dropOffAddress;
    notifyListeners();
  }
}
