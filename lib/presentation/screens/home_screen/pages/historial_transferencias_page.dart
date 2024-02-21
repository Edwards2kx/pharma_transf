import 'package:flutter/material.dart';
import 'package:pharma_transfer/presentation/providers/provider_transferencias.dart';
import 'package:pharma_transfer/models/transferencia_model.dart';
import 'package:pharma_transfer/presentation/screens/home_screen/widgets/transfer_card_widget.dart';
import 'package:provider/provider.dart';

enum Filtro { dia, mes, semana }

class HistorialTansferenciasPage extends StatefulWidget {
  // final String searchString;

  const HistorialTansferenciasPage({Key? key}) : super(key: key);
  @override
  HistorialTansferenciasPageState createState() =>
      HistorialTansferenciasPageState();
}

class HistorialTansferenciasPageState extends State<HistorialTansferenciasPage>
    with AutomaticKeepAliveClientMixin {
  String searchString = '';
  // Set<int> filtroSeleccionado = {0};
  Filtro filtroSeleccionado = Filtro.dia;
  TextEditingController searchBoxController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    super.build(context);
    final provider =
        Provider.of<ProviderTransferencias>(context, listen: false);
    final List<Transferencia> transferencias =
        provider.getTransferenciasTerminadas;
    return SizedBox(
      width: double.infinity,
      height: double.infinity,
      child: RefreshIndicator(
        // onRefresh: provider.fetchTransferenciasTerminadas,
        onRefresh: () {
          searchBoxController.clear();
          setState(() => searchString = '');

          return provider.fetchTransferenciasTerminadas();
        },
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
            SegmentedButton(
              showSelectedIcon: false,
              segments: const [
                ButtonSegment(value: Filtro.dia, label: Text('Hoy')),
                ButtonSegment(value: Filtro.semana, label: Text('Semana')),
                ButtonSegment(value: Filtro.mes, label: Text('Mes')),
              ],
              selected: {filtroSeleccionado},
              onSelectionChanged: (v) =>
                  setState(() => filtroSeleccionado = v.first),
            ),
            const SizedBox(height: 8),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: _buildCardTransferencia(
                        transferencias, searchString, filtroSeleccionado) ??
                    ListView(
                      children: const [
                        Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            mainAxisSize: MainAxisSize.max,
                            children: [
                              SizedBox(height: 24),
                              Icon(Icons.manage_search_outlined, size: 128),
                              SizedBox(height: 24),
                              Text(
                                'No se encontraron registros para esta busqueda',
                              ),
                            ],
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

  @override
  bool get wantKeepAlive => true;
}

Widget? _buildCardTransferencia(List<Transferencia> transferencias,
    String searchWord, Filtro filtroSeleccionado) {
  List<Widget> cards = [];
  List<Transferencia> transfFiltradas = [];
  // transferencias = transferencias.reversed.toList();

  for (var transferencia in transferencias) {
    if (transferencia.estado == EstadoTransferencia.entregado) {
      if (searchWord.isEmpty) {
        // cards.add(TransferCard(transferencia: transferencia));
        transfFiltradas.add(transferencia);
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
          // cards.add(TransferCard(transferencia: transferencia));
          transfFiltradas.add(transferencia);
        }
      }
    }
  }

  for (var t in transfFiltradas) {
    final fechaT = t.transfDateSubida;
    final fechaActual = DateTime.now();
    if (fechaT == null) continue;

    switch (filtroSeleccionado) {
      case Filtro.dia:
        if (fechaT.day == fechaActual.day) {
          cards.add(TransferCard(transferencia: t));
        }
        break;
      case Filtro.semana:
        if (fechaT.difference(fechaActual).inDays < 7) {
          cards.add(TransferCard(transferencia: t));
        }
        break;
      case Filtro.mes:
        if (fechaT.difference(fechaActual).inDays < 30) {
          cards.add(TransferCard(transferencia: t));
        }
        break;
    }
  }

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
