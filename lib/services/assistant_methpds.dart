import 'package:fusers_app/Global/global.dart';
import 'package:fusers_app/Global/map_key.dart';
import 'package:fusers_app/Models/user_model.dart';
import 'package:fusers_app/services/request_assistant.dart';
import 'package:geolocator/geolocator.dart';

class AssistantMethods {
  static Future<String> searchAddressforGeographicCoordinates(
      Position position) async {
    String apiUrl =
        "https://maps.googleapis.com/maps/api/geocode/json?latlng=${position.latitude},${position.longitude}&key=$mapKey";

    String humanReadableAddress = "";

    var requestResponse = await RequestAssistant.recieveRequest(apiUrl);
    if (requestResponse != "Failed") {
      humanReadableAddress = requestResponse["results"][0]["formatted_address"];
    }
    return humanReadableAddress;
  }

  static void readCurrentOnlineUserInfo() {
    currentFirebaseUser = fireAuth.currentUser;

    var myUser = usersRef.child(currentFirebaseUser!.uid);

    myUser.once().then((snap) {
      userModelCurrentInfo = UserModel.fromSnapshot(snap.snapshot);
      print("name: =  ${userModelCurrentInfo!.name}");
      print("Email: = ${userModelCurrentInfo!.email}");
    });
  }
}
