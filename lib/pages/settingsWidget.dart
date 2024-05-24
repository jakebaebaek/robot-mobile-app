  import 'dart:developer';

  import 'package:flutter/cupertino.dart';
  import 'package:flutter/material.dart';
  import 'package:lorobot_app/pages/settings/body/configure.dart';
  import 'package:lorobot_app/pages/settings/body/information.dart';
  import 'package:lorobot_app/pages/settings/body/map.dart';
  import 'package:lorobot_app/pages/settings/body/network.dart';

  class SettingsWidget extends StatefulWidget{
    const SettingsWidget({super.key});

    @override
    State<SettingsWidget> createState() => _SettingsWidget();
  }

  class ContentScreen extends StatefulWidget {
    final int selectedIndex;

    const ContentScreen({Key? key, required this.selectedIndex}) : super(key: key);

    @override
    _ContentScreenState createState() => _ContentScreenState();
  }

  class _ContentScreenState extends State<ContentScreen> {
    final List<Widget> _screens = [
      const ConfigureWidget(),
      const NetworkWidget(),
      const MapWidget(),
      const InformationWidget(),
    ];
    @override
    Widget build(BuildContext context) {
      return Scaffold(
        body: _screens[widget.selectedIndex],
      );
    }
  }

  class _SettingsWidget extends State<SettingsWidget> {
    final List<NavigationRailDestination> navBarItems = [
      const NavigationRailDestination(icon: Icon(CupertinoIcons.gear), label: Text('Configure')),
      const NavigationRailDestination(icon: Icon(CupertinoIcons.wifi), label: Text('Network')),
      const NavigationRailDestination(icon: Icon(CupertinoIcons.map), label: Text('Map')),
      const NavigationRailDestination(icon: Icon(CupertinoIcons.info), label: Text('Info')),
    ];
    int _selectedIndex = 0;




    void onSelected(int index) {
      if (_selectedIndex != index) {
        _selectedIndex = index;
        setState(() {
          var wdt = toString();
          log('[$wdt] Index Selected $index');
        });
      }
    }


    @override
    Widget build(BuildContext context){
      double width = MediaQuery.of(context).size.width;
      return Scaffold(
        body: Row(
          children: [
            NavigationRail(
              labelType: NavigationRailLabelType.all,
              groupAlignment: -1.0,
              selectedIndex: _selectedIndex,
              destinations: navBarItems,
              onDestinationSelected: onSelected,
            ),
            Flexible(
              child: ContentScreen(selectedIndex: _selectedIndex),
            )
          ],
        ),
      );
    }
  }




