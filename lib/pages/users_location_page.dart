import 'package:flutter/material.dart';
import 'package:pharma_transfer/controller/provider_transferencias.dart';
import 'package:pharma_transfer/pages/users_location_map_screen.dart';
import 'package:provider/provider.dart';

class UsersLocationPage extends StatelessWidget {
  const UsersLocationPage({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<ProviderTransferencias>(context, listen: true);
    final usersLocation = provider.getUserLocationList;
    return Scaffold(
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (_) =>
                  UsersLocationMapScreen(usersLocation: usersLocation),
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
          child: ListView.builder(
            itemCount: usersLocation.length,
            itemBuilder: (context, index) {
              final user = usersLocation[index];
              return Card(
                child: ListTile(
                  // isThreeLine: true,
                  dense: true,
                  title: Text(user.userName),
                  subtitle: Text('Ultima Actualización: ${user.dateTime}'),
                  trailing: Icon(
                    Icons.location_on_outlined,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                  onTap: () {},
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
