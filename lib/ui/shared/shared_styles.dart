import 'package:flutter/material.dart';

// Box Decorations

BoxDecoration fieldDecortaion = BoxDecoration(
    borderRadius: BorderRadius.circular(5), color: Colors.grey[200]);

BoxDecoration disabledFieldDecortaion = BoxDecoration(
    borderRadius: BorderRadius.circular(5), color: Colors.grey[100]);

// Field Variables

const double fieldHeight = 55;
const double smallFieldHeight = 40;
const double inputFieldBottomMargin = 30;
const double inputFieldSmallBottomMargin = 0;
const EdgeInsets fieldPadding = const EdgeInsets.symmetric(horizontal: 15);
const EdgeInsets largeFieldPadding =
    const EdgeInsets.symmetric(horizontal: 15, vertical: 15);

// Text Variables
const TextStyle buttonTitleTextStyle =
    const TextStyle(fontWeight: FontWeight.w700, color: Colors.white);

const ShapeBorder cardShapeBorder = const RoundedRectangleBorder(
    borderRadius: BorderRadius.all(Radius.circular(5)));
const TextStyle cardStyleDate =
    const TextStyle(fontSize: 8, color: Colors.cyan);
const TextStyle cardStyleToday =
    const TextStyle(fontSize: 8, color: Colors.white);
const TextStyle cardHeader = const TextStyle(fontSize: 14, color: Colors.white);
const TextStyle cardHeaderHomwAwayHighlight = const TextStyle(
    fontSize: 14, color: Colors.white, fontWeight: FontWeight.bold);
const TextStyle cardHeaderHomwAway = const TextStyle(
    fontSize: 14,
    color: Color.fromARGB(255, 44, 179, 163),
    fontWeight: FontWeight.bold);
const TextStyle cardSubHeader = const TextStyle(
    fontSize: 16, color: Colors.white, fontWeight: FontWeight.bold);
const TextStyle cardStyleFixture =
    const TextStyle(fontSize: 9, color: Colors.white);
const TextStyle cardFixtureText = const TextStyle(
    fontSize: 9, color: Colors.white, fontStyle: FontStyle.italic);
const TextStyle positionStyle =
    const TextStyle(fontSize: 9, color: Colors.white);

const TextStyle playerIconTextStyle = const TextStyle(
    color: Colors.white, fontSize: 11.0, fontWeight: FontWeight.w500);
