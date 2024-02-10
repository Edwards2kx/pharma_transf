

import 'package:flutter_gemini/flutter_gemini.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pharma_transfer/controller/server_comunication.dart';


void main() {
  test('Recibo constructor from map', () async {
      Gemini.init(apiKey: 'AIzaSyDIZJ0ZW4WoRxQt00twWLWhLFTALs0auMU', generationConfig: GenerationConfig(temperature: 0.05));
    //Arrange
final gemini = Gemini.instance;

final response = await gemini.listModels();
print (response);
    // .then((models) => print(models)) /// list
    // .catchError((e) => print('listModels error $e',));
    // final farmacias = await getPharmaFromServer();
    // for (var farmacia in farmacias) {
    //   print(farmacia.farmasName);
    // }
    // print(farmacias);
  });

  test('getAlternateTransferList', () async {
    final listaActiva = await getActiveTransferList();
    print(listaActiva.length);

    // final listaAlternativa = await getAlternateTransferList();
    // print(listaAlternativa.length);

    final user = await getUserWithEmail('emoticsas@gmail.com');
    print(user);
  });
}


// [
//   {
//     "farmas_id": "1",
//     "farmas_name": "ECO QUITO LAS ORQUIDEAS",
//     "farmas_lat": "-0.2257",
//     "farmas_lon": "-78.4902",
//     "farmas_horario": "8:00 - 21:00"
//   },
//   {
//     "farmas_id": "2",
//     "farmas_name": "ECO QUITO ALMA LOJANA",
//     "farmas_lat": "-0.2333",
//     "farmas_lon": "-78.4835",
//     "farmas_horario": "8:00 - 21:00"
//   },
//   {
//     "farmas_id": "3",
//     "farmas_name": "MEDI QUITO LA ARMENIA PUENTE 3",
//     "farmas_lat": "-0.2632",
//     "farmas_lon": "-78.4872",
//     "farmas_horario": "8:00 - 21:00"
//   },
//   {
//     "farmas_id": "4",
//     "farmas_name": "MEDI PLAZA EL TRIANGULO",
//     "farmas_lat": "-0.3013",
//     "farmas_lon": "-78.4592",
//     "farmas_horario": "7:00 - 22:00"
//   },
//   {
//     "farmas_id": "5",
//     "farmas_name": "ECO CONOCOTO",
//     "farmas_lat": "-0.2934",
//     "farmas_lon": "-78.4772",
//     "farmas_horario": "7:00 - 22:00"
//   },
//   {
//     "farmas_id": "6",
//     "farmas_name": "ECO QUITO LA ARMENIA",
//     "farmas_lat": "-0.2681",
//     "farmas_lon": "-78.4630",
//     "farmas_horario": "7:00 - 22:00"
//   },
//   {
//     "farmas_id": "7",
//     "farmas_name": "MEDI SAN RAFAEL",
//     "farmas_lat": "-0.3025",
//     "farmas_lon": "-78.4560",
//     "farmas_horario": "8:00 - 22:00"
//   },
//   {
//     "farmas_id": "8",
//     "farmas_name": "ECO SAN RAFAEL RIO ZAMORA",
//     "farmas_lat": "-0.2990",
//     "farmas_lon": "-78.4520",
//     "farmas_horario": "8:00 - 21:00"
//   },
//   {
//     "farmas_id": "9",
//     "farmas_name": "MEDI QUITO ILALO",
//     "farmas_lat": "-0.3038",
//     "farmas_lon": "-78.4661",
//     "farmas_horario": "7:30 - 21:00"
//   },
//   {
//     "farmas_id": "10",
//     "farmas_name": "MEDI ILALO",
//     "farmas_lat": "-0.2923",
//     "farmas_lon": "-78.4485",
//     "farmas_horario": "8:00 - 22:00"
//   },
//   {
//     "farmas_id": "11",
//     "farmas_name": "ECO QUITO EDEN DEL VALLE",
//     "farmas_lat": "-0.2435",
//     "farmas_lon": "-78.4857",
//     "farmas_horario": "7:00 - 21:00"
//   },
//   {
//     "farmas_id": "12",
//     "farmas_name": "MEDI QUITO LA ARMENIA PUENTE 8",
//     "farmas_lat": "-0.2807",
//     "farmas_lon": "-78.4647",
//     "farmas_horario": "7:00 - 22:00"
//   },
//   {
//     "farmas_id": "13",
//     "farmas_name": "ECO SANGOLQUI EL COLIBRI",
//     "farmas_lat": "-0.3328",
//     "farmas_lon": "-78.4349",
//     "farmas_horario": "8:30 - 22:00"
//   },
//   {
//     "farmas_id": "14",
//     "farmas_name": "MEDI SAN RAFAEL EL SENOR DE LOS PUENTES",
//     "farmas_lat": "-0.3048",
//     "farmas_lon": "-78.4585",
//     "farmas_horario": "8:00 - 21:00"
//   },
//   {
//     "farmas_id": "15",
//     "farmas_name": "ECO CONOCOTO 2",
//     "farmas_lat": "-0.2939",
//     "farmas_lon": "-78.4781",
//     "farmas_horario": "8:00 - 21:00"
//   },
//   {
//     "farmas_id": "16",
//     "farmas_name": "ECO CONOCOTO 3",
//     "farmas_lat": "-0.2920",
//     "farmas_lon": "-78.4816",
//     "farmas_horario": "8:00 - 21:00"
//   },
//   {
//     "farmas_id": "17",
//     "farmas_name": "ECO CONOCOTO ABDON CALDERON",
//     "farmas_lat": "-0.2919",
//     "farmas_lon": "-78.4853",
//     "farmas_horario": "8:00 - 20:30"
//   },
//   {
//     "farmas_id": "18",
//     "farmas_name": "ECO CONOCOTO 6 DE DICIEMBRE",
//     "farmas_lat": "-0.2826",
//     "farmas_lon": "-78.4921",
//     "farmas_horario": "8:00 - 21:00"
//   },
//   {
//     "farmas_id": "19",
//     "farmas_name": "ECO CAPELO",
//     "farmas_lat": "-0.3036",
//     "farmas_lon": "-78.4570",
//     "farmas_horario": "8:00 - 21:00"
//   },
//   {
//     "farmas_id": "20",
//     "farmas_name": "MEDI PLAYA CHICA SAN RAFAEL",
//     "farmas_lat": "-0.3031",
//     "farmas_lon": "-78.4498",
//     "farmas_horario": "8:00 - 22:00"
//   },
//   {
//     "farmas_id": "21",
//     "farmas_name": "ECO QUITO MONJAS ALTO",
//     "farmas_lat": "-0.2304",
//     "farmas_lon": "-78.4917",
//     "farmas_horario": "7:00 - 21:00"
//   },
//   {
//     "farmas_id": "22",
//     "farmas_name": "ECO OBRERO INDEPENDIENTE",
//     "farmas_lat": "-0.2438",
//     "farmas_lon": "-78.4959",
//     "farmas_horario": "8:00 - 21:00"
//   },
//   {
//     "farmas_id": "23",
//     "farmas_name": "MEDI GONZALEZ SUAREZ",
//     "farmas_lat": "-0.1939",
//     "farmas_lon": "-78.4773",
//     "farmas_horario": "8:00 - 22:00"
//   },
//   {
//     "farmas_id": "24",
//     "farmas_name": "ECO RUMINAHUI",
//     "farmas_lat": "-0.3333",
//     "farmas_lon": "-78.4428",
//     "farmas_horario": "8:00 - 21:00"
//   },
//   {
//     "farmas_id": "25",
//     "farmas_name": "ECO CONOCOTO PUENTE 9",
//     "farmas_lat": "-0.2921",
//     "farmas_lon": "-78.4657",
//     "farmas_horario": "8:00 - 21:00"
//   },
//   {
//     "farmas_id": "26",
//     "farmas_name": "ECO QUITO FAJARDO",
//     "farmas_lat": "-0.3318",
//     "farmas_lon": "-78.4796",
//     "farmas_horario": "8:00 - 21:00"
//   },
//   {
//     "farmas_id": "27",
//     "farmas_name": "MEDI QUITO LA PRIMAVERA",
//     "farmas_lat": "-0.2175",
//     "farmas_lon": "-78.4374",
//     "farmas_horario": "8:00 - 21:00"
//   },
//   {
//     "farmas_id": "28",
//     "farmas_name": "ECO SANGOLQUI LUIS CORDERO",
//     "farmas_lat": "-0.3277",
//     "farmas_lon": "-78.4452",
//     "farmas_horario": "8:00 - 21:00"
//   },
//   {
//     "farmas_id": "29",
//     "farmas_name": "ECO SANGOLQUI SAN NICOLAS",
//     "farmas_lat": "-0.3291",
//     "farmas_lon": "-78.4571",
//     "farmas_horario": "8:00 - 21 :00"
//   },
//   {
//     "farmas_id": "30",
//     "farmas_name": "ECO CONOCOTO SAN JOSE",
//     "farmas_lat": "-0.3143",
//     "farmas_lon": "-78.4734",
//     "farmas_horario": "8:00 - 21:00"
//   },
//   {
//     "farmas_id": "31",
//     "farmas_name": "ECO CONOCOTO SIMON BOLIVAR",
//     "farmas_lat": "-0.2924",
//     "farmas_lon": "-78.4758",
//     "farmas_horario": "8:00 - 20:30"
//   },
//   {
//     "farmas_id": "32",
//     "farmas_name": "ECO CONOCOTO PUENTE 8",
//     "farmas_lat": "-0.2812",
//     "farmas_lon": "-78.4705",
//     "farmas_horario": "8:00 - 21:00"
//   },
//   {
//     "farmas_id": "33",
//     "farmas_name": "ECO SAN RAFAEL",
//     "farmas_lat": "-0.3004",
//     "farmas_lon": "-78.4587",
//     "farmas_horario": "8:00 - 20:30"
//   },
//   {
//     "farmas_id": "34",
//     "farmas_name": "MEDI CUMBAYA SAN JUAN BAJO",
//     "farmas_lat": "-0.2061",
//     "farmas_lon": "-78.4450",
//     "farmas_horario": "8:00 - 21:00"
//   },
//   {
//     "farmas_id": "35",
//     "farmas_name": "MEDI QUITO MONTESERRIN",
//     "farmas_lat": "-0.1576",
//     "farmas_lon": "-78.4607",
//     "farmas_horario": "8:00 - 21:00"
//   },
//   {
//     "farmas_id": "36",
//     "farmas_name": "MEDI CUMBAYA EL CEBOLLAR",
//     "farmas_lat": "-0.1977",
//     "farmas_lon": "-78.4428",
//     "farmas_horario": "8:00 - 21:00"
//   }
// ]