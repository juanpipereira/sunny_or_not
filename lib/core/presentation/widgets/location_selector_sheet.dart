import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sunny_or_not/features/gps/presentation/bloc/gps_bloc.dart';
import 'package:sunny_or_not/features/gps/presentation/bloc/gps_event.dart';

class LocationSelectorSheet extends StatelessWidget {
  const LocationSelectorSheet({super.key});

  @override
  Widget build(BuildContext context) {
    final TextEditingController searchController = TextEditingController();

    return Padding(
      padding: EdgeInsets.only(
        left: 16,
        right: 16,
        top: 16,
        bottom: MediaQuery.of(context).viewInsets.bottom + 16,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ListTile(
            leading: const Icon(Icons.gps_fixed),
            title: const Text('Use my current location'),
            onTap: () {
              context.read<GpsBloc>().add(GpsCoordinatesRequested());
              Navigator.pop(context);
            },
          ),
          const Divider(),
          TextField(
            controller: searchController,
            decoration: const InputDecoration(
              hintText: 'Enter city name (e.g. London)',
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 8),
          ElevatedButton(
            onPressed: () {
              // TODO: implement location search
            },
            child: const Text('Search City'),
          ),
        ],
      ),
    );
  }
}
