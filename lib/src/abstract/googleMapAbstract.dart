import 'package:flutter/cupertino.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

abstract class GoogleMapAbstract extends ChangeNotifier {
  void setMapButtonPressed(bool pressed);

  bool getMapButtonPressed();

  getLocation(GoogleMapController mapController);

  onMapCreated(GoogleMapController controller);

  CameraPosition intializeMap();
}
