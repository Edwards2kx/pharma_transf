import 'dart:typed_data';

import 'package:geolocator/geolocator.dart';
import 'package:pharma_transfer/controller/image_gemini_decoder.dart';
import 'package:pharma_transfer/controller/transf_service.dart';
import 'package:pharma_transfer/models/pharma_model.dart';
import 'package:pharma_transfer/models/transferencia_model.dart';
import 'package:either_dart/either.dart';
import 'package:flutter/material.dart';
import 'package:pharma_transfer/controller/server_comunication.dart';
import 'package:pharma_transfer/models/recibo_model.dart';
import 'package:pharma_transfer/models/user_model.dart';
import 'google_sign_in_services.dart';

class ProviderTransferencias extends ChangeNotifier {
  List<Pharma> _pharmaList = [];
  List<Transferencia> _transferenciasActivas = [];
  List<Transferencia> _transferenciasTerminadas = [];
  User? currentUser;
  Pharma? currentPharma;
  double? latitud; //la vista no deveria necesitar latitud y longitud
  double? longitud;
  double minimunDistance = 200.0;
  DateTime lastUpdate = DateTime.now();
  bool firstBoot = false;
  bool isLoading = false;

  final TransfService transfService = TransfService();

  Set<Pharma> get getFarmaciasParaRecoger => _getFarmaciasParaRecoger();

  Set<Pharma> get getFarmaciasParaEntregar => _getFarmaciasParaEntregar();


///Devuelve el listado de transferencias activas sin recoger, o recogidas para entrega
///del usuario actual.
  List<Transferencia> get getTransferenciasActivas => _getTransferenciasActivas();
  //TODO: verificar si es necesario filtrar por relacionadas con usuario o dependiente
///Devuelve el listado de transferencias terminadas por el usuario actual.
  List<Transferencia> get getTransferenciasTerminadas =>
      _transferenciasTerminadas;


  List<Transferencia> _getTransferenciasActivas() {
    return _transferenciasActivas.where((t) {
      final dataCompleta =
          t.transfFarmaSolicita != null && t.transfFarmaAcepta != null;

      final sinRecoger = t.estado == EstadoTransferencia.pendiente;
      final recogidoPorUsuario = t.usuarioRecoge == currentUser?.usersEmail;

      return dataCompleta && (sinRecoger || recogidoPorUsuario);
    }).toList();
  }

  // List<Transferencia> _getTransferenciasActivas() {

  //   final transferencias = <Transferencia>[];

  //   for (var transferencia in _transferenciasActivas) {
  //     final dataCompleta = (transferencia.transfFarmaSolicita != null &&
  //         transferencia.transfFarmaAcepta != null);

  //     final sinRecoger =
  //         (transferencia.estado == EstadoTransferencia.pendiente);

  //     final recogidoPorUsuario =
  //         (transferencia.usuarioRecoge == currentUser?.usersEmail);

  //     if (dataCompleta && (sinRecoger || recogidoPorUsuario)) {
  //       transferencias.add(transferencia);
  //     }
  //   }
  //   return transferencias;

  // }

  @Deprecated(
      'reemplazado por fetchTransferenciasActivas y fetchTransferenciasTerminadas')
  Future<void> updateTransferencias() async {
    if (isLoading) return;
    isLoading == true;
    // if (firstBoot == false) firstBoot = true;
    _transferenciasActivas = await getActiveTransferList();
    _pharmaList = await getPharmaFromServer(); // remover
    await getCurrentUser();
    await nearPharma();
    isLoading == false;
    lastUpdate = DateTime.now();
    debugPrint('se refresco el provider');
    notifyListeners();
  }



//TODO: devolver un either con mensaje de error
  Future<void> initialLoad() async {
    if (isLoading) return;
    isLoading == true;
    await getCurrentUser();
    await getPharmaList();
    await fetchTransferenciasActivas();
    await fetchTransferenciasTerminadas();
    isLoading == false;
  }

  Future<void> fetchTransferenciasActivas() async {
    if (isLoading || currentUser == null) return;
    isLoading == true;
    _transferenciasActivas =
        await transfService.getActiveTransfByUser(currentUser!);
    isLoading == false;
    lastUpdate = DateTime.now();
    debugPrint(
        'se refresco el provider transferencias activas con fetchTransferenciasActivas');
    notifyListeners();
  }

  Future<void> fetchTransferenciasTerminadas() async {
    if (isLoading || currentUser == null) return;
    isLoading == true;
    _transferenciasTerminadas =
        await transfService.getFinishedTransfByUser(currentUser!);
    isLoading == false;
    lastUpdate = DateTime.now();
    debugPrint(
        'se refresco el provider transferencias terminadas fetchTransferenciasTerminadas');
    notifyListeners();
  }

  Future<void> getPharmaList() async {
    _pharmaList = await getPharmaFromServer();
    debugPrint(
        ' se actualizo la lista de farmacias ${_pharmaList.length} elementos');
//    notifyListeners();
  }

  Future<Pharma?> nearPharma() async {
    final pharmacies = _pharmaList;
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
    //TODO verificar que la distancia esté en el rango minimunDistance
    currentPharma = pharmacies[index];
    return currentPharma;
  }

  Future<Either<String, Recibo>> procesarImagenRecibo(Uint8List? imageBytes) =>
      ImageGeminiDecoder.procesarImagen(imageBytes);

  Future<void> getCurrentUser() async {
    final accountGoogle = GoogleSignInService.currentUser();
    currentUser = await getUserWithEmail(accountGoogle!.email);
  }

  Set<Pharma> _getFarmaciasParaEntregar() {
    Set<Pharma> farmasParaEntregar = {};
    for (var transferencia in _transferenciasActivas) {
      final farmaSolicita = transferencia.transfFarmaSolicita;
      final farmaAcepta = transferencia.transfFarmaAcepta;
      final estado = transferencia.estado;
      final dataCompleta = (farmaSolicita != null && farmaAcepta != null);
      final perteneUsuario =
          (transferencia.usuarioRecoge == currentUser?.usersEmail);

      if (estado == EstadoTransferencia.recogido &&
          dataCompleta &&
          perteneUsuario) {
        final farmacia = _pharmaList.firstWhere(
            (f) => f.farmasName == farmaSolicita,
            orElse: () => Pharma()..farmasName = farmaSolicita);
        farmasParaEntregar.add(farmacia);
      }
    }
    return farmasParaEntregar;
  }

  Set<Pharma> _getFarmaciasParaRecoger() {
    Set<Pharma> farmasParaRecoger = {};
    for (var transferencia in _transferenciasActivas) {
      final farmaSolicita = transferencia.transfFarmaSolicita;
      final farmaAcepta = transferencia.transfFarmaAcepta;
      final estado = transferencia.estado;

      if (estado == EstadoTransferencia.pendiente &&
          farmaSolicita != null &&
          farmaAcepta != null) {
        final farmacia = _pharmaList.firstWhere(
            (f) => f.farmasName == farmaAcepta,
            orElse: () => Pharma()..farmasName = farmaAcepta);
        farmasParaRecoger.add(farmacia);
      }
    }
    return farmasParaRecoger;
  }
}
