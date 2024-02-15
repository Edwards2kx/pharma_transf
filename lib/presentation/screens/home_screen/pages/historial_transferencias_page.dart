import 'package:flutter/material.dart';
import 'package:pharma_transfer/presentation/providers/provider_transferencias.dart';
import 'package:pharma_transfer/models/transferencia_model.dart';
import 'package:pharma_transfer/presentation/screens/home_screen/widgets/transfer_card_widget.dart';
import 'package:provider/provider.dart';

class HistorialTansferenciasPage extends StatefulWidget {
  final String searchString;

  const HistorialTansferenciasPage({Key? key, required this.searchString})
      : super(key: key);
  @override
  HistorialTansferenciasPageState createState() => HistorialTansferenciasPageState();
}

class HistorialTansferenciasPageState extends State<HistorialTansferenciasPage> {
  String searchString = '';
  TextEditingController searchBoxController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    final provider =
        Provider.of<ProviderTransferencias>(context, listen: false);
    final List<Transferencia> transferencias =
        provider.getTransferenciasTerminadas;
    return SizedBox(
      width: double.infinity,
      height: double.infinity,
      child: RefreshIndicator(
        // onRefresh: provider.updateTransferencias,
        onRefresh: provider.fetchTransferenciasTerminadas,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Text('Transferencias terminadas',
                style: TextStyle(
                    fontSize: 24.0,
                    fontWeight: FontWeight.w300,
                    color: Colors.black87)),
            const SizedBox(height: 8.0),
            Container(
              // margin: const EdgeInsetsDirectional.all(16.0),
              padding: const EdgeInsetsDirectional.symmetric(
                  vertical: 8, horizontal: 16),
              child: Center(
                child: TextField(
                  decoration: const InputDecoration(
                    fillColor: Colors.white,
                    filled: true,
                    suffixIcon: Icon(Icons.search, color: Colors.grey),
                    hintText: 'Buscar por farmacia o producto',
                    contentPadding:
                        EdgeInsets.symmetric(horizontal: 16.0, vertical: 20.0),
                  ),
                  cursorColor: Colors.white,
                  autofocus: false,
                  style: const TextStyle(color: Colors.black54),
                  controller: searchBoxController,
                  onChanged: (s) {
                    setState(() {
                      searchString = s;
                    });
                  },
                  onSubmitted: (s) {
                    setState(() {
                      searchString = s;
                    });
                  },
                ),
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: _buildCardTransferencia(transferencias, searchString) ??
                    ListView(
                      children: [
                        Center(
                          child: Container(
                            padding: const EdgeInsets.only(top: 100.0),
                            child: const Text('No se encontraron registros'),
                          ),
                        ),
                      ],
                    ),
              ),
            )
          ],
        ),
      ),
    );
  }
}

Widget? _buildCardTransferencia(
    List<Transferencia> transferencias, String searchWord) {
  List<Widget> cards = [];
  transferencias = transferencias.reversed.toList();
  //listview builder.
  transferencias.forEach(
    (transferencia) {
      if (transferencia.estado == EstadoTransferencia.entregado) {
        if (searchWord.isEmpty) {
          cards.add(TransferCard(transferencia: transferencia));
        } else {
          String newSearchWord = searchWord.trim().toUpperCase();
          String farmaSolName =
              transferencia.transfFarmaSolicita!.trim().toUpperCase();
          String farmaRecName =
              transferencia.transfFarmaAcepta!.trim().toUpperCase();
          String products = transferencia.transfProducto!.trim().toUpperCase();
          if (farmaSolName.contains(newSearchWord) ||
              farmaRecName.contains(newSearchWord) ||
              products.contains(newSearchWord)) {
            cards.add(TransferCard(transferencia: transferencia));
          }
        }
      }
    },
  );

  if (cards.isEmpty) {
    return null;
  }

  return ListView.builder(
    itemCount: cards.length,
    itemBuilder: (BuildContext context, int index) {
      return cards[index];
    },
  );
}
