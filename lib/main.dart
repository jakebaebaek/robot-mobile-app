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


  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(brightness:  Brightness.light),
      home: const MainPage(),
    );
  }
}

class MainPage extends StatefulWidget {
  const MainPage({Key? key}) : super(key: key);
  @override
  State<MainPage> createState() => _LorobotApp();
}

class _LorobotApp extends State<MainPage> {
  int _gIndex = 0;

  void onTapNavBar(int index){
    setState(() {
      _gIndex = index;
    });
  }

  @override
  Widget build(BuildContext context){
    DeviceInfo devinfo = DeviceInfo(context: context);
    double h = devinfo.height;
    double w = devinfo.width;
    double pr = devinfo.pixelRatio;
    // sysLog.d('DeviceInformation Height $h');
    // sysLog.d('DeviceInformation Width $w');
    // sysLog.d('DeviceInformation pixel ratio $pr');
    // sysLog.d('DeviceInformation prHeight ${h*pr}');
    // sysLog.d('DeviceInformation prWidth ${w*pr}');
    //TODO pixel ratio * (height || width) 를 기준으로 ui 배치하기.
    final List<BottomNavigationBarItem> navBarItems = [
      const BottomNavigationBarItem(icon: Icon(CupertinoIcons.game_controller), label: 'Control'),
      // arrow_2_squarepath
      const BottomNavigationBarItem(icon: Icon(Icons.checklist), label: 'Operating'),
      const BottomNavigationBarItem(icon: Icon(CupertinoIcons.settings), label: 'Settings'),
    ];
    final List<Widget> screens = [const ControlsWidget(), const TasksWidget(), const SettingsWidget()];

    return Scaffold(
      appBar: AppBar(title: Text(navBarItems.elementAt(_gIndex).label.toString())),
      body: screens[_gIndex],
      bottomNavigationBar: BottomNavigationBar(
        items: navBarItems,
        selectedItemColor: Colors.blue,
        unselectedItemColor: Colors.grey,
        useLegacyColorScheme: false,
        currentIndex: _gIndex,
        onTap: onTapNavBar,
      )
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