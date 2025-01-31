import 'package:either_dart/either.dart';
import 'package:flutter/material.dart';
import 'package:pharma_transfer/controller/dio_instance.dart';
import 'package:pharma_transfer/models/transferencia_model.dart';
import 'package:pharma_transfer/models/user_model.dart';

class TransfService {
  //GOOD
  Future<List<Transferencia>> getActiveTransfByUser(User user) async {
    final params = <String, dynamic>{};

    switch (user.userCargo) {
      case UserCargo.administrador:
      case UserCargo.motorizado:
        params.addAll({"accion": "getTransf"});
        params.addAll(user.toModel());
        break;
      case UserCargo.dependiente:
        params.addAll({
          "accion": "getTransf_dep",
          "trans_farma_solicita": user.userPertenece ?? ''
        });
        break;
      // case UserCargo.motorizado:
      //   requestBody.addAll({"accion": "getTransf"});
      //   break;
    }
    return await _getTransferList(params);
  }

  Future<List<Transferencia>> getFinishedTransfByUser(User user) async {
    final params = <String, dynamic>{};
    switch (user.userCargo) {
      case UserCargo.administrador:
      case UserCargo.motorizado:
        params.addAll({"accion": "getTransfFarm"});
        params.addAll(user.toModel());
        // params.addAll({"email": user.usersEmail});
        break;
      case UserCargo.dependiente:
        params.addAll({
          "accion": "getTransfFarm_dep",
          "trans_farma_solicita": user.userPertenece ?? ''
        });
        break;
    }
    return await _getTransferList(params);
  }

  Future<List<Transferencia>> _getTransferList(
      Map<String, dynamic> params) async {
    final dio = DioInstance.getDio();
    final resp = await dio.get('', queryParameters: params);
    List<Transferencia> transfList = [];
    try {
      if (resp.statusCode == 200) {
        transfList = transferenciaFromJson(resp.data);
      } else {
        debugPrint('error en la comunicacion con el servidor');
        return [];
      }
    } catch (e) {
      debugPrint('error en getActiveTransferList $e');
      debugPrint(resp.data);
    }
    return transfList;
  }

  Future<Either<String, bool>> updateTransfRetiro(
      Transferencia transferencia, User user) async {
    if (!user.isActive) {
      debugPrint('usuario invalido');
      return const Left('No puedes realizar está acción');
    }

    final dio = DioInstance.getDio();

    final params = {
      "database": "admin_Smart",
      "accion": "farmaUpdateRet",
      "transId": transferencia.transfId,
      "farmaUserRecoge": user.usersEmail,
    };

    final resp = await dio.get('', queryParameters: params);

    try {
      if (resp.statusCode == 200) {
        // debugPrint('resultado de estatus = 200 ${resp.body}');
        if (resp.data == "No Registrado") return const Right(false);
        return const Right(true);
      } else {
        debugPrint(
            'error en la comunicacion con el servidor ${resp.data} ${resp.data.length}');
        return const Left('Ocurrio un error, intenta nuevamente');
      }
    } catch (e) {
      debugPrint('error en updateTransfRetiro $e');
      return const Left('Ocurrio un error, intenta nuevamente');
    }
  }

  Future<Either<String, bool>> updateTransfEntrega(
      Transferencia transferencia, User user) async {
    if (!user.isActive) {
      debugPrint('usuario invalido');
      return const Left('No puedes realizar está acción');
    }

    final dio = DioInstance.getDio();

    final params = {
      "database": "admin_Smart",
      "accion": "farmaUpdateEnt",
      "transId": transferencia.transfId,
      "farmaUserEntrega": user.usersEmail,
    };

    debugPrint('voy a actualizar');

    final resp = await dio.get('', queryParameters: params);

    // final resp = await http.post(url, body: {
    //   "database": "admin_Smart",
    //   "accion": "farmaUpdateEnt",
    //   "transId": transferencia.transfId,
    //   "farmaUserEntrega": user.usersEmail,
    // });

    try {
      if (resp.statusCode == 200) {
        // debugPrint('resultado de estatus = 200 ${resp.body}');
        if (resp.data == "No Registrado") return const Right(false);
        return const Right(true);
      } else {
        debugPrint(
            'error en la comunicacion con el servidor ${resp.data} ${resp.data.length}');
        return const Left('Error en la comunicación con el servidor');
      }
    } catch (e) {
      debugPrint('error en updateTransfEntrega $e');
      return const Left('Error en la comunicación con el servidor');
    }
  }
}
