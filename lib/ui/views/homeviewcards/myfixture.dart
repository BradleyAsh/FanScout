import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:fsproj/services/navigation_service.dart';
import 'package:fsproj/ui/shared/constants/route_names.dart';
import 'package:fsproj/ui/shared/ui_helpers.dart';
import 'package:intl/intl.dart';

import 'package:fsproj/locator.dart';
import 'package:fsproj/services/authentication_service.dart';
import 'package:fsproj/ui/shared/shared_styles.dart';

class NextMatchWidget extends StatefulWidget {
  NextMatchWidget({Key key}) : super(key: key);

  @override
  _NextMatchWidget createState() => _NextMatchWidget();
}

class _NextMatchWidget extends State<NextMatchWidget> {
  DateTime dayDate = DateTime.now();
  bool isHome = true;

  Widget build(BuildContext context) {
    final authService = locator<AuthenticationService>();
    final user = authService.currentUser; //Provider.of<User>(context);

    String myTeam = user.team;

    return Card(
      shape: cardShapeBorder,
      child: InkWell(
        splashColor: Colors.blue.withAlpha(30),
        onTap: () {
          print('Card tapped.');
        },
        child: Container(
          width: 300,
          height: 150,
          color: Color.fromARGB(255, 28, 37, 51),
          child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                verticalSpaceSmall,
                Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      homeAwayHeader("Home", isHome),
                      homeAwayHeader("Away", !isHome),
                    ]),
                Container(
                  height: 120,
                  padding: const EdgeInsets.all(10),
                  child: MyNextFixtureListView(myTeam),
                ),
              ]),
        ),
      ),
    );
  }

  StreamBuilder MyNextFixtureListView(String teamname) {
    DateTime day = DateTime.now();
    String dayStart = DateFormat("y").format(day) +
        '-' +
        DateFormat("M").format(day).padLeft(2, '0') +
        '-' +
        DateFormat("d").format(day).padLeft(2, '0') +
        'T' +
        DateFormat("Hms").format(day.add(Duration(hours: -1)));
    String dayEnd = DateFormat("y").format(day.add(Duration(days: 14))) +
        '-' +
        DateFormat("M").format(day.add(Duration(days: 30))).padLeft(2, '0') +
        '-' +
        DateFormat("d").format(day.add(Duration(days: 30))).padLeft(2, '0') +
        'T23:59:59';
    String homeOrAwayTeamField = isHome ? 'teams.home.name' : 'teams.away.name';
    print("dayStart: " +
        dayStart +
        "dayEnd: " +
        dayEnd +
        "homeaway: " +
        homeOrAwayTeamField +
        "teamname: " +
        teamname);
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('Fixtures')
          .where('event_date', isGreaterThan: dayStart)
          .where('event_date', isLessThan: dayEnd)
          .where(homeOrAwayTeamField, isEqualTo: teamname)
          .limit(1)
          .snapshots(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasError) return new Text('Error: ${snapshot.error}');
        switch (snapshot.connectionState) {
          case ConnectionState.waiting:
            return new Text('Loading...');
          default:
            return new ListView(
              children: snapshot.data.docs.map((DocumentSnapshot document) {
                return MyFixture(
                  document.data(),
                );
              }).toList(),
            );
        }
      },
    );
  }

  Widget MyFixture(Map<dynamic, dynamic> fixture) {
    final NavigationService _navigationService = locator<NavigationService>();

    Map<dynamic, dynamic> homeTeam = fixture['teams']['home'];
    Map<dynamic, dynamic> awayTeam = fixture['teams']['away'];
    String eventDate = fixture['event_date'];
    Map<dynamic, dynamic> league = fixture['league'];

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

    String fixtureHeader =
        league['name'] + ' - ' + kickOffDate + ' - ' + kickOff;

    return Container(
      padding: EdgeInsets.all(0),
      child: Column(mainAxisAlignment: MainAxisAlignment.start, children: [
        Row(mainAxisAlignment: MainAxisAlignment.center, children: [
          Text(fixtureHeader, style: cardHeader),
        ]),
        verticalSpaceSmall,
        InkWell(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              Image.network(
                homeTeam['logo'],
                scale: 2.5,
              ),
              Text("vs", style: cardSubHeader),
              Image.network(
                awayTeam['logo'],
                scale: 2.5,
              ),
            ],
          ),
          onTap: () => _navigationService.navigateTo(FixtureViewRoute,
              arguments: fixture),
        ),
      ]),
    );
  }

  Widget homeAwayHeader(String homeAway, bool isSelected) {
    final TextStyle homeAwayStyle =
        isSelected == true ? cardHeaderHomwAwayHighlight : cardHeaderHomwAway;

    return InkWell(
        child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(homeAway, style: homeAwayStyle),
            ]),
        onTap: () {
          setState(() {
            isHome = (homeAway == 'Home');
          });
        });
  }
} //class NextMatchFixture