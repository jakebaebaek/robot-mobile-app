// lib/widgets/settings/connection_widget.dart
import 'package:dartros/dartros.dart';
import 'package:flutter/material.dart';
import 'package:lorobot_app/utils/connection.dart';
import 'package:lorobot_app/widgets/modulewidgets/IPInputFeild.dart'; // IPInputField import
import 'package:dartros/dartros.dart' as dartros;
import 'package:sensor_msgs/msgs.dart' as sensor_msgs;


class UnderlinedBotton extends StatelessWidget {
  final String deviceIP;
  final String robotIP;


  UnderlinedBotton({required this.deviceIP, required this.robotIP});

  Future<void> connectToRos(String deviceIP, String robotIP) async {
    final nh = await dartros.initNode('ros_node_1', [], rosMasterUri: 'http://$robotIP:11311');
    final pub = nh.advertise<sensor_msgs.Image>('/robot/head_display', sensor_msgs.Image.$prototype);

    final imgMsg = sensor_msgs.Image(
      header: null,
      height: 600,
      width: 1024,
      encoding: 'rgba8',
      is_bigendian: 0,
      step: 1024 * 4,
      data: List.generate(600 * 1024 * 4, (_) => 255),
    );

    pub.publish(imgMsg);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(3.0),
      child: OutlinedButton(
        style: OutlinedButton.styleFrom(
          padding: EdgeInsets.symmetric(horizontal: 60, vertical: 20),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
            side: BorderSide(color: Colors.blue, width: 2),
          ),
        ),
        onPressed: () {
          connectToRos(deviceIP, robotIP);
        },
        child: const Text(
          style: TextStyle(fontSize: 30),
          'Connect🐱',
        ),
      ),
    );
  }
}

