import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '/MyDrawer.dart';
import '/Rides/ChatPage.dart';
import '/Rides/Logout.dart';
import '/main.dart';
import 'package:intl/intl.dart';
import '/CommonDrawer.dart';
import '/Profile/ProfilePage.dart';
import '/Rides/Ratings.dart';
import '/Rides/Ride.dart';
import '/Rides/User.dart';
import '/CommonDrawer.dart';
import 'package:flutter/material.dart';
import '/Wheretogo.dart';


class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final int _polylineCount = 1;
  final Map<PolylineId, Polyline> polylines = <PolylineId, Polyline>{};
  late GoogleMapController _controller;
  @override
  void initState() {
    getCurrentLocation();

    // TODO: implement initState
    super.initState();
  }

  LatLng? startingPosition;
  LatLng? endingPosition;

  getCurrentLocation() async {
    final permission = await Geolocator.checkPermission();

    if (permission != LocationPermission.denied &&
        permission != LocationPermission.deniedForever) {
      if (startingPosition == null) {
        final currentPositions = await Geolocator.getCurrentPosition();
        setState(() {
          startingPosition =
              LatLng(currentPositions.latitude, currentPositions.longitude);
          endingPosition = startingPosition;
          _originLocation = LatLng(startingPosition!.latitude.toDouble(),
              startingPosition!.longitude.toDouble());
          _destinationLocation = LatLng(endingPosition!.latitude.toDouble(),
              endingPosition!.longitude.toDouble());
          _getPolylinesWithLocation();

    
        });
      }
    } else {
      await Geolocator.requestPermission();
      getCurrentLocation();
    }
  }

  Set<Marker> _createMarker() {
    return <Marker>{
      Marker(
        markerId: const MarkerId("Starting"),
        position: LatLng(startingPosition!.latitude.toDouble(),
            startingPosition!.longitude.toDouble()),
        icon: BitmapDescriptor.defaultMarker,
        infoWindow: const InfoWindow(title: "Starting Location"),
      ),
      Marker(
        markerId: const MarkerId("Destination"),
        position: LatLng(endingPosition!.latitude.toDouble(),
            endingPosition!.longitude.toDouble()),
        icon: BitmapDescriptor.defaultMarker,
        infoWindow: const InfoWindow(title: "Destination"),
      )
    };
  }

  // final GoogleMapPolyline _googleMapPolyline =
  //     GoogleMapPolyline(apiKey: "AIzaSyBTpq2aXpU-MsCALXcmCWpNE6-hNZ11mZI");

  List<List<PatternItem>> patterns = <List<PatternItem>>[
    <PatternItem>[], //line
    <PatternItem>[PatternItem.dash(30.0), PatternItem.gap(20.0)], //dash
    <PatternItem>[PatternItem.dot, PatternItem.gap(10.0)], //dot
    <PatternItem>[
      PatternItem.dash(30.0),
      PatternItem.gap(20.0),
      PatternItem.dot,
      PatternItem.gap(20.0)
    ],
  ];

  late LatLng _originLocation;
  late LatLng _destinationLocation;
  PolylinePoints polylinePoints = PolylinePoints();
  _getPolylinesWithLocation() async {
    List<LatLng> polylineCoordinates = [];

    PolylineResult result = await polylinePoints.getRouteBetweenCoordinates(
      "AIzaSyCy7TyO8nomTDUSnkXeQZDbyJS0T8Enrw8",
      PointLatLng(startingPosition!.latitude.toDouble(),
          startingPosition!.longitude.toDouble()),
      PointLatLng(endingPosition!.latitude.toDouble(),
          endingPosition!.longitude.toDouble()),
      travelMode: TravelMode.driving,
    );

    if (result.points.isNotEmpty) {
      for (var point in result.points) {
        polylineCoordinates.add(LatLng(point.latitude, point.longitude));
        print("added");
      }
    } else {
      print(" ---------- ${result.errorMessage}");
    }
    addPolyLine(polylineCoordinates);
  }

  addPolyLine(List<LatLng> polylineCoordinates) {
    PolylineId id = const PolylineId("poly");
    Polyline polyline = Polyline(
      polylineId: id,
      color: Colors.red,
      points: polylineCoordinates,
      width: 8,
    );
    polylines[id] = polyline;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(
      context,
      designSize: const Size(454, 969),
      // allowFontScaling: false
    );
    return Scaffold(
      body: LayoutBuilder(
        builder: (context, cont) {
          return startingPosition==null ? 
          const Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [CircularProgressIndicator()],)
            ],
          )
           : GoogleMap(
            zoomGesturesEnabled: true,
            mapType: MapType.normal,
            markers: _createMarker(),
            onMapCreated: (GoogleMapController controller) {
              _controller = controller;
            },
            polylines: Set<Polyline>.of(polylines.values),
            initialCameraPosition: CameraPosition(
              target: LatLng((startingPosition!.latitude).toDouble(),
                  (startingPosition!.longitude).toDouble()),
              zoom: 10.0,
            ),
          );
        },
      ),
    );
  }

}