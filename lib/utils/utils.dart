// import 'package:flutter/material.dart';
// import 'package:string_similarity/string_similarity.dart';
// import '../models/pharmaModel.dart';

// const TextStyle textStyleValue = TextStyle(
//     fontSize: 16.0, color: Colors.black87, fontWeight: FontWeight.w500);

// const TextStyle textStyleLabel = TextStyle(
//     fontSize: 14.0, color: Colors.black54, fontWeight: FontWeight.w300);

// String getLocal(String stOriginal, List<Pharma> pharmaList) {
//   if (stOriginal != null && pharmaList != null) {
//     List<String> locales = [];
//     pharmaList.forEach((pharma) {
//       locales.add(pharma.farmasName);
//     });
//     String _st = stOriginal.replaceAll(' ', '');

//     List<String> _dbString = locales.map((e) => e.replaceAll(' ', '')).toList();
//     var _bestMatch = StringSimilarity.findBestMatch(_st, _dbString);

//     return locales[_bestMatch.bestMatchIndex];
//   } else
//     return null;
// }

