import 'dart:typed_data';

import 'package:collection/collection.dart';
import 'package:geolocator/geolocator.dart';
import 'package:pharma_transfer/controller/image_gemini_decoder.dart';
import 'package:pharma_transfer/controller/transf_service.dart';
import 'package:pharma_transfer/controller/user_location_service.dart';
import 'package:pharma_transfer/models/pharma_model.dart';
import 'package:pharma_transfer/models/transferencia_model.dart';
import 'package:either_dart/either.dart';
import 'package:flutter/material.dart';
import 'package:pharma_transfer/controller/server_comunication.dart';
import 'package:pharma_transfer/models/recibo_model.dart';
import 'package:pharma_transfer/models/user_location_model.dart';
import 'package:pharma_transfer/models/user_model.dart';
import '../../controller/google_sign_in_services.dart';

class ProviderTransferencias extends ChangeNotifier {
  final UserLocationService _locationService = UserLocationService();
  final TransfService transfService = TransfService();

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
  List<UserLocation> _usersLocationList = [];

  Set<Pharma> get getFarmaciasParaRecoger => _getFarmaciasParaRecoger();

  Set<Pharma> get getFarmaciasParaEntregar => _getFarmaciasParaEntregar();

  List<Transferencia> get getTransferenciasActivas =>
      _getTransferenciasActivas();

  List<Transferencia> get getTransferenciasTerminadas =>
      _transferenciasTerminadas;

  Map<String, List<UserLocation>> get getUserLocationList => _getUserLocationList();


  Map<String, List<UserLocation>> _getUserLocationList() {
    Map<String, List<UserLocation>> groupedByUser =
        _usersLocationList.groupListsBy((loc) => loc.userName);

    groupedByUser.forEach((userName, userLocations) {
      userLocations.sort((a, b) => b.dateTime.compareTo(a.dateTime));
    });

    // for (var user in groupedByUser.keys) {
    //   debugPrint(
    //       'registros para usuario user :  ${groupedByUser[user]?.length}');
    //       debugPrint(
    //       'el registro más reciente es :  ${groupedByUser[user]?.first.dateTime}');
    // }
    return groupedByUser;
  }

  List<Transferencia> _getTransferenciasActivas() {
    return _transferenciasActivas.where((t) {
      final dataCompleta =
          t.transfFarmaSolicita != null && t.transfFarmaAcepta != null;

      final sinRecoger = t.estado == EstadoTransferencia.pendiente;
      final recogidoPorUsuario = t.usuarioRecoge == currentUser?.usersEmail;

      return dataCompleta && (sinRecoger || recogidoPorUsuario);
    }).toList();
  }

  // @Deprecated(
  //     'reemplazado por fetchTransferenciasActivas y fetchTransferenciasTerminadas')
  // Future<void> updateTransferencias() async {
  //   if (isLoading) return;
  //   isLoading == true;
  //   // if (firstBoot == false) firstBoot = true;
  //   _transferenciasActivas = await getActiveTransferList();
  //   _pharmaList = await getPharmaFromServer(); // remover
  //   await getCurrentUser();
  //   await nearPharma();
  //   isLoading == false;
  //   lastUpdate = DateTime.now();
  //   debugPrint('se refresco el provider');
  //   await registrarUbicacion();
  //   notifyListeners();
  // }

//TODO: devolver un either con mensaje de error
  Future<void> initialLoad() async {
    if (isLoading) return;
    isLoading == true;
    await getCurrentUser();
    await getPharmaList();
    await fetchTransferenciasActivas();
    await fetchTransferenciasTerminadas();
    await fetchUsersLocation();
    await registrarUbicacion();
    isLoading == false;
  }

  Future<void> fetchUsersLocation() async {
    _usersLocationList = await _locationService.fetchUsersLocation();
    notifyListeners();
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
    final user = await getUserWithEmail(accountGoogle!.email);
    if (user == null) {
      //TODO: lanzar una excepcion
      return;
    }
    currentUser = user;
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

  Future<Either<String, bool>> registrarUbicacion() async {
    final status = await Geolocator.checkPermission();

    if (status == LocationPermission.whileInUse ||
        status == LocationPermission.always) {
      try {
        final location = await Geolocator.getCurrentPosition();

        final userLocation = UserLocation(
            dateTime: DateTime.now(),
            userEmail: currentUser!.usersEmail,
            userName: currentUser?.usersNombre ?? '',
            latitud: location.latitude,
            longitud: location.longitude);
        final response = await _locationService.pushUserLocation(userLocation);
        return Right(response);
      } catch (e) {
        debugPrint('No se pudo leer la ubicación del dispositivo exception $e');
        return const Left('No se pudo leer la ubicación del dispositivo');
      }
    } else {
      return const Left('Sin permiso de ubicación');
    }
  }

  Future<Either<String, bool>> updateTransfEntrega(
          Transferencia transferencia) =>
      transfService.updateTransfEntrega(transferencia, currentUser!);

  Future<Either<String, bool>> updateTransfRetiro(
          Transferencia transferencia) =>
      transfService.updateTransfRetiro(transferencia, currentUser!);
}
