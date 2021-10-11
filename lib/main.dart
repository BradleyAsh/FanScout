import 'package:fsproj/ui/views/startup_view.dart';
import 'package:flutter/material.dart';
import 'package:fsproj/services/navigation_service.dart';
import 'package:fsproj/services/dialog_service.dart';
import 'managers/dialog_manager.dart';
import 'ui/router.dart';
import 'locator.dart';
import 'package:firebase_core/firebase_core.dart';

void main() async {
  // Register all the models and services before the app starts
  setupLocator();
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Fan Scout',
      builder: (context, child) => Navigator(
        key: locator<DialogService>().dialogNavigationKey,
        onGenerateRoute: (settings) => MaterialPageRoute(
            builder: (context) => DialogManager(child: child)),
      ),
      navigatorKey: locator<NavigationService>().navigationKey,
      theme: ThemeData(
        primaryColor: Color.fromARGB(255, 9, 202, 172),
        backgroundColor: Color.fromARGB(255, 26, 27, 30),
        textTheme: Theme.of(context).textTheme.apply(
              fontFamily: 'Open Sans',
            ),
        appBarTheme: AppBarTheme(
          iconTheme: IconThemeData(color: Color.fromARGB(255, 44, 179, 163)),
        ),
      ),
      home: StartUpView(),
      onGenerateRoute: generateRoute,
    );
  }
}
