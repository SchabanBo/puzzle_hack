import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/main_controller.dart';
import '../controllers/puzzle_controller.dart';
import 'backgrounds/background.dart';
import 'puzzle/puzzle_view.dart';
import 'sidebar/constants.dart';
import 'sidebar/setting_section.dart';
import 'sidebar/sidebar_view.dart';

class MainScreen extends StatelessWidget {
  const MainScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetBuilder<MainController>(
      init: MainController(),
      builder: (c) => Scaffold(
          drawer: const Drawer(
            child: SettingsSection(),
          ),
          drawerScrimColor: Colors.transparent,
          onDrawerChanged: (v) {
            if (!v) {
              final con = Get.find<PuzzleController>();
              con.tiles.refresh();
              FocusScope.of(context).requestFocus(con.focusNode);
            }
          },
          backgroundColor: Colors.black,
          body: Stack(
            children: [
              const RepaintBoundary(child: Background()),
              MainView(),
            ],
          )),
    );
  }
}

class MainView extends GetResponsiveView<MainController> {
  MainView({Key? key}) : super(key: key);

  @override
  Widget? builder() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Flex(direction: mainAxis(screen.width), children: [
        ConstrainedBox(
            constraints: BoxConstraints(
              maxWidth: crossAxis(screen.width) == Axis.vertical
                  ? 250
                  : double.infinity,
              maxHeight: mainAxis(screen.width) == Axis.vertical
                  ? 100
                  : double.infinity,
            ),
            child: SidebarView(crossAxis(screen.width))),
        const Expanded(child: PuzzleView()),
      ]),
    );
  }
}
