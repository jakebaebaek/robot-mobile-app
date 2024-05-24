import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:lorobot_app/assets/slider/sliderWgt.dart';
import 'package:lorobot_app/pages/modulewidgets/IPInputFeild.dart';

enum WhenObstacleDetects {avoid, stop}
enum Examples {exam, ples}

class ConfigureWidget extends StatefulWidget {
  const ConfigureWidget({super.key});

  @override
  State<ConfigureWidget> createState() => _ConfigureWidget();
}

class _ConfigureWidget extends State<ConfigureWidget>{

  final Map obstacleRadioInfos = {
    'title': ['avoid', 'stop'],
    'value': [WhenObstacleDetects.avoid, WhenObstacleDetects.stop],
  };

  final Map exampleInfos = {
    'title': ['exam', 'ples'],
    'value': [Examples.exam, Examples.ples],
  };

  late WhenObstacleDetects? _configDetection;
  late Examples? _examples;

  @override
  void initState(){
    super.initState();
    _configDetection = WhenObstacleDetects.avoid;
    _examples = Examples.exam;
  }

  late Map radioInfos = {
    WhenObstacleDetects: _configDetection,
    Examples: _examples,
  };

  void _genericRadioCallback<obj>(obj? value, gValue){
    setState(() {
      gValue[obj] = value;
      switch(obj){
        case WhenObstacleDetects:
          break;
        case Examples:
          break;
        default:
          break;
      }
    });
  }

  @override
  Widget build(BuildContext context){
    return SingleChildScrollView(
      child: Column(
          children: [
            Column(
                children: [
                  Text('Max Speed'),
                  Padding(padding: EdgeInsets.all(3.0),
                    child: const SliderExample(),
                  ),
                ]
            ),
            Column(
                children: [
                  Text('Max Angular'),
                  Padding(padding: EdgeInsets.all(3.0),
                    child: const SliderExample(),
                  ),
                ]
            ),
            Container(
              child: Column(
                children: [
                  Text("Obstacle Settings"),
                  singleRadioBtnMaker<WhenObstacleDetects>(obstacleRadioInfos, radioInfos, 0),
                  singleRadioBtnMaker<WhenObstacleDetects>(obstacleRadioInfos, radioInfos, 1),
                ],
              ),
            ),
            Container(
              child: const WheelDirectionSetting(),
            ),
            SizedBox(
              child: Column(
                children: [
                  const Text(
                    style: TextStyle(fontSize: 17),
                    'Topic Setting',
                  ),
                  UnderlineInput(TextKey:ValueKey('MapTopic'),HintText:'MAP Topic ',TextonTop: 'Map Topic'),
                  UnderlineInput(TextKey:ValueKey('TfTopic'),HintText:'TF Topic ',TextonTop: 'TF Topic'),
                  UnderlineInput(TextKey:ValueKey('OdomTopic'),HintText:'Odom Topic ',TextonTop: 'Odom Topic'),
                ],
              ),
            )
          ]
      ),
    );
  }

  Widget singleRadioBtnMaker<obj>(Map radioInfos, groupValue, index){
    return RadioListTile<obj>(
      title: Text(radioInfos['title'][index]),
      groupValue: groupValue[obj],
      value: radioInfos['value'][index],
      onChanged:(value) {
        _genericRadioCallback(value, groupValue);
      },
    );
  }
}

class WheelDirectionSetting extends StatefulWidget {
  const WheelDirectionSetting({Key? key}) : super(key: key);

  @override
  _WheelDirectionSettingState createState() => _WheelDirectionSettingState();
}

class _WheelDirectionSettingState extends State<WheelDirectionSetting> {
  bool _leftDirection = false;
  bool _rightDirection = false;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        width: MediaQuery.of(context).size.width * 0.95, // Container width 제한
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.black),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'Wheel Direction Setting',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Expanded(
                  child: _buildDirectionControl('Left', _leftDirection, (value) {
                    setState(() {
                      _leftDirection = value;
                    });
                  }),
                ),
                const VerticalDivider(
                  color: Colors.black,
                  thickness: 1,
                ),
                Expanded(
                  child: _buildDirectionControl('Right', _rightDirection, (value) {
                    setState(() {
                      _rightDirection = value;
                    });
                  }),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDirectionControl(
      String label, bool direction, ValueChanged<bool> onChanged) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(label),
        const SizedBox(height: 10),
        Row(
          mainAxisSize: MainAxisSize.min, // Row 의 크기를 최소화
          mainAxisAlignment: MainAxisAlignment.center, // 중앙 정렬
          children: [
            SizedBox(
              width: 40, // 아이콘 버튼의 고정 너비
              child: IconButton(
                icon: const Icon(Icons.add),
                onPressed: () {
                  // Add functionality here
                },
              ),
            ),
            SizedBox(
              width: 60, // 스위치의 고정 너비
              child: Switch(
                value: direction,
                onChanged: onChanged,
              ),
            ),
            SizedBox(
              width: 40, // 아이콘 버튼의 고정 너비
              child: IconButton(
                icon: const Icon(Icons.remove),
                onPressed: () {
                  // Remove functionality here
                },
              ),
            ),
          ],
        ),
      ],
    );
  }
}
