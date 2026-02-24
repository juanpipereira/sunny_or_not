import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sunny_or_not/features/gps/presentation/bloc/gps_bloc.dart';
import 'package:sunny_or_not/features/gps/presentation/bloc/gps_event.dart';
import 'package:sunny_or_not/features/gps/presentation/bloc/gps_state.dart';
import 'package:sunny_or_not/features/location/presentation/bloc/location_bloc.dart';
import 'package:sunny_or_not/features/location/presentation/bloc/location_event.dart';
import 'package:sunny_or_not/features/location/presentation/bloc/location_state.dart';

class LocationSelectorSheet extends StatelessWidget {
  const LocationSelectorSheet({super.key});

  @override
  Widget build(BuildContext context) {
    final TextEditingController searchController = TextEditingController();

    return MultiBlocListener(
      listeners: [
        BlocListener<LocationBloc, LocationState>(
          listener: (context, state) {
            if (state is LocationLoadSuccess) Navigator.pop(context);
          },
        ),
        BlocListener<GpsBloc, GpsState>(
          listener: (context, state) {
            if (state is GpsLoadSuccess) Navigator.pop(context);
          },
        ),
      ],
      child: BlocBuilder<GpsBloc, GpsState>(
        builder: (context, gpsState) {
          return BlocBuilder<LocationBloc, LocationState>(
            builder: (context, locationState) {
              final bool isLoading = gpsState is GpsLoadInProgress ||
                  locationState is LocationLoadInProgress;

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
                    if (gpsState is GpsLoadInProgress)
                      const ListTile(
                        leading: SizedBox(
                            width: 24,
                            height: 24,
                            child: CircularProgressIndicator(strokeWidth: 2)),
                        title: Text('Fetching GPS...'),
                      )
                    else
                      ListTile(
                        leading: const Icon(Icons.my_location),
                        title: const Text('Use Current Location'),
                        enabled: !isLoading,
                        onTap: () => context
                            .read<GpsBloc>()
                            .add(GpsCoordinatesRequested()),
                      ),
                    const Divider(),
                    TextField(
                      controller: searchController,
                      enabled: !isLoading,
                      decoration: InputDecoration(
                        hintText: 'Enter city name (e.g. London)',
                        errorText: locationState is LocationLoadFailure
                            ? locationState.message
                            : null,
                        border: const OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 16),
                    if (locationState is LocationLoadInProgress)
                      const CircularProgressIndicator()
                    else
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: isLoading
                              ? null
                              : () {
                                  final query = searchController.text.trim();
                                  if (query.isNotEmpty) {
                                    context
                                        .read<LocationBloc>()
                                        .add(LocationCitySearched(query));
                                  }
                                },
                          child: const Text('Search City'),
                        ),
                      ),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }
}
