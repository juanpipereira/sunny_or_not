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
import 'package:sunny_or_not/features/weather/presentation/widgets/current_weather_card.dart';
import 'package:sunny_or_not/features/weather/presentation/widgets/forecast_card.dart';

class WeatherScreen extends StatelessWidget {
  const WeatherScreen({super.key});

  void _openLocationSelector(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      constraints: const BoxConstraints(maxWidth: double.infinity),
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
          centerTitle: true,
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
                if (state is GpsLoadFailure) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text(state.message)),
                  );
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
                      WeatherInitial() =>
                        const Text('Search to see the weather'),
                      WeatherLoadInProgress() =>
                        const CircularProgressIndicator(),
                      WeatherLoadFailure(message: var msg) => Text(msg),
                      WeatherLoadSuccess(
                        currentWeather: var currentWeather,
                        cityName: var cityName,
                        latitude: var latitude,
                        longitude: var longitude,
                      ) =>
                        OrientationBuilder(
                          builder: (context, orientation) {
                            final isLandscape =
                                orientation == Orientation.landscape;

                            return Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Flex(
                                direction: isLandscape
                                    ? Axis.horizontal
                                    : Axis.vertical,
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                spacing: 16.0,
                                children: [
                                  Expanded(
                                    flex: 2,
                                    child: MapViewer(
                                      latitude: latitude,
                                      longitude: longitude,
                                    ),
                                  ),
                                  Expanded(
                                    flex: 1,
                                    child: CurrentWeatherCard(
                                      currentWeather: currentWeather,
                                      cityName: cityName,
                                    ),
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                    };
                  },
                ),
              ),
              Center(
                child: BlocBuilder<WeatherBloc, WeatherState>(
                  builder: (context, state) {
                    return switch (state) {
                      WeatherInitial() =>
                        const Text('Search to see the forecast'),
                      WeatherLoadInProgress() =>
                        const CircularProgressIndicator(),
                      WeatherLoadFailure(message: var msg) => Text(msg),
                      WeatherLoadSuccess(forecast: var forecastList) =>
                        ListView.builder(
                          padding: const EdgeInsets.symmetric(vertical: 16.0),
                          itemCount: forecastList.length,
                          itemBuilder: (context, index) {
                            final day = forecastList[index];
                            return ForecastCard(daily: day);
                          },
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
