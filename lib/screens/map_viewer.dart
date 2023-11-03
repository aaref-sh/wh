import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:url_launcher/url_launcher.dart';

import '../all.dart';

class MapViewer extends StatefulWidget {
  const MapViewer({super.key, required this.location});
  final GeoLocation location;

  @override
  State<MapViewer> createState() => _MapViewerState();
}

class _MapViewerState extends State<MapViewer> {
  MapController mapcontroller = MapController();
  @override
  Widget build(BuildContext context) {
    var lati = double.parse(widget.location.latitude ?? '0');
    var longi = double.parse(widget.location.longitude ?? '0');
    return Stack(
      children: [
        FlutterMap(
          mapController: mapcontroller,
          options: MapOptions(
            center: LatLng(lati, longi),
            zoom: 15,
          ),
          children: [
            TileLayer(
              urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
              userAgentPackageName: 'com.example.wh',
            ),
            MarkerLayer(
              markers: [
                Marker(
                  point: LatLng(lati, longi),
                  builder: (BuildContext context) {
                    return const Icon(Icons.location_on);
                  },
                ),
                if (lastLocation != null) myMarker(),
              ],
            ),
          ],
        ),
        // Positioned(
        //   bottom: 20,
        //   right: 10,
        //   child: Container(
        //     width: 60,
        //     height: 130,
        //     child: Column(
        //       children: [
        //         Container(
        //           height: 50,
        //           child: IconButton(
        //               onPressed: () {},
        //               icon: Icon(
        //                 Icons.location_searching,
        //                 size: 50,
        //               )),
        //         ),
        //         Container(
        //           height: 50,
        //           child: IconButton(
        //               onPressed: showMyLocation,
        //               icon: Icon(
        //                 Icons.location_history_rounded,
        //                 size: 50,
        //               )),
        //         )
        //       ],
        //     ),
        //   ),
        // ),
      ],
    );
  }

  void showMyLocation() {
    if (lastLocation == null) {
      Fluttertoast.showToast(msg: resLicatingFailed);
      return;
    }
  }

  Marker myMarker() {
    return Marker(
      point: LatLng(lastLocation!.latitude!, lastLocation!.longitude!),
      builder: (BuildContext context) {
        return const Icon(Icons.location_history);
      },
    );
  }
}
