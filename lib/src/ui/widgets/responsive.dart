import 'package:flutter/material.dart';

class Responsive {
  static bool isLargeScreen(BuildContext context) =>
      MediaQuery.of(context).size.width >= 800;
  static bool isMediumScreen(BuildContext context) =>
      MediaQuery.of(context).size.width >= 600 &&
      MediaQuery.of(context).size.width < 800;
  static bool isSmallScreen(BuildContext context) =>
      MediaQuery.of(context).size.width < 600;

  static double carouselHeight(BuildContext context) =>
      isLargeScreen(context) ? 450 : 250;

  static double carouselAspectRatio(BuildContext context) =>
      isLargeScreen(context) ? 16 / 9 : 4 / 3;
}
