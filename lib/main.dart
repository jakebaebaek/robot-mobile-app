import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:lorobot_app/widgets/controlsWidget.dart';
import 'package:lorobot_app/widgets/settingsWidget.dart';
import 'package:lorobot_app/widgets/tasksWidget.dart';
import 'package:lorobot_app/utils/deviceInfo.dart';
import 'package:lorobot_app/utils/constants.dart';

void main() {
  runApp(const LorobotApp());
}

class LorobotApp extends StatelessWidget {
  const LorobotApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(brightness: Brightness.light),
      home: const MainPage(),
    );
  }
}

class MainPage extends StatefulWidget {
  const MainPage({Key? key}) : super(key: key);

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int _gIndex = 0;

  void onTapNavBar(int index) {
    if (_gIndex != index) {
      setState(() => _gIndex = index);
    }
  }

  @override
  Widget build(BuildContext context) {
    DeviceInfo devinfo = DeviceInfo(context: context); // 여기서 context를 전달하여 초기화
    double h = devinfo.height;
    double w = devinfo.width;
    double pr = devinfo.pixelRatio;

    final List<BottomNavigationBarItem> navBarItems = [
      const BottomNavigationBarItem(icon: Icon(CupertinoIcons.game_controller), label: 'Control'),
      const BottomNavigationBarItem(icon: Icon(Icons.checklist), label: 'Operating'),
      const BottomNavigationBarItem(icon: Icon(CupertinoIcons.settings), label: 'Settings'),
    ];

    final List<Widget> screens = [const ControlsWidget(), const TasksWidget(), const SettingsWidget()];

    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(40.0),
        child: AppBar(title: Text(navBarItems[_gIndex].label.toString())),
      ),
      body: IndexedStack(
        index: _gIndex,
        children: screens,
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: navBarItems,
        selectedItemColor: Colors.blue,
        unselectedItemColor: Colors.grey,
        currentIndex: _gIndex,
        onTap: onTapNavBar,
      ),
    );
  }
}


// bottomNavigationBar: CupertinoTabScaffold(
//         tabBar: CupertinoTabBar(items: navBarItems),
//         tabBuilder: (context, index) {
//           gIndex = index;
//           switch (index){
//             case 0:
//               return TasksWidget();
//             case 1: 
//               return ControlsWidget();
//             case 2:
//               return SettingsWidget();
//             default:
//               return TasksWidget();
//           }
//       // })