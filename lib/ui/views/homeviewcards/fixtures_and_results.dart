//import 'dart:js_util';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:fsproj/locator.dart';
import 'package:fsproj/services/navigation_service.dart';
import 'package:fsproj/ui/shared/constants/route_names.dart';
import 'package:intl/intl.dart';

import 'package:fsproj/ui/shared/shared_styles.dart';

class FixtureDate {
  String weekDay;
  String weekDate;
  DateTime fullDate;
  bool isSelected;

  FixtureDate(this.weekDay, this.weekDate, this.fullDate, this.isSelected);
}

class FixturesCardWidget extends StatefulWidget {
  FixturesCardWidget({Key key}) : super(key: key);

  @override
  _FixturesCardWidget createState() => _FixturesCardWidget();
}

class _FixturesCardWidget extends State<FixturesCardWidget> {
  DateTime dayDate = DateTime.now();

  Widget build(BuildContext context) {
    //final authService = locator<AuthenticationService>();
    //final user = authService.currentUser;  //Provider.of<User>(context);

    List<FixtureDate> dayList = List();
    for (int i = -2; i <= 2; i++) {
      DateTime columnDate = DateTime.now().add(Duration(days: i));
      bool isSelected = (columnDate.year == dayDate.year &&
          columnDate.month == dayDate.month &&
          columnDate.day == dayDate.day);
      FixtureDate fxdate = FixtureDate(
          i == 0 ? "TODAY" : DateFormat('EEE').format(columnDate).toString(),
          i == 0
              ? ""
              : DateFormat("d").format(columnDate).toString() +
                  " " +
                  DateFormat("MMMM").format(columnDate).toString(),
          columnDate,
          isSelected);
      dayList.add(fxdate);
    }

    return Card(
      shape: cardShapeBorder,
      child: InkWell(
        splashColor: Colors.blue.withAlpha(30),
        onTap: () {
          print('Card tapped.');
        },
        child: Container(
          width: 300,
          height: 200,
          color: Colors.black87,
          child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                  Text("Fixtures and Results", style: cardHeader),
                ]),
                Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    for (var fxdate in dayList)
                      dateHeader(
                          fxdate.weekDay, fxdate.weekDate, fxdate.fullDate,
                          isToday: fxdate.isSelected)
                  ],
                ),
                Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: 5.0,
                    vertical: 3.0,
                  ),
                  child: Container(
                    height: 1.0,
                    color: Colors.cyan,
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text("Premier League", style: cardSubHeader),
                  ],
                ),
                /*fixtureResult("Brighton", "2-0", "Bournemouth"),
                        fixtureResult("Southampton", "0-0", "Crystal Palace"),
                        fixtureResult("Newcastle", "0-1", "Everton"),
                        fixtureResult("Watford", "15:00", "Aston Villa"),
                        fixtureResult("Norwich", "15:00", "Tottenham Hotspur"),
                        fixtureResult("West Ham", "15:00", "Leicester City"),
                        */
                Container(
                  height: 94,
                  padding: const EdgeInsets.all(10),
                  child: fixtureListView(dayDate),
                ),
              ]),
        ),
      ),
    );
  }

  StreamBuilder fixtureListView(DateTime day) {
    String dayStart = DateFormat("y").format(day) +
        '-' +
        DateFormat("M").format(day).padLeft(2, '0') +
        '-' +
        DateFormat("d").format(day).padLeft(2, '0') +
        'T00:00:00';
    String dayEnd = DateFormat("y").format(day) +
        '-' +
        DateFormat("M").format(day).padLeft(2, '0') +
        '-' +
        DateFormat("d").format(day).padLeft(2, '0') +
        'T23:59:59';

    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('Fixtures')
          .where('event_date', isGreaterThan: dayStart)
          .where('event_date', isLessThan: dayEnd)
          .where('league.id', isEqualTo: 39)
          .snapshots(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasError) return new Text('Error: ${snapshot.error}');
        switch (snapshot.connectionState) {
          case ConnectionState.waiting:
            return new Text('Loading');
          default:
            return new ListView(
              children: snapshot.data.docs.map((DocumentSnapshot document) {
                return fixtureResult(
                  document.data(),
                );
              }).toList(),
            );
        }
      },
    );
  }

  Widget fixtureResult(Map<dynamic, dynamic> fixture) {
    final NavigationService _navigationService = locator<NavigationService>();

    Map<dynamic, dynamic> homeTeam = fixture['teams']['home'];
    Map<dynamic, dynamic> awayTeam = fixture['teams']['away'];
    String eventDate = fixture['event_date'];
    int goalsHT = fixture['goals']['home'];
    int goalsAT = fixture['goals']['away'];

    print("result" + homeTeam['name'] + awayTeam['name'] + goalsHT.toString());
    DateTime kickoffdt = DateTime.parse(eventDate);
    String kickOff = kickoffdt.toLocal().hour.toString() +
        ':' +
        kickoffdt.toLocal().minute.toString().padLeft(2, '0');
    String scoreOrDate = "";
    if (goalsHT != null && goalsAT != null) {
      scoreOrDate = goalsHT.toString() + '-' + goalsAT.toString();
    } else {
      scoreOrDate = kickOff;
    }
    return Container(
      padding: EdgeInsets.all(1),
      child: InkWell(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Container(
              width: 70,
              child: Text(homeTeam['name'], style: cardStyleFixture),
            ),
            Container(
              width: 30,
              child: Text(scoreOrDate, style: cardStyleFixture),
            ),
            Container(
              width: 70,
              child: Text(awayTeam['name'], style: cardStyleFixture),
            ),
          ],
        ),
        onTap: () =>
            _navigationService.navigateTo(FixtureViewRoute, arguments: fixture),
      ),
    );
  }

  Widget dateHeader(String day, String date, DateTime fullDate,
      {bool isToday = false}) {
    final TextStyle dateStyle =
        isToday == true ? cardStyleToday : cardStyleDate;

    return InkWell(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(day, style: dateStyle),
            Text(
              date,
              style: dateStyle,
            ),
          ],
        ),
        onTap: () {
          setState(() {
            dayDate = fullDate;
          });
        });
  }
}
