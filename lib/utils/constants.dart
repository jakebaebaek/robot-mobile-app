import 'package:logger/logger.dart';

import 'package:lorobot_app/utils/ros.dart';

String kVersion = '0.0.1';
String kModelName = 'Lorobot';
String defaultNodeName = kModelName;
var sysLog = Logger();
RosHandler rh = RosHandler();
late final node;