import 'package:flutter/foundation.dart' show debugPrint;
import 'package:pharma_transfer/models/user_location_model.dart';

import 'dio_instance.dart';

class UserLocationService {
  Future<bool> pushUserLocation(UserLocation userLocation) =>
      _pushUserLocation(userLocation);

  Future<List<UserLocation>> fetchUsersMotoLocation() => _fetchUsersLocation();

  // Future<bool> _pushUserLocation(UserLocation userLocation) async {
  //   var url = Uri.parse('http://18.228.147.99/modulos/app_services.php');

  //   try {
  //     final resp = await http.post(url, body: {
  //       "accion": "farmaLocatioMoto",
  //       "database": "admin_Smart",
  //       "moto_time": userLocation.dateTime.toIso8601String(),
  //       "moto_name": userLocation.userName,
  //       "moto_email": userLocation.userEmail,
  //       "moto_lat": userLocation.latitud.toString(),
  //       "moto_lon": userLocation.longitud.toString()
  //     });

  //     if (resp.statusCode != 200) {
  //       debugPrint('error en la comunicacion con el servidor ${resp.body}');
  //       return false;
  //     }
  //     if (resp.body == "No Registrado") {
  //       debugPrint(
  //           'error no se registro la ubicacion del usuario ${resp.body}');
  //       return false;
  //     }
  //     debugPrint(
  //         'se registro la ubicacion del usuario ${userLocation.userEmail}');
  //     return true;
  //   } catch (e) {
  //     debugPrint('excepcion durante pushUserLocation $e');
  //     return false;
  //   }
  // }

  Future<bool> _pushUserLocation(UserLocation userLocation) async {
    final params = {
      "accion": "farmaLocatioMoto",
      "moto_time": userLocation.dateTime.toIso8601String(),
      "moto_name": userLocation.userName,
      "moto_email": userLocation.userEmail,
      "moto_lat": userLocation.latitud.toString(),
      "moto_lon": userLocation.longitud.toString()
    };

    final dio = DioInstance.getDio();
    try {
      final resp = await dio.get('', queryParameters: params);

      if (resp.statusCode != 200) {
        debugPrint('error en la comunicacion con el servidor ${resp.data}');
        return false;
      }
      if (resp.data == "No Registrado") {
        debugPrint(
            'error no se registro la ubicacion del usuario ${resp.data}');
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
  final params = {"accion": "ReqLocationMoto"};

  final dio = DioInstance.getDio();

  try {
    final resp = await dio.get('', queryParameters: params);

    if (resp.statusCode != 200) {
      debugPrint('error en la comunicacion con el servidor ${resp.data}');
      return [];
    }
//remover
    if (resp.data == "No Registrado") {
      debugPrint('error no se registro la ubicacion del usuario ${resp.data}');
      return [];
    }
    return userLocationFromJson(resp.data);
  } catch (e) {
    debugPrint('excepcion durante _fetchUsersLocation $e');
    return [];
  }
}
// Future<List<UserLocation>> _fetchUsersLocation() async {
//   var url = Uri.parse('http://18.228.147.99/modulos/app_services.php');

//   try {
//     final resp = await http.post(url, body: {
//       "accion": "ReqLocationMoto",
//       "database": "admin_Smart",
//     });

//     if (resp.statusCode != 200) {
//       debugPrint('error en la comunicacion con el servidor ${resp.body}');
//       return [];
//     }
// //remover
//     if (resp.body == "No Registrado") {
//       debugPrint('error no se registro la ubicacion del usuario ${resp.body}');
//       return [];
//     }
//     return userLocationFromJson(resp.body);
//   } catch (e) {
//     debugPrint('excepcion durante _fetchUsersLocation $e');
//     return [];
//   }
// }
