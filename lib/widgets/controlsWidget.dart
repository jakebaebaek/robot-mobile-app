import 'dart:developer' as dev;

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:dartros/dartros.dart';
import 'package:flutter_joystick/flutter_joystick.dart';
import 'package:geometry_msgs/msgs.dart';

import 'package:lorobot_app/assets/joystickWgt.dart' ;
import 'package:lorobot_app/assets/slider/sliderWgt.dart';
import 'package:lorobot_app/utils/constants.dart';
import 'package:lorobot_app/utils/ros.dart';
import 'dart:typed_data';

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
  void callbackListener(double x, double y, double rad){
    setState((){
      // print('x = $x, y = $y, rad = $rad');
    });
  }
  // void onTapCallback(TapUpDetails? details){
  //   if(details != null){
  //     var dx = details.localPosition.dx;
  //     var dy = details.localPosition.dy;
  //     PoseStamped goalPose = PoseStamped(pose: Pose(position: Point(x:dx, y:dy, z:0)));
  //     print('${goalPose.pose.position.x}, ${goalPose.pose.position.y}, ${goalPose.pose.position.z}');
  //     if(pubGoal != null && !(pubGoal!.isShutdown)){
  //       pubGoal!.publish(goalPose);
  //       //TODO position match with map on application, quaternion match.
  //       // quarternion from current robot pose or direction...
  //     }
  //   }
  // }
  @override
  Widget build(BuildContext context){
    return Scaffold (
      body: Container(
        alignment: Alignment.center,
        child: Column(
          // mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height*0.45,
              child : const Image(image: AssetImage('lib/assets/images/occumap.png'))
            ),
            SizedBox(
              width: MediaQuery.of(context).size.width*0.8,
              height: 50,
              child: const SliderExample(),
            ),
            Container(
              decoration: BoxDecoration(
                border: Border.all(
                  color: Colors.black,
                  width: 2,
                ),
                borderRadius: BorderRadius.circular(30),
              ),
              child:  SizedBox(
                width: MediaQuery.of(context).size.width,
                height: 197,
                child : JoyStick(listener: stickCallback),
              ),
            )
          ], // Children
        ),
      ),
    );
  }
}