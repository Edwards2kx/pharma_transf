import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:geolocator/geolocator.dart';
import 'package:pharma_transfer/config/python_gemini_prompt.dart';
import 'package:pharma_transfer/models/pharma_model.dart';
import 'package:pharma_transfer/models/transferencia_model.dart';
import 'package:string_similarity/string_similarity.dart';
import 'package:either_dart/either.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gemini/flutter_gemini.dart';
import 'package:pharma_transfer/config/gemini_prompt.dart';
import 'package:pharma_transfer/controller/server_comunication.dart';
import 'package:pharma_transfer/models/recibo_model.dart';
import 'package:pharma_transfer/models/user_model.dart';

import 'google_sign_in_services.dart';

class ProviderTransferencias extends ChangeNotifier {
  List<Pharma> pharmaList = [];
  List<Transferencia> transfList = [];
  List<Transferencia> transfListAlternative = [];
  User? currentUser;
  Pharma? currentPharma;
  // Location _location = Location();
  double? latitud;
  double? longitud;
  // double _distancia = 0;
  // Distance _distance = Distance();

  double minimunDistance = 200.0;
  DateTime lastUpdate = DateTime.now();
  bool firstBoot = false;

  void booted() {
    firstBoot = true;
    //notifyListeners();
  }

  Future<void> updateTransferencias() async {
    // if (firstBoot == false) firstBoot = true;
    transfList = await getActiveTransferList();
    transfListAlternative = await getAlternateTransferList();
    pharmaList = await getPharmaFromServer(); // remover
    await getCurrentUser();
    await whichPharmaAmIIn();
    lastUpdate = DateTime.now();
    debugPrint('se refresco el provider');
    notifyListeners();
  }

  Future<void> getPharmaInfo() async {
    pharmaList = await getPharmaFromServer();
    debugPrint(' se actualizo la lista de farmacias ${pharmaList.length} elementos');
//    notifyListeners();
  }

  Future<Pharma?> whichPharmaAmIIn() async {
    // final locationPermission = await Geolocator.checkPermission();
    // if (locationPermission == LocationPermission.denied || locationPermission == LocationPermission.deniedForever) return;
    // final location = await Geolocator.getCurrentPosition();
    // latitud = location.latitude;
    // longitud = location.longitude;

    // if(latitud == null || longitud == null) return;

    // if (pharmaList.isEmpty) return;

    //  Distance distance = const Distance();
    // currentPharma = pharmaList.firstWhere((f) {
    //   var dis = distance.as(LengthUnit.Meter, LatLng(latitud!, longitud!),
    //       LatLng(f.farmasLat!, f.farmasLon!));
    //   return (dis <= minimunDistance);
    // });

    // if (currentPharma != null) {
    //   debugPrint('estas en ${currentPharma?.farmasName}');
    // } else {
    //   debugPrint('no estas cerca a una farmacia');
    // }

    final pharmacies = pharmaList;
    if (pharmacies.isEmpty) return null;
    Position position = await Geolocator.getCurrentPosition();
    latitud = position.latitude;
    longitud = position.longitude;
    // Calcula las distancias a todas las farmacias
    List<double> distances = pharmacies.map((pharma) {
      if (pharma.farmasLat != null && pharma.farmasLon != null) {
        double distance = Geolocator.distanceBetween(
          position.latitude,
          position.longitude,
          pharma.farmasLat!,
          pharma.farmasLon!,
        );
        return distance;
      } else {
        return double.infinity;
      }
    }).toList();

    // Encuentra la farmacia más cercana
    double minDistance =
        distances.reduce((value, element) => value < element ? value : element);
    int index = distances.indexOf(minDistance);

    // Retorna la farmacia más cercana
    currentPharma = pharmacies[index];
    return currentPharma;
  }

  // Future<Either<String, Recibo>> procesarImagenRecibo(String imagePath, [Uint8List? imageBytes] ) async {
  Future<Either<String, Recibo>> procesarImagenRecibo(Uint8List? imageBytes) async {
    // final imageFile = File(imagePath);

    if (imageBytes == null) return const Left('No seleccionaste ninguna imagen');
    final gemini = Gemini.instance;
    // final 
    // final geminiResponse = await gemini.textAndImage(
    //     text: kPromptDecodeTicket, images: [imageFile.readAsBytesSync()]);

      final geminiResponse = await gemini.textAndImage(
        text: kPythonPromptDecodeTicket, images: [imageBytes]);


    // final geminiResponse = await gemini.textAndImage(
    //     text: kPythonPromptDecodeTicket, images: [imageFile.readAsBytesSync()]);

    final response = geminiResponse?.content?.parts?.first.text;
    debugPrint('raw response from gemini server $response');
    if (response == null) {
      return const Left('Se presentó un fallo, intenta nueamente');
    }
    final sanitizedResponse = response.substring(
        response.indexOf('{'), response.lastIndexOf('}') + 1);
    final json = jsonDecode(sanitizedResponse);
    final result = json['result'];
    final error = json['error'];
    if (result == null) {
      return const Left('Se presentó un fallo, intenta nueamente');
    }
    if (result == 'SUCCESS') {
      final recibo = Recibo.fromMap(json['body']);
      final pharmaList = await getPharmaFromServer();
      final pharmaListNames = pharmaList.map((e) => e.farmasName).toList();
      final farAutoBestStringComparative =
          StringSimilarity.findBestMatch(recibo.farAutoTransf, pharmaListNames);
      final farSoliBestStringComparative =
          StringSimilarity.findBestMatch(recibo.farSoliTransf, pharmaListNames);
      final reciboValidated = recibo.copyWith(
          farAutoTransf:
              pharmaListNames[farAutoBestStringComparative.bestMatchIndex],
          farSoliTransf:
              pharmaListNames[farSoliBestStringComparative.bestMatchIndex]);
      debugPrint(reciboValidated.toString());
      return Right(reciboValidated);
    }
    // if (result == 'ERROR') {
    if (error != null) {
      debugPrint('se presento el siguiente error ${json['body']['message'].toString()}.');
      // return Left(json['body']['message'].toString());
      return Left(error.toString());
    }
    return const Left('Error al procesar la imagen');
  }

  Future<void> getCurrentUser() async {
    final accountGoogle = GoogleSignInService.currentUser();
    currentUser = await getUserWithEmail(accountGoogle!.email);
  }
}
