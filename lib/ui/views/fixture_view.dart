import 'dart:math';

import 'package:flutter/material.dart';
import 'package:fsproj/ui/shared/common_widgets/avatar.dart';
import 'package:fsproj/ui/shared/constants/keys.dart';
import 'package:fsproj/ui/shared/constants/route_names.dart';
import 'package:fsproj/ui/shared/constants/strings.dart';
import 'package:fsproj/ui/shared/ui_helpers.dart';
import 'package:fsproj/ui/views/homeviewcards/fixturesubview.dart';
import 'package:fsproj/ui/widgets/busy_button.dart';
import 'package:fsproj/ui/widgets/input_field.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:fsproj/viewmodels/profile_view_model.dart';
import 'package:intl/intl.dart';
import 'package:stacked/stacked.dart';

import '../../locator.dart';
import '../../models/user.dart';
import '../../services/authentication_service.dart';
import '../../services/navigation_service.dart';
import 'package:fsproj/ui/shared/shared_styles.dart';
import 'package:fsproj/models/fixtures.dart';
import 'package:fsproj/ui/views/homeviewcards/fixturesubview.dart';

class FixtureView extends StatelessWidget {
  const FixtureView({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final authService = locator<AuthenticationService>();
    final NavigationService _navigationService = locator<NavigationService>();
    final user = authService.currentUser; //Provider.of<User>(context);

    final fixture = ModalRoute.of(context).settings.arguments;

    return ViewModelBuilder<ProfileViewModel>.reactive(
        viewModelBuilder: () => ProfileViewModel(),
        builder: (context, model, child) => Scaffold(
              appBar: AppBar(
                backgroundColor: Color.fromARGB(255, 10, 22, 40),
              ),
              body: _buildFixtureInfo(model, user, fixture),
            ));
  }

// Body
  Widget _buildFixtureInfo(model, AUser user, fixture) {
    return Container(
      //background container
      color: Color.fromARGB(255, 10, 22, 40),
      padding: const EdgeInsets.all(2),
      child: Card(
        shape: cardShapeBorder,
        child: InkWell(
          // splashColor: Colors.pink,
          onTap: () {
            print('Card tapped.');
          },
          child: Container(
            // Main Container
            // padding: const EdgeInsets.all(10),
            color: Color.fromARGB(255, 28, 37, 51),
            child: Column(children: [
              Row(children: [
                Expanded(flex: 10, child: thisFixture(fixture)),
              ]),
            ]),
          ),
        ),
      ),
    );
  }

  Widget thisFixture(fixture) {
    final NavigationService _navigationService = locator<NavigationService>();

    Map<dynamic, dynamic> homeTeam = fixture['teams']['home'];
    Map<dynamic, dynamic> awayTeam = fixture['teams']['away'];
    String eventDate = fixture['event_date'];
    Map<dynamic, dynamic> league = fixture['league'];
    Map<dynamic, dynamic> venue = fixture['fixture']['venue'];
    String referee = fixture['fixture']['referee'] ?? "";
    int fixtureId = fixture['fixture']['id'];
    int homeId = homeTeam['id'];
    int awayId = awayTeam['id'];
    int homegoals = fixture['goals']['home'];
    int awaygoals = fixture['goals']['away'];
    print("Score - " + homegoals.toString() + "-" + awaygoals.toString());

    DateTime today = DateTime.now();
    DateTime kickoffdt = DateTime.parse(eventDate);
    bool isToday = (kickoffdt.year == today.year &&
        kickoffdt.month == today.month &&
        kickoffdt.day == today.day);
    String kickOffDate = isToday
        ? "TODAY"
        : DateFormat("d").format(kickoffdt).toString() +
            " " +
            DateFormat("MMMM").format(kickoffdt).toString();
    String kickOff = kickoffdt.toLocal().hour.toString() +
        ':' +
        kickoffdt.toLocal().minute.toString().padLeft(2, '0');

    String homeTeamName = homeTeam['name'].toString();
    String awayTeamName = awayTeam['name'].toString();

    // String fixtureHeader = homeTeamName + ' vs ' + awayTeamName;
    if (homegoals == null) {
      return Container(
        child: Column(children: <Widget>[
          verticalSpaceSmall,
          Row(
            children: <Widget>[
              Expanded(
                flex: 8,
                child: Container(
                  child: Text(
                    homeTeamName,
                    textAlign: TextAlign.right,
                    style: cardHeader,
                  ),
                ),
              ),
              Expanded(
                flex: 2,
                child: Container(
                    child: Text(
                  ' vs ',
                  textAlign: TextAlign.center,
                  style: cardHeader,
                )),
              ),
              Expanded(
                flex: 8,
                child: Container(
                    child: Text(
                  awayTeamName,
                  textAlign: TextAlign.left,
                  style: cardHeader,
                )),
              )
            ],
          ),
          Row(
            children: <Widget>[
              Expanded(
                flex: 3,
                child: Container(
                    padding: const EdgeInsets.all(1.0),
                    child: Image.network(
                      homeTeam['logo'],
                      scale: 2,
                    )),
              ),
              Expanded(
                flex: 4,
                child: Container(
                  child: Column(
                    children: [
                      Text(venue['name'],
                          style: cardFixtureText,
                          softWrap: true,
                          textAlign: TextAlign.center),
                      Text(kickOffDate,
                          style: cardFixtureText, textAlign: TextAlign.center),
                      Text(kickOff,
                          style: cardFixtureText, textAlign: TextAlign.center),
                      Text(referee,
                          style: cardFixtureText, textAlign: TextAlign.center),
                    ],
                  ),
                ),
              ),
              Expanded(
                flex: 3,
                child: Container(
                    padding: const EdgeInsets.all(1.0),
                    child: Image.network(
                      awayTeam['logo'],
                      scale: 2,
                    )),
              ),
            ],
          ),
          verticalSpaceSmall,
          FixtureDetailWidget(
            fixtureId: fixtureId,
            homeId: homeId,
            awayId: awayId,
          )
        ]),
      );
    } // if
    else {
      return Container(
        child: Column(children: <Widget>[
          verticalSpaceSmall,
          Row(
            children: <Widget>[
              Expanded(
                flex: 8,
                child: Container(
                  child: Text(
                    homeTeamName,
                    textAlign: TextAlign.right,
                    style: cardHeader,
                  ),
                ),
              ),
              Expanded(
                flex: 2,
                child: Container(
                    child: Text(
                  ' vs ',
                  textAlign: TextAlign.center,
                  style: cardHeader,
                )),
              ),
              Expanded(
                flex: 8,
                child: Container(
                    child: Text(
                  awayTeamName,
                  textAlign: TextAlign.left,
                  style: cardHeader,
                )),
              )
            ],
          ),
          Row(
            children: <Widget>[
              Expanded(
                flex: 3,
                child: Container(
                    padding: const EdgeInsets.all(1.0),
                    child: Image.network(
                      homeTeam['logo'],
                      scale: 2,
                    )),
              ),
              Expanded(
                flex: 4,
                child: Container(
                    child: Text(
                  homegoals.toString() + '-' + awaygoals.toString(),
                  textAlign: TextAlign.center,
                  style: largeScore,
                )),
              ),
              Expanded(
                flex: 3,
                child: Container(
                    padding: const EdgeInsets.all(1.0),
                    child: Image.network(
                      awayTeam['logo'],
                      scale: 2,
                    )),
              ),
            ],
          ),
          verticalSpaceSmall,
          FixtureDetailWidget(
            fixtureId: fixtureId,
            homeId: homeId,
            awayId: awayId,
          )
        ]),
      );
    }
  }
}
