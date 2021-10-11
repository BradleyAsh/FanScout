import 'package:fsproj/ui/views/home_view.dart';
import 'package:flutter/material.dart';
import 'package:fsproj/ui/shared/constants/route_names.dart';
import 'package:fsproj/ui/views/login_view.dart';
import 'package:fsproj/ui/views/signup_view.dart';
import 'package:fsproj/ui/views/profile_view.dart';
import 'package:fsproj/ui/views/fixture_view.dart';


Route<dynamic> generateRoute(RouteSettings settings) {
  switch (settings.name) {
    case LoginViewRoute:
      return _getPageRoute(
        routeName: settings.name,
        viewToShow: LoginView(),
      );
    case SignUpViewRoute:
      return _getPageRoute(
        routeName: settings.name,
        viewToShow: SignUpView(),
      );
    case HomeViewRoute:
      return _getPageRoute(
        routeName: settings.name,
        viewToShow: HomeView(),
      );
      case ProfileViewRoute:
      return _getPageRoute(
        routeName: settings.name,
        viewToShow: ProfileView(),
      );
      case FixtureViewRoute:
      return _getPageRoute(
      routeName: settings.name,
      arguments: settings.arguments,
      viewToShow: FixtureView(),
      );
    default:
      return MaterialPageRoute(
          builder: (_) => Scaffold(
                body: Center(
                    child: Text('No route defined for ${settings.name}')),
              ));
  }
}

PageRoute _getPageRoute({String routeName, Widget viewToShow, arguments}) {
  return MaterialPageRoute(
      settings: RouteSettings(
        name: routeName,
        arguments: arguments,
      ),
      builder: (_) => viewToShow);
}
