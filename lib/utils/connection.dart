import 'package:dartros/dartros.dart';

class ConnectionService {
  Function(String)? onStatusChanged;

  Future<void> connectToRos(String deviceIp, String robotIp) async {
    if (deviceIp.isEmpty || robotIp.isEmpty) {
      onStatusChanged?.call('Device IP or Robot IP cannot be empty');
      return;
    }
    try {
      final nodeHandle = await initNode(
        'my_ros_node',
        [],
        rosMasterUri: 'http://$robotIp:11311',
      );
      // 연결 성공 시 알림
      print('연결 성공');
      print(robotIp);
      print(deviceIp);
      onStatusChanged?.call('Connected');
    } catch (e) {
      // 연결 실패 시 알림
      print('연결 실패: $e');
      onStatusChanged?.call('Failed to connect');
    }
  }
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



