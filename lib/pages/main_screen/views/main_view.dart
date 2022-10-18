import 'package:flutter/material.dart';

import '../../../helpers/locator.dart';
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
    return Scaffold(
      drawer: const Drawer(
        child: SettingsSection(),
      ),
      drawerScrimColor: Colors.transparent,
      onDrawerChanged: (v) {
        if (!v) {
          final con = locator<PuzzleController>();
          con.tiles.refresh();
          FocusScope.of(context).requestFocus(con.focusNode);
        }
      },
      backgroundColor: Colors.black,
      body: Stack(
        children: const [
          RepaintBoundary(child: Background()),
          MainView(),
        ],
      ),
    );
  }
}

class MainView extends StatelessWidget {
  const MainView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (c, box) {
        final width = MediaQuery.of(c).size.width;
        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: Flex(
            direction: mainAxis(width),
            children: [
              ConstrainedBox(
                constraints: BoxConstraints(
                  maxWidth:
                      crossAxis(width) == Axis.vertical ? 250 : double.infinity,
                  maxHeight:
                      mainAxis(width) == Axis.vertical ? 100 : double.infinity,
                ),
                child: SidebarView(crossAxis(width)),
              ),
              const Expanded(child: PuzzleView()),
            ],
          ),
        );
      },
    );
  }
}
