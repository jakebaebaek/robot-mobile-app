import 'package:flutter/material.dart';

enum WhenObstacleDetects {avoid, stop}
enum Examples {exam, ples}

class ConfigureWidget extends StatefulWidget{
  const ConfigureWidget({super.key});
  // const ConfigureWidget({Key? key});
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
  } //generic also good, but should be seperated for operating each action. or just swithching by object.

  @override
  Widget build(BuildContext context){
    return Column(
        children: [
          Container(
            padding: const EdgeInsets.only(top: 15),
            child: Column(
              children: [
                Text("Obstacle Settings"),
                singleRadioBtnMaker<WhenObstacleDetects>(obstacleRadioInfos, radioInfos, 0),
                singleRadioBtnMaker<WhenObstacleDetects>(obstacleRadioInfos, radioInfos, 1),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.only(top: 15),
            child: Column(
              children: [
                Text("Examples"),
                singleRadioBtnMaker<Examples>(exampleInfos, radioInfos, 0),
                singleRadioBtnMaker<Examples>(exampleInfos, radioInfos, 1),
              ],
            ),
          ),
        ]
    );
  }

  Widget singleRadioBtnMaker<obj>(Map radioInfos, groupValue, index){
    late Widget radio;

    radio =RadioListTile<obj>(
      title: Text(radioInfos['title'][index]),
      groupValue: groupValue[obj],
      value: radioInfos['value'][index],
      onChanged:(value) {
        _genericRadioCallback(value, groupValue);
      },
    );
    
    return radio;
  }
  // List<Widget> radioBtnMaker(Map radioInfos, groupValue, onChanged){
  //   List<Widget> radios = [];
  //   for(int i = 0; i < radioInfos.length; i++){
  //     radios.add(
  //       RadioListTile<WhenObstacleDetects>(
  //         title: Text(radioInfos['title'][i]),
  //         groupValue: groupValue,
  //         value: radioInfos['value'][i],
  //         onChanged: onChanged,
  //       )
  //     );
  //   }
  //   log('$radios');
  //   return radios;
  // }
}