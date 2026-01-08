class AppBreakpoints {
  static const double mobile = 600.0;
  static const double tablet = 840.0;
  static const double desktop = 1000.0;
}

class AppResponsive {
  static bool isMobile(double width) => width < AppBreakpoints.mobile;

  static bool isTablet(double width) =>
      width < AppBreakpoints.tablet && width >= AppBreakpoints.mobile;

  static bool isDesktop(double width) => width >= AppBreakpoints.desktop;
}
