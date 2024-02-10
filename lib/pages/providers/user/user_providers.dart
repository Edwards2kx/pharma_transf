//listado de providers requeridos

//usuario de gmail para obtener el correo

//usuario de la aplicacion

//listado de farmacias para obtener la ubicación y los nombres

//listado de transferencias con ultima hora de actualizacion

//si es usuario admin listados de las ultimas ubicaciones de los motorizados

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:pharma_transfer/controller/server_comunication.dart';
import 'package:pharma_transfer/models/user_model.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
// @riverpod
// Future<User?> getCurrentUser( GetCurrentUserRef ref, String email) async {
// return getUserWithEmail(email);

// }

//future provider, init app, busca el usuario correo de usuario logueado en sharedPreferences
//intena loguearse silenciosamente si falla retornar null

//cuando se hace un logueo exitoso, se asigna el valor al currentUser y se guarda en las preferencias


final currentUserEmailProvider = StateProvider<String?>((ref) {
  return null;
});

final googleAccountProvider = FutureProvider<GoogleSignInAccount?>((ref) async {
  GoogleSignIn googleSignIn = GoogleSignIn(scopes: <String>['email']);
  final googleAccount = await googleSignIn.signIn();
  if (googleAccount != null) {
    ref
        .watch(currentUserEmailProvider.notifier)
        .update((_) => googleAccount.email);
  }
  return googleAccount;
});

// final currentUserProvider = FutureProvider<User?>((ref) async {
// // return getUserWithEmail(email);
// return null;
// });

//1065658842 susan cristina padilla duran