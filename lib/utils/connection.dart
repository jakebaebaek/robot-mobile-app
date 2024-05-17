import 'package:flutter/material.dart';
import 'package:dartros/dartros.dart';
import 'package:sensor_msgs/msgs.dart';

class ConnectionService {
  void connectToRos(String deviceIp, String robotIp) async {
    try {
      final nodeHandle = await initNode(
        'my_ros_node',
        [],
        rosMasterUri: 'http://$robotIp:11311',
      );
      // 연결 성공 시 알림
      print('연결 성공');
      // 또는 앱 화면에 상태 업데이트
      setState(() {
        _connectionStatus = 'Connected';
      });
    } catch (e) {
      // 연결 실패 시 알림
      print('연결 실패: $e');
      setState(() {
        _connectionStatus = 'Failed to connect';
      });
    }
  }

    // Future<void> connectToRos(String robotIP) async {
    //   nh = await initNode('ros_node_1', [], masterUri: 'http://$robotIP:11311');
    //   imgPublisher = nh.advertise<Image>('/robot/head_display', Image.$prototype);
    // }

    Future<void> connectToRos(String robotIP) async {
      nh =
      await initNode('my_ros_node', [], rosMasterUri: '$robotIP:11311');
      print('연결성공')
      setState(() {

      });
    }


    //connectRMS
    // var wdt = toString();
    // var txt = rTxt ?? _textEditingController.text;
    // log(txt);
    // for(var matched in regexp.allMatches(txt)){
    //   log('$wdt got groupt ${matched.groupCount}');
    //   l  og('$wdt matched ${matched[0]}');
    // }
    // rh = R_connectRososHandler.withUri(defaultNodeName, 'http://$txt:11311/', []);
    // ('http://$txt:11311/');


}
