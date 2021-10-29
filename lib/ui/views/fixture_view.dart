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
    //final name = ModalRoute.of(context).settings.name;
    //print("FixtureView: " + fixture.toString());

    return ViewModelBuilder<ProfileViewModel>.reactive(
        viewModelBuilder: () => ProfileViewModel(),
        builder: (context, model, child) => Scaffold(
              appBar: AppBar(
                backgroundColor: Color.fromARGB(255, 10, 22, 40),
              ),
              body: _buildFixtureInfo(model, user, fixture),
            ));
  }

  Widget _buildFixtureInfo(model, AUser user, fixture) {
    //print("buildFixtureInfo Team ID: " + fixture.toString());

    return Container(
      color: Color.fromARGB(255, 10, 22, 40),
      padding: const EdgeInsets.all(6),
      child: Card(
        shape: cardShapeBorder,
        child: InkWell(
          splashColor: Colors.pink,
          onTap: () {
            print('Card tapped.');
          },
          child: Container(
            padding: const EdgeInsets.all(10),
            color: Color.fromARGB(255, 28, 37, 51),
            child: Column(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  // Row(
                  //  mainAxisAlignment: MainAxisAlignment.center,
                  //children: [Text("Countdown", style: cardHeader)],
                  // ),
                  Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                    thisFixture(fixture),
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
    int fixtureId = fixture['fixture_id'];

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

    String fixtureHeader = homeTeamName + ' vs ' + awayTeamName;

    return Container(
      padding: EdgeInsets.all(0),
      child: Column(mainAxisAlignment: MainAxisAlignment.start, children: [
        Row(mainAxisAlignment: MainAxisAlignment.center, children: [
          Text(fixtureHeader, textAlign: TextAlign.center, style: cardHeader),
        ]),
        verticalSpaceSmall,
        Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Image.network(
              homeTeam['logo'],
              scale: 2,
            ),
            SizedBox(width: 20),
            SizedBox(
              width: 100,
              child: Column(
                children: [
                  Text(venue['name'], style: cardFixtureText, softWrap: true),
                  Text(kickOffDate, style: cardFixtureText),
                  Text(kickOff, style: cardFixtureText),
                  Text(referee, style: cardFixtureText),
                ],
              ),
            ),
            SizedBox(width: 20),
            Image.network(
              awayTeam['logo'],
              scale: 2,
            ),
          ],
        ),
        verticalSpaceMedium,
        FixtureDetailWidget(fixtureId: fixtureId),
      ]),
    );
  }
}
