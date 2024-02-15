import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:pharma_transfer/controller/provider_transferencias.dart';
import 'package:pharma_transfer/pages/users_location_map_screen.dart';
import 'package:pharma_transfer/utils/utils.dart';
import 'package:provider/provider.dart';

class UsersLocationPage extends StatelessWidget {
  const UsersLocationPage({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<ProviderTransferencias>(context, listen: true);
    final usersLocation = provider.getUserLocationList;
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.onInverseSurface,
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          final lastLocationEveryUser =
              usersLocation.entries.map((e) => e.value.first).toList();
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (_) => UsersLocationMapScreen(
                usersLocation: lastLocationEveryUser,
                isMultiUser: true,
              ),
            ),
          );
        },
        label: const Text('Ver todos en mapa'),
        icon: const Icon(Icons.location_history),
      ),
      body: RefreshIndicator(
        onRefresh: provider.fetchUsersLocation,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              Text(
                'Listado de usuarios',
                style: Theme.of(context)
                    .textTheme
                    .headlineSmall
                    ?.copyWith(fontWeight: FontWeight.w300),
              ),
              const SizedBox(height: 8.0),
              Expanded(
                child: ListView.separated(
                  itemCount: usersLocation.keys.length,
                  separatorBuilder: (_, __) =>
                      const Divider(indent: 16, endIndent: 16),
                  itemBuilder: (context, index) {
                    final userName = usersLocation.keys.toList()[index];
                    final lastLocation = usersLocation[userName]?.first;
                    final nameText = lastLocation?.userName ?? 'No registra';
                    final dateText = lastLocation?.dateTime != null
                        ? DateFormat('dd-MM-yy / hh:mm')
                            .format(lastLocation!.dateTime)
                        : 'N/A';
                    return ListTile(
                      dense: true,
                      leading: CircleAvatar(
                          child: Text(Utils.get2FirtsInitials(nameText))),
                      title: Text(nameText),
                      // subtitle: Text('Ultimo registro: ${lastLocation?.dateTime}'),
                      subtitle: Text('Ultimo registro: $dateText'),
                      trailing: Icon(
                        Icons.location_on_outlined,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (_) => UsersLocationMapScreen(
                                usersLocation: usersLocation[userName]!),
                          ),
                        );
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
