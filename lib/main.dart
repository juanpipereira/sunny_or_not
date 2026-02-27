import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sunny_or_not/core/theme/gradient_theme.dart';
import 'package:sunny_or_not/di_setup.dart';
import 'package:sunny_or_not/features/gps/presentation/bloc/gps_bloc.dart';
import 'package:sunny_or_not/features/location/presentation/bloc/location_bloc.dart';
import 'package:sunny_or_not/features/weather/presentation/blocs/weather_bloc.dart';
import 'package:sunny_or_not/features/weather/presentation/screens/weather_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await initGetIt();

  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  static final Color blue300 = Colors.blue.shade300;
  static final Color blue600 = Colors.blue.shade600;
  static final Color background = Colors.grey.shade50;
  static const Color mainWhite = Colors.white;
  static const Color secondaryWhite = Colors.white70;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Sunny or not',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: blue600,
          primary: blue600,
          secondary: blue300,
          surface: background,
          onPrimaryContainer: mainWhite,
          onSecondaryContainer: secondaryWhite,
        ),
        scaffoldBackgroundColor: background,
        extensions: [
          GradientTheme(
            mainGradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [blue300, blue600],
            ),
          ),
        ],
      ),
      home: MultiBlocProvider(
        providers: [
          BlocProvider<GpsBloc>(
            create: (_) => getIt<GpsBloc>(),
          ),
          BlocProvider<WeatherBloc>(
            create: (_) => getIt<WeatherBloc>(),
          ),
          BlocProvider<LocationBloc>(
            create: (_) => getIt<LocationBloc>(),
          ),
        ],
        child: const WeatherScreen(),
      ),
    );
  }
}
