import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:fsproj/services/navigation_service.dart';
import 'package:fsproj/ui/shared/constants/route_names.dart';
import 'package:intl/intl.dart';

import 'package:fsproj/locator.dart';
import 'package:fsproj/services/authentication_service.dart';
import 'package:fsproj/ui/shared/shared_styles.dart';

class FixtureDetailWidget extends StatefulWidget {
  final fixtureId;
  final int homeId;
  final int awayId;

  FixtureDetailWidget(
      {Key key, @required this.fixtureId, this.homeId, this.awayId})
      : super(key: key);

  @override
  _FixtureDetailWidget createState() => _FixtureDetailWidget();
}

class _FixtureDetailWidget extends State<FixtureDetailWidget> {
  DateTime dayDate = DateTime.now();
  bool isHome = true;
  int selectedSubHeading = 1;

  Widget build(BuildContext context) {
    final authService = locator<AuthenticationService>();
    final user = authService.currentUser; //Provider.of<User>(context);

    return Card(
      shape: cardShapeBorder,
      child: InkWell(
        splashColor: Colors.blue.withAlpha(30),
        onTap: () {
          print('Card tapped.');
        },
        child: Container(
          width: 300,
          height: 440,
          color: Color.fromARGB(255, 28, 37, 51),
          child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      fixtureDetailsHeader(
                          "Lineups", selectedSubHeading == 1, 1),
                      fixtureDetailsHeader(
                          "Ratings", selectedSubHeading == 2, 2),
                      fixtureDetailsHeader("Stats", selectedSubHeading == 3, 3),
                      fixtureDetailsHeader("News", selectedSubHeading == 4, 4),
                    ]),
                Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: 0.0,
                    vertical: 3.0,
                  ),
                  child: Container(
                    height: 1.0,
                    color: Colors.cyan,
                  ),
                ),
                Container(
                    height: 200,
                    // padding: const EdgeInsets.all(0.0),
                    child: HomeFixtureDetailsView(
                        widget.fixtureId, widget.homeId)),
                Container(
                    height: 200,
                    // padding: const EdgeInsets.all(0.0),
                    child: AwayFixtureDetailsView(
                        widget.fixtureId, widget.awayId)),
              ]),
        ),
      ),
    );
  }

  StreamBuilder HomeFixtureDetailsView(int fixtureId, int homeId) {
    print("Fixture detail widget called for fixture - " +
        fixtureId.toString() +
        " Home team - " +
        homeId.toString() +
        " Away team - ");

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
        DateFormat("M").format(day.add(Duration(days: 14))).padLeft(2, '0') +
        '-' +
        DateFormat("d").format(day.add(Duration(days: 14))).padLeft(2, '0') +
        'T23:59:59';
//Lineups Queried by fixture ID limited to two results
    Stream homequery = FirebaseFirestore.instance
        .collection('Lineups')
        .where('fixture_id', isEqualTo: fixtureId)
        .where('team.id', isEqualTo: homeId)
        .limit(1)
        .snapshots();

    if (selectedSubHeading == 1) {
      //Lineup
      homequery = FirebaseFirestore.instance
          .collection('Lineups')
          .where('fixture_id', isEqualTo: fixtureId)
          .where('team.id', isEqualTo: homeId)
          .limit(1)
          .snapshots();
    } else if (selectedSubHeading == 2) {
      //Ratings
    } else if (selectedSubHeading == 3) {
      //Stats
    } else if (selectedSubHeading == 4) {
      //News
    }

    return StreamBuilder<QuerySnapshot>(
      stream: homequery,
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasError) return new Text('Error: ${snapshot.error}');
        switch (snapshot.connectionState) {
          case ConnectionState.waiting:
            return new Text('Loading...');
          default:
            return new ListView(
              children: snapshot.data.docs.map((DocumentSnapshot document) {
                return LineupDetails(document.data(), homeId, "home");
              }).toList(),
            );
        }
      },
    );
  }

  StreamBuilder AwayFixtureDetailsView(int fixtureId, int awayId) {
    print("Fixture detail widget called for fixture - " +
        fixtureId.toString() +
        " Home team - " +
        " Away team - " +
        awayId.toString());

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
        DateFormat("M").format(day.add(Duration(days: 14))).padLeft(2, '0') +
        '-' +
        DateFormat("d").format(day.add(Duration(days: 14))).padLeft(2, '0') +
        'T23:59:59';
//Lineups Queried by fixture ID limited to two results
    Stream homequery = FirebaseFirestore.instance
        .collection('Lineups')
        .where('fixture_id', isEqualTo: fixtureId)
        .where('team.id', isEqualTo: awayId)
        .limit(1)
        .snapshots();

    if (selectedSubHeading == 1) {
      //Lineup
      homequery = FirebaseFirestore.instance
          .collection('Lineups')
          .where('fixture_id', isEqualTo: fixtureId)
          .where('team.id', isEqualTo: awayId)
          .limit(1)
          .snapshots();
    } else if (selectedSubHeading == 2) {
      //Ratings
    } else if (selectedSubHeading == 3) {
      //Stats
    } else if (selectedSubHeading == 4) {
      //News
    }

    return StreamBuilder<QuerySnapshot>(
      stream: homequery,
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasError) return new Text('Error: ${snapshot.error}');
        switch (snapshot.connectionState) {
          case ConnectionState.waiting:
            return new Text('Loading...');
          default:
            return new ListView(
              children: snapshot.data.docs.map((DocumentSnapshot document) {
                return LineupDetails(document.data(), awayId, "away");
              }).toList(),
            );
        }
      },
    );
  }

  Widget LineupDetails(Map<dynamic, dynamic> lineUp, int teamid, homeaway) {
    final NavigationService _navigationService = locator<NavigationService>();
    Map<dynamic, dynamic> Team = lineUp['team'];
    String Formation = lineUp['formation'];
    int fixtureteamId = lineUp['team']['id'];
    // print("Team: " + Team.toString());
    // print("Fixture Team: " + fixtureteamId.toString());
    // print("HomeTeamId: " + teamid.toString());

    if (fixtureteamId == teamid) {
      return Container(
        padding: EdgeInsets.all(0),
        child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [TeamFormationWidget(lineUp, homeaway)]),
      );
    }
  }

  Widget TeamFormationWidget(
      Map<dynamic, dynamic> lineUp, String homeOrAwayTeam) {
    bool isHome = homeOrAwayTeam == 'home';
    String formation = lineUp['formation'];
    String manager = lineUp['coach']['name'];
    int numRows = formation.allMatches("-").length +
        1; //Rows is goalie  e.g. 4-3-3 o 4-2-3-1
    List<dynamic> lineUpList = lineUp['startXI'];
    List<dynamic> GoalKeeperList =
        lineUpList.where((p) => p['pos'] == "G").toList();
    List<dynamic> DefenderList =
        lineUpList.where((p) => p['pos'] == "D").toList();
    List<dynamic> MidfieldList =
        lineUpList.where((p) => p['pos'] == "M").toList();
    List<dynamic> ForwardList =
        lineUpList.where((p) => p['pos'] == "F").toList();
    final twentyYdBoxWidth = 120.0;
    final twentyYdBoxHeight = 50.0;
    final CentreCircleDia = 120.0;
    final HalfPitchHeight = 200.0;
    final PitchWidth = 300.0;
    final formationHeightPos = 5.0;
    //print("StartXI ---- " + lineUpList.toString());
    // print("Goalkeeper ---- " + GoalKeeperList.toString());
    // print("Defenders ---- " + DefenderList.toString());
    // print("Midfielders ---- " + MidfieldList.toString());
    // print("Forwards ---- " + ForwardList.toString());

    List<String> formationRows = lineUp['formation'].toString().split("-");
    bool midfieldSplit =
        (formationRows.length > 3) && int.parse(formationRows[2]) >= 2;
    bool forwardSplit =
        (formationRows.length > 3) && int.parse(formationRows[2]) < 2;

    int numDefenders = DefenderList.length;

    int numMidfield = (formationRows.length > 3 &&
            MidfieldList.length > int.parse(formationRows[1]))
        ? int.parse(formationRows[1])
        : MidfieldList.length;
    int numMidfield2 = (formationRows.length > 3 &&
            MidfieldList.length > int.parse(formationRows[1]))
        ? int.parse(formationRows[2])
        : 0;
    int numForwards = (formationRows.length > 3 &&
            ForwardList.length >
                int.parse(formationRows[formationRows.length - 1]))
        ? ForwardList.length -
            int.parse(formationRows[formationRows.length - 1])
        : ForwardList.length;
    int numForwards2 = (formationRows.length > 3 &&
            ForwardList.length >
                int.parse(formationRows[formationRows.length - 1]))
        ? int.parse(formationRows[formationRows.length - 1])
        : 0;

    List<dynamic> MidfieldList1 =
        numMidfield2 > 0 ? MidfieldList.sublist(0, numMidfield) : MidfieldList;
    print(MidfieldList1.toString());
    List<dynamic> MidfieldList2 = numMidfield2 > 0
        ? MidfieldList.sublist(numMidfield, MidfieldList.length)
        : null;
    print(MidfieldList2.toString());
    List<dynamic> ForwardList1 =
        numForwards2 > 0 ? ForwardList.sublist(0, numForwards) : ForwardList;
    List<dynamic> ForwardList2 = numForwards2 > 0
        ? ForwardList.sublist(numForwards, ForwardList.length)
        : null;

    //now build up a list of widgets for column
    List<Widget> columnWidgets = [];
    double columnspacing =
        8 - ((numMidfield2 > 0) ? 6.0 : 0.0) - ((numForwards2 > 0) ? 6.0 : 0.0);
    if (isHome) {
      //Home team formation

      columnWidgets.add(PositionRow(GoalKeeperList));
      columnWidgets.add(SizedBox(
        height: columnspacing,
      ));
      columnWidgets.add(PositionRow(DefenderList));
      columnWidgets.add(SizedBox(
        height: columnspacing,
      ));
      columnWidgets.add(PositionRow(MidfieldList1));
      if (numMidfield2 > 0) {
        columnWidgets.add(SizedBox(
          height: columnspacing / 2,
        ));
        columnWidgets.add(PositionRow(MidfieldList2));
      }
      columnWidgets.add(SizedBox(
        height: columnspacing,
      ));
      columnWidgets.add(PositionRow(ForwardList1));
      if (numForwards2 > 0) {
        columnWidgets.add(SizedBox(
          height: columnspacing / 2,
        ));
        columnWidgets.add(PositionRow(ForwardList2));
      }
    } else {
      //reverse order to home
      columnWidgets.add(SizedBox(
        height: columnspacing,
      ));
      if (numForwards2 > 0) {
        columnWidgets.add(PositionRow(ForwardList2));
      }
      columnWidgets.add(PositionRow(ForwardList1));
      columnWidgets.add(SizedBox(
        height: columnspacing,
      ));
      if (numMidfield2 > 0) {
        //columnWidgets.add(SizedBox(height: columnspacing-3,));
        columnWidgets.add(PositionRow(MidfieldList2));
        columnWidgets.add(SizedBox(
          height: columnspacing / 2,
        ));
      }
      columnWidgets.add(PositionRow(MidfieldList1));
      columnWidgets.add(SizedBox(
        height: columnspacing,
      ));
      columnWidgets.add(PositionRow(DefenderList));
      columnWidgets.add(SizedBox(
        height: columnspacing,
      ));
      columnWidgets.add(PositionRow(GoalKeeperList));
    }

    Color pitchColour = Color.fromARGB(255, 44, 179, 163);

    return Stack(children: [
      Container(
        width: PitchWidth,
        height: HalfPitchHeight,
        decoration: BoxDecoration(
          color: Colors.black54,
          border: Border.all(
            color: pitchColour,
            width: 1,
          ),
        ),
      ),
      Positioned(
        left: 5,
        top: (isHome
            ? formationHeightPos
            : HalfPitchHeight - formationHeightPos - 10),
        child: Text(formation, style: positionStyle),
      ),
      Positioned(
        left: (PitchWidth - twentyYdBoxWidth) / 2 + twentyYdBoxWidth + 5,
        top: (isHome
            ? formationHeightPos
            : HalfPitchHeight - formationHeightPos - 10),
        child: Text(manager, style: positionStyle),
      ),
      Positioned(
        left: (PitchWidth - twentyYdBoxWidth) / 2,
        top: (isHome ? 0.0 : HalfPitchHeight - twentyYdBoxHeight),
        child: Container(
          width: twentyYdBoxWidth,
          height: twentyYdBoxHeight,
          decoration: BoxDecoration(
            color: Colors.black54,
            border: Border.all(
              color: pitchColour,
              width: 1,
            ),
          ),
        ),
      ),
      Positioned(
        left: (PitchWidth - CentreCircleDia) / 2,
        top: (isHome
            ? HalfPitchHeight - (CentreCircleDia / 2)
            : -(CentreCircleDia / 2)),
        child: Container(
          width: CentreCircleDia,
          height: CentreCircleDia,
          decoration: BoxDecoration(
            color: Colors.black54,
            border: Border.all(
              color: pitchColour,
              width: 1,
            ),
            borderRadius: BorderRadius.circular(CentreCircleDia / 2),
          ),
        ),
      ),
      Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children:
              columnWidgets /*[
                    SizedBox(height: isHome? 0.0: 12.0,),
                    PositionRow(isHome? GoalKeeperList : ForwardList),
                    SizedBox(height: 12,),
                    PositionRow(isHome? DefenderList: MidfieldList),
                    SizedBox(height: 12,),
                    PositionRow(isHome? MidfieldList: DefenderList ),
                    SizedBox(height: 12,),
                    PositionRow(isHome? ForwardList: GoalKeeperList),
                    
                  ]*/
          )
    ]);
  }

  Widget PositionRow(List<dynamic> positionList) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [for (var position in positionList) PositionWidget(position)],
    );
  }

  Widget PositionWidget(var position) {
    List<String> playFullName = position['name'].toString().split(" ");
    String firstInitial =
        playFullName.length > 1 ? position['name'][0] + ". " : "";
    String firstName = playFullName.length > 1 ? playFullName.removeAt(0) : "";
    String playerName = firstInitial + playFullName.join(" ");
    return PlayerIcon(position['number'].toString(), playerName);
  }

  Widget fixtureDetailsHeader(
      String subHeading, bool isSelected, int subHeadingNum) {
    final TextStyle fixtureDetailsStyle =
        isSelected == true ? cardHeaderHomwAwayHighlight : cardHeaderHomwAway;

    return InkWell(
        child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(subHeading, style: fixtureDetailsStyle),
            ]),
        onTap: () {
          setState(() {
            selectedSubHeading = subHeadingNum;
          });
        });
  }
} //class NextMatchFixture

Widget PlayerIcon(String displayText, String playername) {
  return Column(mainAxisAlignment: MainAxisAlignment.start, children: [
    Stack(
      children: <Widget>[
        new Icon(Icons.brightness_1,
            size: 25.0, color: Color.fromARGB(255, 44, 179, 163)),
        new Positioned(
            top: 3.0,
            right: 7.0,
            child: new Center(
              child: new Text(
                displayText,
                style: playerIconTextStyle,
                textAlign: TextAlign.center,
              ),
            )),
      ],
    ),
    Text(playername, style: positionStyle),
  ]);
}

class CircleButton extends StatelessWidget {
  final GestureTapCallback onTap;
  final String displayText;

  const CircleButton({Key key, this.onTap, this.displayText}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double size = 25.0;

    return new InkResponse(
      onTap: onTap,
      child: new Container(
        width: size,
        height: size,
        decoration: new BoxDecoration(
          color: Colors.cyan,
          shape: BoxShape.circle,
        ),
        child: Text(
          displayText,
          style: positionStyle,
        ),
      ),
    );
  }
}
