import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'package:fusers_app/Global/global.dart';

import 'package:fusers_app/services/assistant_methpds.dart';
import 'package:smooth_star_rating_nsafe/smooth_star_rating.dart';

class SelectNearestActiveDriverScreen extends StatefulWidget {
  DatabaseReference? referenceRideRequest;

  SelectNearestActiveDriverScreen({super.key, this.referenceRideRequest});

  @override
  State<SelectNearestActiveDriverScreen> createState() =>
      _SelectNearestActiveDriverScreenState();
}

class _SelectNearestActiveDriverScreenState
    extends State<SelectNearestActiveDriverScreen> {
  String fareAmount = "";
//finction to calculate the fare amount according to the vehicle type and also distance
  getFareAmountAccordingToVehicleType(int index) {
    if (tripDirectiondetailsInfo != null) {
      if ('${dList[index]["Car_details"]["type"]}' == "bike") {
        fareAmount = (AssistantMethods
                    .calculateDistanceFareAmountFromOriginToDestination(
                        tripDirectiondetailsInfo!) /
                2)
            .toStringAsFixed(1);
      }

      if ('${dList[index]["Car_details"]["type"]}' == "Uber-x") {
        fareAmount = (AssistantMethods
                    .calculateDistanceFareAmountFromOriginToDestination(
                        tripDirectiondetailsInfo!) +
                400)
            .toStringAsFixed(1);
      }

      if ('${dList[index]["Car_details"]["type"]}' == "Uber-go") {
        fareAmount = (AssistantMethods
                .calculateDistanceFareAmountFromOriginToDestination(
                    tripDirectiondetailsInfo!))
            .toString();
      }
    }
    return fareAmount;
  }

  @override
  Widget build(BuildContext context) {
    print("this is the valueeeeee:::::=== ,$dList");
    // print("this is the valueeeeee:::::=== ,${dList[index]}");

    return Scaffold(
      backgroundColor: Colors.blueGrey,
      appBar: AppBar(
        backgroundColor: Colors.white54,
        title: const Text('Pick a Driver'),
        leading: IconButton(
            onPressed: (() {
              //delete the write request from the database:
              widget.referenceRideRequest!.remove();
              // Navigator.pop(context);
              Fluttertoast.showToast(msg: "you have cancled the ride request");
              SystemNavigator.pop();
            }),
            icon: const Icon(
              Icons.close,
              color: Colors.white,
            )),
      ),
      body: ListView.builder(
        itemCount: dList.length,
        itemBuilder: (BuildContext context, int index) {
          return GestureDetector(
            onTap: () {
              setState(() {
                chosenDriverId = dList[index]['driverID'].toString();
              });
              //get the driver choosed and pass it to the homepage:
              Navigator.pop(context, "driverChoosed");
            },
            child: Card(
              color: Colors.grey,
              elevation: 3,
              shadowColor: Colors.green,
              margin: const EdgeInsets.all(10),
              child: ListTile(
                leading: Padding(
                  padding: const EdgeInsets.only(top: 10.0),
                  child: Image.asset(
                    "Assets/images/${dList[index]["Car_details"]["type"]}.png",
                    width: 70,
                  ),
                ),
                title: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text(
                        dList[index]["diverName"],
                        style: const TextStyle(
                          fontSize: 14,
                          color: Colors.black54,
                        ),
                      ),
                      Text(
                        dList[index]["Car_details"]["car_model"],
                        style: const TextStyle(
                          fontSize: 12,
                          color: Colors.white54,
                        ),
                      ),
                      SmoothStarRating(
                        rating: 3.5,
                        color: Colors.black,
                        borderColor: Colors.black,
                        allowHalfRating: true,
                        starCount: 5,
                        size: 15,
                      ),
                    ],
                  ),
                ),

                //to Show the Price and destinbation and duration:
                trailing: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "₦${getFareAmountAccordingToVehicleType(index)}",
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(
                      height: 2,
                    ),
                    Text(
                      tripDirectiondetailsInfo != null
                          ? tripDirectiondetailsInfo!.distanceText!
                          : "",
                      style: const TextStyle(
                          //fontWeight: FontWeight.bold,
                          ),
                    ),
                    const SizedBox(
                      height: 2,
                    ),
                    Text(
                      tripDirectiondetailsInfo != null
                          ? tripDirectiondetailsInfo!.durationText!
                          : "",
                      style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.black54,
                          fontSize: 12),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
