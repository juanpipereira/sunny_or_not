import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sunny_or_not/core/presentation/widgets/location_selector_sheet.dart';
import 'package:sunny_or_not/features/gps/presentation/bloc/gps_bloc.dart';
import 'package:sunny_or_not/features/gps/presentation/bloc/gps_state.dart';
import 'package:sunny_or_not/features/weather/presentation/blocs/weather_bloc.dart';
import 'package:sunny_or_not/features/weather/presentation/blocs/weather_event.dart';
import 'package:sunny_or_not/features/weather/presentation/blocs/weather_state.dart';

class WeatherScreen extends StatelessWidget {
  const WeatherScreen({super.key});

  void _showLocationSelector(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (_) => MultiBlocProvider(
        providers: [
          BlocProvider.value(value: context.read<GpsBloc>()),
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
              onPressed: () => _showLocationSelector(context),
            ),
          ],
          bottom: const TabBar(
            tabs: [
              Tab(text: 'Today'),
              Tab(text: '10 Days'),
            ],
          ),
        ),
        body: BlocListener<GpsBloc, GpsState>(
          listener: (context, state) {
            if (state is GpsLoadSuccess) {
              context.read<WeatherBloc>().add(
                    WeatherFetchedByCoordinates(
                      latitude: state.gpsCoordinates.latitude,
                      longitude: state.gpsCoordinates.longitude,
                    ),
                  );
            }
          },
          child: BlocBuilder<WeatherBloc, WeatherState>(
            builder: (context, state) {
              final content = switch (state) {
                WeatherInitial() => 'Initial: Press the GPS icon',
                WeatherLoadInProgress() => 'Loading...',
                WeatherLoadFailure(message: var msg) => 'Error: $msg',
                WeatherLoadSuccess(
                  currentWeather: var curr,
                  forecast: var days
                ) =>
                  {
                    'today': 'Temp: ${curr.temperature} - ${curr.condition}',
                    'weekly': days
                        .map((d) => '${d.date.day}: ${d.maxTemperature}°')
                        .join(', ')
                  },
              };

              return TabBarView(
                children: [
                  Center(
                    child: Text(
                      content is Map ? content['today']! : content.toString(),
                    ),
                  ),
                  Center(
                    child: Text(
                      content is Map ? content['weekly']! : content.toString(),
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
