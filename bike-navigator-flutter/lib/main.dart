import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wakelock_plus/wakelock_plus.dart';
import 'providers/navigation_provider.dart';
import 'screens/home_screen.dart';
import 'screens/navigation_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  WakelockPlus.enable();
  runApp(const BikeNavigatorApp());
}

class BikeNavigatorApp extends StatelessWidget {
  const BikeNavigatorApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => NavigationProvider(),
      child: MaterialApp(
        title: 'Bike Navigator',
        theme: ThemeData(
          useMaterial3: true,
          brightness: Brightness.dark,
          scaffoldBackgroundColor: Colors.black,
          colorScheme: ColorScheme.dark(
            primary: Colors.white,
            secondary: Colors.white70,
            surface: Colors.black,
            error: Colors.grey,
          ),
          textTheme: const TextTheme(
            displayLarge: TextStyle(
              color: Colors.white,
              fontSize: 72,
              fontWeight: FontWeight.bold,
              letterSpacing: 1.0,
            ),
            displayMedium: TextStyle(
              color: Colors.white,
              fontSize: 48,
              fontWeight: FontWeight.bold,
            ),
            headlineSmall: TextStyle(
              color: Colors.white,
              fontSize: 32,
              fontWeight: FontWeight.bold,
            ),
            bodyLarge: TextStyle(
              color: Colors.white70,
              fontSize: 18,
            ),
            bodyMedium: TextStyle(
              color: Colors.white60,
              fontSize: 14,
            ),
          ),
        ),
        debugShowCheckedModeBanner: false,
        home: Consumer<NavigationProvider>(
          builder: (context, navProvider, _) {
            return navProvider.hasLoadedRoute
                ? const NavigationScreen()
                : const HomeScreen();
          },
        ),
      ),
    );
  }
}
