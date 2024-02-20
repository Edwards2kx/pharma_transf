import 'package:geolocator/geolocator.dart';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:pharma_transfer/models/user_location_model.dart';
import 'package:pharma_transfer/utils/utils.dart';

const double kMinDistance = 200.0;

class UsersLocationMapScreen extends StatelessWidget {
  final MapController mapController = MapController();
  final List<UserLocation> usersLocation;
  final bool isMultiUser;
  UsersLocationMapScreen(
      {super.key, required this.usersLocation, this.isMultiUser = false});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(backgroundColor: Colors.transparent),
      extendBodyBehindAppBar: true,
      floatingActionButton: isMultiUser
          ? floatingIsMultiUser(context)
          : floatingIsSingleUser(context),
      body: FlutterMap(
        mapController: mapController,
        options: const MapOptions(
            initialCenter: LatLng(-0.22985, -78.48495), //Quito
            // initialCenter: LatLng(-0.22985, -78.52495), //Quito
            initialZoom: 12,
            minZoom: 3),
        children: [
          TileLayer(
            urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
            userAgentPackageName: 'com.example.app',
          ),
          MarkerLayer(
            markers: _buildMarkers(context, usersLocation),
          ),
        ],
      ),
    );
  }

  FloatingActionButton floatingIsMultiUser(BuildContext context) {
    return FloatingActionButton(
      onPressed: () => _searchUserDialogList(context),
      child: const Icon(Icons.search_outlined),
    );
  }

  FloatingActionButton floatingIsSingleUser(BuildContext context) {
    final lastLoc = usersLocation.first;
    return FloatingActionButton(
      onPressed: () =>
          mapController.move(LatLng(lastLoc.latitud, lastLoc.longitud), 15.0),
      child: const Icon(Icons.location_searching_outlined),
    );
  }

  Future<dynamic> _searchUserDialogList(BuildContext context) {
    return showDialog(
      context: context,
      builder: (context) {
        return SimpleDialog(
          title: const Text('Escoge ubicación a buscar'),
          children: usersLocation
              .map(
                (e) => ListTile(
                  onTap: () {
                    Navigator.pop(context);
                    mapController.move(LatLng(e.latitud, e.longitud), 15.0);
                  },
                  title: Text(e.userName),
                  trailing: CircleAvatar(
                    child: Text(Utils.get2FirtsInitials(e.userName)),
                  ),
                ),
              )
              .toList(),
        );
      },
    );
  }

  // List<Marker> _buildMarkers(context, List<UserLocation> listLocationUser) {
  //   final labelStyle = Theme.of(context).textTheme.labelSmall;
  //   List<Marker> markers = [];
  //   LatLng? prevLocation;
  //   for (var location in listLocationUser) {
  //     final currentLoc = LatLng(location.latitud, location.longitud);
  //     prevLocation ??= currentLoc;

  //     final marker = Marker(
  //       width: 80,
  //       height: 120,
  //       point: currentLoc,
  //       child: Column(
  //         children: [
  //           CircleAvatar(
  //               child: Text(Utils.get2FirtsInitials(location.userName))),
  //           const Icon(Icons.location_pin, color: Colors.red, size: 32),
  //           Card(
  //             color: Colors.black12,
  //             elevation: 0,
  //             child: Padding(
  //               padding: const EdgeInsets.all(4.0),
  //               child: Column(
  //                 crossAxisAlignment: CrossAxisAlignment.center,
  //                 children: [
  //                   Text(
  //                     DateFormat('dd-MM-yy').format(location.dateTime),
  //                     style: labelStyle,
  //                   ),
  //                   Text(DateFormat('HH:mm').format(location.dateTime),
  //                       style: labelStyle),
  //                 ],
  //               ),
  //             ),
  //           ),
  //         ],
  //       ),
  //     );
  //     markers.add(marker);
  //   }
  //   return markers;
  // }
  List<Marker> _buildMarkers(context, List<UserLocation> listLocationUser) {
    final labelStyle = Theme.of(context).textTheme.labelSmall?.copyWith(color: Colors.white);
    LatLng? prevLocation;
    List<Marker> markers = [];
    for (var location in listLocationUser) {
      final currentLoc = LatLng(location.latitud, location.longitud);
      if (prevLocation == null ||
          Geolocator.distanceBetween(
                  prevLocation.latitude,
                  prevLocation.longitude,
                  currentLoc.latitude,
                  currentLoc.longitude) >=
              kMinDistance) {
        final marker = Marker(
          width: 80,
          height: 120,
          point: currentLoc,
          child: Column(
            children: [
              CircleAvatar(
                  child: Text(Utils.get2FirtsInitials(location.userName))),
              const Icon(Icons.location_pin, color: Colors.red, size: 32),
              Card(
                color: Colors.black38,
                elevation: 0,
                child: Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        DateFormat('dd-MM-yy').format(location.dateTime),
                        style: labelStyle,
                      ),
                      Text(DateFormat('HH:mm').format(location.dateTime),
                          style: labelStyle),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
        markers.add(marker);
      }
      prevLocation = currentLoc;
    }
    return markers;
  }
}
