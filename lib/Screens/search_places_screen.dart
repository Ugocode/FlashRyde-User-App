import 'package:flutter/material.dart';
import 'package:fusers_app/Global/map_key.dart';
import 'package:fusers_app/Models/predicted_places.dart';
import 'package:fusers_app/Widgets/place_prediction_tile.dart';
import 'package:fusers_app/services/request_assistant.dart';

class SearchLocationScreen extends StatefulWidget {
  const SearchLocationScreen({Key? key}) : super(key: key);

  @override
  State<SearchLocationScreen> createState() => _SearchLocationScreenState();
}

class _SearchLocationScreenState extends State<SearchLocationScreen> {
  List<PredictionPlaces> placePredictedList = [];

  void findplaceAutoCompleteSearch(String inputText) async {
    if (inputText.length > 1) {
      String urlAutoCompleteSearch =
          "https://maps.googleapis.com/maps/api/place/autocomplete/json?input=$inputText&key=$mapKey&components=country:ng";
      var responseAutoCompleteSearch =
          await RequestAssistant.recieveRequest(urlAutoCompleteSearch);

      if (responseAutoCompleteSearch == "Failed") {
        return;
      }
      if (responseAutoCompleteSearch["status"] == "OK") {
        var placePredictions = responseAutoCompleteSearch["predictions"];
        var placePredictionsList = (placePredictions as List)
            .map((jsonData) => PredictionPlaces.fromJson(jsonData))
            .toList();

        //to be able to get it outside this function we need to assign it to a list
        //outside this function by doing:
        setState(() {
          placePredictedList = placePredictionsList;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.blueGrey,
        body: Column(
          children: [
            //search part UI
            Container(
              height: 180,
              decoration: const BoxDecoration(
                color: Colors.pink,
                boxShadow: [
                  BoxShadow(
                    color: Colors.white54,
                    blurRadius: 8,
                    spreadRadius: 0.5,
                    offset: Offset(
                      0.7,
                      0.7,
                    ),
                  ),
                ],
              ),
              child: Padding(
                padding: const EdgeInsets.all(18.0),
                child: Column(children: [
                  const SizedBox(
                    height: 10,
                  ),
                  Stack(
                    children: [
                      GestureDetector(
                        onTap: (() {
                          Navigator.pop(context);
                        }),
                        child: const Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Icon(Icons.arrow_back_ios),
                        ),
                      ),
                      const Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Center(
                          child: Text(
                            "Search and set Drop off location",
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 16,
                  ),
                  Row(
                    children: [
                      const Padding(
                        padding: EdgeInsets.only(left: 8.0),
                        child: Icon(
                          Icons.adjust_sharp,
                          color: Colors.black,
                        ),
                      ),
                      const SizedBox(
                        width: 18,
                      ),
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: TextField(
                            onChanged: ((valueTyped) {
                              findplaceAutoCompleteSearch(valueTyped);
                            }),
                            decoration: const InputDecoration(
                                hintText: "serach here",
                                fillColor: Colors.white,
                                filled: true,
                                border: InputBorder.none,
                                contentPadding: EdgeInsets.only(
                                  left: 11,
                                  top: 8.0,
                                  bottom: 8.0,
                                )),
                          ),
                        ),
                      )
                    ],
                  )
                ]),
              ),
            ),

            //to desplay the preditions list
            (placePredictedList.isNotEmpty)
                ? Expanded(
                    child: ListView.separated(
                      physics: const ClampingScrollPhysics(),
                      itemCount: placePredictedList.length,
                      itemBuilder: (context, index) {
                        return Padding(
                          padding: const EdgeInsets.all(6.0),
                          child: PlacePredictionTile(
                            predictedPlaces: placePredictedList[index],
                          ),
                        );
                      },
                      separatorBuilder: ((context, index) {
                        return const Divider(
                          height: 1,
                          color: Colors.grey,
                          thickness: 1,
                        );
                      }),
                    ),
                  )
                : Container()
          ],
        ),
      ),
    );
  }
}
