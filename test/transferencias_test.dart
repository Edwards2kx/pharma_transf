import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:pharma_transfer/controller/server_comunication.dart';
import 'package:pharma_transfer/controller/transf_service.dart';
import 'package:pharma_transfer/models/producto_model.dart';
import 'package:pharma_transfer/models/recibo_model.dart';
import 'package:pharma_transfer/models/transferencia_model.dart';

void main() async {
  final user = await getUserWithEmail('nedan449@gmail.com');
  if (user == null) debugPrint('user is null');
  debugPrint('user is $user');
  group(
    'transferencias test',
    () {
      final transferService = TransfService();
      Transferencia? transferencia;
      test('send transferencia con 2 productos ', skip: true, () async {
        //Arrange
        final recibo = Recibo(
          fecha: DateTime.now().toString(),
          numeroTransferencia: '838-001-0012863',
          usuSoliTransf: 'EJLLIVIPUM',
          farSoliTransf: 'ECO CONOCOTO',
          usuAutoTransf: 'EEFLORES',
          farAutoTransf: 'MEDI QUITO LA ARMENIA PUENTE 8',
          producto: [
            Producto(nombre: 'Nombre producto 1', ent: 1, frac: 0),
            Producto(nombre: 'Nombre producto 2', ent: 0, frac: 20),
          ],
        );
        //Act
        final response = await pushTransferencia(recibo);
        //Assert
        expect(response, isNotNull);
      });
      test('get transfer from server', () async {
        //Arrange
        //Act
        final response = await transferService.getActiveTransfByUser(user!);
        if (response.isNotEmpty) {
          transferencia = response.first;
        }
        //Assert
        expect(response, isNotEmpty);
      });
      test('modificar transferencia recoger', skip: true, () async {
        //Arrange
        //Act
        final response =
            await transferService.updateTransfRetiro(transferencia!, user!);
        //Assert
        expect(response.isRight, isTrue);
      });
      //!Al parecer las devuelve todas por ser admin
      test('listar transferencias recogidas por usuario', skip: true,
          () async {
        //Arrange
        //Act
        final response = await transferService.getActiveTransfByUser(user!);
        //Assert
        expect(response, isNotEmpty);
      });

      test('modificar transferencia recogidas para entregar', skip: false,
          () async {
        //Arrange
        //Act
        final response =
            await transferService.updateTransfEntrega(transferencia!, user!);
        //Assert
        expect(response.isRight, isTrue);
      });
    },
  );
}
