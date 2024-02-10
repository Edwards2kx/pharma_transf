import 'package:flutter_test/flutter_test.dart';
import 'package:pharma_transfer/controller/transf_service.dart';
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
}
