import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:pharma_transfer/controller/google_sign_in_services.dart';
import 'package:pharma_transfer/pages/login_page.dart';

class CustomDrawer extends StatefulWidget {
  final PageController controller;
  final GoogleSignInAccount? accountGoogle;
  final GlobalKey<ScaffoldState> scaffoldKey;
  const CustomDrawer(
      {super.key,
      required this.controller,
      this.accountGoogle,
      required this.scaffoldKey});

  @override
  State<CustomDrawer> createState() => _CustomDrawerState();
}

class _CustomDrawerState extends State<CustomDrawer> {
  int navDrawerIndex = 1;

  @override
  Widget build(BuildContext context) {
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
          UserAccountsDrawerHeader(
              // arrowColor: Colors.red,

              currentAccountPicture: CircleAvatar(
                backgroundImage: widget.accountGoogle?.photoUrl != null
                    ? NetworkImage(widget.accountGoogle!.photoUrl!)
                    : null,
              ),
              accountName: Text(
                '${widget.accountGoogle?.displayName}',
                style: const TextStyle(fontSize: 22.0),
              ),
              accountEmail: Text('${widget.accountGoogle?.email}',
                  style: const TextStyle(fontSize: 18.0))),
          const NavigationDrawerDestination(
              icon: Icon(Icons.add), label: Text('Transferencias')),
          const NavigationDrawerDestination(
              icon: Icon(Icons.add), label: Text('Farmacias')),
          const NavigationDrawerDestination(
              icon: Icon(Icons.add), label: Text('Historial')),
          
          ListTile(
            title: const Text('Cerrar sesión'),
            onTap: () {
              GoogleSignInService.signOut()
                  .then((_) => context.go(LoginPage.route));
            },
            trailing: const Icon(Icons.logout, color: Colors.red),
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
