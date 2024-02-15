import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:pharma_transfer/controller/google_sign_in_services.dart';
import 'package:pharma_transfer/controller/provider_transferencias.dart';
import 'package:pharma_transfer/models/user_model.dart';
import 'package:pharma_transfer/pages/login_page.dart';
import 'package:provider/provider.dart';

class CustomDrawer extends StatefulWidget {
  final PageController controller;
  // final GoogleSignInAccount? accountGoogle;
  final GlobalKey<ScaffoldState> scaffoldKey;
  const CustomDrawer(
      {super.key,
      required this.controller,
      // this.accountGoogle,
      required this.scaffoldKey});

  @override
  State<CustomDrawer> createState() => _CustomDrawerState();
}

class _CustomDrawerState extends State<CustomDrawer> {
  int navDrawerIndex = 1;

  @override
  Widget build(BuildContext context) {
    final usuario = context.read<ProviderTransferencias>().currentUser;
    return NavigationDrawer(
        selectedIndex: navDrawerIndex,
        onDestinationSelected: (value) {
          setState(() {
            navDrawerIndex = value;
          });
          widget.controller.jumpToPage(value);
          widget.scaffoldKey.currentState?.closeDrawer();
        },
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Icon(
                  Icons.supervised_user_circle_outlined,
                  size: 36,
                  color: Theme.of(context).colorScheme.primary,
                ),
                const SizedBox(width: 8),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(usuario!.usersNombre),
                    Text(usuario.usersEmail),
                  ],
                ),
              ],
            ),
          ),
          const Divider(indent: 16, endIndent: 16),
          const NavigationDrawerDestination(
            icon: Icon(Icons.receipt_outlined),
            label: Text('Transferencias'),
          ),
          const NavigationDrawerDestination(
              icon: Icon(Icons.local_pharmacy_outlined),
              label: Text('Farmacias')),
          const NavigationDrawerDestination(
            icon: Icon(Icons.history_outlined),
            label: Text('Historial'),
          ),
          if (usuario.userCargo == UserCargo.administrador)
            const NavigationDrawerDestination(
              icon: Icon(Icons.location_on_outlined),
              label: Text('Ubicaciones'),
            ),
          const Divider(indent: 16, endIndent: 16),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: OutlinedButton.icon(
                onPressed: () {
                  GoogleSignInService.signOut().then(
                    (_) => context.go(LoginPage.route),
                  );
                },
                icon: const Icon(Icons.logout),
                label: const Text('Cerrar sesión')),
          ),
        ]);
  }
}


// Widget customDrawer(BuildContext context,
//     {required PageController controller, GoogleSignInAccount? accountGoogle}) {
//   int navDrawerIndex = 1;

//   return NavigationDrawer(selectedIndex: navDrawerIndex, children: [
//     UserAccountsDrawerHeader(
//         currentAccountPicture: CircleAvatar(
//           backgroundImage: accountGoogle?.photoUrl != null
//               ? NetworkImage(accountGoogle!.photoUrl!)
//               : null,
//         ),
//         accountName: Text(
//           '${accountGoogle?.displayName}',
//           style: const TextStyle(fontSize: 22.0),
//         ),
//         accountEmail: Text('${accountGoogle?.email}',
//             style: const TextStyle(fontSize: 18.0))),





//     const NavigationDrawerDestination(
//         icon: Icon(Icons.add), label: Text('Transferencias')),
//     const NavigationDrawerDestination(
//         icon: Icon(Icons.add), label: Text('Transferencias')),
//     const NavigationDrawerDestination(
//         icon: Icon(Icons.add), label: Text('Transferencias')),






//     ListTile(
//       title: const Text('Transferencias'),
//       onTap: () {
//         Navigator.pop(context);
//         controller.jumpToPage(0);
//       },
//     ),
//     ListTile(
//       title: const Text('Farmacias'),
//       onTap: () {
//         Navigator.pop(context);
//         controller.jumpToPage(1);
//       },
//     ),
//     ListTile(
//       title: const Text('Historial'),
//       onTap: () {
//         Navigator.pop(context);
//         controller.jumpToPage(2);
//       },
//     ),
//     ListTile(
//       title: const Text('Cerrar sesión'),
//       onTap: () {
//         GoogleSignInService.signOut().then((_) => context.go(LoginPage.route));
//       },
//       trailing: const Icon(Icons.logout, color: Colors.red),
//     ),
//   ]);
// }

// Widget customDrawer(BuildContext context, {required PageController controller,
//     GoogleSignInAccount? accountGoogle}) {
//   return Drawer(
//     child: ListView(children: [
//       UserAccountsDrawerHeader(
//           currentAccountPicture: CircleAvatar(
//             backgroundImage: accountGoogle?.photoUrl != null
//                 ? NetworkImage(accountGoogle!.photoUrl!)
//                 : null,
//           ),
//           accountName: Text(
//             '${accountGoogle?.displayName}',
//             style: const TextStyle(fontSize: 22.0),
//           ),
//           accountEmail: Text('${accountGoogle?.email}',
//               style: const TextStyle(fontSize: 18.0))),
//       ListTile(
//         title: const Text('Transferencias'),
//         onTap: () {
//           Navigator.pop(context);
//           controller.jumpToPage(0);
//         },
//       ),
//       ListTile(
//         title: const Text('Farmacias'),
//         onTap: () {
//           Navigator.pop(context);
//           controller.jumpToPage(1);
//         },
//       ),
//       ListTile(
//         title: const Text('Historial'),
//         onTap: () {
//           Navigator.pop(context);
//           controller.jumpToPage(2);
//         },
//       ),
//       ListTile(
//         title: const Text('Cerrar sesión'),
//         onTap: () {
//           GoogleSignInService.signOut()
//               .then((_) => context.go(LoginPage.route));
//         },
//         trailing: const Icon(Icons.logout, color: Colors.red),
//       ),
//     ]),
//   );
// }
