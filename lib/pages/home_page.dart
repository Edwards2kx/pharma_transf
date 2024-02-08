import 'dart:typed_data';

import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:go_router/go_router.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

import 'package:pharma_transfer/controller/google_sign_in_services.dart';
import 'package:pharma_transfer/controller/provider_transferencias.dart';
import 'package:pharma_transfer/controller/server_comunication.dart';
import 'package:pharma_transfer/models/transferencia_model.dart';
import 'package:pharma_transfer/pages/done_transfer_page.dart';
import 'package:pharma_transfer/pages/pharma_page.dart';
import 'package:pharma_transfer/pages/transf_page.dart';
import 'package:pharma_transfer/pages/widgets/drawer_widget.dart';
import 'package:pharma_transfer/pages/widgets/image_cropper.dart';
import 'package:pharma_transfer/pages/widgets/result_sheet_widget.dart';

import 'login_page.dart';

const bool kUseCropper = true;
const bool kallowGuestMode = false;

class HomePage extends StatefulWidget {
  static String route = '/homepage';
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final _connectivity = Connectivity();
  late GoogleSignInAccount? accountGoogle;
  final PageController controller = PageController(initialPage: 1);

  bool showSearchButton = false;
  bool showSearchBox = false;
  String searchString = '';
  TextEditingController searchBoxController = TextEditingController();
  late List<Transferencia> listaTransferencia;

  @override
  void initState() {
    _connectivity.checkConnectivity().then((value) {
      debugPrint('si hay internet');

//TODO: mover la solicitud de permiso a otro lugar
      Geolocator.requestPermission()
          .then((value) => debugPrint('estado permiso de ubiciación $value'));
    });

    accountGoogle = GoogleSignInService.currentUser();
    //guardian de ruta... si es null el usuario activo se devuelve a login
    if (accountGoogle == null) context.go(LoginPage.route);
    getUserWithEmail(accountGoogle!.email).then((user) {
      debugPrint('user existe? ${user?.usersNombre}');
      if (user == null || user.usersEstado == '0') {
        showDialog(
          barrierDismissible: false,
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Usuario no autorizado'),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  GoogleSignInService.signOut();
                  context.go(LoginPage.route);
                },
                child: const Text('Salir'),
              ),
            ],
          ),
        );
      }
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<ProviderTransferencias>(context, listen: false);
    final scaffoldKey = GlobalKey<ScaffoldState>();
    final DateTime lastUpdate = provider.lastUpdate;
    if (accountGoogle == null && kallowGuestMode == false) {
      return const Center(
        child: Text('No se ha iniciado sesion correctamente'),
      );
    } else {
      return WillPopScope(
        onWillPop: _onWillPop,
        child: Scaffold(
          key: scaffoldKey,
          appBar: _buildAppBar(lastUpdate),
          // backgroundColor: const Color(0xFFd4d4d4),
          // backgroundColor: const Color(Colors.red),
          drawer: CustomDrawer(
              controller: controller,
              scaffoldKey: scaffoldKey,
              accountGoogle: accountGoogle),
          body: Container(
            width: double.infinity,
            height: double.infinity,
            color: const Color(0xFFE7E7E7),
            child: PageView(
              controller: controller,
              children: [
                TransfPage(),
                PharmaPage(),
                DoneTransfPage(
                  searchString: searchString,
                )
              ],
            ),
          ),
          floatingActionButton: _floatButton(),
        ),
      );
    }
  }

  Future<bool> _onWillPop() async {
    return (await showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Deseas salir de la app?'),
            actions: <Widget>[
              TextButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: const Text('No'),
              ),
              TextButton(
                onPressed: () => Navigator.of(context).pop(true),
                child: const Text('Si'),
              ),
            ],
          ),
        )) ??
        false;
  }

//TODO: extraer el appbar a un widget y desde allí manejar el provider que actualiza la hora
  AppBar _buildAppBar(DateTime lastUpdate) {
    return AppBar(
      iconTheme: const IconThemeData(color: Colors.white),
      flexibleSpace: Container(
        decoration: BoxDecoration(
            gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: <Color>[Colors.blue[200]!, Colors.blue[600]!])),
      ),
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Pharma Transf', style: TextStyle(color: Colors.white)),
          Text(
              'Ultima actualización: ${lastUpdate.hour}:${lastUpdate.minute.toString().padLeft(2, '0')}:${lastUpdate.second.toString().padLeft(2, '0')}',
              style: const TextStyle(fontSize: 12, color: Colors.white)),
        ],
      ),
      actions: [
        //TODO: validar por las paginas en el controller
        if (showSearchBox == false)
          IconButton(
            onPressed: () async {
              await getImageAndProcess(ImageSource.gallery);
            },
            icon:
                const Icon(Icons.image_search, color: Colors.white, size: 32.0),
          ),
      ],
    );
  }

 
  FloatingActionButton _floatButton() {
    return FloatingActionButton.large(
      child: const Icon(Icons.add_a_photo, color: Colors.black87),
      onPressed: () async {
        await getImageAndProcess(ImageSource.camera);
      },
    );
  }

  Future<void> getImageAndProcess(ImageSource imageSource) async {
    try {
      final imagePicker = ImagePicker();
      final imageFile = await imagePicker.pickImage(source: imageSource);
      if (imageFile == null) return;
      final imageCropped = await _callImageCropper(imageFile.path);
      if (imageCropped == null) return;
      _showImageResultBottomSheet(imageCropped);
    } catch (e) {
      debugPrint('Error al seleccionar la imagen: $e');
    }
  }

  Future<Uint8List?> _callImageCropper(String imagePath) async {
    return await Navigator.push<Uint8List>(
      context,
      MaterialPageRoute(
        builder: (_) => CropperWidget(
          title: 'Recorta y endereza la imagen',
          imagePath: imagePath,
        ),
      ),
    );
  }

//llama al bottom sheet que muestra la información de la imagen
  void _showImageResultBottomSheet(Uint8List image) {
    double screenHeight = MediaQuery.of(context).size.height;
    double sheetHeight = screenHeight * 0.9;
    showModalBottomSheet(
      isScrollControlled: true,
      context: context,
      builder: (BuildContext context) {
        return SizedBox(
          width: double.infinity,
          height: sheetHeight,
          child: ResultSheetWidget(image: image),
        );
      },
    );
  }
}
