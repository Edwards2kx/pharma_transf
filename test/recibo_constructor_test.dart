

import 'package:flutter_test/flutter_test.dart';
import 'package:pharma_transfer/controller/server_comunication.dart';


void main() {
  test('Recibo constructor from map', () async {
    //Arrange

    final farmacias = await getPharmaFromServer();
    for (var farmacia in farmacias) {
      print(farmacia.farmasName);
    }
    // print(farmacias);
  });

  test('getAlternateTransferList', () async {
    final listaActiva = await getActiveTransferList();
    print(listaActiva.length);

    final listaAlternativa = await getAlternateTransferList();
    print(listaAlternativa.length);

    final user = await getUserWithEmail('emoticsas@gmail.com');
    print(user);
  });
}
