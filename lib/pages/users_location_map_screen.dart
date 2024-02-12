// import 'package:flutter/material.dart';
// import 'package:flutter_map/flutter_map.dart';
// import 'package:flutter_map/plugin_api.dart';
// import 'package:latlong2/latlong.dart';
// import 'package:yuragrowapp/src/domain/location/location_user.dart';

import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:pharma_transfer/models/user_location_model.dart';

class UsersLocationMapScreen extends StatelessWidget {
  final MapController mapController = MapController();
  final List<UserLocation> usersLocation;
  UsersLocationMapScreen({super.key, required this.usersLocation});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      body: FlutterMap(
        options: const MapOptions(
            initialCenter: LatLng(-0.22985, -78.52495), //Quito
            initialZoom: 7,
            minZoom: 5),
        children: [
          TileLayer(
            urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
            userAgentPackageName: 'com.example.app',
          ),
          MarkerLayer(
            markers: _buildMarkers(usersLocation),
          ),
        ],
      ),
    );
  }
}

// class MapWithLocations extends StatelessWidget {
//   final List<LocationUser> listaUbicaciones;
//   final MapController mapController = MapController();
//   MapWithLocations({super.key, required this.listaUbicaciones});
// @override
// Widget build(BuildContext context) {
// return Scaffold(
//       appBar: AppBar(
//         backgroundColor: Colors.transparent,
//         elevation: 0,
//       ),
//       extendBodyBehindAppBar: true,
//       floatingActionButton: (FloatingActionButton(
//         onPressed: () {
//           if (listaUbicaciones.isNotEmpty) {
//             final lastLocation = listaUbicaciones.last;

//             mapController.move(
//                 LatLng(
//                   double.parse(lastLocation.lat),
//                   double.parse(lastLocation.lon),
//                 ),
//                 15.0);
//           }
//         },
//         child: Icon(
//           Icons.gps_fixed,
//         ),
//       )),
//       body: FlutterMap(
//         mapController: mapController,
//         options: MapOptions(
//             center: LatLng(-0.22985, -78.52495),
//             zoom: 10,
//             minZoom: 5,
//             //maxZoom: 20,
//             interactiveFlags: InteractiveFlag.all & ~InteractiveFlag.rotate),
//         nonRotatedChildren: [
//           MarkerLayer(
//             markers: _buildMarkers(listaUbicaciones),
//           ),
//           AttributionWidget.defaultWidget(
//             source: 'OpenStreetMap contributors',
//             onSourceTapped: null,
//           ),
//         ],
//         children: [
//           TileLayer(
//             urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
//             userAgentPackageName: 'com.example.app',
//           ),
//         ],
//       ),
//     );
//   }

List<Marker> _buildMarkers(List<UserLocation> listLocationUser) {
  List<Marker> markers = [];
  for (var location in listLocationUser) {
    final marker = Marker(
      point: LatLng(location.latitud, location.longitud),
      child: const Icon(Icons.location_pin, color: Colors.red, size: 32)
      // child: Column(
      //   children: [
      //     Text(location.userName),
      //     const Icon(Icons.location_pin, color: Colors.red, size: 32)
      //   ],
      // ),
    );
    markers.add(marker);
  }
  return markers;
}



//   List<Marker> _buildMarkers(List<LocationUser> listLocationUser) {
//     var markers = <Marker>[];
//     for (var locationUser in listLocationUser) {
//       final newMarker = Marker(
//         //anchorPos: AnchorPos.exactly(Anchor(120, 50)),
//         width: 120,
//         height: 100,
//         point: LatLng(
//           double.parse(locationUser.lat),
//           double.parse(locationUser.lon),
//         ),
//         builder: (context) {
//           return Column(
//             children: [
//               Container(
//                 padding: EdgeInsets.all(4),
//                 color: Colors.black26,
//                 child: Column(
//                   children: [
//                     Text(
//                       '${locationUser.nombre} ${locationUser.apellido?[0]}.',
//                       //'${locationUser.nombre} ${locationUser.apellido}',
//                       overflow: TextOverflow.ellipsis,
//                       style: TextStyle(
//                           color: Colors.white, fontWeight: FontWeight.w600),
//                     ),
//                     Text(
//                       locationUser.fecha.toString().substring(0, 10),
//                       style: TextStyle(
//                           color: Colors.white, fontWeight: FontWeight.w600),
//                     ),
//                     Text(
//                       locationUser.fecha.toString().substring(10, 16),
//                       style: TextStyle(
//                           color: Colors.white, fontWeight: FontWeight.w600),
//                     ),
//                   ],
//                 ),
//               ),
//               Icon(
//                 Icons.pin_drop,
//                 color: Colors.red,
//                 size: 32,
//               ),
//             ],
//           );
//         },
//       );
//       markers.add(newMarker);
//     }
//     return markers;
//   }
// }
