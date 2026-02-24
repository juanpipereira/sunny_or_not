import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sunny_or_not/di_setup.dart';
import 'package:sunny_or_not/features/gps/presentation/bloc/gps_bloc.dart';
import 'package:sunny_or_not/features/weather/presentation/blocs/weather_bloc.dart';
import 'package:sunny_or_not/features/weather/presentation/screens/weather_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await initGetIt();

  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Sunny or not',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorSchemeSeed: Colors.blue,
      ),
      home: MultiBlocProvider(
        providers: [
          BlocProvider<GpsBloc>(
            create: (_) => getIt<GpsBloc>(),
          ),
          BlocProvider<WeatherBloc>(
            create: (_) => getIt<WeatherBloc>(),
          ),
        ],
        child: const WeatherScreen(),
      ),
    );
  }
}
