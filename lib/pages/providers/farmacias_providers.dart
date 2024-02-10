// import 'dart:convert';
// import 'dart:io';

// import 'package:flutter/material.dart';
// import 'package:flutter_gemini/flutter_gemini.dart';
// import 'package:pharma_transfer/config/gemini_prompt.dart';
// import 'package:pharma_transfer/models/pharma_model.dart';
// import 'package:pharma_transfer/models/recibo_model.dart';
// import 'package:riverpod_annotation/riverpod_annotation.dart';
// import 'package:http/http.dart' as http;
// import 'package:string_similarity/string_similarity.dart';

// // final pharmaListProvider = FutureProvider<List<Pharma>>((ref) async {
// //   final response = await http
// //       .post(Uri.parse('http://18.228.147.99/modulos/app_services.php'), body: {
// //     "accion": "farma",
// //     "database": "admin_Smart",
// //   });

// //   if (response.statusCode == 200) {
// //     return pharmaFromJson(response.body);
// //   } else {
// //     throw StateError('Error en la comunicación con el servidor');
// //   }
// // });
// // final pharmaListProvider2 = Provider<List<Pharma>>((ref) {
// //   // Lógica para obtener o cargar el listado de farmacias.
// //   // Puedes acceder a ref.watch(pharmaListProvider.future) para obtener el FutureProvider.
// //   return ref.watch(pharmaListProvider.future).data?.value ?? [];
// // });

// // final procesarImagenReciboProvider =
// //     FutureProvider.family<Recibo, String>((ref, imagePath) async {
// //   final List<Pharma> pharmaList = ref.read(pharmaListProvider.future).then(() {
// // final imageFile = File(imagePath);
// //   final gemini = Gemini.instance;

// //   final geminiResponse = await gemini.textAndImage(
// //       text: kPromptDecodeTicket, images: [imageFile.readAsBytesSync()]);

// //   final response = geminiResponse?.content?.parts?.first.text;
// //   debugPrint('raw response from gemini server $response');
// //   if (response == null) {
// //     return const Left('Se presentó un fallo, intenta nueamente');
// //   }
// //   final sanitizedResponse =
// //       response.substring(response.indexOf('{'), response.lastIndexOf('}') + 1);
// //   final json = jsonDecode(sanitizedResponse);
// //   final result = json['result'];
// //   if (result == null) {
// //     return const Left('Se presentó un fallo, intenta nueamente');
// //   }
// //   if (result == 'SUCCESS') {
// //     final recibo = Recibo.fromMap(json['body']);
// //     // final pharmaList = ref.watch(pharmaListProvider);
// //     final List<Pharma> pharmaList = [];
// //     final pharmaListNames = pharmaList.map((e) => e.farmasName).toList();
// //     final farAutoBestStringComparative =
// //         StringSimilarity.findBestMatch(recibo.farAutoTransf, pharmaListNames);
// //     final farSoliBestStringComparative =
// //         StringSimilarity.findBestMatch(recibo.farSoliTransf, pharmaListNames);
// //     final reciboValidated = recibo.copyWith(
// //         farAutoTransf: pharmaListNames[farAutoBestStringComparative.bestMatchIndex],
// //         farSoliTransf: pharmaListNames[farSoliBestStringComparative.bestMatchIndex]);
// //     debugPrint(reciboValidated.toString());
// //     return Right(reciboValidated);
// //   }
// //   if (result == 'ERROR') {
// //     debugPrint('se presento el siguiente error ${json['body']}');
// //     return Left(json['body']);
// //   }
// //   return const Left('Error al procesar la imagen');
// //   });

// // }

// final pharmaListProvider = FutureProvider<List<Pharma>>((ref) async {
//   final response = await http
//       .post(Uri.parse('http://18.228.147.99/modulos/app_services.php'), body: {
//     "accion": "farma",
//     "database": "admin_Smart",
//   });

//   if (response.statusCode == 200) {
//     return pharmaFromJson(response.body);
//   } else {
//     throw StateError('Error en la comunicación con el servidor');
//   }
// });

// final procesarImagenReciboProvider =
//     FutureProvider.family<Recibo, String>((ref, imagePath) async {
//   ref.watch(pharmaListProvider).whenData((value) async {
//     final pharmaList = value;
//     final imageFile = File(imagePath);
//     final gemini = Gemini.instance;

//     final geminiResponse = await gemini.textAndImage(
//         text: kPromptDecodeTicket, images: [imageFile.readAsBytesSync()]);

//     final response = geminiResponse?.content?.parts?.first.text;
//     debugPrint('raw response from gemini server $response');

//     if (response == null) {
//       throw StateError('Se presentó un fallo, intenta nuevamente');
//     }

//     final sanitizedResponse = response.substring(
//         response.indexOf('{'), response.lastIndexOf('}') + 1);
//     final json = jsonDecode(sanitizedResponse);
//     final result = json['result'];

//     if (result == null) {
//       throw StateError('Se presentó un fallo, intenta nuevamente');
//     }

//     if (result == 'SUCCESS') {
//       final recibo = Recibo.fromMap(json['body']);
//       final pharmaListNames = pharmaList.map((e) => e.farmasName).toList();
//       final farAutoBestStringComparative =
//           StringSimilarity.findBestMatch(recibo.farAutoTransf, pharmaListNames);
//       final farSoliBestStringComparative =
//           StringSimilarity.findBestMatch(recibo.farSoliTransf, pharmaListNames);
//       final reciboValidated = recibo.copyWith(
//           farAutoTransf:
//               pharmaListNames[farAutoBestStringComparative.bestMatchIndex],
//           farSoliTransf:
//               pharmaListNames[farSoliBestStringComparative.bestMatchIndex]);
//       debugPrint(reciboValidated.toString());
//       return reciboValidated;
//     }
//     if (result == 'ERROR') {
//       debugPrint('Se presentó el siguiente error ${json['body']}');
//       throw StateError(json['body']);
//     }
//     throw StateError('Error al procesar la imagen');
//   });
//   throw StateError('Error al procesar la imagen');
// });
