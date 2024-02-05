import 'package:flutter/material.dart';
import 'package:pharma_transfer/controller/provider_transferencias.dart';
import 'package:pharma_transfer/models/transferencia_model.dart';
import 'package:pharma_transfer/pages/widgets/transfer_card_widget.dart';
import 'package:provider/provider.dart';

class DoneTransfPage extends StatefulWidget {
  final String searchString;

  const DoneTransfPage({Key? key, required this.searchString})
      : super(key: key);
  @override
  DoneTransfPageState createState() => DoneTransfPageState();
}

class DoneTransfPageState extends State<DoneTransfPage> {
  String searchString = '';
  TextEditingController searchBoxController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<ProviderTransferencias>(context, listen: true);
    //final List<Transferencia> transferencias = provider.transfList;
    final List<Transferencia> transferencias = provider.transfListAlternative;
    return SizedBox(
      width: double.infinity,
      height: double.infinity,
      child: RefreshIndicator(
        onRefresh: provider.updateTransferencias,
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
              margin: const EdgeInsetsDirectional.all(16.0),
              padding: const EdgeInsetsDirectional.all(8.0),
              child: Center(
                child: TextField(
                    decoration: InputDecoration(
                      fillColor: Colors.white,
                      filled: true,
                      suffixIcon: const Icon(Icons.search, color: Colors.grey),
                      hintText: 'Buscar por farmacia o producto',
                      contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16.0, vertical: 20.0),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16.0),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16.0),
                      ),
                    ),
                    cursorColor: Colors.white,
                    autofocus: false,
                    style: const TextStyle(color: Colors.black38),
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
                    }),
              ),
            ),
            Expanded(
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
