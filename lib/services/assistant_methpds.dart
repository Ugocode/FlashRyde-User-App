import 'package:fusers_app/Global/global.dart';
import 'package:fusers_app/Global/info_handler.dart';
import 'package:fusers_app/Global/map_key.dart';
import 'package:fusers_app/Models/address_models.dart';
import 'package:fusers_app/Models/direction_details.dart';
import 'package:fusers_app/Models/user_model.dart';
import 'package:fusers_app/services/request_assistant.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';

class AssistantMethods {
  static Future<String> searchAddressforGeographicCoordinates(
      Position position, context) async {
    String apiUrl =
        "https://maps.googleapis.com/maps/api/geocode/json?latlng=${position.latitude},${position.longitude}&key=$mapKey";

    String humanReadableAddress = "";

    var requestResponse = await RequestAssistant.recieveRequest(apiUrl);
    if (requestResponse != "Failed") {
      humanReadableAddress = requestResponse["results"][0]["formatted_address"];

      Directions userPickUpAddress = Directions();
      userPickUpAddress.locationLatitude = position.latitude;
      userPickUpAddress.locationLongitude = position.longitude;
      userPickUpAddress.locationName = humanReadableAddress;

      Provider.of<AppInfo>(context, listen: false)
          .updatePickUpLocationAddress(userPickUpAddress);
    }

    return humanReadableAddress;
  }

  static void readCurrentOnlineUserInfo() {
    currentFirebaseUser = fireAuth.currentUser;

    var myUser = usersRef.child(currentFirebaseUser!.uid);

    myUser.once().then((snap) {
      userModelCurrentInfo = UserModel.fromSnapshot(snap.snapshot);
    });
  }

  static Future<DirectionDetailsInfo?>
      obtainOriginToDestinationDirectionDetails(
          LatLng originPosition, LatLng destinationPosition) async {
    String url4DestinationDirectionDetails =
        "https://maps.googleapis.com/maps/api/directions/json?origin=${originPosition.latitude},${originPosition.longitude}&destination=${destinationPosition.latitude},${destinationPosition.longitude}&key=$mapKey";

    var responseDirectionApi =
        await RequestAssistant.recieveRequest(url4DestinationDirectionDetails);

    if (responseDirectionApi == "Failed") {
      return null;
    }

    DirectionDetailsInfo directionDetailsInfo = DirectionDetailsInfo();

    directionDetailsInfo.ePoints =
        responseDirectionApi["routes"][0]["overview_polyline"]["points"];
    directionDetailsInfo.distanceText =
        responseDirectionApi["routes"][0]["legs"][0]["distance"]["text"];
    directionDetailsInfo.distanceValue =
        responseDirectionApi["routes"][0]["legs"][0]["distance"]["value"];
    directionDetailsInfo.durationText =
        responseDirectionApi["routes"][0]["legs"][0]["duration"]["text"];
    directionDetailsInfo.durationValue =
        responseDirectionApi["routes"][0]["legs"][0]["duration"]["value"];

    return directionDetailsInfo;
  }
}
