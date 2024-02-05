// import 'package:flutter/material.dart';
// import 'package:go_router/go_router.dart';
// import 'package:google_sign_in/google_sign_in.dart';
// import 'package:pharma_transfer/ui/pages/home/home_page.dart';

// class LoginPage extends StatelessWidget {
//   static String route = '/';
//   const LoginPage({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Login Page'),
//       ),
//       body: Container(
//         decoration: const BoxDecoration(
//           image: DecorationImage(
//             fit: BoxFit.cover,
//             image: AssetImage('assets/background_pattern_pharma.jpg'),
//             colorFilter: ColorFilter.mode(Colors.blue, BlendMode.modulate),
//           ),
//         ),
//         child: Center(
//           child: ElevatedButton(
//             onPressed: () async {
//               final gUser = (await GoogleSignIn().signInSilently()) ??
//                   (await GoogleSignIn().signIn());
//               // final GoogleSignInAccount? gUser = await GoogleSignIn().signIn();

//               debugPrint('${gUser?.displayName}');
//               debugPrint('$gUser');

//               if (gUser != null) context.push(HomePage.route);
//             },
//             child: const Icon(Icons.navigate_next_outlined),
//           ),
//         ),
//       ),
//     );
//   }
// }
