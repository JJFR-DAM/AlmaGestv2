import 'package:almagestv2/services/services.dart';
import 'package:flutter/material.dart';
import 'package:flutter_no_internet_widget/flutter_no_internet_widget.dart';

import 'package:almagestv2/screens/screens.dart';
import 'package:provider/provider.dart';

void main() => runApp(const AppState());

class AppState extends StatelessWidget {
  const AppState({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => UserService(),
          lazy: false,
        ),
        ChangeNotifierProvider(
          create: (_) => OpinionsPlaguesService(),
          lazy: false,
        ),
        ChangeNotifierProvider(
          create: (_) => ProductsService(),
          lazy: false,
        ),
      ],
      child: const MyApp(),
    );
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return InternetWidget(
      whenOffline: () => LoadingScreen,
      // ignore: avoid_print
      whenOnline: () => print('Connected to internet'),
      loadingWidget: const Center(child: Text('Loading')),
      online: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Plague Management',
        initialRoute: 'login',
        routes: {
          'checking': (_) => const CheckAuthScreen(),
          'home': (_) => const HomeScreen(),
          'login': (_) => const LoginScreen(),
          'register': (_) => const RegisterScreen(),
          'admin': (_) => const AdminScreen(),
          'update': (_) => const UpdateScreen(),
          'opinions': (_) => const OpinionScreen(),
          'plagues': (_) => const PlagueScreen(),
          'graphic': (_) => const GraphicScreen(),
        },
        theme: ThemeData.light().copyWith(
            scaffoldBackgroundColor: Colors.grey[300],
            appBarTheme:
                const AppBarTheme(elevation: 0, color: Colors.deepPurple),
            floatingActionButtonTheme: const FloatingActionButtonThemeData(
                backgroundColor: Colors.deepPurple, elevation: 0)),
      ),
    );
  }
}
