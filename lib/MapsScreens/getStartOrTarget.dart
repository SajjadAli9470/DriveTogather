import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapScreen extends StatefulWidget {
  final LatLng initLoc;
  final Function(LatLng value) lotlocation;
  const MapScreen(
      {super.key, required this.lotlocation, required this.initLoc});

  @override
  _MapScreenState createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  GoogleMapController? mapController;
  LatLng? selectedLocation = const LatLng(24.8928, 67.0876);
  String? selectedAddress;

  @override
  void initState() {
    selectedLocation = widget.initLoc;
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Select Location'),
      ),
      body: GoogleMap(
        onMapCreated: _onMapCreated,
        onTap: _onMapTapped,
        initialCameraPosition: CameraPosition(
          target: widget.initLoc, // Initial camera position (center of the map)
          zoom: 15.0,
        ),
        markers: Set.of((selectedLocation != null)
            ? [
                Marker(
                    markerId: const MarkerId('selected'),
                    position: selectedLocation!)
              ]
            : []),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          if (selectedLocation != null) {
       
            widget.lotlocation(selectedLocation!);
            Navigator.pop(context);
            print("Selected Location: $selectedLocation");
          } else {
            print("Please select a location on the map.");
          }
        },
        child: const Icon(Icons.check),
      ),
    );
  }

  void _onMapCreated(GoogleMapController controller) {
    setState(() {
      mapController = controller;
    });
  }

  void _onMapTapped(LatLng location) {
    setState(() {
      selectedLocation = location;
      mapController!.animateCamera(CameraUpdate.newLatLng(location));
    });
  }



}
