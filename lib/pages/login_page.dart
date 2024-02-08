import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:pharma_transfer/controller/google_sign_in_services.dart';
import 'package:connectivity/connectivity.dart';
import 'package:pharma_transfer/controller/provider_transferencias.dart';
import 'package:provider/provider.dart';

import 'Home_page.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});
  static String route = '/';

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool isSignedIn = false;
  String message = "Cargando....";

  final _connectivity = Connectivity();

  void navigateToHome() {
     Provider.of<ProviderTransferencias>(context, listen: false).updateTransferencias();
    // context.push(HomePage.route);
    context.go(HomePage.route);
  }

  @override
  void initState() {
    _connectivity.checkConnectivity().then((value) {
      if (value == ConnectivityResult.wifi ||
          value == ConnectivityResult.mobile) {
        GoogleSignInService.signInSilenty().then((account) {
          debugPrint('está logueado? ${account?.email}');
          if (account != null) navigateToHome();
        });

        GoogleSignInService.isSignedIn().then((value) {
          isSignedIn = value;
          var account = GoogleSignInService.currentUser();
          if (account != null) navigateToHome();
        });
      } else {
        setState(() {
          message = 'Revisa tu conexión a internet...';
        });
        debugPrint('no hay conexion a internet');
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      body: SizedBox(
          width: double.infinity,
          height: double.infinity,
          // child: isSignedIn ? _loading() : _loginProccess()),
          child: _loginProccess()),
    );
  }

  Widget _loading() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const SizedBox(width: 100, height: 1),
          const CircularProgressIndicator(backgroundColor: Colors.redAccent),
          const SizedBox(height: 30.0),
          Text(message),
        ],
      ),
    );
  }

  Widget _loginProccess() {
    return Container(
      width: double.infinity,
      height: double.infinity,
      decoration: const BoxDecoration(
          image: DecorationImage(
              fit: BoxFit.cover,
              image: AssetImage('assets/background_pattern_pharma.jpg'),
              colorFilter: ColorFilter.mode(Colors.blue, BlendMode.modulate))),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            MaterialButton(
              onPressed: () async {
                if (isSignedIn) {
                  bool status = await GoogleSignInService.isSignedIn();
                  if (status) debugPrint('already signed');
                } else {
                  var account = await GoogleSignInService.signInWithGoogle();
                  if (account != null) {
                    debugPrint(account.email);
                    navigateToHome();
                  }
                }
              },
              shape: const StadiumBorder(),
              padding:
                  const EdgeInsets.symmetric(vertical: 16.0, horizontal: 22.0),
              color: isSignedIn ? Colors.black : Colors.red,
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
}
