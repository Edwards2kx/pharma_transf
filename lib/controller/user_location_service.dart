import 'package:flutter/foundation.dart' show debugPrint;
import 'package:http/http.dart' as http;
import 'package:pharma_transfer/models/user_location_model.dart';

class UserLocationService {
  Future<bool> pushUserLocation(UserLocation userLocation) =>
      _pushUserLocation(userLocation);

  Future<List<UserLocation>> fetchUsersLocation() => _fetchUsersLocation();

  Future<bool> _pushUserLocation(UserLocation userLocation) async {
    var url = Uri.parse('http://18.228.147.99/modulos/app_services.php');

    try {
      final resp = await http.post(url, body: {
        "accion": "farmaLocatioMoto",
        "database": "admin_Smart",
        "moto_time": userLocation.dateTime.toIso8601String(),
        "moto_name": userLocation.userName,
        "moto_email": userLocation.userEmail,
        "moto_lat": userLocation.latitud.toString(),
        "moto_lon": userLocation.longitud.toString()
      });

      if (resp.statusCode != 200) {
        debugPrint('error en la comunicacion con el servidor ${resp.body}');
        return false;
      }
      if (resp.body == "No Registrado") {
        debugPrint(
            'error no se registro la ubicacion del usuario ${resp.body}');
        return false;
      }
      debugPrint(
          'se registro la ubicacion del usuario ${userLocation.userEmail}');
      return true;
    } catch (e) {
      debugPrint('excepcion durante pushUserLocation $e');
      return false;
    }
  }
}

Future<List<UserLocation>> _fetchUsersLocation() async {
  var url = Uri.parse('http://18.228.147.99/modulos/app_services.php');

  try {
    final resp = await http.post(url, body: {
      "accion": "ReqLocationMoto",
      "database": "admin_Smart",
    });

    if (resp.statusCode != 200) {
      debugPrint('error en la comunicacion con el servidor ${resp.body}');
      return [];
    }
//remover
    if (resp.body == "No Registrado") {
      debugPrint('error no se registro la ubicacion del usuario ${resp.body}');
      return [];
    }
    print('user locations ${resp.body}'); //remover
    return userLocationFromJson(resp.body);
  } catch (e) {
    debugPrint('excepcion durante _fetchUsersLocation $e');
    return [];
  }
}
