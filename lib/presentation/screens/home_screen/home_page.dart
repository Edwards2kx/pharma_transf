import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:pharma_transfer/presentation/screens/home_screen/pages/farmacias_page.dart';
import 'package:pharma_transfer/presentation/screens/home_screen/pages/historial_transferencias_page.dart';
import 'package:pharma_transfer/presentation/screens/home_screen/pages/transferencias_page.dart';
import 'package:pharma_transfer/presentation/screens/home_screen/pages/ubicaciones_usuarios_page.dart';
import 'package:pharma_transfer/presentation/screens/home_screen/widgets/drawer_widget.dart';
import 'package:pharma_transfer/presentation/screens/home_screen/widgets/image_cropper_widget.dart';
import 'package:pharma_transfer/presentation/screens/home_screen/widgets/result_sheet_widget.dart';
import 'package:pharma_transfer/presentation/screens/login_screen/login_page.dart';
import 'package:provider/provider.dart';
import 'package:connectivity/connectivity.dart';
import 'package:go_router/go_router.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:image_picker/image_picker.dart';
import 'package:pharma_transfer/models/user_model.dart';
import 'package:pharma_transfer/controller/google_sign_in_services.dart';
import 'package:pharma_transfer/presentation/providers/provider_transferencias.dart';
import 'package:pharma_transfer/controller/server_comunication.dart';
import 'package:pharma_transfer/models/transferencia_model.dart';

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
  final List<int> _pageKeys = [0, 1, 2, 3];

//TODO:remover estos 2 estados
  bool showSearchButton = false;
  bool showSearchBox = false;
  String searchString = '';
  TextEditingController searchBoxController = TextEditingController();
  late List<Transferencia> listaTransferencia;

  @override
  void initState() {
    super.initState();
    _connectivity.checkConnectivity().then((value) {
      debugPrint('si hay internet');
    });

    accountGoogle = GoogleSignInService.currentUser();
    if (accountGoogle == null) context.go(LoginPage.route);
    getUserWithEmail(accountGoogle!.email).then((user) {
      debugPrint("$user");
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
  }

  @override
  void dispose() {
    controller.dispose(); // Liberar recursos asociados con el PageController
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final provider =
        Provider.of<ProviderTransferencias>(context, listen: false);
    final isAdmin =
        (provider.currentUser?.userCargo == UserCargo.administrador);
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
          backgroundColor: Theme.of(context).colorScheme.onInverseSurface,
          key: scaffoldKey,
          appBar: _buildAppBar(lastUpdate),
          drawer: CustomDrawer(
            controller: controller,
            scaffoldKey: scaffoldKey,
            // accountGoogle: accountGoogle
          ),
          body: SizedBox(
            width: double.infinity,
            height: double.infinity,
            // color: const Color(0xFFE7E7E7),
            child: PageView(
              controller: controller, 
              children: [
                const TransferenciasPage(key: ValueKey<int>(0)),
                const PharmaPage(key: ValueKey<int>(1)),
                const HistorialTansferenciasPage( key: ValueKey<int>(2)),
                // const HistorialTansferenciasPage(searchString: searchString, key: ValueKey<int>(2)),
                if (isAdmin) const UbicacionesUsuariosPage(key: ValueKey<int>(3))
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
      elevation: 24,
      flexibleSpace: Container(),
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Pharma Transf',
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          Text(
              'Ultima actualización: ${lastUpdate.hour}:${lastUpdate.minute.toString().padLeft(2, '0')}:${lastUpdate.second.toString().padLeft(2, '0')}',
              style: Theme.of(context).textTheme.bodySmall),
        ],
      ),
      actions: [
        //TODO: validar por las paginas en el controller
        if (showSearchBox == false)
          IconButton(
            onPressed: () async {
              await getImageAndProcess(ImageSource.gallery);
            },
            icon: const Icon(Icons.image_search, size: 32.0),
          ),
      ],
    );
  }

  FloatingActionButton _floatButton() {
    return FloatingActionButton(
      heroTag: 'homeFloat',
      child: const Icon(Icons.add_a_photo, color: Colors.black87),
      onPressed: () async {
        await getImageAndProcess(ImageSource.camera);
      },
    );
  }

  Future<void> getImageAndProcess(ImageSource imageSource) async {
    try {
      final imagePicker = ImagePicker();
      final imageFile =
          await imagePicker.pickImage(source: imageSource, imageQuality: 90);
      if (imageFile == null) return;
      final imageFileAsBytes = await imageFile.readAsBytes();
      debugPrint(
          'tamaño de la imagen original size in bytes ${imageFileAsBytes.elementSizeInBytes}');
      debugPrint(
          'longitud de la imagen original len in bytes  ${imageFileAsBytes.lengthInBytes}');
      final imageCropped = await _callImageCropper(imageFile.path);
      if (imageCropped == null) return;

      debugPrint('tamaño de la imagen:  ${imageCropped.lengthInBytes}');
      _showImageResultBottomSheet(imageCropped);
    } catch (e) {
      debugPrint('Error al seleccionar la imagen: $e');
    }
  }

  Future<Uint8List?> _callImageCropper(String imagePath) async {
    return await Navigator.push<Uint8List>(
      context,
      MaterialPageRoute(
        builder: (_) => ImageCropperWidget(
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
