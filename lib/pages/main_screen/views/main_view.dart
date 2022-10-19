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
          SafeArea(child: MainView()),
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
            children: const [
              AnimatedSidebar(),
              Expanded(child: PuzzleView()),
            ],
          ),
        );
      },
    );
  }
}

class AnimatedSidebar extends StatefulWidget {
  const AnimatedSidebar({Key? key}) : super(key: key);

  @override
  State<AnimatedSidebar> createState() => _AnimatedSidebarState();
}

class _AnimatedSidebarState extends State<AnimatedSidebar> {
  bool show = false;
  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    if (!show) {
      Future.delayed(const Duration(seconds: 2), () {
        setState(() {
          show = true;
        });
      });
    }
    final offset = mainAxis(width) == Axis.vertical
        ? const Offset(0, -1)
        : const Offset(-1, 0);
    return SizedBox(
      width: crossAxis(width) == Axis.vertical ? 260 : double.infinity,
      height: mainAxis(width) == Axis.vertical ? 150 : double.infinity,
      child: AnimatedSwitcher(
        duration: const Duration(seconds: 1),
        switchInCurve: Curves.elasticOut,
        transitionBuilder: (child, animation) {
          return SlideTransition(
            position: Tween<Offset>(begin: offset, end: Offset.zero)
                .animate(animation),
            child: child,
          );
        },
        child: show ? SidebarView(crossAxis(width)) : const SizedBox.shrink(),
      ),
    );
  }
}
