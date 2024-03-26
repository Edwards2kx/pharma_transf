import 'package:either_dart/either.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:pharma_transfer/models/transferencia_model.dart';
import 'package:pharma_transfer/models/user_model.dart';

class TransfService {
  final _serverUrl = Uri.parse('http://18.228.147.99/modulos/app_services.php');

  final Map<String, String> _baseBody = {
    "database": "admin_Smart",
  };

  Future<List<Transferencia>> getActiveTransfByUser(User user) async {
    final requestBody = Map<String, String>.from(_baseBody);

    switch (user.userCargo) {
      case UserCargo.administrador:
      case UserCargo.motorizado:
        requestBody.addAll({"accion": "getTransf"});
        break;
      case UserCargo.dependiente:
        requestBody.addAll({
          "accion": "getTransf_dep",
          "trans_farma_solicita": user.dependencia ?? ''
        });
        break;
      // case UserCargo.motorizado:
      //   requestBody.addAll({"accion": "getTransf"});
      //   break;
    }
    return await _getTransferList(requestBody);
  }

  Future<List<Transferencia>> getFinishedTransfByUser(User user) async {
    final requestBody = Map<String, String>.from(_baseBody);

    switch (user.userCargo) {
      case UserCargo.administrador:
      case UserCargo.motorizado:
        requestBody.addAll({"accion": "getTransfFarm"});
        break;
      case UserCargo.dependiente:
        requestBody.addAll({
          "accion": "getTransfFarm_dep",
          "trans_farma_solicita": user.dependencia ?? ''
        });
        break;
    }
    return await _getTransferList(requestBody);
  }

  Future<List<Transferencia>> _getTransferList(
      Map<String, String> requestBody) async {
    final resp = await http.post(_serverUrl, body: requestBody);
    List<Transferencia> transfList = [];
    try {
      if (resp.statusCode == 200) {
        transfList = transferenciaFromJson(resp.body);
      } else {
        debugPrint('error en la comunicacion con el servidor');
        return [];
      }
    } catch (e) {
      debugPrint('error en getActiveTransferList $e');
      debugPrint(resp.body);
    }
    return transfList;
  }

  Future<Either<String, bool>> updateTransfRetiro(
      Transferencia transferencia, User user) async {
    if (user.usersEstado != '1') {
      debugPrint('usuario invalido');
      return const Left('No puedes realizar está acción');
    }

    final resp = await http.post(_serverUrl, body: {
      "database": "admin_Smart",
      "accion": "farmaUpdateRet",
      "transId": transferencia.transfId,
      "farmaUserRecoge": user.usersEmail,
    });

    try {
      if (resp.statusCode == 200) {
        // debugPrint('resultado de estatus = 200 ${resp.body}');
        if (resp.body == "No Registrado") return const Right(false);
        return const Right(true);
      } else {
        debugPrint(
            'error en la comunicacion con el servidor ${resp.body} ${resp.body.length}');
        return const Left('Ocurrio un error, intenta nuevamente');
      }
    } catch (e) {
      debugPrint('error en updateTransfRetiro $e');
      return const Left('Ocurrio un error, intenta nuevamente');
    }
  }

  Future<Either<String, bool>> updateTransfEntrega(
      Transferencia transferencia, User user) async {
    if (user.usersEstado != '1') {
      debugPrint('usuario invalido');
      return const Left('No puedes realizar está acción');
    }

    var url = Uri.parse('http://18.228.147.99/modulos/app_services.php');

    debugPrint('voy a actualizar');

    final resp = await http.post(url, body: {
      "database": "admin_Smart",
      "accion": "farmaUpdateEnt",
      "transId": transferencia.transfId,
      "farmaUserEntrega": user.usersEmail,
    });

    try {
      if (resp.statusCode == 200) {
        // debugPrint('resultado de estatus = 200 ${resp.body}');
        if (resp.body == "No Registrado") return const Right(false);
        return const Right(true);
      } else {
        debugPrint(
            'error en la comunicacion con el servidor ${resp.body} ${resp.body.length}');
        return const Left('Error en la comunicación con el servidor');
      }
    } catch (e) {
      debugPrint('error en updateTransfEntrega $e');
      return const Left('Error en la comunicación con el servidor');
    }
  }
}
