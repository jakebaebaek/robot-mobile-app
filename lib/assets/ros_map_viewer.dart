import 'dart:async';
import 'dart:math';

import 'package:dartros/dartros.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:dartros_msgs/geometry_msgs/msgs.dart' as geo;
import 'package:dartros_msgs/nav_msgs/msgs.dart';
import 'package:dartros_msgs/tf2_msgs/msgs.dart';
import 'package:image/image.dart' as imglib;

import 'package:lorobot_app/utils/constants.dart';


class ImageDetail {

  final int width;
  final int height;
  final Uint8List? bytes;

  ImageDetail({required this.width, required this.height, this.bytes});
}
class RosMapViewer extends StatefulWidget{
  final String mapTopic;
  final String odomTopic;
  final String tfTopic;
  final double mapSizeModifier;
  final void Function(double x, double y, double radian) posCallback;
  // final void Function(Image image, Uint8List imgData) imgCallback;
  const RosMapViewer({super.key,
    this.mapTopic = '/map', this.odomTopic = '/odom', this.tfTopic = '/tf',
    this.mapSizeModifier = 1.0, // mapsizemodifier needs to be refer address not value. reference by value makes map not inteded size.
    required this.posCallback,});

  @override
  State<RosMapViewer> createState() => _RosMapViewer();
}

class _RosMapViewer extends State<RosMapViewer>{
  geo.Vector3? robotPos;
  geo.Vector3 robotVec = geo.Vector3(x:0,y:0,z:0);
  geo.Vector3 odomBase = geo.Vector3(x:0,y:0,z:0);
  geo.Vector3 mapOdom = geo.Vector3();
  late String mapTopic;
  late String odomTopic;
  late String tfTopic;
  bool mapOdomFlag = false;
  bool odomBaseFlag = false;
  Image mapImg = Image.asset('lib/assets/images/temp_map.png', fit: BoxFit.contain,);
  Uint8List? mapData;
  late Subscriber subOdom;
  late Subscriber subTf;
  OccupancyGrid? curGrid;
  late double mapSizeModifier;

  void gridCallback(OccupancyGrid gridmap) {
    curGrid = gridmap;
    convertGridtoImage();
  }

  void convertGridtoImage(){
    if(curGrid == null) return;
    var data = curGrid!.data;
    imglib.Image ii = imglib.Image(
        width: curGrid!.info.width,
        height: curGrid!.info.height,
        numChannels: 1,
        format: imglib.Format.uint8);

    for(int h = 0; h<(curGrid!.info.height); h++){
      for(int w = 0; w < curGrid!.info.width; w++){
        int idx = w + h*(curGrid!.info.width);
        num d = data[idx] != -1 ? (data[idx]/100 * 200) + 50 : 0; // for coloring data
        if(inverseMap){
          ii.setPixelRgb(w, h, 255-d, 255-d, 255-d);
        } else {
          ii.setPixelRgb(w, curGrid!.info.height - h - 1, 255-d, 255-d, 255-d);
        }
      }
    }

    setState((){
      ii = imglib.copyResize(ii, height: ii.height*mapSizeModifier.toInt(), width: ii.width*mapSizeModifier.toInt());
      mapData = ii.toUint8List();
      mapImg = Image.memory(imglib.encodePng(ii), fit: BoxFit.fill,);
    });
    print('height: ${mapImg.height}');
  }

  void pointRobotPos(){
    if(!(odomBaseFlag && mapOdomFlag) || curGrid == null) return;
    var res = curGrid!.info.resolution;
    var halfWid = curGrid!.info.width ~/ 2;
    var halfHei = curGrid!.info.height ~/ 2;
    robotPos = geo.Vector3(x: halfHei + (robotVec.x / res), y: halfWid + (robotVec.y / res), z:robotVec.z);
    sysLog.d('halfWid: $halfWid, halfHei: $halfHei\nrobotVec: ${robotVec.x}, ${robotVec.y}\nrobotPos: ${robotPos!.x}, ${robotPos!.y}');
    mapOdomFlag = false;
    odomBaseFlag = false;
    robotVec = geo.Vector3(x:0,y:0,z:0);
    setState(() {

    });
  }

