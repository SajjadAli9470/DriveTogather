import 'dart:typed_data';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_map_polyline_new/google_map_polyline_new.dart';
// import 'package:flutter_screenutil/screenutil.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
// import 'package:google_map_polyline/google_map_polyline.dart';

class RouteModel {
  final String target;
  final num lat;
  final num lng;

  RouteModel(this.target, this.lat, this.lng);
}

class DestinationRoute extends StatefulWidget {
  const DestinationRoute({super.key, required this.startLoc, required this.endLoc});
  final RouteModel startLoc;
  final RouteModel endLoc;
 

  @override
  _DestinationRouteState createState() => _DestinationRouteState();
}

class _DestinationRouteState extends State<DestinationRoute> {
 
 
  final int _polylineCount = 1;
  final Map<PolylineId, Polyline> polylines = <PolylineId, Polyline>{};
  late GoogleMapController _controller;

  Set<Marker> _createMarker(){
 


    return <Marker>{
      Marker(
        markerId: const MarkerId("Starting"),
        position: LatLng(widget.startLoc.lat.toDouble(), widget.startLoc.lng.toDouble()),
        icon: BitmapDescriptor.defaultMarker,
        infoWindow: const InfoWindow(title: "Starting Location"),
      ),
      Marker(
        markerId: const MarkerId("Destination"),
        position: LatLng(widget.endLoc.lat.toDouble(),
            widget.endLoc.lng.toDouble()),
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
          PointLatLng(widget.startLoc.lat.toDouble(), widget.startLoc.lng.toDouble()),
          PointLatLng(widget.endLoc.lat.toDouble(), widget.endLoc.lng.toDouble()),
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
  void initState() {
    _originLocation = LatLng(widget.startLoc.lat.toDouble(), widget.startLoc.lng.toDouble());
    _destinationLocation = LatLng(
        widget.endLoc.lat.toDouble(), widget.endLoc.lng.toDouble());

    _getPolylinesWithLocation();

    super.initState();
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
          return GoogleMap(
            zoomGesturesEnabled: true,
            mapType: MapType.normal,
            markers: _createMarker(),
            onMapCreated: (GoogleMapController controller) {
              _controller = controller;
            },
            polylines: Set<Polyline>.of(polylines.values),
            initialCameraPosition: CameraPosition(
              target: LatLng((widget.startLoc.lat).toDouble(),
                  (widget.startLoc.lng).toDouble()),
              zoom: 10.0,
            ),
          );
        },
      ),
    );
  }
}
