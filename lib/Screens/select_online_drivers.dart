import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fusers_app/Global/global.dart';
import 'package:smooth_star_rating_nsafe/smooth_star_rating.dart';

class SelectNearestActiveDriverScreen extends StatefulWidget {
  const SelectNearestActiveDriverScreen({super.key});

  @override
  State<SelectNearestActiveDriverScreen> createState() =>
      _SelectNearestActiveDriverScreenState();
}

class _SelectNearestActiveDriverScreenState
    extends State<SelectNearestActiveDriverScreen> {
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
              Navigator.pop(context);
              //SystemNavigator.pop();
            }),
            icon: const Icon(
              Icons.close,
              color: Colors.white,
            )),
      ),
      body: ListView.builder(
        itemCount: dList.length,
        itemBuilder: (BuildContext context, int index) {
          return Card(
            color: Colors.grey,
            elevation: 3,
            shadowColor: Colors.green,
            margin: const EdgeInsets.all(8),
            child: ListTile(
              leading: Padding(
                padding: const EdgeInsets.only(top: 2.0),
                child: Image.asset(
                  "Assets/images/${dList[index]["Car_details"]["type"]}.png",
                  width: 70,
                ),
              ),
              title: Column(
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
              trailing: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  Text(
                    "3",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(
                    height: 2,
                  ),
                  Text(
                    "13 km",
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.black54,
                        fontSize: 12),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
