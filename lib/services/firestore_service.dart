import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fsproj/models/user.dart';
import 'package:fsproj/models/fixtures.dart';

FirebaseFirestore firestore = FirebaseFirestore.instance;

class FirestoreService {
  final CollectionReference _usersCollectionReference =
      FirebaseFirestore.instance.collection('Users');
  final CollectionReference _teamsCollectionReference =
      FirebaseFirestore.instance.collection('Teams');
  final CollectionReference _fixturesCollectionReference =
      FirebaseFirestore.instance.collection('Fixtures');

  Future createUser(AUser user) async {
    try {
      await _usersCollectionReference.doc(user.id).set(user.toJson());
    } catch (e) {
      return e.message;
    }
  }

  Future getUser(String uid) async {
    try {
      var userData = await _usersCollectionReference.doc(uid).get();
      return AUser.fromData(userData.data());
    } catch (e) {
      return AUser();
    }
  }

  Future getFixtures() async {
    /*var fixtureData = await _fixturesCollectionReference.where("eventDate", isGreaterThan: "2020-07-05").where("eventDate", isLessThan: "2020-07-08").snapshots() ;
      return Fixture.fromData(fixtureData.data);
    } catch (e) {
      return User();
    }*/
  }

//NOT USED AT THE MOMENT: UFOR REFERENCE
  Future getMyTeamNextFixture(String teamname) async {
    try {
      var fixtureDocumentSnapshot = _fixturesCollectionReference
          .where("event_date", isGreaterThan: "2020-07-07T00:00:00")
          .where("event_date", isLessThan: "2020-07-11T23:59:59")
          .where("homeTeam.team_name", isEqualTo: teamname)
          .snapshots()
          .listen(
              (data) => data.docs.forEach((doc) => print(doc["league_id"])));
    } catch (e) {
      print("Errored: getMyTeamNextFixture" + e.toString());
      return null;
    }
  }

  Future<List<String>> getTeams(var pattern) async {
    if (pattern.length <= 1) {
      return null;
    }
    try {
      var strlength = pattern.length;
      // print("pattern: " + pattern);
      //print("strFrontCode:  $strlength");
      var strFirstLetter = pattern.substring(0, 1).toUpperCase();
      // print("strFirstLetter: $strFirstLetter");
      var strFrontCode = strFirstLetter + pattern.substring(1, strlength - 1);
      // print("strFrontCode: $strFrontCode");
      var strEndCode = pattern.substring(strlength - 1, pattern.length);
      // print("strEndCode: $strEndCode");
      var endCode =
          strFrontCode + String.fromCharCode(strEndCode.codeUnitAt(0) + 1);
      // print("EndCode: $endCode");

      var patternWithFirstCap =
          strFirstLetter + pattern.substring(1, strlength);
      //  print("patternWithFirstCap: $patternWithFirstCap");

      return await FirebaseFirestore.instance
          .collection('Teams')
          .where('team.name', isGreaterThanOrEqualTo: patternWithFirstCap)
          .where('team.name', isLessThan: endCode)
          .get()
          .then((QuerySnapshot querySnapshot) {
        List<String> list = querySnapshot.docs.map((DocumentSnapshot doc) {
          //print("Team Returned: ");
          //  print(doc["team"]["country"]);
          return doc["team"]["name"].toString();
        }).toList();

        print("List: $list");
        return list;
      });
    } catch (e) {
      List<String> suggestions = [
        "Error",
      ];
      return suggestions;
    }
  }
}
