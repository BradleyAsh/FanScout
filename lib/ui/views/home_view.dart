import 'package:async/async.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:fsproj/ui/shared/common_widgets/avatar.dart';
import 'package:fsproj/ui/shared/common_widgets/platform_alert_dialog.dart';
import 'package:fsproj/ui/shared/common_widgets/platform_exception_alert_dialog.dart';
import 'package:fsproj/ui/shared/constants/keys.dart';
import 'package:fsproj/ui/shared/constants/route_names.dart';
import 'package:fsproj/ui/shared/constants/strings.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:stacked/stacked.dart';

import '../../locator.dart';
import '../../models/user.dart';
import '../../services/authentication_service.dart';
import '../../services/navigation_service.dart';
import 'package:fsproj/ui/shared/shared_styles.dart';
import 'package:fsproj/viewmodels/home_view_model.dart';
import 'homeviewcards/myfixture.dart';
import 'homeviewcards/fixtures_and_results.dart';

class HomeView extends StatelessWidget {
  const HomeView({Key key}) : super(key: key);

  Future<void> _signOut(BuildContext context) async {
    try {
      //final AuthService auth = Provider.of<AuthService>(context, listen: false);
      final NavigationService _navigationService = locator<NavigationService>();
      final AuthenticationService authService =
          locator<AuthenticationService>();
      await authService.signOut();
      _navigationService.navigateTo(LoginViewRoute);
    } on PlatformException catch (e) {
      await PlatformExceptionAlertDialog(
        title: Strings.logoutFailed,
        exception: e,
      ).show(context);
    }
  }

  Future<void> _confirmSignOut(BuildContext context) async {
    final bool didRequestSignOut = await PlatformAlertDialog(
      title: Strings.logout,
      content: Strings.logoutAreYouSure,
      cancelActionText: Strings.cancel,
      defaultActionText: Strings.logout,
    ).show(context);
    if (didRequestSignOut == true) {
      _signOut(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    final authService = locator<AuthenticationService>();
    final NavigationService _navigationService = locator<NavigationService>();
    final user = authService.currentUser; //Provider.of<User>(context);

    return ViewModelBuilder<HomeViewModel>.reactive(
        viewModelBuilder: () => HomeViewModel(),
        builder: (context, model, child) => Scaffold(
              appBar: AppBar(
                backgroundColor: Color.fromARGB(255, 10, 22, 40),
                title:
                    Image.asset('assets/fanscoutlogo.png', fit: BoxFit.cover),
                actions: <Widget>[
                  IconButton(
                    icon: Icon(Icons.account_circle),
                    color: Colors.teal,
                    onPressed: () =>
                        _navigationService.navigateTo(ProfileViewRoute),
                  ),
                  FlatButton(
                    key: Key(Keys.logout),
                    child: Text(
                      Strings.logout,
                      style: TextStyle(
                          fontSize: 12.0,
                          color: Colors.white,
                          fontWeight: FontWeight.bold),
                    ),
                    onPressed: () => _confirmSignOut(context),
                  ),
                ],
              ),
              body: _buildHomeInfo(context, model, user),
            ));
  }

  Widget _buildHomeInfo(BuildContext context, model, AUser user) {
    return Container(
        color: Color.fromARGB(255, 10, 22, 40),
        child: ListView(
          padding: const EdgeInsets.all(8),
          children: <Widget>[
            NextMatchWidget(),
            FixturesCardWidget(),
            Card(
              shape: cardShapeBorder,
              child: InkWell(
                splashColor: Colors.blue.withAlpha(30),
                onTap: () {
                  print('Card tapped!');
                },
                child: Container(
                  width: 300,
                  height: 100,
                  child: Text('Form Players'),
                ),
              ),
            ),
            Card(
              shape: cardShapeBorder,
              child: InkWell(
                splashColor: Colors.blue.withAlpha(30),
                onTap: () {
                  print('Card tapped.');
                },
                child: Container(
                  width: 300,
                  height: 100,
                  child: Text('My Ratings'),
                ),
              ),
            ),
            Card(
              shape: cardShapeBorder,
              child: InkWell(
                splashColor: Colors.blue.withAlpha(30),
                onTap: () {
                  print('Card tapped.');
                },
                child: Container(
                  width: 300,
                  height: 100,
                  child: Text('Latest News'),
                ),
              ),
            ),
            Card(
              shape: cardShapeBorder,
              child: InkWell(
                splashColor: Colors.blue.withAlpha(30),
                onTap: () {
                  print('Card tapped.');
                },
                child: Container(
                  width: 300,
                  height: 100,
                  child: Text('Card 7'),
                ),
              ),
            ),
          ],
        ));
  }

  Widget _buildUserInfo(AUser user) {
    return Column(
      children: [
        Avatar(
          photoUrl: user.photoUrl,
          radius: 50,
          borderColor: Colors.black54,
          borderWidth: 2.0,
        ),
        SizedBox(height: 8),
        if (user.fullname != null)
          Text(
            "Hello " + user.fullname + ", " + user.team + " supporter",
            style: TextStyle(color: Colors.white),
          ),
        SizedBox(height: 8),
      ],
    );
  }
}
