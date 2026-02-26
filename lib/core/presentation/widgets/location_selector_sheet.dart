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
            if (state is GpsLoadSuccess || state is GpsLoadFailure) {
              Navigator.pop(context);
            }
          },
        ),
      ],
      child: BlocBuilder<GpsBloc, GpsState>(
        builder: (context, gpsState) {
          return BlocBuilder<LocationBloc, LocationState>(
            builder: (context, locationState) {
              final bool isLoading = gpsState is GpsLoadInProgress ||
                  locationState is LocationLoadInProgress;

              return SingleChildScrollView(
                child: Padding(
                  padding: EdgeInsets.only(
                    left: 16.0,
                    right: 16.0,
                    top: 16.0,
                    bottom: MediaQuery.of(context).viewInsets.bottom + 16,
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        width: 40,
                        height: 4,
                        margin: const EdgeInsets.only(bottom: 10),
                        decoration: BoxDecoration(
                          color: Colors.grey.shade300,
                          borderRadius: BorderRadius.circular(2),
                        ),
                      ),
                      ListTile(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        tileColor: Colors.blue.shade50,
                        leading: gpsState is GpsLoadInProgress
                            ? const SizedBox(
                                width: 20,
                                height: 20,
                                child:
                                    CircularProgressIndicator(strokeWidth: 2))
                            : Icon(Icons.my_location,
                                color: Colors.blue.shade900),
                        title: Text(
                          gpsState is GpsLoadInProgress
                              ? 'Fetching GPS...'
                              : 'Use Current Location',
                          style: TextStyle(
                              color: Colors.blue.shade900,
                              fontWeight: FontWeight.w500),
                        ),
                        enabled: !isLoading,
                        onTap: () => context
                            .read<GpsBloc>()
                            .add(GpsCoordinatesRequested()),
                      ),
                      const Padding(
                        padding: EdgeInsets.symmetric(vertical: 15),
                        child: Row(
                          children: [
                            Expanded(child: Divider()),
                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: 10),
                              child: Text(
                                "OR",
                                style: TextStyle(
                                  color: Colors.grey,
                                  fontSize: 12,
                                ),
                              ),
                            ),
                            Expanded(child: Divider()),
                          ],
                        ),
                      ),
                      TextField(
                        controller: searchController,
                        enabled: !isLoading,
                        decoration: InputDecoration(
                          hintText: 'Enter city name (e.g. London)',
                          prefixIcon: const Icon(Icons.search),
                          errorText: locationState is LocationLoadFailure
                              ? locationState.message
                              : null,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 12,
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      if (locationState is LocationLoadInProgress)
                        const CircularProgressIndicator()
                      else
                        Container(
                          width: double.infinity,
                          decoration: BoxDecoration(
                            gradient: !isLoading
                                ? LinearGradient(
                                    colors: [
                                      Colors.blue.shade300,
                                      Colors.blue.shade600
                                    ],
                                  )
                                : null,
                            color: isLoading ? Colors.grey.shade400 : null,
                            borderRadius: BorderRadius.circular(12),
                          ),
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
                            style: ElevatedButton.styleFrom(
                              disabledBackgroundColor: Colors.transparent,
                              backgroundColor: Colors.transparent,
                              shadowColor: Colors.transparent,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            child: const Text(
                              'Search City',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
