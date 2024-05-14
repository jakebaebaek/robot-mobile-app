import 'package:flutter/material.dart';
import 'package:dartros/dartros.dart' as dartros;
import 'package:sensor_msgs/msgs.dart' as sensor_msgs;

class ConnectionWidget extends StatefulWidget {

  @override
  _ConnectionWidgetState createState() => _ConnectionWidgetState();
}

class _ConnectionWidgetState extends State<ConnectionWidget> {
  late dartros.NodeHandle nh;
  late dartros.Publisher<sensor_msgs.Image> imgPublisher;

  Future<void> main(List<String> args) async {
    final nh = await dartros.initNode('ros_node_1', args);
    await nh.getMasterUri();
    await nh.setParam('/foo', 'value');
    var value = await nh.getParam('/foo');
    assert(value == 'value');
    print(value);

    print(await nh.setParam('/foo', 'new value'));
    value = await nh.getParam('/foo');
    assert(value == 'new value');
    print(value);
  }

  void publishImage() {
    final imgMsg = sensor_msgs.Image(
      header: null,
      height: 600,
      width: 1024,
      encoding: 'rgba8',
      is_bigendian: 0,
      step: 1024 * 4,
      data: List.generate(600 * 1024 * 4, (_) => 255),
    );
    imgPublisher.publish(imgMsg);

    //connectRMS
    var wdt = toString();
    // var txt = rTxt ?? _textEditingController.text;
    // log(txt);
    // for(var matched in regexp.allMatches(txt)){
    //   log('$wdt got groupt ${matched.groupCount}');
    //   log('$wdt matched ${matched[0]}');
    // }
    // rh = RosHandler.withUri(defaultNodeName, 'http://$txt:11311/', []);
    // _connectRos('http://$txt:11311/');
  }

  @override
  Widget build(BuildContext context) {
    return Padding(padding: const EdgeInsets.all(3.0),
      child: OutlinedButton(
        style: OutlinedButton.styleFrom(
            padding: EdgeInsets.symmetric(horizontal:60, vertical:20),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30),
                side: BorderSide(color: Colors.blue, width:2)
            )
        ),
        onPressed: publishImage,
        child: const Text(
            style: TextStyle(fontSize: 30),
            'Connect🐱'),
      ),
    );
  }
}
