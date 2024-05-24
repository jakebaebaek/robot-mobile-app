import 'dart:io';

import 'package:logger/logger.dart' as log;

import 'package:dartros/dartros.dart';
import 'package:dartros_msgs/geometry_msgs/msgs.dart';
import 'package:dartros_msgs/nav_msgs/msgs.dart';

import 'package:lorobot_app/utils/device_info.dart';
import 'package:lorobot_app/utils/ros.dart';


enum WheelDirections {lprp, lprm, lmrp, lmrm}
enum WhenObstacleDetects {avoid, stop}

String kVersion = '0.0.1+';
String kModelName = 'HIBOT';
String defaultNodeName = kModelName;
log.Logger sysLog = log.Logger();
RosHandler rh = RosHandler();
NodeHandle? nodehandle;
Publisher<Twist>? pubVel;
Publisher<PoseStamped>? pubGoal;
Subscriber<OccupancyGrid>? subImg;
double defaultMaxSpd = 0.5; // this value will be from robot configuration file.
double defaultMaxAng = 0.3;
InternetAddress? serverIp;
bool inverseMap = false;
DeviceInfo? devinfo;

final Map wheelDirectionInfos = {
  'title': ['Left+ Right+', 'Left+ Right-', 'Left- Right+', 'Left- Right-'],
  'value': [WheelDirections.lprp, WheelDirections.lprm, WheelDirections.lmrp, WheelDirections.lmrm],
};

final Map obstacleRadioInfos = {
  'title': ['avoid', 'stop'],
  'value': [WhenObstacleDetects.avoid, WhenObstacleDetects.stop],
};

class RobotSettings{
  double maxSpd = defaultMaxSpd;
  double maxAng = defaultMaxAng;
  String robotOdomTopic = '/odom';
  String robotMapTopic = '/map';
  String robotTfTopic = '/tf';

  Map radioOptions = {
    WhenObstacleDetects: WhenObstacleDetects.avoid,
    WheelDirections: WheelDirections.lprp,
  };
}

RobotSettings robotSetting = RobotSettings();
// WheelDirections configDirection;