import 'package:flutter/material.dart';

class Fixture {
  final int fixtureId;
  final String eventDate;
  final Map<dynamic, dynamic> awayTeam;
  final Map<dynamic, dynamic> homeTeam;
  final int goalsHomeTeam;
  final int goalsAwayTeam;
  final int leagueId;

  Fixture({this.fixtureId, this.eventDate, this.homeTeam, this.awayTeam, this.goalsHomeTeam, this.goalsAwayTeam, this.leagueId});

  Fixture.fromData(Map<String, dynamic> data)
      : fixtureId = data['fixture_id'],
        eventDate = data['eventDate'],
        homeTeam = data['homeTeam'],
        awayTeam = data['awayTeam'],
        goalsHomeTeam = data['goalsHomeTeam'],
        goalsAwayTeam = data['goalsAwayTeam'],
        leagueId = data['league_id'];

  Map<String, dynamic> toJson() {
    return {
      'fixture_id': fixtureId,
      'eventDate': eventDate,
      'homeTeam': homeTeam,
      'awayTeam': awayTeam,
      'goalsHomeTeam': goalsHomeTeam,
      'goalsAwayTeam': goalsAwayTeam,
      'league_id': leagueId,
    };
  }

//NOT USED: ANOTHER WAY TO GET Fixture class filled from retrieved data
  static Fixture fromMap(Map<String, dynamic> data) {
    if (data == null) return null;

    return Fixture (
      fixtureId :data['fixture_id'],
        eventDate : data['eventDate'],
        homeTeam : data['homeTeam'],
        awayTeam : data['awayTeam'],
//        goalsHomeTeam : data['goalsHomeTeam'] , 
//        goalsAwayTeam : data['goalsAwayTeam'] ,
        leagueId : data['league_id'],
    );
  }
}
