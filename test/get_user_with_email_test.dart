import 'package:flutter_test/flutter_test.dart';
import 'package:pharma_transfer/controller/dio_instance.dart';
import 'package:pharma_transfer/controller/server_comunication.dart';

void main() {
  test('getUserWithEmail', () async {
    //Arrange
    const email = 'nedan449@gmail.com';
    //Act
    final dio = DioInstance.getDio();

    final response = await dio.get('', queryParameters: {
      'accion': 'getFarmaUser',
      'farmaUserEmail': email,
    });
    // final user = await getUserWithEmail(email);
    //Assert
    expect(response.statusCode, 200);
  });

  test('getPharmaFromServer', () async {
    //Arrange
    //Act
    final pharmaList = await getPharmaFromServer();
    //Assert
    expect(pharmaList, isNotEmpty);
  });
  test('getUserWithEmail', () async {
    //Arrange
    const email = 'nedan449@gmail.com';
    //Act
    final user = await getUserWithEmail(email);
    //Assert
    expect(user?.usersEmail, email);
  });
}