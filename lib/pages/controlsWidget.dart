import 'dart:developer' as dev;
import 'dart:typed_data';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:dartros_msgs/geometry_msgs/msgs.dart';
import 'package:image/image.dart' as imglib;

import 'package:lorobot_app/assets/joystickWgt.dart' ;
import 'package:lorobot_app/utils/constants.dart';
import 'package:lorobot_app/assets/ros_map_viewer.dart';

import 'package:lorobot_app/utils/ros.dart';

bool debugOffline = false;
double imgSizeModifier = 1.0;
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
  Image? mapimg;
  Uint8List? mapData;

  @override
  void dispose(){
    if(nodehandle != null){
      sysLog.d('나감.');
    }
    super.dispose();
  }

  void stickCallback(double x, double y) {
    setState(() {
      double offsetModi = 10;
      _pos = Offset(_pos.dx + x / offsetModi, _pos.dy + y / offsetModi);

      // 선형 속도 (linear velocity)와 각속도 (angular velocity) 계산
      double linX = (y / 10).clamp(-robotSetting.maxSpd, robotSetting.maxSpd);
      double angZ = x.clamp(-robotSetting.maxAng, robotSetting.maxAng);

      // ROS 메시지 생성: Twist
      Vector3 linear = Vector3(x: -linX, y: 0.0, z: 0.0);
      Vector3 angular = Vector3(x: 0.0, y: 0.0, z: -angZ);
      Twist twist = Twist(linear: linear, angular: angular);

      // 노드 핸들이 null이 아니고, pubVel 퍼블리셔가 설정되어 있는 경우
      if (nodehandle != null && pubVel != null) {
        pubVel!.publish(twist);
      }
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
    // setState((){
    //   // print('x = $x, y = $y, rad = $rad');
    // });
  }
  void onTapCallback(TapUpDetails? details){
    if(details != null){
      var dx = details.localPosition.dx;
      var dy = details.localPosition.dy;
      PoseStamped goalPose = PoseStamped(pose: Pose(position: Point(x:dx, y:dy, z:0)));
      print('${goalPose.pose.position.x}, ${goalPose.pose.position.y}, ${goalPose.pose.position.z}');
      if(pubGoal != null && !(pubGoal!.isShutdown)){
        pubGoal!.publish(goalPose);
        //TODO position match with map on application, quaternion match.
        // quarternion from current robot pose or direction...
      }
    }
  }

  @override
  Widget build(BuildContext context){

    return Scaffold (
      body: Container(
        alignment: Alignment.center,
        child: Column(
          // mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // UI 예시용 사이즈 박스 (이미지 파일만 가져와서 렌더링)
            // SizedBox(
            //   width: MediaQuery.of(context).size.width,
            //   height: MediaQuery.of(context).size.height*0.45,
            //   child : const Image(image: AssetImage('li/assets/images/occumap.png'))b
            // ),
            GestureDetector(
              onTapUp: onTapCallback,
              child: SizedBox(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height * 0.2, // 크기 지정
                child: RosMapViewer(
                  mapTopic: robotSetting.robotMapTopic,
                  odomTopic: robotSetting.robotOdomTopic,
                  tfTopic: robotSetting.robotTfTopic,
                  mapSizeModifier: imgSizeModifier,
                  posCallback: callbackListener,
                ),
              ),
            ),
            SizedBox(
              width: MediaQuery.of(context).size.width*0.8,
              height: 50,
              child: Slider.adaptive(value: imgSizeModifier,
                onChanged: (value) {
                  setState(() {
                    imgSizeModifier = value;
                    print(imgSizeModifier);
                  });
                },
                min: 0.5, max: 3.0, label: imgSizeModifier.toString(),),
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