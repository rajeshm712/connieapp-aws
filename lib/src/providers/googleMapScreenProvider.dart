import 'package:connie/src/abstract/googleMapAbstract.dart';
import 'package:flutter/cupertino.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class GoogleMapScreenProvider extends GoogleMapAbstract {
  bool mapButtonPressed = false;

  GoogleMapController mapController;

  // static const LatLng _center = const LatLng(52.502858, -1.964576);
  bool enable = false;
  List<LatLng> latlng = [];
  LatLng startLocation = LatLng(52.502858, -1.964576);
  LatLng endLocation = LatLng(52.504961, -1.966475);

  LatLng initialcameraposition = const LatLng(52.502858, -1.964576);

  static const String _apiRootDomain =
      'http://router.project-osrm.org/route/v1/driving';
  Set<Marker> attractionMarkerList = Set();
  Marker currentDestMarker;
  BuildContext scaffoldContext;
  BitmapDescriptor customIcon;
  Position currentLocationd;
  CameraPosition initialPosition;

  @override
  bool getMapButtonPressed() {
    return mapButtonPressed;
  }

  @override
  void setMapButtonPressed(bool pressed) {
    mapButtonPressed = pressed;
    notifyListeners();
    // TODO: implement setInfoButtonPressStatus
  }

  @override
  getLocation(GoogleMapController mapController) async {
    // TODO: implement getLocation
    currentLocationd = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.best);
    var newPosition = CameraPosition(
        target: LatLng(currentLocationd.latitude, currentLocationd.longitude),
        zoom: 18);
    CameraUpdate update = CameraUpdate.newCameraPosition(newPosition);
    mapController.moveCamera(update);
  }

  @override
  onMapCreated(GoogleMapController controller) {
    mapController = controller;
    notifyListeners();
    getLocation(controller);
  }

  @override
  CameraPosition intializeMap() {
    // TODO: implement intializeMap
    initialPosition = CameraPosition(target: initialcameraposition, zoom: 16);
    return initialPosition;
  }
}
