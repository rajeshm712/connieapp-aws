import 'package:connie/src/providers/googleMapScreenProvider.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';

class GoogleMapScreen extends StatelessWidget {
  final Function(bool) onMapEnable;
  BuildContext globalContext;
  GoogleMapScreenProvider googleMapScreenProvider;

  GoogleMapScreen({Key key, this.onMapEnable}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    globalContext = context;
    googleMapScreenProvider = Provider.of<GoogleMapScreenProvider>(context);

    return Scaffold(
        body: Stack(
      children: [
        GoogleMap(
          initialCameraPosition: googleMapScreenProvider.intializeMap(),
          mapType: MapType.terrain,
          onMapCreated: googleMapScreenProvider.onMapCreated,
          myLocationEnabled: true,
        ),
        Align(
          alignment: Alignment.topRight,
          child: Padding(
            padding: const EdgeInsets.only(top: 45.0, right: 20.0),
            child: FloatingActionButton(
              key: Key('map_cancel'),
              onPressed: () {
                onMapEnable(false);
              },
              child: Image.asset('assets/images/cancel.png',
                  width: 50.0, height: 50.0),
            ),
          ),
        )
      ],
    ));
  }
}
