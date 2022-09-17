import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_geofire/flutter_geofire.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:fusers_app/Global/global.dart';
import 'package:fusers_app/Global/info_handler.dart';
import 'package:fusers_app/Models/active_nearby_available_drivers.dart';
import 'package:fusers_app/Screens/search_places_screen.dart';
import 'package:fusers_app/Widgets/my_drawer.dart';
import 'package:fusers_app/Widgets/progress_dialog.dart';
import 'package:fusers_app/services/assistant_methpds.dart';
import 'package:fusers_app/services/geofire_assistant.dart';

import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  GoogleMapController? newGoogleMapController;

  final Completer<GoogleMapController> _controllerGoogleMap = Completer();

  static const CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(37.42796133580664, -122.085749655962),
    zoom: 14.4746,
  );

  Position? userCurrentPosition;
  var geoLocator = Geolocator();

  LocationPermission? _locationPermission;

  GlobalKey<ScaffoldState> sKey = GlobalKey<ScaffoldState>();

  //function to check if permission is allowed function
  checkIfLocationPermissionAllowed() async {
    _locationPermission = await Geolocator.requestPermission();

    if (_locationPermission == LocationPermission.denied) {
      _locationPermission = await Geolocator.requestPermission();
    }
  }

//drawer username and email field
  String userName = "User name";
  String userEmail = "User email";

  //to change the drawer buttion to cancle button
  //when the dropoff loction is selected
  bool openNavigatoionDrawer = true;

  //to get the ployline corodinates:
  List<LatLng> pLineCoOrdinatesList = [];
  Set<Polyline> ployLineSet = {};

  //to get the markers and circles
  Set<Marker> markesSet = {};
  Set<Circle> circlesSet = {};

  bool activeNearbyDriverKeysLoaded = false;

  //for Dark mode:
  blackThemeGoogleMap() {
    newGoogleMapController!.setMapStyle('''
                    [
                      {
                        "elementType": "geometry",
                        "stylers": [
                          {
                            "color": "#242f3e"
                          }
                        ]
                      },
                      {
                        "elementType": "labels.text.fill",
                        "stylers": [
                          {
                            "color": "#746855"
                          }
                        ]
                      },
                      {
                        "elementType": "labels.text.stroke",
                        "stylers": [
                          {
                            "color": "#242f3e"
                          }
                        ]
                      },
                      {
                        "featureType": "administrative.locality",
                        "elementType": "labels.text.fill",
                        "stylers": [
                          {
                            "color": "#d59563"
                          }
                        ]
                      },
                      {
                        "featureType": "poi",
                        "elementType": "labels.text.fill",
                        "stylers": [
                          {
                            "color": "#d59563"
                          }
                        ]
                      },
                      {
                        "featureType": "poi.park",
                        "elementType": "geometry",
                        "stylers": [
                          {
                            "color": "#263c3f"
                          }
                        ]
                      },
                      {
                        "featureType": "poi.park",
                        "elementType": "labels.text.fill",
                        "stylers": [
                          {
                            "color": "#6b9a76"
                          }
                        ]
                      },
                      {
                        "featureType": "road",
                        "elementType": "geometry",
                        "stylers": [
                          {
                            "color": "#38414e"
                          }
                        ]
                      },
                      {
                        "featureType": "road",
                        "elementType": "geometry.stroke",
                        "stylers": [
                          {
                            "color": "#212a37"
                          }
                        ]
                      },
                      {
                        "featureType": "road",
                        "elementType": "labels.text.fill",
                        "stylers": [
                          {
                            "color": "#9ca5b3"
                          }
                        ]
                      },
                      {
                        "featureType": "road.highway",
                        "elementType": "geometry",
                        "stylers": [
                          {
                            "color": "#746855"
                          }
                        ]
                      },
                      {
                        "featureType": "road.highway",
                        "elementType": "geometry.stroke",
                        "stylers": [
                          {
                            "color": "#1f2835"
                          }
                        ]
                      },
                      {
                        "featureType": "road.highway",
                        "elementType": "labels.text.fill",
                        "stylers": [
                          {
                            "color": "#f3d19c"
                          }
                        ]
                      },
                      {
                        "featureType": "transit",
                        "elementType": "geometry",
                        "stylers": [
                          {
                            "color": "#2f3948"
                          }
                        ]
                      },
                      {
                        "featureType": "transit.station",
                        "elementType": "labels.text.fill",
                        "stylers": [
                          {
                            "color": "#d59563"
                          }
                        ]
                      },
                      {
                        "featureType": "water",
                        "elementType": "geometry",
                        "stylers": [
                          {
                            "color": "#17263c"
                          }
                        ]
                      },
                      {
                        "featureType": "water",
                        "elementType": "labels.text.fill",
                        "stylers": [
                          {
                            "color": "#515c6d"
                          }
                        ]
                      },
                      {
                        "featureType": "water",
                        "elementType": "labels.text.stroke",
                        "stylers": [
                          {
                            "color": "#17263c"
                          }
                        ]
                      }
                    ]
                ''');
  }

  locateUserPosition() async {
    Position cPosition = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    userCurrentPosition = cPosition;

    LatLng latLngPosition =
        LatLng(userCurrentPosition!.latitude, userCurrentPosition!.longitude);

//animate the camera around the position:
    CameraPosition cameraPosition =
        CameraPosition(target: latLngPosition, zoom: 14);

    newGoogleMapController!
        .animateCamera(CameraUpdate.newCameraPosition(cameraPosition));

    String humanreadableAddress =
        // ignore: use_build_context_synchronously
        await AssistantMethods.searchAddressforGeographicCoordinates(
            userCurrentPosition!, context);

    print("This is your address:   $humanreadableAddress");

    userName = userModelCurrentInfo!.name!;
    userEmail = userModelCurrentInfo!.email!;

    initializeGeoFireListiner();
  }

  @override
  void initState() {
    super.initState();
    //get the current user info:
    AssistantMethods.readCurrentOnlineUserInfo();
    //call the permission function
    checkIfLocationPermissionAllowed();
  }

  //custom hight for search box
  double searchLocationContainerHeight = 200.0;
  double bottomPaddingOfMap = 0;

  @override
  Widget build(BuildContext context) {
    //create a variable for the address:
    var mypickupLocation = Provider.of<AppInfo>(context).userPickUpLocation;
    var mydropOffLocation = Provider.of<AppInfo>(context).userDropOffLocation;

    return Scaffold(
      key: sKey,
      //to give our drawer color we add themedata
      drawer: Theme(
        data: Theme.of(context).copyWith(canvasColor: Colors.blueGrey),
        child: MyDrawer(
          name: userName,
          email: userEmail,
        ),
      ),
      body: Stack(
        children: [
          GoogleMap(
            padding: EdgeInsets.only(bottom: bottomPaddingOfMap),
            zoomGesturesEnabled: true,
            zoomControlsEnabled: true,
            mapType: MapType.normal,
            myLocationEnabled: true,
            polylines: ployLineSet,
            markers: markesSet,
            circles: circlesSet,
            initialCameraPosition: _kGooglePlex,
            onMapCreated: (GoogleMapController controller) {
              _controllerGoogleMap.complete(controller);
              newGoogleMapController = controller;

              //to show the google logo:
              setState(() {
                bottomPaddingOfMap = 200;
              });

              //for our black theme
              blackThemeGoogleMap();

              //locate the user position
              locateUserPosition();
            },
          ),
          //custom ahambuger buttion for drawer
          Positioned(
            top: 36,
            left: 22,
            child: GestureDetector(
              onTap: (() {
                if (openNavigatoionDrawer) {
                  sKey.currentState!.openDrawer();
                } else {
                  //restart the app programmatically
                  SystemNavigator.pop();
                }
              }),
              child: CircleAvatar(
                //to toggle the icons to be menue or close button
                child: Icon(openNavigatoionDrawer ? Icons.menu : Icons.close),
              ),
            ),
          ),
          //UI for searching location:
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: AnimatedSize(
              duration: const Duration(
                milliseconds: 120,
              ),
              child: Container(
                height: searchLocationContainerHeight,
                decoration: const BoxDecoration(
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(20),
                      topRight: Radius.circular(20),
                    ),
                    color: Colors.pink),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 24.0, vertical: 18),
                  child: Column(
                    children: [
                      //from location
                      Row(
                        children: [
                          const Icon(
                            Icons.add_location_alt_outlined,
                            color: Colors.white,
                          ),
                          const SizedBox(
                            width: 12,
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                "From",
                                style:
                                    TextStyle(color: Colors.grey, fontSize: 12),
                              ),
                              Text(
                                mypickupLocation != null
                                    ? "${(mypickupLocation.locationName!).substring(0, 45)}..."
                                    : "Your current location",
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                    color: Colors.grey, fontSize: 12),
                              ),
                            ],
                          )
                        ],
                      ),
                      const SizedBox(
                        height: 12,
                      ),
                      const Divider(
                        thickness: 1,
                        height: 1,
                        color: Colors.grey,
                      ),
                      const SizedBox(
                        height: 16,
                      ),
                      //where to location
                      GestureDetector(
                        onTap: (() async {
                          //search location
                          var responsefromSearchScreen = await Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (_) => const SearchLocationScreen()),
                          );
                          if (responsefromSearchScreen.toString() ==
                              "obtainedDropOff") {
                            setState(() {
                              openNavigatoionDrawer = false;
                            });

                            //draw poliline
                            drawPolylineFromOriginToDestination();
                          }
                        }),
                        child: Row(
                          children: [
                            const Icon(
                              Icons.add_location_alt_outlined,
                              color: Colors.white,
                            ),
                            const SizedBox(
                              width: 12,
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  "Where to",
                                  style: TextStyle(
                                      color: Colors.grey, fontSize: 12),
                                ),
                                Text(
                                  mydropOffLocation != null
                                      ? "${(mydropOffLocation.locationName)}..."
                                      : "find Location",
                                  style: const TextStyle(
                                      color: Colors.grey, fontSize: 14),
                                ),
                              ],
                            )
                          ],
                        ),
                      ),
                      const SizedBox(
                        height: 6,
                      ), //e
                      const Divider(
                        thickness: 1,
                        height: 1,
                        color: Colors.grey,
                      ),
                      const SizedBox(
                        height: 18,
                      ), //end of where to

                      ElevatedButton(
                        style: ButtonStyle(
                            backgroundColor: MaterialStateProperty.all<Color>(
                                Colors.blueGrey)),
                        onPressed: () {},
                        child: const Text(
                          'Request a Ride',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> drawPolylineFromOriginToDestination() async {
    var originPosition =
        Provider.of<AppInfo>(context, listen: false).userPickUpLocation;
    var destinationPosition =
        Provider.of<AppInfo>(context, listen: false).userDropOffLocation;

    var originLatLng = LatLng(
        originPosition!.locationLatitude!, originPosition.locationLongitude!);

    var destinationLatLng = LatLng(destinationPosition!.locationLatitude!,
        destinationPosition.locationLongitude!);

    showDialog(
        context: context,
        builder: (context) {
          return const ProgressDialog(
            message: "calm down...",
          );
        });

    var directionDetailsInfo =
        await AssistantMethods.obtainOriginToDestinationDirectionDetails(
            originLatLng, destinationLatLng);

    // ignore: use_build_context_synchronously
    Navigator.pop(context);
    print("thers are the direction info pointsss:::::::===");
    print(directionDetailsInfo!.ePoints);

    PolylinePoints pPoints = PolylinePoints();
    List<PointLatLng> decodedPpointsResultList =
        pPoints.decodePolyline(directionDetailsInfo.ePoints!);

    pLineCoOrdinatesList.clear();

    if (decodedPpointsResultList.isNotEmpty) {
      for (var pointLatLng in decodedPpointsResultList) {
        pLineCoOrdinatesList
            .add(LatLng(pointLatLng.latitude, pointLatLng.longitude));
      }
    }

    ployLineSet.clear();

    setState(() {
      Polyline polyline = Polyline(
        color: Colors.blue,
        polylineId: const PolylineId("PolylineId"),
        jointType: JointType.round,
        points: pLineCoOrdinatesList,
        startCap: Cap.roundCap,
        endCap: Cap.roundCap,
        geodesic: true,
      );
      ployLineSet.add(polyline);
    });

    //to make the zoom inside the screen:
    LatLngBounds boundsLatLng;

    if (originLatLng.latitude > destinationLatLng.latitude &&
        originLatLng.longitude > destinationLatLng.longitude) {
      boundsLatLng =
          LatLngBounds(southwest: destinationLatLng, northeast: originLatLng);
    } else if (originLatLng.longitude > destinationLatLng.longitude) {
      boundsLatLng = LatLngBounds(
          southwest: LatLng(originLatLng.latitude, destinationLatLng.longitude),
          northeast:
              LatLng(destinationLatLng.latitude, originLatLng.longitude));
    } else if (originLatLng.latitude > destinationLatLng.latitude) {
      boundsLatLng = LatLngBounds(
          southwest: LatLng(destinationLatLng.latitude, originLatLng.longitude),
          northeast:
              LatLng(originLatLng.latitude, destinationLatLng.longitude));
    } else {
      boundsLatLng =
          LatLngBounds(southwest: originLatLng, northeast: destinationLatLng);
    }

    newGoogleMapController!
        .animateCamera(CameraUpdate.newLatLngBounds(boundsLatLng, 95));

//for destination marker:
    Marker destinationMarker = Marker(
        markerId: const MarkerId("destinationId"),
        infoWindow: InfoWindow(
            title: destinationPosition.locationName, snippet: "Destination"),
        position: destinationLatLng,
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen));

//for origin marker
    Marker originMarker = Marker(
        markerId: const MarkerId("originId"),
        infoWindow:
            InfoWindow(title: originPosition.locationName, snippet: "Origin"),
        position: originLatLng,
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed));

    setState(() {
      markesSet.add(originMarker);
      markesSet.add(destinationMarker);
    });

//for the circles:
    Circle originCircle = Circle(
        circleId: const CircleId("originId"),
        fillColor: Colors.green,
        radius: 12,
        strokeWidth: 3,
        strokeColor: Colors.white,
        center: originLatLng);

    //for destiation:
    Circle destinationCircle = Circle(
        circleId: const CircleId("destinationId"),
        fillColor: Colors.red,
        radius: 12,
        strokeWidth: 3,
        strokeColor: Colors.white,
        center: destinationLatLng);

    setState(() {
      circlesSet.add(originCircle);
      circlesSet.add(destinationCircle);
    });
  }

  //this shows all the available drivers around you:
  initializeGeoFireListiner() {
    Geofire.initialize("activeDrivers");

    Geofire.queryAtLocation(
            userCurrentPosition!.latitude, userCurrentPosition!.longitude, 10)!
        .listen((map) {
      print(map);
      if (map != null) {
        var callBack = map['callBack'];

        //latitude will be retrieved from map['latitude']
        //longitude will be retrieved from map['longitude']

        switch (callBack) {
          //whenever any driver become active online:
          case Geofire.onKeyEntered:
            ActiveNearbyAvailableDrivers activeNearbyAvailableDriver =
                ActiveNearbyAvailableDrivers();
            //to get the drivers we get this:
            activeNearbyAvailableDriver.locationLatitiude = map['latitude'];
            activeNearbyAvailableDriver.locationLongitiude = map['longitude'];
            activeNearbyAvailableDriver.driverId = map['key'];
            GeoFireAssistant.activeNearbyAvailableDriversList
                .add(activeNearbyAvailableDriver);

            if (activeNearbyDriverKeysLoaded == true) {
              displayActiveDriversOnUsersMap();
            }

            break;
          //whenever any driver become offline:
          case Geofire.onKeyExited:
            GeoFireAssistant.deleteOfflineDriverFromList(map['key']);
            break;
          //whenever the driver moves - update driver location:
          case Geofire.onKeyMoved:
            // Update your key's location
            ActiveNearbyAvailableDrivers activeNearbyAvailableDriver =
                ActiveNearbyAvailableDrivers();
            activeNearbyAvailableDriver.locationLatitiude = map['latitude'];
            activeNearbyAvailableDriver.locationLongitiude = map['longitude'];
            activeNearbyAvailableDriver.driverId = map['key'];
            GeoFireAssistant.updateActiveNearbyAvailableDriverLocation(
                activeNearbyAvailableDriver);
            displayActiveDriversOnUsersMap();
            break;
          //display those online or active drivers on users map:
          case Geofire.onGeoQueryReady:
            // All Intial Data is loaded
            displayActiveDriversOnUsersMap();

            break;
        }
      }

      setState(() {});
    });
  }

  displayActiveDriversOnUsersMap() {
    setState(() {
      markesSet.clear();
      circlesSet.clear();

      Set<Marker> driversMarkerSet = <Marker>{};

      for (ActiveNearbyAvailableDrivers eachDriver
          in GeoFireAssistant.activeNearbyAvailableDriversList) {
        LatLng eachDriverActivePosition = LatLng(
            eachDriver.locationLatitiude!, eachDriver.locationLongitiude!);

        Marker marker = Marker(
          markerId: MarkerId(eachDriver.driverId!),
          position: eachDriverActivePosition,
          icon:
              BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueOrange),
          rotation: 360,
        );
        driversMarkerSet.add(marker);
      }
      setState(() {
        markesSet = driversMarkerSet;
      });
    });
  }
}
