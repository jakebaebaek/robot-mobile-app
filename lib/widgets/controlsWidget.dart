import 'dart:developer' as dev;

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:dartros/dartros.dart';
import 'package:geometry_msgs/msgs.dart';

import 'package:lorobot_app/assets/joystickWgt.dart';
import 'package:lorobot_app/utils/constants.dart';
import 'package:lorobot_app/utils/ros.dart';


class ControlsWidget extends StatefulWidget {
  const ControlsWidget({super.key});

  @override
  _ControlsWidget createState() => _ControlsWidget();
  
}

class _ControlsWidget extends State<ControlsWidget>{
  
  late String imgSrc; //should be get throu rosbridge or smth via setting
  bool isTapped = false;
  late Offset offset;
  Offset _pos = const Offset(0, 0);

  void stickCallback(double x, double y) {
    //TODO implement ROS /cmd_vel
    setState(() {
      double offsetModi = 10;
      dev.log('controlwidget callback x => $x and y $y');
      _pos = Offset(_pos.dx + x/offsetModi, _pos.dy + y/offsetModi);
      sysLog.i('x: $x, y: $y, dx: ${_pos.dx}, dy: ${_pos.dy}'); 
      //x,y for cmd_vel, dx, dy for total move.
      //anyways, dx dy doesn't need at least now.
      Vector3 linear = Vector3(x: y);
      Vector3 angular = Vector3(z: x);
      Twist twist = Twist(linear: linear, angular: angular);
      if(rh.nh is NodeHandle){
        Publisher pub = rh.nh.advertise<Twist>('cmd_vel', Twist());
        pub.publish(twist);
      }
      //좀 정리가 필요할듯;;
    });
  }
  void showJoyStick(downDetails){
    setState(() {
      offset = downDetails.localPosition;
      dev.log('controlwidget callback $offset');
      isTapped = true;
    });
  }
  void hideJoyStick(details){
    setState(() {
      isTapped = false;
    });
  }

  @override
  Widget build(BuildContext context){
    return Stack(
        children: [
          const Image(image: AssetImage('lib/assets/images/occumap.png'),),
          JoyStick(listener: stickCallback,),
          Text("Current $_pos"),
        ],
    );
  }
}