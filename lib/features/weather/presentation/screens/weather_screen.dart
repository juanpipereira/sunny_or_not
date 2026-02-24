import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sunny_or_not/core/presentation/widgets/location_selector_sheet.dart';
import 'package:sunny_or_not/core/presentation/widgets/map_viewer.dart';
import 'package:sunny_or_not/features/gps/presentation/bloc/gps_bloc.dart';
import 'package:sunny_or_not/features/gps/presentation/bloc/gps_state.dart';
import 'package:sunny_or_not/features/location/presentation/bloc/location_bloc.dart';
import 'package:sunny_or_not/features/location/presentation/bloc/location_state.dart';
import 'package:sunny_or_not/features/weather/presentation/blocs/weather_bloc.dart';
import 'package:sunny_or_not/features/weather/presentation/blocs/weather_event.dart';
import 'package:sunny_or_not/features/weather/presentation/blocs/weather_state.dart';

class WeatherScreen extends StatelessWidget {
  const WeatherScreen({super.key});

  void _openLocationSelector(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (_) => MultiBlocProvider(
        providers: [
          BlocProvider.value(value: context.read<GpsBloc>()),
          BlocProvider.value(value: context.read<LocationBloc>()),
        ],
        child: const LocationSelectorSheet(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Sunny or not'),
          actions: [
            IconButton(
              icon: const Icon(Icons.location_searching),
              onPressed: () => _openLocationSelector(context),
            ),
          ],
          bottom: const TabBar(
            tabs: [
              Tab(text: 'Today'),
              Tab(text: '10 Days'),
            ],
          ),
        ),
        body: MultiBlocListener(
          listeners: [
            BlocListener<GpsBloc, GpsState>(
              listener: (context, state) {
                if (state is GpsLoadSuccess) {
                  context.read<WeatherBloc>().add(WeatherFetchedByCoordinates(
                        latitude: state.gpsCoordinates.latitude,
                        longitude: state.gpsCoordinates.longitude,
                        cityName: 'Current Location',
                      ));
                }
              },
            ),
            BlocListener<LocationBloc, LocationState>(
              listener: (context, state) {
                if (state is LocationLoadSuccess) {
                  context.read<WeatherBloc>().add(WeatherFetchedByCoordinates(
                        latitude: state.location.latitude,
                        longitude: state.location.longitude,
                        cityName: state.location.name,
                      ));
                }
              },
            ),
          ],
          child: TabBarView(
            children: [
              Center(
                child: BlocBuilder<WeatherBloc, WeatherState>(
                  builder: (context, state) {
                    return switch (state) {
                      WeatherInitial() => const Text('Search or use GPS'),
                      WeatherLoadInProgress() =>
                        const CircularProgressIndicator(),
                      WeatherLoadFailure(message: var msg) =>
                        Text('Error: $msg'),
                      WeatherLoadSuccess(
                        currentWeather: var currentWeather,
                        cityName: var cityName,
                        latitude: var latitude,
                        longitude: var longitude,
                      ) =>
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text('Location: $cityName'),
                            Text(
                                '${currentWeather.temperature}°C - ${currentWeather.condition}'),
                            const SizedBox(height: 20),
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 24,
                                vertical: 16,
                              ),
                              child: MapViewer(
                                  latitude: latitude, longitude: longitude),
                            ),
                          ],
                        ),
                    };
                  },
                ),
              ),
              Center(
                child: BlocBuilder<WeatherBloc, WeatherState>(
                  builder: (context, state) {
                    return switch (state) {
                      WeatherInitial() => const Text('No forecast data yet'),
                      WeatherLoadInProgress() =>
                        const CircularProgressIndicator(),
                      WeatherLoadFailure(message: var msg) =>
                        Text('Error: $msg'),
                      WeatherLoadSuccess(forecast: var list) =>
                        SingleChildScrollView(
                          child: Text(
                            list
                                .map((d) =>
                                    '${d.date.day}/${d.date.month}: Max ${d.maxTemperature}° Min ${d.minTemperature}°')
                                .join('\n\n'),
                            textAlign: TextAlign.center,
                          ),
                        ),
                    };
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
