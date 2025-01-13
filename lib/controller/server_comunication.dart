import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:pharma_transfer/controller/dio_instance.dart';
import 'package:pharma_transfer/models/pharma_model.dart';
import 'package:pharma_transfer/models/recibo_model.dart';
import 'package:pharma_transfer/models/user_model.dart';

//GOOD
Future<List<Pharma>> getPharmaFromServer() async {
  final dio = DioInstance.getDio();

  final resp = await dio.get('', queryParameters: {"accion": "farma"});

  List<Pharma> pharmaList = [];

  try {
    if (resp.statusCode == 200) {
      pharmaList = pharmaFromJson(resp.data);
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

//GOOD
Future<bool> pushTransferencia(Recibo recibo) async {
  final dio = DioInstance.getDio();
  int contadorSubidos = 0;
  int productosEnTransferencia = recibo.producto.length;
  for (var index = 0; index < productosEnTransferencia; index++) {
    Response<dynamic> resp; //dio response
    Map<String, dynamic> body = {
      "accion": "farmaGrabarTransferencia",
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
      resp = await dio.get('', queryParameters: body);
    } catch (e) {
      debugPrint('error en pushTransferencia $e');
      return false;
    }

    if (resp.statusCode == 200) {
      debugPrint('resultado de estatus = 200 ${resp.data}');
      if (resp.data == "No Registrado") return false;
      contadorSubidos++;
    } else {
      debugPrint(
        'error en la comunicacion con el servidor ${resp.data} ${resp.data.length}',
      );
      return false;
    }
    debugPrint('productos contados como subidos = $contadorSubidos');
    debugPrint('productos reales = ${recibo.producto.length}');
  }
  return true;
}

//GOOD
Future<User?> getUserWithEmail(String email) async {
  final dio = DioInstance.getDio();

  final resp = await dio.get('',
      queryParameters: {"accion": "getFarmaUser", "farmaUserEmail": email});

  try {
    if (resp.statusCode == 200) {
      return userFromJson(resp.data).first;
    } else {
      debugPrint('error en la comunicacion con el servidor');
      return null;
    }
  } catch (e) {
    debugPrint(
        'error al pasear usuario desde el servidor, ${resp.data} error $e');
  }
  return null;
}
