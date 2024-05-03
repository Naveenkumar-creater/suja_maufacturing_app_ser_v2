import 'package:flutter/material.dart';
import 'package:suja/constant/responsive/tablet_body.dart';

import '../../../constant/responsive/desktop_body.dart';
import '../../../constant/responsive/mobile_body.dart';
import '../../../constant/responsive/responsive_layout.dart';


class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return ResponsiveLayout(
        mobileBody: const MobileScaffold(),
        tabletBody: const ResponsiveTabletHomepage(),
        desktopBody: const DesktopScaffold(),
      );
  }
}