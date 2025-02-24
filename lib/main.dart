import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:get/route_manager.dart';
import 'package:responsive_framework/responsive_framework.dart';
import 'package:swag_post/Constants/constants.dart';
import 'package:swag_post/routes/route_pages.dart';
import 'package:swag_post/routes/routes_name.dart';
import 'package:url_strategy/url_strategy.dart';
import 'dart:html' as html;

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  HttpOverrides.global = CustomHttpOverrides();
  setPathUrlStrategy();

  runApp(const MyApp());
}

class CustomHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
  }
}

void suppressNetworkLogs() {
  // Disable console logging for network requests
  html.window.console.log(null);
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      defaultTransition: Transition.noTransition,
      transitionDuration: Duration.zero,
      smartManagement: SmartManagement.keepFactory,
      getPages: AppPages.getPages(),
      theme: ThemeData(
        inputDecorationTheme: InputDecorationTheme(),
        scaffoldBackgroundColor: Constants.scaffoldBackground,
        primaryColor: Colors.white,
        textSelectionTheme: TextSelectionThemeData(cursorColor: Colors.white),
        textTheme: TextTheme(
          displayLarge: TextStyle(color: Colors.white),
        ),
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.white),
        appBarTheme: AppBarTheme(backgroundColor: Constants.scaffoldBackground),
        useMaterial3: true,
      ),
      builder: FlutterSmartDialog.init(
        builder: (context, widget) => ResponsiveBreakpoints.builder(
          child: widget!,
          breakpoints: [
            const Breakpoint(start: 0, end: 450, name: MOBILE),
            const Breakpoint(start: 451, end: 800, name: TABLET),
            const Breakpoint(start: 801, end: double.infinity, name: DESKTOP),
          ],
        ),
      ),
      navigatorObservers: [
        FlutterSmartDialog.observer,
      ],
      initialRoute: RoutesName.workSpaceHome,
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              'You have pushed the button this many times:',
            ),
            Text(
              '$_counter',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ),
    );
  }
}
