// ignore_for_file: avoid_print

import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:pharma_transfer/controller/transf_service.dart';
import 'package:pharma_transfer/models/pharma_model.dart';
import 'package:pharma_transfer/models/user_model.dart';

void main() {
  final User usuarioAdministrador = User(
      usersId: '2',
      usersDate: DateTime.now(),
      usersEmail: 'emoticsas@gmail.com',
      usersNombre: '',
      usersEstado: '1',
      userCargo: UserCargo.administrador);

  final User usuarioDependiente = User(
      usersId: '13',
      usersDate: DateTime.now(),
      usersEmail: 'eduardo.mendoza.ojeda@gmail.com',
      usersNombre: '',
      usersEstado: '1',
      userCargo: UserCargo.dependiente,
      dependencia: 'ECO QUITO ALMA LOJANA');

  test('obtener transferencias como administrador o motorizado, success',
      () async {
    final service = TransfService();
    final activeTransf =
        await service.getActiveTransfByUser(usuarioAdministrador);

    print('se obtuvieron ${activeTransf.length} transferencias activas');

    expect(activeTransf, isNotEmpty);
  });

  test('obtener transferencias como dependiente con farmacia, success',
      () async {
    final service = TransfService();
    final activeTransf =
        await service.getActiveTransfByUser(usuarioDependiente);

    print('se obtuvieron ${activeTransf.length} transferencias activas');

    expect(activeTransf, isNotEmpty);
  });

  test('obtener transferencias como dependiente, farmacia = null, failed',
      () async {
    final service = TransfService();
    final activeTransf =
        await service.getActiveTransfByUser(usuarioDependiente.copyWith(dependencia: ''));

    print('se obtuvieron ${activeTransf.length} transferencias activas');

    expect(activeTransf, isNotEmpty);
  });

  test('Pharma from Json', ()  {
    //Arrange
    const String pharmaInString = '{"farmas_id": "1","farmas_name": "ECO QUITO LAS ORQUIDEAS","farmas_lat": "-0.2257","farmas_lon": "-78.4902","farmas_horario": "8:00 - 21:00"}';
    const String pharmaInStringWithNulls = '{"farmas_id": "37","farmas_name": "ECO 10 DE AGOSTO QUITO","farmas_lat": null,"farmas_lon": null,"farmas_horario": null}';
    // final pharma = Pharma.fromJson(jsonDecode(pharmaInString));
    final pharma = Pharma.fromJson(jsonDecode(pharmaInStringWithNulls));

    print(pharma);

    expect(pharma, isNotNull);

  });
}