  void odomCallback(Odometry odom){
    var pos = odom.pose.pose.position;
    var ori = odom.pose.pose.orientation;
    // print('${pos.x}, ${pos.y}');
    if(!odomBaseFlag){
      double yaw = atan2(2 * (ori.z*ori.w), 1 - 2 * (ori.z * ori.z));
      odomBase = geo.Vector3(x: pos.x, y: pos.y, z: yaw);
      widget.posCallback(pos.x, pos.y, yaw);
      robotVec = geo.Vector3(x: robotVec.x - odomBase.y, y: robotVec.y + odomBase.x, z: robotVec.z + yaw);
      //in turtlebot... x, y reversed...
      odomBaseFlag = true;
    }
    pointRobotPos();
    // print('${ori.z}, ${ori.w}');
    // print('$yaw');
    // print('${yaw * 180 / pi} degree');
  }

  bool compareFrameId(geo.TransformStamped element, String headerFrameId, String childFrameId){
    return (element.header.frame_id == headerFrameId && element.child_frame_id == childFrameId) ? true : false;
  }

  void tfCallback(TFMessage tf){
    var tfs = tf.transforms.asMap();
    for (var element in tfs.values) {
      if(compareFrameId(element, 'map', 'odom') && !mapOdomFlag){
        mapOdom = element.transform.translation;
        var rot = element.transform.rotation;
        // mapOdom.z = element.transform.rotation.z;
        double yaw = atan2(2 * (rot.z*rot.w), 1 - 2 * (rot.z * rot.z));
        robotVec = geo.Vector3(x: robotVec.x + mapOdom.x, y: robotVec.y + mapOdom.y, z: robotVec.z + yaw);
        mapOdomFlag = true;
      }
    }
    pointRobotPos();
  }

  @override
  void initState(){
    mapTopic = widget.mapTopic;
    odomTopic = widget.odomTopic;
    tfTopic = widget.tfTopic;
    mapSizeModifier = widget.mapSizeModifier;
    super.initState();
    if(nodehandle?.node != null){
      subImg = nodehandle!.subscribe<OccupancyGrid>(mapTopic, OccupancyGrid.$prototype, gridCallback);
      subOdom = nodehandle!.subscribe<Odometry>(odomTopic, Odometry.$prototype, odomCallback);
      subTf = nodehandle!.subscribe<TFMessage>(tfTopic, TFMessage.$prototype, tfCallback);
      sysLog.d('subscribed /map topic successfully!');
    }
  }

  @override
  void dispose(){
    if(nodehandle != null){
      nodehandle!.unsubscribe(mapTopic);
      nodehandle!.unsubscribe(odomTopic);
      nodehandle!.unsubscribe(tfTopic);
      sysLog.d('unsubscribed /map topic successfully!');
    }
    super.dispose();
  }

  imgToBytes() async {
    int wi =598;
    int he =511;
    final ByteData bytes = await rootBundle.load('lib/assets/images/temp_map.png');
    final Uint8List list = bytes.buffer.asUint8List();

    imglib.Image ii = imglib.Image(
        width: wi,
        height: he,
        numChannels: 1,
        format: imglib.Format.uint8);
    ii = imglib.decodeImage(list)!;

    ii = imglib.copyResize(ii, height: ii.height*mapSizeModifier.toInt(), width: ii.width*mapSizeModifier.toInt());
    var bn = imglib.encodePng(ii);
    mapImg = Image.memory(imglib.encodePng(ii), fit: BoxFit.fill,);
    setState((){

    });
    // print(mapImg.height);tec
  }

  //Scale should be calculated through device width or height.
  @override
  Widget build(BuildContext context) {
    if(nodehandle == null || nodehandle!.isShutdown){
      imgToBytes();
    }
    return Stack(
      children: [
        // Image.asset('lib/assets/images/temp_map.png'),
        SizedBox(
            width: mapImg.width,
            height: mapImg.height,
            child: mapImg
        ),
        if(robotPos != null)
          Positioned(
            width: mapImg.width,
            height: mapImg.height,
            left: robotPos!.x.toDouble(),
            bottom: robotPos!.y.toDouble(),
            child: Transform.rotate(
                angle: robotPos!.z,
                child: const Icon(Icons.smart_toy, size: 15, color: Colors.purple,)),
          ),
      ],
    );
  }
}