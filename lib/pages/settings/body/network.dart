import 'dart:developer' as dev;
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:dartros/dartros.dart';
import 'package:dartros_msgs/geometry_msgs/msgs.dart';
import 'package:flutter/widgets.dart';

import 'package:lorobot_app/utils/constants.dart';
import 'package:lorobot_app/utils/device_info.dart';

enum WhenObstacleDetects { avoid, stop }

class NetworkWidget extends StatefulWidget {
  const NetworkWidget({super.key});

  @override
  State<NetworkWidget> createState() => _NetworkWidget();
}

class _NetworkWidget extends State<NetworkWidget> {
  final rmsKey = GlobalKey(debugLabel: 'network_rms');
  final rmsTxtKey = GlobalKey(debugLabel: 'network_rms_text');
  final String initialTextValue = '';
  late TextEditingController _textEditingController;
  late String _oldText;
  late Text? _alertTexts;
  bool _exceed = false;
  static const ipPattern = r'\d[0-9.]+\d';
  final regexp = RegExp(ipPattern);
  List<Text> texts = [];

  @override
  void initState() {
    super.initState();
    _textEditingController = TextEditingController(text: initialTextValue);
    _oldText = initialTextValue;
    _alertTexts = const Text('');
    returnIPAddressWithInterface();
  }

  @override
  void dispose() {
    _textEditingController.dispose();
    super.dispose();
  }

  Future<Map<String, List<InternetAddress>>> getIPAddress() async {
    final ifaces = await NetworkInterface.list(type: InternetAddressType.IPv4);
    Map<String, List<InternetAddress>> ipAddresses = {};
    for (final iface in ifaces) {
      ipAddresses[iface.toString()] = iface.addresses;
    }
    sysLog.d("current IP address: $ipAddresses");
    return ipAddresses;
  }

  Future<List<Text>> returnIPAddressWithInterface() async {
    final ifaces = await NetworkInterface.list(type: InternetAddressType.IPv4);
    texts = [];
    for (final iface in ifaces) {
      texts.add(Text('IP => ${iface.name}: ${iface.addresses.first.address}'));
    }
    setState(() {});
    return texts;
  }

  void _connectRos(String uri) async {
    List<String> args = [];
    try {
      nodehandle = await initNode(defaultNodeName, args,
          rosMasterUri: 'http://$uri:11311');
      if (nodehandle!.node.nodeReady.isCompleted) {
        var ipList = getIPAddress();
        dev.log("complete with rosmaster_uri ${nodehandle!.node.rosMasterURI}");
        dev.log("node named as ${nodehandle!.node.nodeName}");
        if (pubVel != null && pubVel!.topic.isNotEmpty) {
          nodehandle!.unadvertise('/cmd_vel');
        }
        if (pubGoal != null && pubGoal!.topic.isNotEmpty) {
          nodehandle!.unadvertise('/move_base_simple/goal');
        }
        pubVel = nodehandle!.advertise<Twist>('/cmd_vel', Twist.$prototype);
        pubGoal = nodehandle!.advertise<PoseStamped>(
            '/move_base_simple/goal', PoseStamped.$prototype);
        serverIp = InternetAddress(uri);
        setState(() {});
      }
    } catch (e) {
      sysLog.d(e);
    }
  }

  void _connectRMS() {
    var txt = _textEditingController.text;
    dev.log('Trying to connect to: $txt');  // 디버깅 로그 추가
    _connectRos(txt);
  }

  void _formattingIP(String txt) {
    final TextSelection previousCursorPos = _textEditingController.selection;
    TextSelection tempPos;
    List<String> splittedTxt = txt.split('.');
    List txtSublist = [];
    bool dotted = false;
    _exceed = false;
    sysLog.d(splittedTxt.toString());
    _alertTexts = null;

    if (_oldText.length < txt.length) {
      String res = '';
      int index = 0;
      for (String spspTxt in splittedTxt) {
        int? value = int.tryParse(spspTxt) ?? -1;
        int value1 = value ~/ 10;
        bool checked = false;
        if (value > 255) {
          _exceed = true;
          break;
        }
        if (value1 > 2 || value == 0) checked = true;
        if (index < splittedTxt.length) {
          txtSublist = splittedTxt.length > 1
              ? List.from(splittedTxt.sublist(0, index + 1))
              : List.from(splittedTxt);
          if (checked) {
            txtSublist.add('');
            dotted = true;
          }
        }
        res = txtSublist.join('.');
        index += 1;
      }
      if ('.'.allMatches(res).length > 3) {
        int a = res.lastIndexOf('.');
        res = res.substring(0, a); // remove last dot
      }
      _textEditingController.text = res;
    }
    if (_exceed || dotted) {
      tempPos = TextSelection.fromPosition(
          TextPosition(offset: _textEditingController.text.length));
    } else {
      tempPos = previousCursorPos;
    }
    _oldText = _textEditingController.text;
    _textEditingController.selection = tempPos;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    var devInfo = DeviceInfo(context: context);
    return Column(mainAxisAlignment: MainAxisAlignment.start, children: [
      buildSectionEnterIP(),
    ]);
  }

  Widget buildSectionEnterIP() {
    return Container(
      key: rmsKey,
      child: Flexible(
        child: Column(
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(style: TextStyle(fontSize: 19), ' '),
                Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: texts.isEmpty
                        ? [const Text('Loading')]
                        : texts),
              ],
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(
                  child: TextFormField(
                    decoration: InputDecoration(
                      hintText: "Please write an IP address to connect server",
                      hintMaxLines: 1,
                      errorText: _exceed ? "Please check again" : null,
                    ),
                    key: rmsTxtKey,
                    keyboardType: const TextInputType.numberWithOptions(),
                    inputFormatters: [
                      FilteringTextInputFormatter.allow(RegExp("[0-9.]")),
                    ],
                    controller: _textEditingController,
                    onChanged: _formattingIP,
                  ),
                ),
                SizedBox(
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height * 0.2,
                ),
                OutlinedButton(
                  onPressed: _connectRMS,
                  child: const Text(
                      style: TextStyle(fontSize: 20), 'Connect to RMS'),
                ),
              ],
            ),
            SizedBox(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height * 0.1,
            ),
            Column(
              children: [
                nodehandle == null ||
                    nodehandle!.isShutdown ||
                    nodehandle!.node.nodeReady.isCompleted
                    ? const Text(style: TextStyle(fontSize: 25), 'Not Connected')
                    : const Text(style: TextStyle(fontSize: 25), 'Connected'),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
