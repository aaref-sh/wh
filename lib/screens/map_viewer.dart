import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

import '../all.dart';

class MapViewer extends StatefulWidget {
  const MapViewer({super.key, required this.location});
  final GeoLocation location;

  @override
  State<MapViewer> createState() => _MapViewerState();
}

class _MapViewerState extends State<MapViewer> {
  MapController mapcontroller = MapController();
  LatLng? location;
  LatLng defaultLocation() {
    var lati = double.parse(widget.location.latitude ?? '0');
    var longi = double.parse(widget.location.longitude ?? '0');
    return LatLng(lati, longi);
  }

  @override
  void initState() {
    location = defaultLocation();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          FlutterMap(
            mapController: mapcontroller,
            options: MapOptions(
              center: location,
              zoom: mapDefaultZoom.toDouble(),
              maxZoom: 18.3,
            ),
            children: [
              TileLayer(
                urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                userAgentPackageName: 'com.example.wh',
              ),
              MarkerLayer(
                rotate: true,
                markers: [
                  Marker(
                    point: defaultLocation(),
                    builder: (BuildContext context) {
                      return const Icon(
                        Icons.location_on,
                        size: 30,
                        color: Color.fromARGB(255, 189, 51, 41),
                      );
                    },
                  ),
                  if (lastLocation != null) myMarker(),
                ],
              ),
            ],
          ),
          Positioned(
            bottom: 20,
            right: 10,
            child: SizedBox(
              width: 60,
              height: 130,
              child: Column(
                children: [
                  TextButton(
                    style: TextButton.styleFrom(
                      backgroundColor: Colors.white60,
                      shape: const CircleBorder(),
                    ),
                    child: const Icon(
                      Icons.location_searching,
                      color: Color.fromARGB(185, 0, 0, 0),
                    ),
                    onPressed: () {
                      moveToMarker();
                    },
                  ),
                  TextButton(
                    style: TextButton.styleFrom(
                      backgroundColor: Colors.white60,
                      shape: const CircleBorder(),
                    ),
                    onPressed: showMyLocation,
                    child: const Icon(
                      Icons.location_history_rounded,
                      color: Color.fromARGB(185, 0, 0, 0),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  void moveToMarker() {
    smooooooooth(defaultLocation());
  }

  void showMyLocation() {
    if (lastLocation == null) {
      Fluttertoast.showToast(msg: resLicatingFailed);
      return;
    }
    smooooooooth(LatLng(lastLocation!.latitude, lastLocation!.longitude));
  }

  Future<void> smooooooooth(LatLng to) async {
    var lat = (mapcontroller.center.latitude - to.latitude) / mapSmoothRate;
    var lon = (mapcontroller.center.longitude - to.longitude) / mapSmoothRate;
    var zom = (mapcontroller.zoom - mapDefaultZoom) / mapSmoothRate;
    for (int i = 0; i < mapSmoothRate; i++) {
      var center = LatLng(mapcontroller.center.latitude - lat,
          mapcontroller.center.longitude - lon);
      var zoom = mapcontroller.zoom - zom;
      mapcontroller.move(center, zoom);
      await Future.delayed(const Duration(milliseconds: 4));
    }
  }

  Marker myMarker() {
    return Marker(
      point: LatLng(lastLocation!.latitude, lastLocation!.longitude),
      builder: (BuildContext context) {
        return const Icon(
          Icons.location_history,
          size: 30,
          color: Colors.blue,
        );
      },
    );
  }
}
