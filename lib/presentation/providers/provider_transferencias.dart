import 'dart:typed_data';

import 'package:collection/collection.dart';
import 'package:geolocator/geolocator.dart';
import 'package:pharma_transfer/controller/image_gemini_decoder.dart';
import 'package:pharma_transfer/controller/transf_service.dart';
import 'package:pharma_transfer/controller/user_location_service.dart';
import 'package:pharma_transfer/models/pharma_info_model.dart';
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
  Pharma? _currentPharma;
  double? latitud; //la vista no deveria necesitar latitud y longitud
  double? longitud;
  final double kMinimunDistance = 200.0;
  DateTime lastUpdate = DateTime.now();
  bool firstBoot = false;
  bool isLoading = false;
  List<UserLocation> _usersMotoLocationList = [];

  ///Carga inicial de la aplicacion despues del login
  Future<void> initialLoad() => _initialLoad();

  // Set<Pharma> get getFarmaciasParaRecoger => _getFarmaciasParaRecoger();
  @Deprecated('reemplazado por getFarmaciasConEventos')
  Set<PharmaInfo> get getFarmaciasParaRecoger => _getFarmaciasParaRecoger();
// @Deprecated('reemplazado por getFarmaciasConEventos')
  // Set<PharmaInfo> get getFarmaciasParaEntregar => _getFarmaciasParaEntregar();

  Set<PharmaInfo> get getFarmaciasConEventos => _getFarmaciasConEventos();

  Pharma? get getFarmaciaCercana => _currentPharma;

  List<Transferencia> get getTransferenciasActivas =>
      _getTransferenciasActivas();

  List<Transferencia> get getTransferenciasTerminadas =>
      _transferenciasTerminadas;

  Map<String, List<UserLocation>> get getUserLocationList =>
      _getUserLocationList();

  Future<Either<String, bool>> updateTransfEntrega(
          Transferencia transferencia) =>
      transfService.updateTransfEntrega(transferencia, currentUser!);

  Future<Either<String, bool>> updateTransfRetiro(
          Transferencia transferencia) =>
      transfService.updateTransfRetiro(transferencia, currentUser!);

  Map<String, List<UserLocation>> _getUserLocationList() {
    Map<String, List<UserLocation>> groupedByUser =
        _usersMotoLocationList.groupListsBy((loc) => loc.userName);

    groupedByUser.forEach((userName, userLocations) {
      userLocations.sort((a, b) => b.dateTime.compareTo(a.dateTime));
    });

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

//TODO: devolver un either con mensaje de error
  Future<void> _initialLoad() async {
    if (isLoading) return;
    isLoading == true;
    await getCurrentUser();
    await getPharmaList();
    await fetchTransferenciasActivas(); //aqui obtengo la ubicacion
    await fetchTransferenciasTerminadas(); //*probar un lazyload
    await fetchUsersMotoLocation(); //*probar un lazyload
    await updateNearPharma();
    await registrarUbicacion();
    isLoading == false;
  }

  Future<void> fetchUsersMotoLocation() async {
    _usersMotoLocationList = await _locationService.fetchUsersMotoLocation();
    notifyListeners();
  }

  Future<void> fetchTransferenciasActivas() async {
    if (isLoading || currentUser == null) return;
    isLoading == true;
    await actualizarUbicacionActual();
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

  Future<void> updateNearPharma() async {
    if (isLoading) return;
    isLoading = true;
    final pharmacies = _pharmaList;
    if (pharmacies.isEmpty) return;
    final response = await actualizarUbicacionActual();
    if (!response) {
      _currentPharma = null;
      isLoading = false;
      return;
    }

    List<double> distances = pharmacies.map((pharma) {
      if (pharma.farmasLat != null && pharma.farmasLon != null) {
        double distance = Geolocator.distanceBetween(
          latitud!,
          longitud!,
          pharma.farmasLat!,
          pharma.farmasLon!,
        );
        return distance;
      } else {
        return double.infinity;
      }
    }).toList();

    double minDistance =
        distances.reduce((value, element) => value < element ? value : element);

    if (minDistance > kMinimunDistance) {
      _currentPharma = null;
      isLoading = false;
      return;
    }
    final index = distances.indexOf(minDistance);
    _currentPharma = pharmacies[index];
    isLoading = false;
    notifyListeners();
    return;
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

  // Set<PharmaInfo> _getFarmaciasParaEntregar() {
  //   Set<Pharma> farmasParaEntregar = {};
  //   Map<String, int> productosPorFarmacia = {};
  //   Set<PharmaInfo> farmasInfo = {};

  //   for (var transferencia in _transferenciasActivas) {
  //     final farmaSolicita = transferencia.transfFarmaSolicita;
  //     final farmaAcepta = transferencia.transfFarmaAcepta;
  //     final estado = transferencia.estado;
  //     final dataCompleta = (farmaSolicita != null && farmaAcepta != null);
  //     final perteneceUsuario =
  //         (transferencia.usuarioRecoge == currentUser?.usersEmail);
  //     final productosEnTransferencia =
  //         transferencia.transfCantidadEntera != null
  //             ? 1
  //             : transferencia.transfCantidadFraccion != null
  //                 ? 1
  //                 : 0;

  //     if (estado == EstadoTransferencia.recogido &&
  //         dataCompleta &&
  //         perteneceUsuario) {
  //       final farmacia = _pharmaList.firstWhere(
  //           (f) => f.farmasName == farmaSolicita,
  //           orElse: () => Pharma()..farmasName = farmaSolicita);
  //       farmasParaEntregar.add(farmacia);

  //       productosPorFarmacia.update(farmacia.farmasName!, (value) => value + 1,
  //           ifAbsent: () => productosEnTransferencia);
  //     }
  //   }
  //   for (var f in farmasParaEntregar) {
  //     double? distancia;
  //     if (latitud != null &&
  //         longitud != null &&
  //         f.farmasLat != null &&
  //         f.farmasLon != null) {
  //       distancia = Geolocator.distanceBetween(
  //           latitud!, longitud!, f.farmasLat!, f.farmasLon!);
  //     }
  //     farmasInfo.add(
  //       PharmaInfo(
  //           farmacia: f,
  //           distancia: distancia,
  //           prodRecoger: productosPorFarmacia[f.farmasName]!),
  //     );
  //   }
  //   // return farmasParaEntregar;
  //   return farmasInfo;
  // }

  Set<PharmaInfo> _getFarmaciasConEventos() {
    Set<Pharma> farmasConEvento = {};
    Map<String, int> cantProdRecogerFarmacia = {};
    Map<String, int> cantProdEntregarFarmacia = {};
    Map<String, int> cantProdEntregarUsuario = {};
    Set<PharmaInfo> farmasInfo = {};

    for (var transferencia in _transferenciasActivas) {
      final farmaSolicita = transferencia.transfFarmaSolicita;
      final farmaAcepta = transferencia.transfFarmaAcepta;
      final estado = transferencia.estado;
      final dataCompleta = (farmaSolicita != null && farmaAcepta != null);
      // final perteneceUsuario =
      //     (transferencia.usuarioRecoge == 'nedan449@gmail.com');
      final perteneceUsuario =
          (transferencia.usuarioRecoge == currentUser?.usersEmail);
      final productosEnTransferencia =
          transferencia.transfCantidadEntera != null
              ? 1
              : transferencia.transfCantidadFraccion != null
                  ? 1
                  : 0;

      // if ((estado == EstadoTransferencia.recogido &&
      //         dataCompleta &&
      //         perteneceUsuario) ||
      //     (estado == EstadoTransferencia.pendiente && dataCompleta)) {

      //producto nuevo para recoger en esta farmacia 
      if (estado == EstadoTransferencia.pendiente && dataCompleta) {
        final farmacia = _pharmaList.firstWhere(
            (f) => f.farmasName == farmaAcepta,
            orElse: () => Pharma()..farmasName = farmaAcepta);
        farmasConEvento.add(farmacia);

        cantProdRecogerFarmacia.update(
            farmacia.farmasName!, (value) => value + 1,
            ifAbsent: () => productosEnTransferencia);
      }
      //producto sin recoger a llevar a esta farmacia 
       if (estado == EstadoTransferencia.pendiente && dataCompleta) {
        final farmacia = _pharmaList.firstWhere(
            (f) => f.farmasName == farmaSolicita,
            orElse: () => Pharma()..farmasName = farmaSolicita);
        farmasConEvento.add(farmacia);

        cantProdEntregarFarmacia.update(
            farmacia.farmasName!, (value) => value + 1,
            ifAbsent: () => productosEnTransferencia);
      }
      //producto recogido para entregar por usuario
      //TODO: verificar lo del administrador
       if (estado == EstadoTransferencia.recogido &&
          dataCompleta &&
          (perteneceUsuario || currentUser?.userCargo == UserCargo.administrador  )) {
        final farmacia = _pharmaList.firstWhere(
            (f) => f.farmasName == farmaSolicita,
            orElse: () => Pharma()..farmasName = farmaSolicita);
        farmasConEvento.add(farmacia);

        cantProdEntregarUsuario.update(
            farmacia.farmasName!, (value) => value + 1,
            ifAbsent: () => productosEnTransferencia);
      }
    }
    for (var f in farmasConEvento) {
      double? distancia;
      if (latitud != null &&
          longitud != null &&
          f.farmasLat != null &&
          f.farmasLon != null) {
        distancia = Geolocator.distanceBetween(
            latitud!, longitud!, f.farmasLat!, f.farmasLon!);
      }
      farmasInfo.add(
        PharmaInfo(
            farmacia: f,
            distancia: distancia,
            prodRecoger: cantProdRecogerFarmacia[f.farmasName] ?? 0,
            prodRecogidoUsuario: cantProdEntregarUsuario[f.farmasName] ?? 0,
            prodEntregar: cantProdEntregarFarmacia[f.farmasName]?? 0),
      );
    }
    // return farmasParaEntregar;
    return farmasInfo;
  }

@Deprecated('reemplazado por _getFarmaciasConEventos')
  Set<PharmaInfo> _getFarmaciasParaRecoger() {
    Set<Pharma> farmasParaRecoger = {};
    Map<String, int> productosPorFarmacia = {};
    Set<PharmaInfo> farmasInfo = {};
    for (var transferencia in _transferenciasActivas) {
      final farmaSolicita = transferencia.transfFarmaSolicita;
      final farmaAcepta = transferencia.transfFarmaAcepta;
      final estado = transferencia.estado;
      final dataCompleta = (farmaSolicita != null && farmaAcepta != null);
      final productosEnTransferencia =
          transferencia.transfCantidadEntera != null
              ? 1
              : transferencia.transfCantidadFraccion != null
                  ? 1
                  : 0;

      if (estado == EstadoTransferencia.pendiente && dataCompleta) {
        final farmacia = _pharmaList.firstWhere(
            (f) => f.farmasName == farmaAcepta,
            orElse: () => Pharma()..farmasName = farmaAcepta);
        farmasParaRecoger.add(farmacia);

        productosPorFarmacia.update(farmacia.farmasName!, (value) => value + 1,
            ifAbsent: () => productosEnTransferencia);
      }
    }
    for (var f in farmasParaRecoger) {
      double? distancia;
      if (latitud != null &&
          longitud != null &&
          f.farmasLat != null &&
          f.farmasLon != null) {
        distancia = Geolocator.distanceBetween(
            latitud!, longitud!, f.farmasLat!, f.farmasLon!);
      }
      farmasInfo.add(
        PharmaInfo(
            farmacia: f,
            distancia: distancia,
            prodRecoger: productosPorFarmacia[f.farmasName]!,
            prodRecogidoUsuario: 0,
            prodEntregar: 0),
      );
    }
    return farmasInfo;
  }

  Future<Either<String, bool>> registrarUbicacion() async {
    if (currentUser?.userCargo != UserCargo.motorizado) {
      return const Right(false);
    }

    final status = await Geolocator.checkPermission();

    if (status == LocationPermission.whileInUse ||
        status == LocationPermission.always) {
      try {
        final location = await Geolocator.getCurrentPosition();
        //actualiza la ubicacion en el provider
        latitud = location.latitude;
        longitud = location.longitude;

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

  Future<bool> actualizarUbicacionActual() async {
    final status = await Geolocator.checkPermission();
    if (status == LocationPermission.whileInUse ||
        status == LocationPermission.always) {
      try {
        final location = await Geolocator.getCurrentPosition();
        latitud = location.latitude;
        longitud = location.longitude;
        return true;
      } catch (e) {
        debugPrint('No se pudo leer la ubicación del dispositivo exception $e');
        return false;
      }
    }
    return false;
  }
}
