import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:pharma_transfer/models/pharma_model.dart';
import 'package:pharma_transfer/models/recibo_model.dart';
import 'package:pharma_transfer/models/transferencia_model.dart';
import 'package:pharma_transfer/models/user_model.dart';

Future<List<Pharma>> getPharmaFromServer() async {
  var url = Uri.parse('http://18.228.147.99/modulos/app_services.php');

  final resp = await http.post(url, body: {
    "accion": "farma",
    "database": "admin_Smart",
  });
  List<Pharma> pharmaList = [];
  try {
    if (resp.statusCode == 200) {
      pharmaList = pharmaFromJson(resp.body);
      debugPrint('getPharmaFromServer return ${pharmaList.length} elementos');
    } else {
      debugPrint('error en la comunicacion con el servidor');
      return [];
    }
  } catch (e) {
    debugPrint('error en getPharmaFromServer $e');
  }
  return pharmaList;
}

// @Deprecated('reemplazador por metodo [getActiveTransfByUser]')
// Future<List<Transferencia>> getActiveTransferList() async {
//   var url = Uri.parse('http://18.228.147.99/modulos/app_services.php');

// //TODO: ESTO SE USARA PARA LAS TRANSFERENCIAS ACTIVAS O PARA ENTREGAR
//   final resp = await http.post(url, body: {
//     "accion": "getTransf",
//     "database": "admin_Smart",
//   });
//   List<Transferencia> transfList = [];
//   try {
//     if (resp.statusCode == 200) {
//       transfList = transferenciaFromJson(resp.body);
//     } else {
//       debugPrint('error en la comunicacion con el servidor');
//       return [];
//     }
//   } catch (e) {
//     debugPrint('error en getActiveTransferList $e');
//   }
//   return transfList;
// }

Future<bool> pushTransferencia(Recibo recibo) async {
  var url = Uri.parse('http://18.228.147.99/modulos/app_services.php');
  int contadorSubidos = 0;
  int productosEnTransferencia = recibo.producto.length;
  for (var index = 0; index < productosEnTransferencia; index++) {
    http.Response resp;
    Object body = {
      "accion": "farmaGrabarTransferencia",
      "database": "admin_Smart",
      "trans_date": DateTime.now().toString(),
      "trans_numero": recibo.numeroTransferencia,
      "trans_usr_solicita": recibo.usuSoliTransf,
      "trans_farma_solicita": recibo.farSoliTransf,
      "trans_usr_acepta": recibo.usuAutoTransf,
      "trans_farma_acepta": recibo.farAutoTransf,
      "trans_producto": recibo.producto[index].nombre,
      "trans_cantidad_entera": recibo.producto[index].ent.toString(),
      "trans_cantidad_fraccion": recibo.producto[index].frac.toString(),
    };

    debugPrint(body.toString());

    try {
      resp = await http.post(url, body: body);
    } catch (e) {
      debugPrint('error en pushTransferencia $e');
      return false;
    }

    if (resp.statusCode == 200) {
      debugPrint('resultado de estatus = 200 ${resp.body}');
      if (resp.body == "No Registrado") return false;
      contadorSubidos++;
    } else {
      debugPrint(
          'error en la comunicacion con el servidor ${resp.body} ${resp.body.length}');
      return false;
    }
    debugPrint('productos contados como subidos = $contadorSubidos');
    debugPrint('productos reales = ${recibo.producto.length}');
  }
  return true;
}

@Deprecated('pasado a la clase  TransfService')
Future<bool> updateTransfRetiro(
    Transferencia transferencia, String usuarioEmail) async {
  final myUser = await getUserWithEmail(usuarioEmail);
  if (myUser != null) {
    if (myUser.usersEstado == '1') {
      debugPrint('usuario valido');
    } else {
      return false;
    }

    var url = Uri.parse('http://18.228.147.99/modulos/app_services.php');
    final resp = await http.post(url, body: {
      "database": "admin_Smart",
      "accion": "farmaUpdateRet",
      "transId": transferencia.transfId,
      "farmaUserRecoge": myUser.usersEmail,
    });

    try {
      if (resp.statusCode == 200) {
        debugPrint('resultado de estatus = 200 ${resp.body}');
        if (resp.body == "No Registrado") return false;
        return true;
      } else {
        debugPrint(
            'error en la comunicacion con el servidor ${resp.body} ${resp.body.length}');
        return false;
      }
    } catch (e) {
      debugPrint('error en updateTransfRetiro $e');
      return false;
    }
  }
  return false;
}

@Deprecated('pasado a la clase  TransfService')
Future<bool> updateTransfEntrega(
    Transferencia transferencia, String usuarioEmail) async {
  final myUser = await getUserWithEmail(usuarioEmail);
  if (myUser != null) {
    if (myUser.usersEstado == '1') {
      debugPrint('usuario valido');
    } else {
      return false;
    }

    var url = Uri.parse('http://18.228.147.99/modulos/app_services.php');

    debugPrint('voy a actualizar');

    final resp = await http.post(url, body: {
      "database": "admin_Smart",
      "accion": "farmaUpdateEnt",
      "transId": transferencia.transfId,
      "farmaUserEntrega": myUser.usersEmail,
    });

    try {
      if (resp.statusCode == 200) {
        debugPrint('resultado de estatus = 200 ${resp.body}');
        if (resp.body == "No Registrado") return false;
        return true;
      } else {
        debugPrint(
            'error en la comunicacion con el servidor ${resp.body} ${resp.body.length}');
        return false;
      }
    } catch (e) {
      debugPrint('error en updateTransfEntrega $e');
      return false;
    }
  }
  return false;
}

Future<User?> getUserWithEmail(String email) async {
  var url = Uri.parse('http://18.228.147.99/modulos/app_services.php');
  final resp = await http.post(url, body: {
    "accion": "getFarmaUser",
    "database": "admin_Smart",
    "farmaUserEmail": email
  });
  try {
    if (resp.statusCode == 200) {
      return userFromJson(resp.body).first;
    } else {
      debugPrint('error en la comunicacion con el servidor');
      return null;
    }
  } catch (e) {
    debugPrint(
        'error al pasear usuario desde el servidor, ${resp.body} error $e');
  }
  return null;
}
