// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:go_router/go_router.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:pharma_transfer/controller/google_sign_in_services.dart';
import 'package:connectivity/connectivity.dart';
import 'package:pharma_transfer/presentation/providers/provider_transferencias.dart';
import 'package:pharma_transfer/presentation/screens/home_screen/home_page.dart';
import 'package:provider/provider.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});
  static String route = '/';

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool isSignedIn = false;

  final snackBarError = SnackBar(
    content: const Text('Se requiere el permiso de ubicación para continuar'),
    action: SnackBarAction(
        label: 'Configuración',
        onPressed: () => Geolocator.openLocationSettings()),
  );

  final snackBarErrorInternet = const SnackBar(
    content: Text('No tienes conexión a internet'),
  );

  @override
  void initState() {
    super.initState();
    _checkConnectivityAndSignIn();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SizedBox(
        width: double.infinity,
        height: double.infinity,
        child: loginView(),
      ),
    );
  }

  Widget loginView() {
    return Container(
      width: double.infinity,
      height: double.infinity,
      decoration: const BoxDecoration(
          image: DecorationImage(
              fit: BoxFit.cover,
              image: AssetImage('assets/background_pattern_pharma.jpg'),
              colorFilter: ColorFilter.mode(Colors.blueAccent, BlendMode.modulate))),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              'PharmaTransf',
              style: Theme.of(context)
                  .textTheme
                  .displaySmall
                  ?.copyWith(color: Colors.white, fontWeight: FontWeight.w900, letterSpacing: 0),
            ),
            const SizedBox(height: 128),
            MaterialButton(
              onPressed: () async {
                var account = await GoogleSignInService.signInWithGoogle();
                if (account != null) {
                  debugPrint(account.email);
                  navigateToHome();
                }
              },
              shape: const StadiumBorder(),
              padding:
                  const EdgeInsets.symmetric(vertical: 16.0, horizontal: 22.0),
              color: Colors.red,
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text('Inicia con tu cuenta Google   ',
                      style: TextStyle(color: Colors.white, fontSize: 16.0)),
                  Icon(Icons.login, color: Colors.white)
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _checkConnectivityAndSignIn() async {
    final connectivity = Connectivity();
    var connectivityResult = await connectivity.checkConnectivity();
    final isConnected = (connectivityResult == ConnectivityResult.wifi ||
        connectivityResult == ConnectivityResult.mobile);

    if (!isConnected) {
      ScaffoldMessenger.of(context).showSnackBar(snackBarErrorInternet);
      return;
    }
    final signInSilenty = await GoogleSignInService.signInSilenty();
    if (signInSilenty == null) return;
    navigateToHome();
  }

//TODO: extraer la logica de permiso ubicacion a un provider booleano
  void navigateToHome() async {
    final status = await Geolocator.checkPermission();

    final permisionGranted = (status != LocationPermission.whileInUse &&
        status != LocationPermission.always);
    if (permisionGranted) {
      final newStatus = await Geolocator.requestPermission();

      if (newStatus == LocationPermission.denied ||
          newStatus == LocationPermission.deniedForever) {
        ScaffoldMessenger.of(context).showSnackBar(snackBarError);
        debugPrint('Permiso de ubicación negado');
        return;
      }
    }

    context.loaderOverlay.show();
    context.read<ProviderTransferencias>().initialLoad().then((_) {
      context.loaderOverlay.hide();
      context.go(HomePage.route);
    });
  }
}
