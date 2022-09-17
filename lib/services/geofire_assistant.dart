import 'package:fusers_app/Models/active_nearby_available_drivers.dart';

class GeoFireAssistant {
  static List<ActiveNearbyAvailableDrivers> activeNearbyAvailableDriversList =
      [];

  //delete a driver:
  static void deleteOfflineDriverFromList(String driverId) {
    int indexNumber = activeNearbyAvailableDriversList
        .indexWhere((element) => element.driverId == driverId);
    activeNearbyAvailableDriversList.removeAt(indexNumber);
  }

//update driver movement:
  static void updateActiveNearbyAvailableDriverLocation(
      ActiveNearbyAvailableDrivers driverWhoMove) {
    int indexNumber = activeNearbyAvailableDriversList
        .indexWhere((element) => element.driverId == driverWhoMove.driverId);
    activeNearbyAvailableDriversList[indexNumber].locationLatitiude =
        driverWhoMove.locationLatitiude;
    activeNearbyAvailableDriversList[indexNumber].locationLongitiude =
        driverWhoMove.locationLongitiude;
  }
}
