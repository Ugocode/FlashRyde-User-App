import 'package:flutter/material.dart';
import 'package:fusers_app/Global/info_handler.dart';
import 'package:fusers_app/Global/map_key.dart';
import 'package:fusers_app/Models/address_models.dart';
import 'package:fusers_app/Widgets/progress_dialog.dart';
import 'package:fusers_app/services/request_assistant.dart';
import 'package:provider/provider.dart';

import '../Models/predicted_places.dart';

class PlacePredictionTile extends StatelessWidget {
  final PredictionPlaces? predictedPlaces;

  const PlacePredictionTile({Key? key, this.predictedPlaces}) : super(key: key);

  getPlaceDirectionDetails(String placeId, context) async {
    showDialog(
      context: context,
      builder: ((context) => const ProgressDialog(
            message: "setting up Drop-off, please wait...",
          )),
    );
    String placeDirectionDetailsUrl =
        "https://maps.googleapis.com/maps/api/place/details/json?place_id=$placeId&key=$mapKey";
    var resposeApi =
        await RequestAssistant.recieveRequest(placeDirectionDetailsUrl);
//to remove the dialog box after getting resposnse:
    Navigator.pop(context);

    if (resposeApi == "Failed") {
      return;
    }

    if (resposeApi["status"] == "OK") {
      Directions directions = Directions();
      directions.locationName = resposeApi["result"]["name"].toString();
      directions.locationId = placeId.toString();
      directions.locationLatitude =
          resposeApi["result"]["geometry"]["location"]["lat"];
      directions.locationLongitude =
          resposeApi["result"]["geometry"]["location"]["lng"];
      // directions.humanRadabableAddress =
      //     resposeApi["result"]["opening_hours"]["weekday_text"].toString();

      Provider.of<AppInfo>(context, listen: false)
          .dropOffLocationAddress(directions);

      Navigator.pop(context, "obtainedDropOff");

      // print("this is the locationname: ${directions.locationName}");
      // print("\nthis is the locatiid: ${directions.locationId}");
      // print("\nthis is the my ownooooo: ${directions.humanRadabableAddress}");
    }
  }

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(primary: Colors.blueGrey),
      onPressed: (() {
        getPlaceDirectionDetails(predictedPlaces!.placeId!, context);
      }),
      child: Row(children: [
        Image.asset(
          'Assets/images/dest.png',
          height: 20,
          width: 20,
        ),
        const SizedBox(
          width: 14,
        ),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(
                height: 8.0,
              ),
              Text(
                predictedPlaces!.mainText!,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(fontSize: 16, color: Colors.black),
              ),
              const SizedBox(
                height: 2.0,
              ),
              Text(
                predictedPlaces!.secondaryText!,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(fontSize: 12, color: Colors.grey),
              ),
              const SizedBox(
                height: 8.0,
              ),
            ],
          ),
        ),
      ]),
    );
  }
}
